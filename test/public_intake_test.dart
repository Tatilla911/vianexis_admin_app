import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/public_intakes/domain/public_intake.dart';
import 'package:vianexis_admin_app/features/public_intakes/domain/public_intake_filter.dart';
import 'package:vianexis_admin_app/features/public_intakes/domain/public_intake_status.dart';
import 'package:vianexis_admin_app/features/public_intakes/domain/public_intake_type.dart';

void main() {
  group('PublicIntakeType', () {
    test('parses backend values', () {
      expect(
        PublicIntakeType.fromBackendValue('quote_request'),
        PublicIntakeType.quoteRequest,
      );
      expect(
        PublicIntakeType.fromBackendValue('demo_request'),
        PublicIntakeType.demoRequest,
      );
    });
  });

  group('PublicIntakeStatus', () {
    test('parses backend values', () {
      expect(
        PublicIntakeStatus.fromBackendValue('new'),
        PublicIntakeStatus.newStatus,
      );
      expect(
        PublicIntakeStatus.fromBackendValue('reviewing'),
        PublicIntakeStatus.reviewing,
      );
    });

    test('requires reason on reject and close', () {
      expect(PublicIntakeStatus.rejected.requiresReasonOnClose, isTrue);
      expect(PublicIntakeStatus.closed.requiresReasonOnClose, isTrue);
      expect(PublicIntakeStatus.reviewing.requiresReasonOnClose, isFalse);
    });
  });

  group('PublicIntake.fromJson', () {
    test('parses list item without message body', () {
      final intake = PublicIntake.fromJson({
        'id': 7,
        'intakeType': 'contact',
        'sourceLocale': 'hu',
        'preferredLanguage': 'hu',
        'messageOriginalLanguage': 'hu',
        'status': 'new',
        'customerEmailDomain': 'example.com',
        'metadataOnly': true,
      });

      expect(intake.id, '7');
      expect(intake.type, PublicIntakeType.contact);
      expect(intake.messageOriginalText, isNull);
      expect(intake.metadataOnly, isTrue);
    });

    test('parses detail with original message and consent', () {
      final intake = PublicIntake.fromDetailResponseJson({
        'intake': {
          'id': 3,
          'intakeType': 'quote_request',
          'sourceLocale': 'en',
          'preferredLanguage': 'en',
          'messageOriginalLanguage': 'en',
          'status': 'reviewing',
          'messageOriginalText': 'Need pricing for fleet.',
          'consentPrivacy': true,
          'consentVersion': '2026-06',
          'linkedCustomerCommunicationThreadId': 99,
        },
      });

      expect(intake.messageOriginalText, contains('pricing'));
      expect(intake.consentPrivacy, isTrue);
      expect(intake.linkedCustomerCommunicationThreadId, '99');
    });
  });

  group('publicIntakeMatchesFilter', () {
    test('filters quote and demo high priority', () {
      const quote = PublicIntake(
        id: '1',
        type: PublicIntakeType.quoteRequest,
        sourceLocale: 'en',
        preferredLanguage: 'en',
        messageOriginalLanguage: 'en',
        status: PublicIntakeStatus.newStatus,
      );
      expect(
        publicIntakeMatchesFilter(quote, PublicIntakeListFilter.quoteDemo),
        isTrue,
      );
      expect(
        publicIntakeMatchesFilter(quote, PublicIntakeListFilter.newStatus),
        isTrue,
      );
    });
  });
}
