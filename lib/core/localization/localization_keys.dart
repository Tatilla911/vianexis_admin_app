/// Stable localization keys referenced from non-UI layers.
abstract final class LocalizationKeys {
  static const loginBackendNotConfigured = 'loginBackendNotConfigured';
  static const errorGenericBody = 'errorGenericBody';
  static const roleSuperAdmin = 'roleSuperAdmin';
  static const roleSupportAdmin = 'roleSupportAdmin';
  static const roleOnboardingReviewer = 'roleOnboardingReviewer';
  static const roleBillingAdmin = 'roleBillingAdmin';
}

/// Resolves a localization key to a user-visible string.
String localizeKey(String key, String Function(String key) lookup) => lookup(key);
