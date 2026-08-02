import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../domain/company_data_amendment.dart';
import '../domain/platform_company.dart';
import '../domain/platform_company_status.dart';
import '../domain/platform_company_status_request.dart';
import '../domain/platform_company_summary.dart';

class PlatformCompaniesApi {
  PlatformCompaniesApi(this._apiClient);

  final ApiClient _apiClient;

  Future<PlatformCompaniesPage> listCompanies({
    PlatformCompanyStatus? status,
    String? search,
    int limit = 100,
    int offset = 0,
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/companies',
      queryParameters: {
        if (status != null && status != PlatformCompanyStatus.unknown)
          'status': status.backendValue,
        if (search != null && search.trim().isNotEmpty) 'q': search.trim(),
        'limit': limit,
        'offset': offset,
      },
    );
    final data = response.data;
    if (data == null) {
      return const PlatformCompaniesPage(items: [], total: 0);
    }
    return PlatformCompaniesPage.fromJson(data);
  }

  Future<PlatformCompany> getCompany(String id) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/companies/$id',
    );
    final data = response.data;
    if (data == null) {
      throw StateError('Empty platform company response');
    }
    return PlatformCompany.fromJson(data);
  }

  Future<PlatformCompanyUsersSummary> getUsersSummary(String id) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/companies/$id/users-summary',
    );
    final data = response.data;
    if (data == null) {
      throw StateError('Empty platform company users summary response');
    }
    return PlatformCompanyUsersSummary.fromJson(data);
  }

  Future<PlatformCompanySystemSummary> getSystemSummary(String id) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/companies/$id/system-summary',
    );
    final data = response.data;
    if (data == null) {
      throw StateError('Empty platform company system summary response');
    }
    return PlatformCompanySystemSummary.fromJson(data);
  }

  Future<PlatformCompanyOnboardingSummary> getOnboardingSummary(
    String id,
  ) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/companies/$id/onboarding-summary',
    );
    final data = response.data;
    if (data == null) {
      throw StateError('Empty platform company onboarding summary response');
    }
    return PlatformCompanyOnboardingSummary.fromJson(data);
  }

  Future<PlatformCompany> updateStatus({
    required String id,
    required PlatformCompanyStatusRequest request,
  }) async {
    final response = await _apiClient.patch<Map<String, dynamic>>(
      '/platform-admin/companies/$id/status',
      data: request.toJson(),
    );
    final data = response.data;
    if (data == null) {
      throw StateError('Empty platform company status response');
    }
    return PlatformCompany.fromJson(data);
  }

  Future<PlatformCompanyDashboardSummary> getDashboardSummary() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/dashboard',
    );
    final data = response.data;
    if (data == null) {
      return const PlatformCompanyDashboardSummary(
        activeCompanies: 0,
        pendingReviewCompanies: 0,
        suspendedCompanies: 0,
        companiesWithOpenSupportIssues: 0,
        companiesWithPendingOnboarding: 0,
      );
    }
    return PlatformCompanyDashboardSummary.fromJson(data);
  }

  Future<CompanyRegistrationSnapshot> getRegistrationSnapshot(String id) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/companies/$id/registration',
    );
    final data = response.data;
    if (data == null) {
      throw StateError('Empty company registration snapshot response');
    }
    return CompanyRegistrationSnapshot.fromJson(data);
  }

  Future<List<CompanyDataAmendment>> listAmendments(String id) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/companies/$id/amendments',
    );
    final data = response.data;
    final items = (data?['items'] as List?) ?? const [];
    return items
        .whereType<Map>()
        .map(
          (e) => CompanyDataAmendment.fromJson(Map<String, dynamic>.from(e)),
        )
        .toList(growable: false);
  }

  Future<List<CompanyAmendmentFieldOption>> listAmendmentFields(
    String id,
  ) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/companies/$id/amendment-fields',
    );
    final data = response.data;
    final items = (data?['fields'] as List?) ?? const [];
    return items
        .whereType<Map>()
        .map(
          (e) =>
              CompanyAmendmentFieldOption.fromJson(Map<String, dynamic>.from(e)),
        )
        .toList(growable: false);
  }

  Future<CompanyDataAmendment> createAmendment({
    required String id,
    required CreateCompanyAmendmentRequest request,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/platform-admin/companies/$id/amendments',
      data: request.toJson(),
    );
    final data = response.data;
    if (data == null) {
      throw StateError('Empty create amendment response');
    }
    return CompanyDataAmendment.fromJson(data);
  }

  Future<CompanyDataAmendment> approveAmendment({
    required String companyId,
    required String amendmentId,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/platform-admin/companies/$companyId/amendments/$amendmentId/approve',
    );
    final data = response.data;
    if (data == null) {
      throw StateError('Empty approve amendment response');
    }
    return CompanyDataAmendment.fromJson(data);
  }

  Future<CompanyDataAmendment> rejectAmendment({
    required String companyId,
    required String amendmentId,
    required String rejectionReason,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/platform-admin/companies/$companyId/amendments/$amendmentId/reject',
      data: {'rejectionReason': rejectionReason},
    );
    final data = response.data;
    if (data == null) {
      throw StateError('Empty reject amendment response');
    }
    return CompanyDataAmendment.fromJson(data);
  }

  Future<CompanyDataAmendment> applyAmendment({
    required String companyId,
    required String amendmentId,
    int? expectedDataVersion,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/platform-admin/companies/$companyId/amendments/$amendmentId/apply',
      data: {
        'expectedDataVersion': ?expectedDataVersion,
      },
    );
    final data = response.data;
    if (data == null) {
      throw StateError('Empty apply amendment response');
    }
    return CompanyDataAmendment.fromJson(data);
  }
}

final platformCompaniesApiProvider = Provider<PlatformCompaniesApi>(
  (ref) => PlatformCompaniesApi(ref.watch(apiClientProvider)),
);
