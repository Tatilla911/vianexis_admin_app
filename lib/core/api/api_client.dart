import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/auth_refresh_coordinator.dart';
import '../auth/auth_refresh_result.dart';
import '../localization/localization_keys.dart';
import 'api_config.dart';
import 'api_error_mapping.dart';
import 'api_exception.dart';
import 'api_request_path.dart';
import 'auth_token_storage.dart';

typedef UnauthorizedCallback = Future<void> Function();

const _skipRefreshExtraKey = 'skipRefresh';
const _retriedAfterRefreshExtraKey = 'retriedAfterRefresh';

/// Configured Dio client with auth header injection, refresh retry, and error mapping.
class ApiClient {
  ApiClient({
    required AuthTokenStorage tokenStorage,
    AuthRefreshCoordinator? refreshCoordinator,
    Dio? dio,
    bool enableDebugLogging = kDebugMode,
  }) : _tokenStorage = tokenStorage,
       _refreshCoordinator = refreshCoordinator,
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
          final handled = await _handleUnauthorized(error, handler);
          if (!handled) {
            handler.next(error);
          }
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

  static final skipRefreshOptions = Options(
    extra: <String, dynamic>{_skipRefreshExtraKey: true},
  );

  final AuthTokenStorage _tokenStorage;
  final AuthRefreshCoordinator? _refreshCoordinator;
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

  Future<Response<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    _assertConfigured();
    try {
      return await dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (error) {
      throw mapDioException(error);
    }
  }

  Future<bool> _handleUnauthorized(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = error.response?.statusCode;
    if (statusCode != 401) return false;

    final path = resolveApiRequestPath(error.requestOptions);
    if (isAuthExemptFromRefreshRetry(path)) return false;

    final skipRefresh =
        error.requestOptions.extra[_skipRefreshExtraKey] == true;
    final retried =
        error.requestOptions.extra[_retriedAfterRefreshExtraKey] == true;
    if (skipRefresh || retried) {
      if (_onUnauthorized != null) {
        await _onUnauthorized!();
      }
      return false;
    }

    final coordinator = _refreshCoordinator;
    if (coordinator == null) {
      if (_onUnauthorized != null) {
        await _onUnauthorized!();
      }
      return false;
    }

    final refreshResult = await coordinator.refreshOnce();
    if (refreshResult == AuthRefreshResult.success) {
      final token = await _tokenStorage.readAccessToken();
      final requestOptions = error.requestOptions;
      requestOptions.headers['Authorization'] = 'Bearer $token';
      requestOptions.extra[_retriedAfterRefreshExtraKey] = true;
      try {
        final response = await dio.fetch<dynamic>(requestOptions);
        handler.resolve(response);
        return true;
      } on DioException catch (retryError) {
        handler.next(retryError);
        return true;
      }
    }

    if (refreshResult == AuthRefreshResult.authInvalid &&
        _onUnauthorized != null) {
      await _onUnauthorized!();
    }
    return false;
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
  final statusCode = error.response?.statusCode;
  final path = resolveApiRequestPath(error.requestOptions);

  if (statusCode != null) {
    return mapHttpStatusException(
      statusCode: statusCode,
      path: path,
      error: error,
    );
  }

  if (isTransportLevelDioException(error)) {
    return ApiException(
      messageKey: LocalizationKeys.authNetworkError,
      kind:
          error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.sendTimeout ||
              error.type == DioExceptionType.receiveTimeout
          ? ApiExceptionKind.timeout
          : ApiExceptionKind.network,
      cause: error,
    );
  }

  if (error.type == DioExceptionType.cancel) {
    return ApiException(
      messageKey: LocalizationKeys.errorGenericBody,
      kind: ApiExceptionKind.unknown,
      cause: error,
    );
  }

  return ApiException(
    messageKey: LocalizationKeys.authNetworkError,
    kind: ApiExceptionKind.network,
    cause: error,
  );
}

String _redactSecrets(Object object) {
  return object
      .toString()
      .replaceAll(
        RegExp(r'Bearer\s+\S+', caseSensitive: false),
        'Bearer [redacted]',
      )
      .replaceAll(
        RegExp(r'"access_token"\s*:\s*"[^"]*"'),
        '"access_token":"[redacted]"',
      )
      .replaceAll(
        RegExp(r'"accessToken"\s*:\s*"[^"]*"'),
        '"accessToken":"[redacted]"',
      )
      .replaceAll(
        RegExp(r'"refresh_token"\s*:\s*"[^"]*"'),
        '"refresh_token":"[redacted]"',
      )
      .replaceAll(
        RegExp(r'"refreshToken"\s*:\s*"[^"]*"'),
        '"refreshToken":"[redacted]"',
      )
      .replaceAll(
        RegExp(r'"password"\s*:\s*"[^"]*"'),
        '"password":"[redacted]"',
      );
}

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(
    tokenStorage: ref.watch(authTokenStorageProvider),
    refreshCoordinator: ref.watch(authRefreshCoordinatorProvider),
  );
});

final dioProvider = Provider<Dio>((ref) => ref.watch(apiClientProvider).dio);
