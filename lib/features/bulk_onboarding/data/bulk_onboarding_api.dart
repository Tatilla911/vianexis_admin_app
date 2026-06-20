import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../domain/bulk_onboarding_action_request.dart';
import '../domain/bulk_onboarding_job.dart';
import '../domain/bulk_onboarding_row.dart';
import '../domain/bulk_onboarding_row_status.dart';
import '../domain/bulk_onboarding_status.dart';
import '../domain/bulk_onboarding_type.dart';
import '../domain/bulk_onboarding_row_action.dart';
import '../domain/bulk_onboarding_upload_result.dart';

class BulkOnboardingApi {
  BulkOnboardingApi(this._apiClient);

  final ApiClient _apiClient;

  Future<BulkOnboardingJobsPage> listJobs({
    BulkOnboardingJobStatus? status,
    BulkOnboardingListFilter? filter,
    String? search,
    int limit = 100,
    int offset = 0,
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/bulk-onboarding/jobs',
      queryParameters: {
        if (status != null && status != BulkOnboardingJobStatus.unknown)
          'status': status.backendValue,
        if (filter == BulkOnboardingListFilter.highRisk) 'highRisk': true,
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
        'limit': limit,
        'offset': offset,
      },
    );

    final data = response.data;
    if (data == null) {
      return const BulkOnboardingJobsPage(items: [], total: 0);
    }
    return BulkOnboardingJobsPage.fromJson(data);
  }

  Future<BulkOnboardingJob> getJob(String id) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/bulk-onboarding/jobs/$id',
    );
    final data = response.data;
    if (data == null) {
      throw StateError('Empty bulk onboarding job response');
    }
    return BulkOnboardingJob.fromDetailResponseJson(data);
  }

  Future<BulkOnboardingRowsPage> listRows({
    required String jobId,
    BulkOnboardingRowStatus? status,
    String? search,
    int limit = 200,
    int offset = 0,
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/bulk-onboarding/jobs/$jobId/rows',
      queryParameters: {
        if (status != null && status != BulkOnboardingRowStatus.unknown)
          'status': status.backendValue,
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
        'limit': limit,
        'offset': offset,
      },
    );
    final data = response.data;
    if (data == null) {
      return const BulkOnboardingRowsPage(items: [], total: 0);
    }
    return BulkOnboardingRowsPage.fromJson(data);
  }

  Future<String> downloadTemplate(BulkOnboardingJobType type) async {
    final response = await _apiClient.get<String>(
      '/platform-admin/bulk-onboarding/templates/${type.backendValue}.csv',
      options: Options(responseType: ResponseType.plain),
    );
    return response.data ?? '';
  }

  Future<String> downloadValidationReport(String jobId) async {
    final response = await _apiClient.get<String>(
      '/platform-admin/bulk-onboarding/jobs/$jobId/export-validation-report.csv',
      options: Options(responseType: ResponseType.plain),
    );
    return response.data ?? '';
  }

  Future<BulkOnboardingUploadResult> uploadCsv({
    required List<int> bytes,
    required String fileName,
    required BulkOnboardingJobType type,
    int? companyId,
    String? companyName,
    String? note,
    ProgressCallback? onSendProgress,
  }) async {
    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(bytes, filename: fileName),
      'type': type.backendValue,
      'companyId': ?companyId,
      if (companyName?.trim().isNotEmpty ?? false) 'companyName': companyName!.trim(),
      if (note != null && note.trim().isNotEmpty) 'note': note.trim(),
    });

    final response = await _apiClient.postMultipart<Map<String, dynamic>>(
      '/platform-admin/bulk-onboarding/jobs/upload',
      data: formData,
      onSendProgress: onSendProgress,
    );
    final data = response.data;
    if (data == null) {
      throw StateError('Empty bulk onboarding upload response');
    }
    return BulkOnboardingUploadResult.fromJson(data);
  }

  Future<BulkOnboardingJob> submitAction({
    required String jobId,
    required BulkOnboardingActionRequest request,
  }) async {
    final path =
        '/platform-admin/bulk-onboarding/jobs/$jobId/${request.endpointSuffix()}';
    final data = request.toJson();

    final response = switch (request.httpMethod()) {
      'POST' => await _apiClient.post<Map<String, dynamic>>(path, data: data),
      _ => await _apiClient.patch<Map<String, dynamic>>(path, data: data),
    };

    final body = response.data;
    if (body == null) {
      throw StateError('Empty bulk onboarding action response');
    }
    return BulkOnboardingJob.fromDetailResponseJson(body);
  }

  Future<BulkOnboardingRow> getRow({
    required String jobId,
    required String rowId,
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/bulk-onboarding/jobs/$jobId/rows/$rowId',
    );
    final data = response.data;
    if (data == null) {
      throw StateError('Empty bulk onboarding row response');
    }
    return BulkOnboardingRow.fromDetailResponseJson(data);
  }

  Future<BulkOnboardingRowActionResult> correctRow({
    required String jobId,
    required String rowId,
    required BulkOnboardingRowCorrectionRequest request,
  }) async {
    final response = await _apiClient.patch<Map<String, dynamic>>(
      '/platform-admin/bulk-onboarding/jobs/$jobId/rows/$rowId/correct',
      data: request.toJson(),
    );
    final data = response.data;
    if (data == null) {
      throw StateError('Empty bulk onboarding row correction response');
    }
    return BulkOnboardingRowActionResult.fromJson(data);
  }

  Future<BulkOnboardingRowActionResult> skipRow({
    required String jobId,
    required String rowId,
    required BulkOnboardingRowSkipRequest request,
  }) async {
    final response = await _apiClient.patch<Map<String, dynamic>>(
      '/platform-admin/bulk-onboarding/jobs/$jobId/rows/$rowId/skip',
      data: request.toJson(),
    );
    final data = response.data;
    if (data == null) {
      throw StateError('Empty bulk onboarding row skip response');
    }
    return BulkOnboardingRowActionResult.fromJson(data);
  }

  Future<BulkOnboardingRowActionResult> revalidateRow({
    required String jobId,
    required String rowId,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/platform-admin/bulk-onboarding/jobs/$jobId/rows/$rowId/revalidate',
    );
    final data = response.data;
    if (data == null) {
      throw StateError('Empty bulk onboarding row revalidate response');
    }
    return BulkOnboardingRowActionResult.fromJson(data);
  }

  Future<BulkOnboardingJob> revalidateJob({required String jobId}) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/platform-admin/bulk-onboarding/jobs/$jobId/revalidate',
    );
    final data = response.data;
    if (data == null) {
      throw StateError('Empty bulk onboarding job revalidate response');
    }
    return BulkOnboardingJob.fromDetailResponseJson(data);
  }
}

final bulkOnboardingApiProvider = Provider<BulkOnboardingApi>(
  (ref) => BulkOnboardingApi(ref.watch(apiClientProvider)),
);
