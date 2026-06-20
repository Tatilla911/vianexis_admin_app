/// Build-time environment profile for the ViaNexis Admin app.
enum AppEnvironment {
  local('local'),
  dev('dev'),
  staging('staging'),
  production('production');

  const AppEnvironment(this.value);

  final String value;

  static const dartDefineKey = 'APP_ENV';

  /// Parses `--dart-define=APP_ENV=...` (defaults to [local]).
  static AppEnvironment fromDefine([String? raw]) {
    final normalized = (raw ?? local.value).trim().toLowerCase();
    if (normalized == 'devlocal') {
      return dev;
    }
    return AppEnvironment.values.firstWhere(
      (profile) => profile.value == normalized,
      orElse: () => local,
    );
  }

  bool get isProduction => this == AppEnvironment.production;

  bool get isStaging => this == AppEnvironment.staging;

  bool get allowsMockFallbackByDefault =>
      this == AppEnvironment.local || this == AppEnvironment.dev;
}

/// Documented dart-define keys for build configuration.
abstract final class AppEnvironmentConfig {
  static const apiBaseUrlDefine = 'API_BASE_URL';

  /// Optional override: `--dart-define=ALLOW_MOCK_FALLBACK=true`
  static const allowMockFallbackDefine = 'ALLOW_MOCK_FALLBACK';
}
