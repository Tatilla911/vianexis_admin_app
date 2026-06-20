import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/core/auth/admin_user.dart';
import 'package:vianexis_admin_app/features/admin_users/presentation/admin_users_providers.dart';

void main() {
  group('Admin destination access phases 21-23', () {
    test('super_admin can access all new destinations', () {
      expect(AdminRole.superAdmin.canAccess(AdminDestination.adminUsers), isTrue);
      expect(AdminRole.superAdmin.canAccess(AdminDestination.securityCenter), isTrue);
      expect(AdminRole.superAdmin.canAccess(AdminDestination.actionCenter), isTrue);
      expect(AdminRole.superAdmin.canAccess(AdminDestination.releaseCenter), isTrue);
    });

    test('support_admin can access security, action center, release center but not admin users', () {
      expect(AdminRole.supportAdmin.canAccess(AdminDestination.securityCenter), isTrue);
      expect(AdminRole.supportAdmin.canAccess(AdminDestination.actionCenter), isTrue);
      expect(AdminRole.supportAdmin.canAccess(AdminDestination.releaseCenter), isTrue);
      expect(AdminRole.supportAdmin.canAccess(AdminDestination.adminUsers), isFalse);
    });

    test('onboarding_reviewer can access action center only among new modules', () {
      expect(AdminRole.onboardingReviewer.canAccess(AdminDestination.actionCenter), isTrue);
      expect(AdminRole.onboardingReviewer.canAccess(AdminDestination.securityCenter), isFalse);
      expect(AdminRole.onboardingReviewer.canAccess(AdminDestination.adminUsers), isFalse);
      expect(AdminRole.onboardingReviewer.canAccess(AdminDestination.releaseCenter), isFalse);
    });

    test('billing_admin can access action center only among new modules', () {
      expect(AdminRole.billingAdmin.canAccess(AdminDestination.actionCenter), isTrue);
      expect(AdminRole.billingAdmin.canAccess(AdminDestination.securityCenter), isFalse);
      expect(AdminRole.billingAdmin.canAccess(AdminDestination.adminUsers), isFalse);
      expect(AdminRole.billingAdmin.canAccess(AdminDestination.releaseCenter), isFalse);
    });
  });

  group('Admin user write gating', () {
    test('only super_admin can manage admin users', () {
      expect(AdminRole.superAdmin.canManageAdminUsers, isTrue);
      expect(AdminRole.supportAdmin.canManageAdminUsers, isFalse);
      expect(AdminRole.onboardingReviewer.canManageAdminUsers, isFalse);
      expect(AdminRole.billingAdmin.canManageAdminUsers, isFalse);
    });
  });
}
