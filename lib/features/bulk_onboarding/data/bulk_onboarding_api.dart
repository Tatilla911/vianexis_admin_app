import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../domain/bulk_onboarding_action_request.dart';
import '../domain/bulk_onboarding_job.dart';
import '../domain/bulk_onboarding_row.dart';
import '../domain/bulk_onboarding_row_status.dart';
import '../domain/bulk_onboarding_status.dart';

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
    int limit = 200,
    int offset = 0,
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/bulk-onboarding/jobs/$jobId/rows',
      queryParameters: {
        if (status != null && status != BulkOnboardingRowStatus.unknown)
          'status': status.backendValue,
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
}

final bulkOnboardingApiProvider = Provider<BulkOnboardingApi>(
  (ref) => BulkOnboardingApi(ref.watch(apiClientProvider)),
);
