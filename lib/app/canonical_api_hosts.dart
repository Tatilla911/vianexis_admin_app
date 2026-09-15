/// Canonical ViaNexis API hosts used when `--dart-define=API_BASE_URL` is omitted
/// for staging/production profiles.
///
/// Documented production host matches Driver App `ApiEnvironment.documentedProductionHost`.
/// Staging host matches current UAT Render service.
///
/// Local/dev keep an empty URL so mock fallback still works unless an explicit
/// `--dart-define=API_BASE_URL` is provided.
abstract final class CanonicalApiHosts {
  /// Staging / UAT / non-production default.
  static const staging = 'https://vianexis-staging-api.onrender.com';

  /// Production default (Driver-aligned canonical host).
  static const production = 'https://api.vianexis.eu';
}
