import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
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

  Future<PlatformCompanyOnboardingSummary> getOnboardingSummary(String id) async {
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
}

final platformCompaniesApiProvider = Provider<PlatformCompaniesApi>(
  (ref) => PlatformCompaniesApi(ref.watch(apiClientProvider)),
);
