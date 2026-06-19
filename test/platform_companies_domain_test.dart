import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/companies/domain/platform_company.dart';
import 'package:vianexis_admin_app/features/companies/domain/platform_company_status.dart';
import 'package:vianexis_admin_app/features/companies/domain/platform_company_status_request.dart';
import 'package:vianexis_admin_app/features/companies/domain/platform_company_summary.dart';

void main() {
  group('PlatformCompany JSON parsing', () {
    test('parses metadata list item', () {
      final company = PlatformCompany.fromJson({
        'id': 12,
        'name': 'Acme Logistics',
        'country': 'HU',
        'vatNumber': 'HU12345678',
        'registrationNumber': '01-09-111111',
        'status': 'active',
        'planName': 'Pro Fleet',
        'subscriptionStatus': 'active',
        'createdAt': '2026-01-01T00:00:00.000Z',
        'updatedAt': '2026-06-01T00:00:00.000Z',
        'activeUsersCount': 5,
        'driversCount': 3,
        'vehiclesCount': 4,
        'trailersCount': 2,
        'openSupportTicketsCount': 1,
        'activeSupportAccessGrantsCount': 0,
        'pendingRegistrationApplicationsCount': 0,
        'pendingBulkOnboardingJobsCount': 1,
        'lastAdminActivityAt': '2026-06-18T12:00:00.000Z',
        'metadataOnly': true,
      });

      expect(company.id, '12');
      expect(company.name, 'Acme Logistics');
      expect(company.status, PlatformCompanyStatus.active);
      expect(company.metadataOnly, isTrue);
    });

    test('parses legacy list fields', () {
      final company = PlatformCompany.fromJson({
        'companyId': 3,
        'name': 'Legacy Co',
        'status': 'inactive',
        'userCount': 2,
        'truckCount': 1,
        'trailerCount': 1,
        'activeSupportGrantCount': 1,
      });

      expect(company.id, '3');
      expect(company.status, PlatformCompanyStatus.inactive);
      expect(company.activeUsersCount, 2);
      expect(company.vehiclesCount, 1);
    });
  });

  group('PlatformCompany status and validation', () {
    test('status parsing includes pending review and archived', () {
      expect(
        PlatformCompanyStatus.fromBackendValue('pending_review'),
        PlatformCompanyStatus.pendingReview,
      );
      expect(
        PlatformCompanyStatus.fromBackendValue('archived'),
        PlatformCompanyStatus.archived,
      );
    });

    test('restrictive status requires reason', () {
      expect(
        const PlatformCompanyStatusRequest(
          status: PlatformCompanyStatus.suspended,
        ).validate(),
        'platformCompanyStatusReasonRequired',
      );
      expect(
        const PlatformCompanyStatusRequest(
          status: PlatformCompanyStatus.active,
        ).validate(),
        isNull,
      );
    });
  });

  group('PlatformCompany filters', () {
    test('search and filter behavior', () {
      const company = PlatformCompany(
        id: '1',
        name: 'Searchable GmbH',
        country: 'DE',
        vatNumber: 'DE123',
        status: PlatformCompanyStatus.pendingReview,
        createdAt: null,
        activeUsersCount: 1,
        driversCount: 0,
        vehiclesCount: 0,
        trailersCount: 0,
        openSupportTicketsCount: 0,
        activeSupportAccessGrantsCount: 0,
        pendingRegistrationApplicationsCount: 0,
        pendingBulkOnboardingJobsCount: 0,
      );

      expect(company.matchesSearch('de123'), isTrue);
      expect(company.matchesFilter(PlatformCompanyListFilter.pendingReview), isTrue);
      expect(company.matchesFilter(PlatformCompanyListFilter.active), isFalse);
    });

    test('parses dashboard summary from platform dashboard payload', () {
      final summary = PlatformCompanyDashboardSummary.fromJson({
        'companies': {
          'active': 4,
          'pendingReview': 1,
          'suspended': 2,
          'withOpenSupportIssues': 3,
          'withPendingOnboarding': 1,
        },
      });

      expect(summary.activeCompanies, 4);
      expect(summary.companiesWithOpenSupportIssues, 3);
    });
  });
}
