import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../localization/localization_keys.dart';
import 'api_config.dart';
import 'api_error_resolver.dart';
import 'api_exception.dart';
import 'auth_token_storage.dart';

typedef UnauthorizedCallback = Future<void> Function();

/// Configured Dio client with auth header injection and error mapping.
class ApiClient {
  ApiClient({
    required AuthTokenStorage tokenStorage,
    Dio? dio,
    bool enableDebugLogging = kDebugMode,
  }) : _tokenStorage = tokenStorage,
       dio = dio ?? Dio() {
    if (ApiConfig.isConfigured) {
      this.dio.options.baseUrl = ApiConfig.baseUrl;
    }
    this.dio.options
      ..connectTimeout = ApiConfig.connectTimeout
      ..receiveTimeout = ApiConfig.receiveTimeout
      ..headers.addAll(ApiConfig.jsonHeaders);

    this.dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _tokenStorage.readAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          final statusCode = error.response?.statusCode;
          if (statusCode == 401 &&
              !_isLoginPath(error.requestOptions.path) &&
              _onUnauthorized != null) {
            await _onUnauthorized!();
          }
          handler.next(error);
        },
      ),
    );

    if (enableDebugLogging) {
      this.dio.interceptors.add(
        LogInterceptor(
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          logPrint: (line) => debugPrint(_redactSecrets(line)),
        ),
      );
    }
  }

  final AuthTokenStorage _tokenStorage;
  UnauthorizedCallback? _onUnauthorized;
  final Dio dio;

  void bindUnauthorizedHandler(UnauthorizedCallback? handler) {
    _onUnauthorized = handler;
  }

  bool get isConfigured =>
      ApiConfig.isConfigured || dio.options.baseUrl.trim().isNotEmpty;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    _assertConfigured();
    try {
      return await dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (error) {
      throw mapDioException(error);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    ProgressCallback? onSendProgress,
  }) async {
    _assertConfigured();
    try {
      return await dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        onSendProgress: onSendProgress,
      );
    } on DioException catch (error) {
      throw mapDioException(error);
    }
  }

  Future<Response<T>> postMultipart<T>(
    String path, {
    required FormData data,
    ProgressCallback? onSendProgress,
  }) async {
    _assertConfigured();
    try {
      return await dio.post<T>(
        path,
        data: data,
        options: Options(
          headers: const {'Accept': 'application/json'},
          contentType: 'multipart/form-data',
        ),
        onSendProgress: onSendProgress,
      );
    } on DioException catch (error) {
      throw mapDioException(error);
    }
  }

  Future<Response<T>> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    _assertConfigured();
    try {
      return await dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (error) {
      throw mapDioException(error);
    }
  }

  void _assertConfigured() {
    if (!isConfigured) {
      throw const ApiException(
        messageKey: LocalizationKeys.authBackendNotConfigured,
        kind: ApiExceptionKind.notConfigured,
      );
    }
  }
}

ApiException mapDioException(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return ApiException(
        messageKey: LocalizationKeys.authNetworkError,
        kind: ApiExceptionKind.timeout,
        cause: error,
      );
    case DioExceptionType.connectionError:
    case DioExceptionType.unknown:
      if (error.error != null && error.response == null) {
        return ApiException(
          messageKey: LocalizationKeys.authNetworkError,
          kind: ApiExceptionKind.network,
          cause: error,
        );
      }
      break;
    case DioExceptionType.badResponse:
      break;
    case DioExceptionType.cancel:
      return ApiException(
        messageKey: LocalizationKeys.errorGenericBody,
        kind: ApiExceptionKind.unknown,
        cause: error,
      );
    case DioExceptionType.badCertificate:
      return ApiException(
        messageKey: LocalizationKeys.authNetworkError,
        kind: ApiExceptionKind.network,
        cause: error,
      );
  }

  final statusCode = error.response?.statusCode;
  final path = error.requestOptions.path;
  final messageKey = apiExceptionMessageKeyForStatus(
    statusCode: statusCode,
    path: path,
  );

  return switch (statusCode) {
    400 => ApiException(
      messageKey: LocalizationKeys.authRequiredField,
      kind: ApiExceptionKind.validation,
      statusCode: statusCode,
      cause: error,
    ),
    401 => ApiException(
      messageKey: messageKey,
      kind: ApiExceptionKind.unauthorized,
      statusCode: statusCode,
      cause: error,
    ),
    403 => ApiException(
      messageKey: messageKey,
      kind: ApiExceptionKind.forbidden,
      statusCode: statusCode,
      cause: error,
    ),
    404 => ApiException(
      messageKey: messageKey,
      kind: ApiExceptionKind.notFound,
      statusCode: statusCode,
      cause: error,
    ),
    409 => ApiException(
      messageKey: LocalizationKeys.errorGenericBody,
      kind: ApiExceptionKind.conflict,
      statusCode: statusCode,
      cause: error,
    ),
    500 || 502 || 503 || 504 => ApiException(
      messageKey: LocalizationKeys.authServerError,
      kind: ApiExceptionKind.server,
      statusCode: statusCode,
      cause: error,
    ),
    _ => ApiException(
      messageKey: messageKey,
      kind: ApiExceptionKind.unknown,
      statusCode: statusCode,
      cause: error,
    ),
  };
}

bool _isLoginPath(String path) {
  final normalized = path.trim().toLowerCase();
  return normalized.endsWith('/auth/login') || normalized == '/auth/login';
}

String _redactSecrets(Object object) {
  return object
      .toString()
      .replaceAll(RegExp(r'Bearer\s+\S+', caseSensitive: false), 'Bearer [redacted]')
      .replaceAll(RegExp(r'"access_token"\s*:\s*"[^"]*"'), '"access_token":"[redacted]"')
      .replaceAll(RegExp(r'"accessToken"\s*:\s*"[^"]*"'), '"accessToken":"[redacted]"')
      .replaceAll(RegExp(r'"refresh_token"\s*:\s*"[^"]*"'), '"refresh_token":"[redacted]"')
      .replaceAll(RegExp(r'"refreshToken"\s*:\s*"[^"]*"'), '"refreshToken":"[redacted]"')
      .replaceAll(RegExp(r'"password"\s*:\s*"[^"]*"'), '"password":"[redacted]"');
}

final authTokenStorageProvider = Provider<AuthTokenStorage>(
  (ref) => AuthTokenStorage(),
);

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(tokenStorage: ref.watch(authTokenStorageProvider));
});

final dioProvider = Provider<Dio>((ref) => ref.watch(apiClientProvider).dio);
