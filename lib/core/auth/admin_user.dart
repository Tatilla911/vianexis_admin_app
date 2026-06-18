import '../localization/localization_keys.dart';

/// Platform administrator roles aligned with backend `UserRole` values.
enum AdminRole {
  superAdmin('super_admin'),
  supportAdmin('support_admin'),
  onboardingReviewer('onboarding_reviewer'),
  billingAdmin('billing_admin');

  const AdminRole(this.backendValue);

  final String backendValue;

  static AdminRole? fromBackendValue(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    for (final role in AdminRole.values) {
      if (role.backendValue == raw) return role;
    }
    return null;
  }
}

/// Navigation destinations exposed in the admin shell.
enum AdminDestination {
  dashboard,
  registrations,
  aiReviews,
  supportTickets,
  supportGrants,
  systemHealth,
  auditLogs,
  settings,
}

extension AdminRoleCapabilities on AdminRole {
  bool canAccess(AdminDestination destination) {
    return switch (this) {
      AdminRole.superAdmin => true,
      AdminRole.supportAdmin => switch (destination) {
        AdminDestination.dashboard ||
        AdminDestination.supportTickets ||
        AdminDestination.supportGrants ||
        AdminDestination.systemHealth ||
        AdminDestination.auditLogs ||
        AdminDestination.settings => true,
        _ => false,
      },
      AdminRole.onboardingReviewer => switch (destination) {
        AdminDestination.dashboard ||
        AdminDestination.registrations ||
        AdminDestination.aiReviews ||
        AdminDestination.settings => true,
        _ => false,
      },
      AdminRole.billingAdmin => switch (destination) {
        AdminDestination.dashboard ||
        AdminDestination.registrations ||
        AdminDestination.settings => true,
        _ => false,
      },
    };
  }

  String localizationKey() {
    return switch (this) {
      AdminRole.superAdmin => LocalizationKeys.roleSuperAdmin,
      AdminRole.supportAdmin => LocalizationKeys.roleSupportAdmin,
      AdminRole.onboardingReviewer => LocalizationKeys.roleOnboardingReviewer,
      AdminRole.billingAdmin => LocalizationKeys.roleBillingAdmin,
    };
  }
}

class AdminUser {
  const AdminUser({
    required this.id,
    required this.email,
    required this.role,
  });

  final String id;
  final String email;
  final AdminRole role;

  bool canAccess(AdminDestination destination) => role.canAccess(destination);
}
