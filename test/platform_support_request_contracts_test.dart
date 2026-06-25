import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/billing/domain/billing_action_request.dart';
import 'package:vianexis_admin_app/features/billing/domain/pricing_intake_status.dart';
import 'package:vianexis_admin_app/features/billing/domain/quote_request_status.dart';
import 'package:vianexis_admin_app/features/billing/domain/subscription_status.dart';
import 'package:vianexis_admin_app/features/customer_communications/domain/customer_evidence_package.dart';
import 'package:vianexis_admin_app/features/customer_communications/domain/evidence_package_request.dart';
import 'package:vianexis_admin_app/features/customer_communications/domain/send_reply_request.dart';
import 'package:vianexis_admin_app/features/support/domain/support_access_grant_request.dart';
import 'package:vianexis_admin_app/features/support/domain/support_access_scope_type.dart';
import 'package:vianexis_admin_app/features/support/domain/support_ticket_action_request.dart';

void main() {
  group('Support ticket actions', () {
    test('acknowledge omits empty note from JSON', () {
      const request = SupportTicketActionRequest(
        type: SupportTicketActionType.acknowledge,
      );
      expect(request.toJson(), isEmpty);
    });

    test('close serializes note field required by backend', () {
      const request = SupportTicketActionRequest(
        type: SupportTicketActionType.close,
        note: 'Resolved after review',
      );
      expect(request.toJson(), {'note': 'Resolved after review'});
      expect(request.toJson().containsKey('reason'), isFalse);
    });
  });

  group('Support access grants', () {
    test('revoke serializes reason never note', () {
      final request = SupportAccessGrantRequest(
        companyId: '12',
        scopeType: SupportAccessScopeType.companyMetadata,
        reason: 'Investigation complete',
        expiresAt: DateTime.utc(2026, 6, 18, 10),
        type: SupportAccessGrantActionType.revoke,
      );
      expect(request.toJson(), {'reason': 'Investigation complete'});
      expect(request.toJson().containsKey('note'), isFalse);
    });

    test('create serializes backend grant fields', () {
      final request = SupportAccessGrantRequest(
        companyId: '12',
        scopeType: SupportAccessScopeType.systemHealthIssue,
        scopeId: '501',
        reason: 'Investigate health metadata',
        expiresAt: DateTime.utc(2026, 6, 18, 10),
      );
      final json = request.toJson();
      expect(json['companyId'], 12);
      expect(json['grantedToRole'], 'support_admin');
      expect(json['accessLevel'], 'read_only');
      expect(json['reason'], 'Investigate health metadata');
      expect(json['documentsAllowed'], isFalse);
      expect(json['scope'], isA<List<dynamic>>());
    });
  });

  group('Customer communications', () {
    test('send reply serializes draft and humanConfirmed fields', () {
      const request = SendCustomerReplyRequest(
        messageText: 'Hello customer',
        messageLanguage: 'en',
        recipientLanguage: 'hu',
        humanConfirmed: true,
      );
      final json = request.toJson();
      expect(json['draftText'], 'Hello customer');
      expect(json['messageText'], 'Hello customer');
      expect(json['draftLanguage'], 'en');
      expect(json['targetLanguage'], 'hu');
      expect(json['humanConfirmed'], isTrue);
    });

    test('resend reply serializes reason and humanConfirmed', () {
      const request = ResendCustomerReplyRequest(
        reason: 'Customer requested resend',
        humanConfirmed: true,
      );
      expect(request.toJson(), {
        'reason': 'Customer requested resend',
        'humanConfirmed': true,
      });
    });

    test('mark dispute serializes reason only', () {
      const request = MarkCustomerDisputeRequest(
        reason: 'Customer disputed billing metadata',
      );
      expect(request.toJson(), {'reason': 'Customer disputed billing metadata'});
    });

    test('evidence package serializes packageType and reason', () {
      const request = EvidencePackageRequest(
        packageType: CustomerEvidencePackageType.communicationEvidence,
        reason: 'Audit export for support review',
      );
      expect(request.toJson(), {
        'packageType': 'communication_evidence',
        'reason': 'Audit export for support review',
      });
    });
  });

  group('Billing admin actions', () {
    test('subscription status serializes status reason and note', () {
      const request = BillingSubscriptionStatusRequest(
        status: SubscriptionStatus.suspended,
        reason: 'Payment review',
        note: 'Ops note',
      );
      expect(request.toJson(), {
        'status': 'suspended',
        'reason': 'Payment review',
        'note': 'Ops note',
      });
    });

    test('pricing intake status serializes backend patch value', () {
      const request = BillingPricingIntakeStatusRequest(
        status: PricingIntakeStatus.rejected,
        reason: 'Out of scope',
      );
      expect(request.toJson(), {
        'status': 'rejected',
        'reason': 'Out of scope',
      });
    });

    test('quote request status serializes status and reason', () {
      const request = BillingQuoteRequestStatusRequest(
        status: QuoteRequestStatus.rejected,
        reason: 'Not a fit',
      );
      expect(request.toJson(), {
        'status': 'rejected',
        'reason': 'Not a fit',
      });
    });
  });

  group('Public intake status patch body', () {
    test('matches backend UpdatePublicIntakeStatusDto field names', () {
      const body = {
        'status': 'rejected',
        'reason': 'Does not meet minimum fleet size',
      };
      expect(body['status'], 'rejected');
      expect(body['reason'], isA<String>());
      expect((body['reason'] as String).length, greaterThanOrEqualTo(5));
      expect(body.containsKey('note'), isFalse);
    });
  });
}
