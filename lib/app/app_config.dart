import 'package:flutter/foundation.dart';

import 'app_environment.dart';
import 'canonical_api_hosts.dart';

/// Central compile-time configuration for the admin app.
class AppConfig {
  AppConfig._({
    required this.environment,
    required this.apiBaseUrl,
    required this.allowMockFallbackOverride,
  });

  factory AppConfig.fromEnvironment() {
    const envRaw = String.fromEnvironment(AppEnvironment.dartDefineKey);
    const apiRaw = String.fromEnvironment(
      AppEnvironmentConfig.apiBaseUrlDefine,
    );
    const mockRaw = String.fromEnvironment(
      AppEnvironmentConfig.allowMockFallbackDefine,
    );

    final environment = AppEnvironment.fromDefine(envRaw);
    return AppConfig._(
      environment: environment,
      apiBaseUrl: resolveApiBaseUrl(
        environment: environment,
        explicitApiBaseUrl: apiRaw,
      ),
      allowMockFallbackOverride: _parseBool(mockRaw),
    );
  }

  /// Test / tooling constructor — does not read dart-defines.
  @visibleForTesting
  factory AppConfig.forTest({
    required AppEnvironment environment,
    required String apiBaseUrl,
    bool allowMockFallbackOverride = false,
  }) {
    return AppConfig._(
      environment: environment,
      apiBaseUrl: apiBaseUrl.trim(),
      allowMockFallbackOverride: allowMockFallbackOverride,
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

  /// Canonical API base URL resolution.
  ///
  /// Priority:
  /// 1. explicit `--dart-define=API_BASE_URL`
  /// 2. production → [CanonicalApiHosts.production]
  /// 3. staging → [CanonicalApiHosts.staging]
  /// 4. local/dev → empty (preserves mock fallback unless a URL is defined)
  static String resolveApiBaseUrl({
    required AppEnvironment environment,
    required String explicitApiBaseUrl,
  }) {
    final explicit = explicitApiBaseUrl.trim();
    if (explicit.isNotEmpty) {
      return normalizeApiBaseUrl(explicit);
    }
    if (environment.isProduction) {
      return CanonicalApiHosts.production;
    }
    if (environment.isStaging) {
      return CanonicalApiHosts.staging;
    }
    return '';
  }

  static String normalizeApiBaseUrl(String raw) {
    var url = raw.trim();
    while (url.endsWith('/')) {
      url = url.substring(0, url.length - 1);
    }
    return url;
  }

  static bool _parseBool(String raw) {
    final normalized = raw.trim().toLowerCase();
    return normalized == '1' ||
        normalized == 'true' ||
        normalized == 'yes' ||
        normalized == 'on';
  }
}
