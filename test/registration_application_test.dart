import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/registrations/domain/registration_application.dart';
import 'package:vianexis_admin_app/features/registrations/domain/registration_application_status.dart';
import 'package:vianexis_admin_app/features/registrations/domain/registration_risk_level.dart';

void main() {
  group('RegistrationApplicationStatus', () {
    test('parses backend values', () {
      expect(
        RegistrationApplicationStatus.fromBackendValue('pending'),
        RegistrationApplicationStatus.pending,
      );
      expect(
        RegistrationApplicationStatus.fromBackendValue('needs_more_info'),
        RegistrationApplicationStatus.needsMoreInfo,
      );
      expect(
        RegistrationApplicationStatus.fromBackendValue('approved'),
        RegistrationApplicationStatus.approved,
      );
    });

    test('returns unknown for invalid value', () {
      expect(
        RegistrationApplicationStatus.fromBackendValue('invalid'),
        RegistrationApplicationStatus.unknown,
      );
    });
  });

  group('RegistrationRiskLevel', () {
    test('maps risk score thresholds', () {
      expect(RegistrationRiskLevel.fromRiskScore(0.2), RegistrationRiskLevel.low);
      expect(RegistrationRiskLevel.fromRiskScore(0.5), RegistrationRiskLevel.medium);
      expect(RegistrationRiskLevel.fromRiskScore(0.9), RegistrationRiskLevel.high);
      expect(RegistrationRiskLevel.fromRiskScore(null), RegistrationRiskLevel.unknown);
    });
  });

  group('RegistrationApplication.fromJson', () {
    test('parses list item json', () {
      final application = RegistrationApplication.fromJson({
        'id': 12,
        'companyName': 'Acme Transport',
        'country': 'HU',
        'vatNumber': 'HU99999999',
        'registrationNumber': '01-09-999999',
        'contactName': 'Jane Doe',
        'contactEmail': 'jane@acme.example',
        'status': 'pending',
        'needsHumanReview': true,
        'createdAt': '2026-06-12T10:00:00.000Z',
      });

      expect(application.id, '12');
      expect(application.companyName, 'Acme Transport');
      expect(application.status, RegistrationApplicationStatus.pending);
      expect(application.contactEmail, 'jane@acme.example');
    });

    test('parses detail response with ai review', () {
      final application = RegistrationApplication.fromDetailResponseJson({
        'application': {
          'id': 5,
          'companyName': 'Beta Logistics',
          'contactEmail': 'ops@beta.example',
          'status': 'needs_more_info',
          'duplicateCheckStatus': 'possible_duplicate',
          'completenessScore': 0.6,
          'createdAt': '2026-06-11T08:00:00.000Z',
        },
        'aiReviews': [
          {
            'suggestedAction': 'request_info',
            'summary': 'Missing registry confirmation.',
            'riskScore': 0.75,
            'findings': {'contact_phone': 'missing'},
          },
        ],
      });

      expect(application.status, RegistrationApplicationStatus.needsMoreInfo);
      expect(application.aiRecommendation, 'request_info');
      expect(application.aiSummary, 'Missing registry confirmation.');
      expect(application.riskLevel, RegistrationRiskLevel.high);
      expect(application.missingInformation, contains('contact_phone'));
      expect(application.duplicateWarnings, contains('possible_duplicate'));
    });

    test('matches search and filters', () {
      const application = RegistrationApplication(
        id: '1',
        type: RegistrationApplicationType.company,
        companyName: 'Searchable Co',
        country: 'DE',
        vatNumber: 'DE123',
        contactEmail: 'hello@searchable.example',
        status: RegistrationApplicationStatus.pending,
        riskLevel: RegistrationRiskLevel.high,
        aiRecommendation: 'review',
        aiSummary: 'summary',
      );

      expect(application.matchesSearch('DE123'), isTrue);
      expect(application.matchesFilter(RegistrationListFilter.pending), isTrue);
      expect(application.matchesFilter(RegistrationListFilter.highRisk), isTrue);
      expect(application.matchesFilter(RegistrationListFilter.approved), isFalse);
    });
  });

  group('RegistrationApplicationsPage.fromJson', () {
    test('parses paginated list', () {
      final page = RegistrationApplicationsPage.fromJson({
        'total': 2,
        'items': [
          {'id': 1, 'companyName': 'A', 'contactEmail': 'a@example.com', 'status': 'pending'},
          {'id': 2, 'companyName': 'B', 'contactEmail': 'b@example.com', 'status': 'approved'},
        ],
      });

      expect(page.total, 2);
      expect(page.items, hasLength(2));
      expect(page.items.first.companyName, 'A');
    });
  });
}
