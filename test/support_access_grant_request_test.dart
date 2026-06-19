import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/support/domain/support_access_grant_request.dart';
import 'package:vianexis_admin_app/features/support/domain/support_access_scope_type.dart';
import 'package:vianexis_admin_app/features/support/domain/support_ticket_action_request.dart';

void main() {
  group('SupportTicketActionRequest', () {
    test('acknowledge json omits empty note', () {
      const request = SupportTicketActionRequest(
        type: SupportTicketActionType.acknowledge,
      );

      expect(request.toJson(), isEmpty);
      expect(request.endpointSuffix(), 'acknowledge');
    });

    test('close json includes note', () {
      const request = SupportTicketActionRequest(
        type: SupportTicketActionType.close,
        note: 'Resolved after queue recovery',
      );

      expect(request.toJson(), {'note': 'Resolved after queue recovery'});
      expect(request.endpointSuffix(), 'close');
    });
  });

  group('SupportAccessGrantRequest', () {
    test('create json maps scoped backend payload', () {
      final request = SupportAccessGrantRequest(
        companyId: '12',
        scopeType: SupportAccessScopeType.systemHealthIssue,
        scopeId: '501',
        reason: 'Investigate health metadata',
        expiresAt: DateTime.utc(2026, 6, 18, 10),
      );

      final json = request.toJson();
      expect(json['companyId'], 12);
      expect(json['documentsAllowed'], isFalse);
      expect(json['scope'], ['portal_dashboard', 'audit']);
      expect(json['metadata'], containsPair('scopeId', '501'));
    });

    test('revoke json includes note', () {
      final request = SupportAccessGrantRequest(
        companyId: '12',
        scopeType: SupportAccessScopeType.companyMetadata,
        reason: 'Investigation complete',
        expiresAt: DateTime.utc(2026, 6, 18, 10),
        type: SupportAccessGrantActionType.revoke,
      );

      expect(request.toJson(), {'note': 'Investigation complete'});
      expect(request.endpointSuffix(), 'revoke');
      expect(request.httpMethod(), 'PATCH');
    });

    test('validation rejects broad access and missing reason', () {
      final invalidReason = SupportAccessGrantRequest(
        companyId: '12',
        scopeType: SupportAccessScopeType.companyMetadata,
        reason: 'ab',
        expiresAt: DateTime.now().toUtc().add(const Duration(hours: 2)),
      );
      expect(invalidReason.validationErrorKey(), 'supportGrantReasonRequired');

      final broadAccess = SupportAccessGrantRequest(
        companyId: '12',
        scopeType: SupportAccessScopeType.companyMetadata,
        reason: 'Need docs',
        expiresAt: DateTime.now().toUtc().add(const Duration(hours: 2)),
        documentsAllowed: true,
      );
      expect(broadAccess.validationErrorKey(), 'supportGrantBroadAccessRejected');
    });
  });
}
