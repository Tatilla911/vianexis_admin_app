import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';

class CompanyAssessmentSummary {
  const CompanyAssessmentSummary({
    required this.id,
    required this.status,
    required this.version,
    this.companyName,
    this.lastSavedAt,
    this.submittedAt,
    this.pricingSuggestion,
    this.adminOverride,
    this.submittedSnapshot,
    this.internalNotes,
  });

  final int id;
  final String status;
  final int version;
  final String? companyName;
  final String? lastSavedAt;
  final String? submittedAt;
  final Map<String, dynamic>? pricingSuggestion;
  final Map<String, dynamic>? adminOverride;
  final Map<String, dynamic>? submittedSnapshot;
  final String? internalNotes;

  factory CompanyAssessmentSummary.fromJson(Map<String, dynamic> json) {
    return CompanyAssessmentSummary(
      id: (json['id'] as num?)?.toInt() ?? 0,
      status: (json['status'] as String?) ?? 'draft',
      version: (json['version'] as num?)?.toInt() ?? 1,
      companyName: json['companyName'] as String?,
      lastSavedAt: json['lastSavedAt'] as String?,
      submittedAt: json['submittedAt'] as String?,
      pricingSuggestion: json['pricingSuggestion'] is Map<String, dynamic>
          ? json['pricingSuggestion'] as Map<String, dynamic>
          : null,
      adminOverride: json['adminOverride'] is Map<String, dynamic>
          ? json['adminOverride'] as Map<String, dynamic>
          : null,
      submittedSnapshot: json['submittedSnapshot'] is Map<String, dynamic>
          ? json['submittedSnapshot'] as Map<String, dynamic>
          : null,
      internalNotes: json['internalNotes'] as String?,
    );
  }
}

class CompanyAssessmentsApi {
  CompanyAssessmentsApi(this._apiClient);

  final ApiClient _apiClient;

  Future<List<CompanyAssessmentSummary>> listForCompany(String companyId) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/company-assessments',
      queryParameters: {'companyId': companyId},
    );
    final data = response.data;
    final items = data?['items'];
    if (items is! List) return const [];
    return items
        .whereType<Map>()
        .map((e) => CompanyAssessmentSummary.fromJson(
              Map<String, dynamic>.from(e),
            ))
        .toList();
  }

  Future<CompanyAssessmentSummary> savePricingOverride({
    required int assessmentId,
    required Map<String, dynamic> override,
    String? internalNotes,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/platform-admin/company-assessments/$assessmentId/pricing-override',
      data: {
        'override': override,
        'internalNotes': ?internalNotes,
      },
    );
    final data = response.data;
    if (data == null) {
      throw StateError('Empty pricing override response');
    }
    return CompanyAssessmentSummary.fromJson(data);
  }
}

final companyAssessmentsApiProvider = Provider<CompanyAssessmentsApi>(
  (ref) => CompanyAssessmentsApi(ref.watch(apiClientProvider)),
);

final companyAssessmentsForCompanyProvider =
    FutureProvider.family<List<CompanyAssessmentSummary>, String>((
  ref,
  companyId,
) {
  return ref.watch(companyAssessmentsApiProvider).listForCompany(companyId);
});
