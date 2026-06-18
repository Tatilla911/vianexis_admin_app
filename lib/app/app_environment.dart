/// Build-time environment profile for the admin app.
enum AppEnvironment {
  devLocal('dev'),
  staging('staging'),
  production('production');

  const AppEnvironment(this.value);

  final String value;

  static const dartDefineKey = 'APP_ENV';

  static AppEnvironment fromDefine([String? raw]) {
    final normalized = (raw ?? devLocal.value).trim().toLowerCase();
    return AppEnvironment.values.firstWhere(
      (profile) => profile.value == normalized,
      orElse: () => devLocal,
    );
  }
}

/// Documented dart-define keys for API configuration.
class AppEnvironmentConfig {
  AppEnvironmentConfig._();

  static const apiBaseUrlDefine = 'API_BASE_URL';

  static bool get isBackendConfigured {
    const raw = String.fromEnvironment(apiBaseUrlDefine);
    return raw.trim().isNotEmpty;
  }
}
