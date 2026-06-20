enum PlatformAdminUserRole {
  superAdmin('super_admin'),
  supportAdmin('support_admin'),
  onboardingReviewer('onboarding_reviewer'),
  billingAdmin('billing_admin'),
  unknown('unknown');

  const PlatformAdminUserRole(this.backendValue);

  final String backendValue;

  static PlatformAdminUserRole fromBackendValue(String? raw) {
    if (raw == null || raw.trim().isEmpty) return unknown;
    for (final role in PlatformAdminUserRole.values) {
      if (role.backendValue == raw) return role;
    }
    return unknown;
  }

  String localizationKey() {
    return switch (this) {
      superAdmin => 'roleSuperAdmin',
      supportAdmin => 'roleSupportAdmin',
      onboardingReviewer => 'roleOnboardingReviewer',
      billingAdmin => 'roleBillingAdmin',
      unknown => 'adminUserRoleUnknown',
    };
  }

  static const invitableRoles = [
    PlatformAdminUserRole.supportAdmin,
    PlatformAdminUserRole.onboardingReviewer,
    PlatformAdminUserRole.billingAdmin,
    PlatformAdminUserRole.superAdmin,
  ];
}
