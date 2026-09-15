import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_config.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/localization/localization_keys.dart';
import '../domain/company_data_amendment.dart';
import '../domain/platform_company.dart';
import '../domain/platform_company_member.dart';
import '../domain/platform_company_status.dart';
import '../domain/platform_company_status_request.dart';
import '../domain/platform_company_summary.dart';
import 'platform_companies_api.dart';

abstract class PlatformCompaniesRepository {
  Future<PlatformCompaniesPage> fetchCompanies({
    PlatformCompanyStatus? status,
    String? search,
    int limit = 50,
    int offset = 0,
  });

  Future<PlatformCompany> fetchCompany(String id);

  Future<PlatformCompanyUsersSummary> fetchUsersSummary(String id);

  Future<PlatformCompanyMembersPage> listCompanyUsers({
    required String id,
    String? role,
    String? status,
    String? q,
    int limit = 100,
    int offset = 0,
  });

  Future<PlatformCompanySystemSummary> fetchSystemSummary(String id);

  Future<PlatformCompanyOnboardingSummary> fetchOnboardingSummary(String id);

  Future<PlatformCompany> updateStatus({
    required String id,
    required PlatformCompanyStatusRequest request,
  });

  Future<PlatformCompanyDashboardSummary> fetchDashboardSummary();

  Future<CompanyRegistrationSnapshot> fetchRegistrationSnapshot(String id);

  Future<List<CompanyDataAmendment>> fetchAmendments(String id);

  Future<List<CompanyAmendmentFieldOption>> fetchAmendmentFields(String id);

  Future<CompanyDataAmendment> createAmendment({
    required String id,
    required CreateCompanyAmendmentRequest request,
  });

  Future<CompanyDataAmendment> approveAmendment({
    required String companyId,
    required String amendmentId,
  });

  Future<CompanyDataAmendment> rejectAmendment({
    required String companyId,
    required String amendmentId,
    required String rejectionReason,
  });

  Future<CompanyDataAmendment> applyAmendment({
    required String companyId,
    required String amendmentId,
    int? expectedDataVersion,
  });

  Future<Map<String, dynamic>> resendInvite(String id);

  Future<Map<String, dynamic>> sendPasswordSetup(String id);

  Future<Map<String, dynamic>> softDelete({
    required String id,
    required String reason,
  });

  bool get usesMockData;
}

class LivePlatformCompaniesRepository implements PlatformCompaniesRepository {
  LivePlatformCompaniesRepository(this._api);

  final PlatformCompaniesApi _api;

  @override
  bool get usesMockData => false;

  @override
  Future<PlatformCompaniesPage> fetchCompanies({
    PlatformCompanyStatus? status,
    String? search,
    int limit = 50,
    int offset = 0,
  }) {
    return _api.listCompanies(
      status: status,
      search: search,
      limit: limit,
      offset: offset,
    );
  }

  @override
  Future<PlatformCompany> fetchCompany(String id) => _api.getCompany(id);

  @override
  Future<PlatformCompanyUsersSummary> fetchUsersSummary(String id) {
    return _api.getUsersSummary(id);
  }

  @override
  Future<PlatformCompanyMembersPage> listCompanyUsers({
    required String id,
    String? role,
    String? status,
    String? q,
    int limit = 100,
    int offset = 0,
  }) {
    return _api.listCompanyUsers(
      id: id,
      role: role,
      status: status,
      q: q,
      limit: limit,
      offset: offset,
    );
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

  @override
  Future<CompanyRegistrationSnapshot> fetchRegistrationSnapshot(String id) {
    return _api.getRegistrationSnapshot(id);
  }

  @override
  Future<List<CompanyDataAmendment>> fetchAmendments(String id) {
    return _api.listAmendments(id);
  }

  @override
  Future<List<CompanyAmendmentFieldOption>> fetchAmendmentFields(String id) {
    return _api.listAmendmentFields(id);
  }

  @override
  Future<CompanyDataAmendment> createAmendment({
    required String id,
    required CreateCompanyAmendmentRequest request,
  }) {
    return _api.createAmendment(id: id, request: request);
  }

  @override
  Future<CompanyDataAmendment> approveAmendment({
    required String companyId,
    required String amendmentId,
  }) {
    return _api.approveAmendment(
      companyId: companyId,
      amendmentId: amendmentId,
    );
  }

  @override
  Future<CompanyDataAmendment> rejectAmendment({
    required String companyId,
    required String amendmentId,
    required String rejectionReason,
  }) {
    return _api.rejectAmendment(
      companyId: companyId,
      amendmentId: amendmentId,
      rejectionReason: rejectionReason,
    );
  }

  @override
  Future<CompanyDataAmendment> applyAmendment({
    required String companyId,
    required String amendmentId,
    int? expectedDataVersion,
  }) {
    return _api.applyAmendment(
      companyId: companyId,
      amendmentId: amendmentId,
      expectedDataVersion: expectedDataVersion,
    );
  }

  @override
  Future<Map<String, dynamic>> resendInvite(String id) {
    return _api.resendInvite(id);
  }

  @override
  Future<Map<String, dynamic>> sendPasswordSetup(String id) {
    return _api.sendPasswordSetup(id);
  }

  @override
  Future<Map<String, dynamic>> softDelete({
    required String id,
    required String reason,
  }) {
    return _api.softDelete(id: id, reason: reason);
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
  Future<PlatformCompaniesPage> fetchCompanies({
    PlatformCompanyStatus? status,
    String? search,
    int limit = 50,
    int offset = 0,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final filtered = _companies
        .where((company) => status == null || company.status == status)
        .where((company) => search == null || company.matchesSearch(search))
        .toList(growable: false);
    final total = filtered.length;
    final start = offset.clamp(0, total);
    final end = (start + limit).clamp(0, total);
    return PlatformCompaniesPage(
      items: filtered.sublist(start, end),
      total: total,
      limit: limit,
      offset: offset,
    );
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
      usersByRole: const {
        'company_owner': 1,
        'company_admin': 1,
        'dispatcher': 2,
        'driver': 8,
        'workshop': 1,
        'documentation': 1,
        'finance': 1,
      },
      usersByStatus: const {'active': 12, 'invited': 1},
    );
  }

  @override
  Future<PlatformCompanyMembersPage> listCompanyUsers({
    required String id,
    String? role,
    String? status,
    String? q,
    int limit = 100,
    int offset = 0,
  }) async {
    await fetchCompany(id);
    await Future<void>.delayed(const Duration(milliseconds: 100));
    final all = <PlatformCompanyMember>[
      PlatformCompanyMember(
        membershipId: '101',
        userId: '101',
        companyId: id,
        displayName: 'Kovács Anna',
        email: 'anna.kovacs@nordtrans.example',
        primaryRole: 'company_owner',
        status: 'active',
        invitationStatus: 'none',
        joinedAt: DateTime.utc(2025, 1, 12),
        lastLoginAt: DateTime.utc(2026, 8, 1, 9, 30),
        createdAt: DateTime.utc(2025, 1, 12),
        updatedAt: DateTime.utc(2026, 8, 1),
      ),
      PlatformCompanyMember(
        membershipId: '102',
        userId: '102',
        companyId: id,
        displayName: 'Nagy Péter',
        email: 'peter.nagy@nordtrans.example',
        primaryRole: 'company_admin',
        status: 'active',
        invitationStatus: 'none',
        lastLoginAt: DateTime.utc(2026, 7, 28, 14, 0),
        createdAt: DateTime.utc(2025, 2, 1),
      ),
      PlatformCompanyMember(
        membershipId: '103',
        userId: '103',
        companyId: id,
        displayName: null,
        email: 'dispatcher@nordtrans.example',
        primaryRole: 'dispatcher',
        status: 'invited',
        invitationStatus: 'pending',
        emailDeliveryStatus: 'sent',
        createdAt: DateTime.utc(2026, 7, 1),
      ),
      PlatformCompanyMember(
        membershipId: '104',
        userId: '104',
        companyId: id,
        displayName: 'Sofőr János',
        email: 'janos.driver@nordtrans.example',
        primaryRole: 'driver',
        status: 'active',
        invitationStatus: 'none',
        driverProfileId: '501',
        lastLoginAt: DateTime.utc(2026, 8, 5, 6, 15),
        createdAt: DateTime.utc(2025, 3, 10),
      ),
      PlatformCompanyMember(
        membershipId: '105',
        userId: '105',
        companyId: id,
        email: 'docs@nordtrans.example',
        primaryRole: 'documentation',
        status: 'active',
        invitationStatus: 'none',
        createdAt: DateTime.utc(2025, 6, 1),
      ),
      PlatformCompanyMember(
        membershipId: '106',
        userId: '106',
        companyId: id,
        displayName: 'Pénzügy',
        email: 'finance@nordtrans.example',
        primaryRole: 'finance',
        status: 'active',
        invitationStatus: 'none',
        createdAt: DateTime.utc(2025, 8, 1),
      ),
    ];

    var filtered = all;
    final roleFilter = role?.trim().toLowerCase();
    if (roleFilter != null && roleFilter.isNotEmpty) {
      filtered = filtered
          .where((m) => (m.primaryRole ?? '').toLowerCase() == roleFilter)
          .toList(growable: false);
    }
    final statusFilter = status?.trim().toLowerCase();
    if (statusFilter != null && statusFilter.isNotEmpty) {
      filtered = filtered
          .where((m) => (m.status ?? '').toLowerCase() == statusFilter)
          .toList(growable: false);
    }
    final query = q?.trim().toLowerCase();
    if (query != null && query.isNotEmpty) {
      filtered = filtered
          .where((m) {
            final haystack = [
              m.displayName,
              m.email,
              m.phone,
            ].whereType<String>().join(' ').toLowerCase();
            return haystack.contains(query);
          })
          .toList(growable: false);
    }

    final total = filtered.length;
    final page = filtered.skip(offset).take(limit).toList(growable: false);
    return PlatformCompanyMembersPage(
      companyId: id,
      items: page,
      total: total,
      limit: limit,
      offset: offset,
      metadataOnly: false,
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
  Future<PlatformCompanyOnboardingSummary> fetchOnboardingSummary(
    String id,
  ) async {
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
      companyName: current.companyName,
      companyDisplayName: current.companyDisplayName,
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

  @override
  Future<CompanyRegistrationSnapshot> fetchRegistrationSnapshot(
    String id,
  ) async {
    final company = await fetchCompany(id);
    return CompanyRegistrationSnapshot(
      companyId: id,
      originalSubmitted: {
        'companyName': company.name,
        'country': company.country,
        'vatNumber': company.vatNumber,
        'registrationNumber': company.registrationNumber,
      },
      currentValid: {
        'companyName': company.name,
        'country': company.country,
        'vatNumber': company.vatNumber,
        'registrationNumber': company.registrationNumber,
      },
      differences: const [],
      registration: CompanyRegistrationMeta(
        id: 'mock-$id',
        status: 'approved',
        createdAt: company.createdAt,
        contactEmail: 'mock@example.com',
        requestedAdminEmail: 'admin@example.com',
      ),
      dataVersion: 1,
    );
  }

  @override
  Future<List<CompanyDataAmendment>> fetchAmendments(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 80));
    return const [];
  }

  @override
  Future<List<CompanyAmendmentFieldOption>> fetchAmendmentFields(
    String id,
  ) async {
    return const [
      CompanyAmendmentFieldOption(
        fieldPath: 'company.companyName',
        fieldLabelKey: 'platformCompanyAmendFieldLegalName',
        valueType: 'string',
        sensitive: true,
      ),
      CompanyAmendmentFieldOption(
        fieldPath: 'company.website',
        fieldLabelKey: 'platformCompanyAmendFieldWebsite',
        valueType: 'url',
        sensitive: false,
      ),
    ];
  }

  @override
  Future<CompanyDataAmendment> createAmendment({
    required String id,
    required CreateCompanyAmendmentRequest request,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return CompanyDataAmendment(
      id: 'mock-1',
      companyId: id,
      fieldPath: request.fieldPath,
      fieldLabelKey: 'platformCompanyAmendFieldLegalName',
      oldValueJson: 'Old',
      newValueJson: request.newValue,
      reason: request.reason,
      requestedByUserId: 1,
      requestedByRole: 'super_admin',
      requestedAt: DateTime.now().toUtc(),
      authorizationSource: request.authorizationSource,
      authorizedByName: request.authorizedByName,
      authorizationMethod: request.authorizationMethod,
      authorizationReference: request.authorizationReference,
      internalComment: request.internalComment,
      customerVisibleComment: request.customerVisibleComment,
      status: request.fieldPath.contains('companyName')
          ? 'pending_approval'
          : 'applied',
      requestId: 'mock-req',
      expectedDataVersion: request.expectedDataVersion,
    );
  }

  @override
  Future<CompanyDataAmendment> approveAmendment({
    required String companyId,
    required String amendmentId,
  }) async {
    throw const ApiException(
      messageKey: LocalizationKeys.errorGenericBody,
      kind: ApiExceptionKind.forbidden,
    );
  }

  @override
  Future<CompanyDataAmendment> rejectAmendment({
    required String companyId,
    required String amendmentId,
    required String rejectionReason,
  }) async {
    throw const ApiException(
      messageKey: LocalizationKeys.errorGenericBody,
      kind: ApiExceptionKind.forbidden,
    );
  }

  @override
  Future<CompanyDataAmendment> applyAmendment({
    required String companyId,
    required String amendmentId,
    int? expectedDataVersion,
  }) async {
    throw const ApiException(
      messageKey: LocalizationKeys.errorGenericBody,
      kind: ApiExceptionKind.forbidden,
    );
  }

  @override
  Future<Map<String, dynamic>> resendInvite(String id) async {
    return {
      'companyId': int.tryParse(id),
      'mode': 'invite',
      'emailSent': false,
      'deliveryStatus': 'provider_disabled',
    };
  }

  @override
  Future<Map<String, dynamic>> sendPasswordSetup(String id) async {
    return {
      'companyId': int.tryParse(id),
      'mode': 'password_reset',
      'emailSent': false,
      'deliveryStatus': 'provider_disabled',
    };
  }

  @override
  Future<Map<String, dynamic>> softDelete({
    required String id,
    required String reason,
  }) async {
    await updateStatus(
      id: id,
      request: PlatformCompanyStatusRequest(
        status: PlatformCompanyStatus.archived,
        reason: reason,
      ),
    );
    return {
      'companyId': int.tryParse(id),
      'deleted': true,
      'status': 'archived',
    };
  }
}

final platformCompaniesRepositoryProvider =
    Provider<PlatformCompaniesRepository>((ref) {
      if (AppConfig.instance.shouldUseLiveRepositories) {
        return LivePlatformCompaniesRepository(
          ref.watch(platformCompaniesApiProvider),
        );
      }
      return MockPlatformCompaniesRepository();
    });
