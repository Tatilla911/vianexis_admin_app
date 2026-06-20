import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/core/auth/admin_user.dart';
import 'package:vianexis_admin_app/features/billing/presentation/billing_providers.dart';

void main() {
  group('AdminRole billing destination access', () {
    test('super_admin and billing_admin can access billing', () {
      expect(AdminRole.superAdmin.canAccess(AdminDestination.billing), isTrue);
      expect(AdminRole.billingAdmin.canAccess(AdminDestination.billing), isTrue);
    });

    test('support_admin has read-only billing module access', () {
      expect(AdminRole.supportAdmin.canAccess(AdminDestination.billing), isTrue);
    });

    test('onboarding_reviewer cannot access billing', () {
      expect(
        AdminRole.onboardingReviewer.canAccess(AdminDestination.billing),
        isFalse,
      );
    });
  });

  group('AdminRole billing status changes', () {
    test('super_admin and billing_admin can change billing status', () {
      expect(AdminRole.superAdmin.canChangeBillingStatus, isTrue);
      expect(AdminRole.billingAdmin.canChangeBillingStatus, isTrue);
    });

    test('support_admin cannot change billing status', () {
      expect(AdminRole.supportAdmin.canChangeBillingStatus, isFalse);
      expect(AdminRole.onboardingReviewer.canChangeBillingStatus, isFalse);
    });
  });
}
