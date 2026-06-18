import 'package:dio/dio.dart';

import '../../app/app_environment.dart';
import 'api_exception.dart';
import 'auth_token_storage.dart';

/// HTTP client configuration. Backend wiring is added in a later phase.
class ApiConfig {
  ApiConfig({
    required this.environment,
    required AuthTokenStorage tokenStorage,
    Dio? dio,
  }) : _tokenStorage = tokenStorage,
       dio = dio ?? Dio() {
    final baseUrl = const String.fromEnvironment(AppEnvironmentConfig.apiBaseUrlDefine);
    if (baseUrl.trim().isNotEmpty) {
      this.dio.options.baseUrl = baseUrl;
    }
    this.dio.options.connectTimeout = const Duration(seconds: 20);
    this.dio.options.receiveTimeout = const Duration(seconds: 30);
    this.dio.options.headers['Accept'] = 'application/json';
  }

  final AppEnvironment environment;
  final AuthTokenStorage _tokenStorage;
  final Dio dio;

  bool get isConfigured => AppEnvironmentConfig.isBackendConfigured;

  Future<String?> readAccessToken() => _tokenStorage.readAccessToken();
}

/// Factory for creating configured API clients.
class ApiClient {
  ApiClient(this.config);

  final ApiConfig config;

  Dio get dio => config.dio;

  Never throwNotConfigured() {
    throw const ApiException(
      messageKey: 'loginBackendNotConfigured',
      kind: ApiExceptionKind.notConfigured,
    );
  }
}
