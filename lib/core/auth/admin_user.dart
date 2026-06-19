import '../api/api_exception.dart';
import '../localization/localization_keys.dart';
import 'admin_user.dart';

/// Roles that must never access the platform admin app.
abstract final class ForbiddenPlatformRoles {
  static const values = {
    'driver',
    'carrier',
    'shipper',
    'receiver',
    'dispatcher',
    'company_admin',
    'workshop',
  };
}

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

  static bool isPlatformAdminBackendRole(String? raw) =>
      fromBackendValue(raw) != null;

  static bool isForbiddenBackendRole(String? raw) {
    if (raw == null || raw.trim().isEmpty) return true;
    if (isPlatformAdminBackendRole(raw)) return false;
    return true;
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
    this.name,
  });

  final String id;
  final String email;
  final AdminRole role;
  final String? name;

  bool canAccess(AdminDestination destination) => role.canAccess(destination);

  factory AdminUser.fromAuthJson(Map<String, dynamic> json) {
    final roleRaw = json['role']?.toString();
    if (AdminRole.isForbiddenBackendRole(roleRaw)) {
      throw const ApiException(
        messageKey: LocalizationKeys.authForbiddenRole,
        kind: ApiExceptionKind.forbidden,
      );
    }

    final role = AdminRole.fromBackendValue(roleRaw);
    if (role == null) {
      throw const ApiException(
        messageKey: LocalizationKeys.authForbiddenRole,
        kind: ApiExceptionKind.forbidden,
      );
    }

    final idValue = json['id'] ?? json['userId'];
    if (idValue == null) {
      throw const ApiException(
        messageKey: LocalizationKeys.errorGenericBody,
        kind: ApiExceptionKind.validation,
      );
    }

    final email = json['email']?.toString();
    if (email == null || email.trim().isEmpty) {
      throw const ApiException(
        messageKey: LocalizationKeys.errorGenericBody,
        kind: ApiExceptionKind.validation,
      );
    }

    final name = json['name']?.toString();

    return AdminUser(
      id: idValue.toString(),
      email: email,
      role: role,
      name: name?.trim().isEmpty == true ? null : name,
    );
  }
}
