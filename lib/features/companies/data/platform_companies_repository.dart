import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/localization/localization_keys.dart';
import '../domain/platform_company.dart';
import '../domain/platform_company_status.dart';
import '../domain/platform_company_status_request.dart';
import '../domain/platform_company_summary.dart';
import 'platform_companies_api.dart';

abstract class PlatformCompaniesRepository {
  Future<List<PlatformCompany>> fetchCompanies({
    PlatformCompanyStatus? status,
    String? search,
  });

  Future<PlatformCompany> fetchCompany(String id);

  Future<PlatformCompanyUsersSummary> fetchUsersSummary(String id);

  Future<PlatformCompanySystemSummary> fetchSystemSummary(String id);

  Future<PlatformCompanyOnboardingSummary> fetchOnboardingSummary(String id);

  Future<PlatformCompany> updateStatus({
    required String id,
    required PlatformCompanyStatusRequest request,
  });

  Future<PlatformCompanyDashboardSummary> fetchDashboardSummary();

  bool get usesMockData;
}

class LivePlatformCompaniesRepository implements PlatformCompaniesRepository {
  LivePlatformCompaniesRepository(this._api);

  final PlatformCompaniesApi _api;

  @override
  bool get usesMockData => false;

  @override
  Future<List<PlatformCompany>> fetchCompanies({
    PlatformCompanyStatus? status,
    String? search,
  }) async {
    final page = await _api.listCompanies(
      status: status,
      search: search,
      limit: 200,
    );
    return page.items;
  }

  @override
  Future<PlatformCompany> fetchCompany(String id) => _api.getCompany(id);

  @override
  Future<PlatformCompanyUsersSummary> fetchUsersSummary(String id) {
    return _api.getUsersSummary(id);
  }

  @override
  Future<PlatformCompanySystemSummary> fetchSystemSummary(String id) {
    return _api.getSystemSummary(id);
  }

  @override
  Future<PlatformCompanyOnboardingSummary> fetchOnboardingSummary(String id) {
    return _api.getOnboardingSummary(id);
  }

  @override
  Future<PlatformCompany> updateStatus({
    required String id,
    required PlatformCompanyStatusRequest request,
  }) {
    return _api.updateStatus(id: id, request: request);
  }

  @override
  Future<PlatformCompanyDashboardSummary> fetchDashboardSummary() {
    return _api.getDashboardSummary();
  }
}

class MockPlatformCompaniesRepository implements PlatformCompaniesRepository {
  MockPlatformCompaniesRepository();

  final List<PlatformCompany> _companies = [
    PlatformCompany(
      id: '1',
      name: 'NordTrans Kft.',
      country: 'HU',
      vatNumber: 'HU12345678',
      registrationNumber: '01-09-999999',
      status: PlatformCompanyStatus.active,
      planName: 'Pro Fleet',
      subscriptionStatus: 'active',
      createdAt: DateTime.utc(2025, 1, 10),
      updatedAt: DateTime.utc(2026, 6, 1),
      activeUsersCount: 12,
      driversCount: 8,
      vehiclesCount: 15,
      trailersCount: 10,
      openSupportTicketsCount: 1,
      activeSupportAccessGrantsCount: 0,
      pendingRegistrationApplicationsCount: 0,
      pendingBulkOnboardingJobsCount: 1,
      lastAdminActivityAt: DateTime.utc(2026, 6, 18, 14, 30),
    ),
    PlatformCompany(
      id: '2',
      name: 'Alpine Logistics GmbH',
      country: 'DE',
      vatNumber: 'DE998877665',
      status: PlatformCompanyStatus.pendingReview,
      planName: 'Trial',
      subscriptionStatus: 'trial',
      createdAt: DateTime.utc(2026, 5, 20),
      updatedAt: DateTime.utc(2026, 6, 10),
      activeUsersCount: 3,
      driversCount: 2,
      vehiclesCount: 4,
      trailersCount: 2,
      openSupportTicketsCount: 2,
      activeSupportAccessGrantsCount: 1,
      pendingRegistrationApplicationsCount: 1,
      pendingBulkOnboardingJobsCount: 0,
    ),
    PlatformCompany(
      id: '3',
      name: 'Suspended Fleet Ltd.',
      country: 'AT',
      status: PlatformCompanyStatus.suspended,
      subscriptionStatus: 'suspended',
      createdAt: DateTime.utc(2024, 11, 5),
      activeUsersCount: 0,
      driversCount: 0,
      vehiclesCount: 2,
      trailersCount: 1,
      openSupportTicketsCount: 0,
      activeSupportAccessGrantsCount: 0,
      pendingRegistrationApplicationsCount: 0,
      pendingBulkOnboardingJobsCount: 0,
    ),
  ];

  @override
  bool get usesMockData => true;

  @override
  Future<List<PlatformCompany>> fetchCompanies({
    PlatformCompanyStatus? status,
    String? search,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return _companies
        .where((company) => status == null || company.status == status)
        .where((company) => search == null || company.matchesSearch(search))
        .toList(growable: false);
  }

  @override
  Future<PlatformCompany> fetchCompany(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return _companies.firstWhere(
      (company) => company.id == id,
      orElse: () => throw const ApiException(
        messageKey: LocalizationKeys.errorGenericBody,
        kind: ApiExceptionKind.notFound,
      ),
    );
  }

  @override
  Future<PlatformCompanyUsersSummary> fetchUsersSummary(String id) async {
    final company = await fetchCompany(id);
    return PlatformCompanyUsersSummary(
      companyId: id,
      activeUsersCount: company.activeUsersCount,
      invitedUsersCount: 1,
      suspendedUsersCount: 0,
      totalUsersCount: company.activeUsersCount + 1,
      driversCount: company.driversCount,
      usersByRole: const {'company_admin': 1, 'driver': 8},
      usersByStatus: const {'active': 12, 'invited': 1},
    );
  }

  @override
  Future<PlatformCompanySystemSummary> fetchSystemSummary(String id) async {
    final company = await fetchCompany(id);
    return PlatformCompanySystemSummary(
      companyId: id,
      vehiclesCount: company.vehiclesCount,
      trailersCount: company.trailersCount,
      openSupportTicketsCount: company.openSupportTicketsCount,
      activeSupportAccessGrantsCount: company.activeSupportAccessGrantsCount,
      departmentsCount: 2,
      contactCardsCount: 4,
      documentsCount: 120,
      packagesCount: 45,
    );
  }

  @override
  Future<PlatformCompanyOnboardingSummary> fetchOnboardingSummary(String id) async {
    final company = await fetchCompany(id);
    return PlatformCompanyOnboardingSummary(
      companyId: id,
      pendingRegistrationApplicationsCount:
          company.pendingRegistrationApplicationsCount,
      pendingBulkOnboardingJobsCount: company.pendingBulkOnboardingJobsCount,
      pendingPricingIntakeCount: 0,
      pricingIntakesNeedingReview: 0,
    );
  }

  @override
  Future<PlatformCompany> updateStatus({
    required String id,
    required PlatformCompanyStatusRequest request,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    final index = _companies.indexWhere((company) => company.id == id);
    if (index < 0) {
      throw const ApiException(
        messageKey: LocalizationKeys.errorGenericBody,
        kind: ApiExceptionKind.notFound,
      );
    }
    final current = _companies[index];
    final updated = PlatformCompany(
      id: current.id,
      name: current.name,
      country: current.country,
      vatNumber: current.vatNumber,
      registrationNumber: current.registrationNumber,
      status: request.status,
      planName: current.planName,
      subscriptionStatus: current.subscriptionStatus,
      createdAt: current.createdAt,
      updatedAt: DateTime.now().toUtc(),
      activeUsersCount: current.activeUsersCount,
      driversCount: current.driversCount,
      vehiclesCount: current.vehiclesCount,
      trailersCount: current.trailersCount,
      openSupportTicketsCount: current.openSupportTicketsCount,
      activeSupportAccessGrantsCount: current.activeSupportAccessGrantsCount,
      pendingRegistrationApplicationsCount:
          current.pendingRegistrationApplicationsCount,
      pendingBulkOnboardingJobsCount: current.pendingBulkOnboardingJobsCount,
      lastAdminActivityAt: DateTime.now().toUtc(),
    );
    _companies[index] = updated;
    return updated;
  }

  @override
  Future<PlatformCompanyDashboardSummary> fetchDashboardSummary() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return PlatformCompanyDashboardSummary(
      activeCompanies: _companies
          .where((c) => c.status == PlatformCompanyStatus.active)
          .length,
      pendingReviewCompanies: _companies
          .where((c) => c.status == PlatformCompanyStatus.pendingReview)
          .length,
      suspendedCompanies: _companies
          .where((c) => c.status == PlatformCompanyStatus.suspended)
          .length,
      companiesWithOpenSupportIssues: _companies
          .where((c) => c.openSupportTicketsCount > 0)
          .length,
      companiesWithPendingOnboarding: _companies
          .where((c) => c.pendingBulkOnboardingJobsCount > 0)
          .length,
    );
  }
}

final platformCompaniesRepositoryProvider = Provider<PlatformCompaniesRepository>(
  (ref) {
    final apiClient = ref.watch(apiClientProvider);
    if (apiClient.isConfigured) {
      return LivePlatformCompaniesRepository(
        ref.watch(platformCompaniesApiProvider),
      );
    }
    return MockPlatformCompaniesRepository();
  },
);
