import '../../app/app_environment.dart';

/// HTTP client configuration constants.
abstract final class ApiConfig {
  static const apiBaseUrlDefine = AppEnvironmentConfig.apiBaseUrlDefine;

  static const connectTimeout = Duration(seconds: 20);
  static const receiveTimeout = Duration(seconds: 30);

  static const jsonHeaders = <String, String>{
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  static String get baseUrl =>
      const String.fromEnvironment(apiBaseUrlDefine).trim();

  static bool get isConfigured => baseUrl.isNotEmpty;
}
