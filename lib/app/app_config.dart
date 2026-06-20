import 'package:flutter/foundation.dart';

import 'app_environment.dart';

/// Central compile-time configuration for the admin app.
class AppConfig {
  AppConfig._({
    required this.environment,
    required this.apiBaseUrl,
    required this.allowMockFallbackOverride,
  });

  factory AppConfig.fromEnvironment() {
    const envRaw = String.fromEnvironment(AppEnvironment.dartDefineKey);
    const apiRaw = String.fromEnvironment(AppEnvironmentConfig.apiBaseUrlDefine);
    const mockRaw =
        String.fromEnvironment(AppEnvironmentConfig.allowMockFallbackDefine);

    return AppConfig._(
      environment: AppEnvironment.fromDefine(envRaw),
      apiBaseUrl: apiRaw.trim(),
      allowMockFallbackOverride: _parseBool(mockRaw),
    );
  }

  static final AppConfig instance = AppConfig.fromEnvironment();

  final AppEnvironment environment;
  final String apiBaseUrl;
  final bool allowMockFallbackOverride;

  String get environmentName => environment.value;

  bool get isApiConfigured => apiBaseUrl.isNotEmpty;

  bool get isProduction => environment.isProduction;

  bool get isMockFallbackAllowed =>
      allowMockFallbackOverride || environment.allowsMockFallbackByDefault;

  /// Live repositories are used when API is configured or mock fallback is disallowed.
  bool get shouldUseLiveRepositories =>
      isApiConfigured || !isMockFallbackAllowed;

  bool get isMockFallbackActive => !isApiConfigured && isMockFallbackAllowed;

  bool get isProductionMisconfigured =>
      isProduction && !isApiConfigured && !isMockFallbackAllowed;

  bool get isDebugBannerVisible => !isProduction || kDebugMode;

  /// Localization key for the environment display label (EN/HU via l10n).
  String get displayLabelKey => switch (environment) {
        AppEnvironment.local => 'appEnvLocal',
        AppEnvironment.dev => 'appEnvDev',
        AppEnvironment.staging => 'appEnvStaging',
        AppEnvironment.production => 'appEnvProduction',
      };

  /// Safe API summary for UI — host only, never tokens or full secrets.
  String? get safeApiHostDisplay {
    if (!isApiConfigured) return null;
    try {
      final uri = Uri.parse(apiBaseUrl);
      if (uri.host.isNotEmpty) {
        return uri.hasPort ? '${uri.host}:${uri.port}' : uri.host;
      }
    } catch (_) {
      // Fall through.
    }
    return 'configured';
  }

  static bool _parseBool(String raw) {
    final normalized = raw.trim().toLowerCase();
    return normalized == '1' ||
        normalized == 'true' ||
        normalized == 'yes' ||
        normalized == 'on';
  }
}
