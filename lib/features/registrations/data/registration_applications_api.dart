import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../domain/registration_application.dart';
import '../domain/registration_application_status.dart';
import '../domain/registration_approval_outcome.dart';
import '../domain/registration_decision_request.dart';

class RegistrationApplicationsApi {
  RegistrationApplicationsApi(this._apiClient);

  final ApiClient _apiClient;

  Future<RegistrationApplicationsPage> listApplications({
    RegistrationApplicationStatus? status,
    int limit = 100,
    int offset = 0,
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/registration-applications',
      queryParameters: {
        if (status != null && status != RegistrationApplicationStatus.unknown)
          'status': status.backendValue,
        'limit': limit,
        'offset': offset,
      },
    );

    final data = response.data;
    if (data == null) {
      return const RegistrationApplicationsPage(items: [], total: 0);
    }
    return RegistrationApplicationsPage.fromJson(data);
  }

  Future<RegistrationApplication> getApplication(String id) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/registration-applications/$id',
    );

    final data = response.data;
    if (data == null) {
      throw StateError('Empty registration application response');
    }
    return RegistrationApplication.fromDetailResponseJson(data);
  }

  Future<RegistrationApprovalOutcome?> submitDecision({
    required String applicationId,
    required RegistrationDecisionRequest request,
  }) async {
    final response = await _apiClient.patch<Map<String, dynamic>>(
      '/platform-admin/registration-applications/$applicationId/${request.endpointSuffix()}',
      data: request.toJson(),
    );
    if (request.type != RegistrationDecisionType.approve) {
      return null;
    }
    return RegistrationApprovalOutcome.fromJson(response.data);
  }

  Future<RegistrationApprovalOutcome> resendInvite(String applicationId) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/platform-admin/registration-applications/$applicationId/resend-invite',
    );
    return RegistrationApprovalOutcome.fromJson(response.data);
  }

  Future<void> revokeInvite(String applicationId) async {
    await _apiClient.post<Map<String, dynamic>>(
      '/platform-admin/registration-applications/$applicationId/revoke-invite',
    );
  }
}

final registrationApplicationsApiProvider = Provider<RegistrationApplicationsApi>(
  (ref) => RegistrationApplicationsApi(ref.watch(apiClientProvider)),
);
