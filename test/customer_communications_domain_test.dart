import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/customer_communications/domain/customer_agreement_snapshot.dart';
import 'package:vianexis_admin_app/features/customer_communications/domain/customer_communication_message.dart';
import 'package:vianexis_admin_app/features/customer_communications/domain/customer_communication_thread.dart';
import 'package:vianexis_admin_app/features/customer_communications/domain/customer_evidence_package.dart';
import 'package:vianexis_admin_app/features/customer_communications/domain/evidence_package_request.dart';

void main() {
  group('CustomerCommunicationThread', () {
    test('parses metadata-first list item json', () {
      final thread = CustomerCommunicationThread.fromJson({
        'id': 101,
        'companyId': 12,
        'subscriptionId': 55,
        'customerEmailDomain': 'nordtrans.example',
        'customerDisplayName': 'Anna Kovács',
        'status': 'disputed',
        'source': 'public_site',
        'disputed': true,
        'disputeReason': 'Customer denies larger package.',
        'metadataOnly': true,
        'createdAt': '2026-06-10T08:00:00.000Z',
        'updatedAt': '2026-06-18T10:00:00.000Z',
      });

      expect(thread.id, '101');
      expect(thread.status, CustomerCommunicationThreadStatus.disputed);
      expect(thread.disputed, isTrue);
      expect(thread.isBillingRelated, isTrue);
      expect(thread.metadataOnly, isTrue);
    });

    test('matches disputed filter and search', () {
      const thread = CustomerCommunicationThread(
        id: '1',
        customerEmailDomain: 'example.com',
        customerDisplayName: 'Test User',
        status: CustomerCommunicationThreadStatus.disputed,
        source: CustomerCommunicationSource.email,
        disputed: true,
      );

      expect(
        thread.matchesFilter(CustomerCommunicationListFilter.disputed),
        isTrue,
      );
      expect(thread.matchesSearch('example'), isTrue);
    });
  });

  group('CustomerCommunicationMessage', () {
    test('preserves original and translated text separately', () {
      final message = CustomerCommunicationMessage.fromJson({
        'id': 1001,
        'threadId': 101,
        'direction': 'inbound',
        'senderType': 'customer',
        'originalText': 'Nagy csomagot szeretnék.',
        'originalLanguage': 'hu',
        'translatedText': 'I want the larger package.',
        'translatedLanguage': 'en',
        'humanReviewedTranslation': true,
      });

      expect(message.originalText, 'Nagy csomagot szeretnék.');
      expect(message.translatedText, 'I want the larger package.');
      expect(message.hasTranslation, isTrue);
    });
  });

  group('CustomerEvidencePackage', () {
    test('marks pdf pending when fileUrl is null', () {
      final pkg = CustomerEvidencePackage.fromJson({
        'id': 701,
        'threadId': 101,
        'packageType': 'subscription_dispute',
        'status': 'generated',
        'fileUrl': null,
        'pdfRendererPending': true,
        'summaryJson': {'pdfRendererPending': true},
      });

      expect(pkg.isPdfPending, isTrue);
      expect(pkg.fileUrl, isNull);
    });
  });

  group('EvidencePackageRequest', () {
    test('requires reason in payload', () {
      final request = EvidencePackageRequest(
        packageType: CustomerEvidencePackageType.communicationEvidence,
        reason: 'Customer dispute review',
      );

      expect(request.toJson()['reason'], 'Customer dispute review');
      expect(
        request.toJson()['packageType'],
        'communication_evidence',
      );
    });
  });

  group('CustomerAgreementSnapshot', () {
    test('parses plan snapshot json', () {
      final snapshot = CustomerAgreementSnapshot.fromJson({
        'id': 501,
        'planName': 'Enterprise Plus',
        'planCode': 'enterprise_plus',
        'selectedModules': ['fleet', 'billing'],
        'termsVersion': '2026.06',
      });

      expect(snapshot.planCode, 'enterprise_plus');
      expect(snapshot.selectedModules, ['fleet', 'billing']);
    });
  });
}
