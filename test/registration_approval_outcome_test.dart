import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/core/auth/admin_user.dart';
import 'package:vianexis_admin_app/features/registrations/domain/registration_approval_outcome.dart';
import 'package:vianexis_admin_app/features/registrations/presentation/registration_providers.dart';

void main() {
  group('RegistrationApprovalOutcome.fromJson', () {
    test('parses company, admin, invite delivery without raw token', () {
      final outcome = RegistrationApprovalOutcome.fromJson({
        'companyId': 42,
        'companyName': 'Acme Kft',
        'adminUser': {'email': 'admin@acme.test', 'id': 9},
        'invite': {
          'tokenId': 'tok-1',
          'expiresAt': '2030-01-01T12:00:00.000Z',
          'preview': 'SHOULD_NOT_APPEAR',
        },
        'emailInviteSent': false,
        'emailInviteDeliveryStatus': 'pending_or_failed',
      });

      expect(outcome.companyId, '42');
      expect(outcome.companyName, 'Acme Kft');
      expect(outcome.adminEmail, 'admin@acme.test');
      expect(outcome.emailInviteSent, isFalse);
      expect(outcome.inviteDeliveryStatus, 'pending_or_failed');
      expect(outcome.inviteTokenId, 'tok-1');
      expect(outcome.inviteExpiresAt, isNotNull);
    });

    test('null json yields unknown delivery', () {
      final outcome = RegistrationApprovalOutcome.fromJson(null);
      expect(outcome.inviteDeliveryStatus, 'unknown');
      expect(outcome.companyId, isNull);
    });
  });

  group('AdminRole company decide policy', () {
    test('only super_admin can decide company registrations', () {
      expect(AdminRole.superAdmin.canDecideCompanyRegistrations, isTrue);
      expect(AdminRole.onboardingReviewer.canDecideCompanyRegistrations, isFalse);
      expect(AdminRole.supportAdmin.canDecideCompanyRegistrations, isFalse);
      expect(AdminRole.onboardingReviewer.canViewRegistrations, isTrue);
    });
  });
}
