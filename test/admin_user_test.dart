import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/core/api/api_exception.dart';
import 'package:vianexis_admin_app/core/auth/admin_user.dart';
import 'package:vianexis_admin_app/features/companies/presentation/platform_companies_providers.dart';
import 'package:vianexis_admin_app/core/localization/localization_keys.dart';

void main() {
  group('AdminRole', () {
    test('parses all platform admin roles', () {
      expect(AdminRole.fromBackendValue('super_admin'), AdminRole.superAdmin);
      expect(AdminRole.fromBackendValue('support_admin'), AdminRole.supportAdmin);
      expect(
        AdminRole.fromBackendValue('onboarding_reviewer'),
        AdminRole.onboardingReviewer,
      );
      expect(AdminRole.fromBackendValue('billing_admin'), AdminRole.billingAdmin);
    });

    test('rejects forbidden tenant and field roles', () {
      for (final role in ForbiddenPlatformRoles.values) {
        expect(AdminRole.isPlatformAdminBackendRole(role), isFalse);
        expect(AdminRole.isForbiddenBackendRole(role), isTrue);
      }
    });

    test('rejects unknown roles', () {
      expect(AdminRole.isForbiddenBackendRole('unknown_role'), isTrue);
      expect(AdminRole.fromBackendValue('unknown_role'), isNull);
    });
  });

  group('AdminUser.fromAuthJson', () {
    test('parses platform admin user from auth/me shape', () {
      final user = AdminUser.fromAuthJson({
        'userId': 42,
        'email': 'superadmin@vianexis-dev.local',
        'role': 'super_admin',
        'name': 'Platform Admin',
      });

      expect(user.id, '42');
      expect(user.email, 'superadmin@vianexis-dev.local');
      expect(user.role, AdminRole.superAdmin);
      expect(user.name, 'Platform Admin');
    });

    test('parses nested login user with id field', () {
      final user = AdminUser.fromAuthJson({
        'id': 7,
        'email': 'billing@vianexis-dev.local',
        'role': 'billing_admin',
      });

      expect(user.id, '7');
      expect(user.role, AdminRole.billingAdmin);
    });

    test('rejects driver role', () {
      expect(
        () => AdminUser.fromAuthJson({
          'userId': 1,
          'email': 'driver@vianexis-dev.local',
          'role': 'driver',
        }),
        throwsA(
          isA<ApiException>()
              .having((error) => error.messageKey, 'messageKey', LocalizationKeys.authForbiddenRole)
              .having((error) => error.kind, 'kind', ApiExceptionKind.forbidden),
        ),
      );
    });

    test('rejects company_admin role', () {
      expect(
        () => AdminUser.fromAuthJson({
          'userId': 2,
          'email': 'admin@vianexis-dev.local',
          'role': 'company_admin',
        }),
        throwsA(isA<ApiException>()),
      );
    });
  });

  group('AdminRole bulk onboarding access', () {
    test('super_admin and onboarding_reviewer can access bulk onboarding', () {
      expect(
        AdminRole.superAdmin.canAccess(AdminDestination.bulkOnboarding),
        isTrue,
      );
      expect(
        AdminRole.onboardingReviewer.canAccess(AdminDestination.bulkOnboarding),
        isTrue,
      );
    });

    test('support_admin and billing_admin cannot access bulk onboarding', () {
      expect(
        AdminRole.supportAdmin.canAccess(AdminDestination.bulkOnboarding),
        isFalse,
      );
      expect(
        AdminRole.billingAdmin.canAccess(AdminDestination.bulkOnboarding),
        isFalse,
      );
    });
  });

  group('AdminRole companies access', () {
    test('platform roles can read companies module', () {
      expect(AdminRole.superAdmin.canAccess(AdminDestination.companies), isTrue);
      expect(AdminRole.supportAdmin.canAccess(AdminDestination.companies), isTrue);
      expect(
        AdminRole.onboardingReviewer.canAccess(AdminDestination.companies),
        isTrue,
      );
      expect(AdminRole.billingAdmin.canAccess(AdminDestination.companies), isTrue);
    });

    test('only super_admin can change company status', () {
      expect(AdminRole.superAdmin.canChangePlatformCompanyStatus, isTrue);
      expect(AdminRole.supportAdmin.canChangePlatformCompanyStatus, isFalse);
      expect(
        AdminRole.onboardingReviewer.canChangePlatformCompanyStatus,
        isFalse,
      );
    });
  });
}
