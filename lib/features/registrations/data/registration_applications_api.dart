import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_exception.dart';
import '../../applications/data/activation_invite_diagnostics.dart';
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
    const method = 'POST';
    final endpoint =
        '/platform-admin/registration-applications/$applicationId/resend-invite';
    logActivationInviteAction(
      action: 'activation_invite_send',
      method: method,
      endpoint: endpoint,
      applicationId: applicationId,
      usedMockRepository: false,
    );
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        endpoint,
        data: const <String, dynamic>{},
      );
      final outcome = RegistrationApprovalOutcome.fromJson(response.data);
      logActivationInviteAction(
        action: 'activation_invite_send',
        method: method,
        endpoint: endpoint,
        applicationId: applicationId,
        companyId: outcome.companyId,
        inviteId: outcome.inviteTokenId,
        httpStatus: response.statusCode,
        deliveryStatus: outcome.inviteDeliveryStatus,
        usedMockRepository: false,
      );
      return outcome;
    } on ApiException catch (error) {
      logActivationInviteApiException(
        action: 'activation_invite_send',
        method: method,
        endpoint: endpoint,
        error: error,
        applicationId: applicationId,
      );
      rethrow;
    }
  }

  Future<Map<String, dynamic>> sendPasswordSetup(String applicationId) async {
    const method = 'POST';
    final endpoint =
        '/platform-admin/registration-applications/$applicationId/send-password-setup';
    logActivationInviteAction(
      action: 'activation_invite_send',
      method: method,
      endpoint: endpoint,
      applicationId: applicationId,
      usedMockRepository: false,
    );
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        endpoint,
        data: const <String, dynamic>{},
      );
      final data = response.data ?? <String, dynamic>{};
      logActivationInviteAction(
        action: 'activation_invite_send',
        method: method,
        endpoint: endpoint,
        applicationId: applicationId,
        companyId: data['companyId']?.toString(),
        inviteId: data['invite'] is Map
            ? (data['invite'] as Map)['tokenId']?.toString()
            : data['inviteId']?.toString(),
        httpStatus: response.statusCode,
        deliveryStatus:
            data['emailDeliveryStatus']?.toString() ??
            data['emailInviteDeliveryStatus']?.toString(),
        usedMockRepository: false,
      );
      return data;
    } on ApiException catch (error) {
      logActivationInviteApiException(
        action: 'activation_invite_send',
        method: method,
        endpoint: endpoint,
        error: error,
        applicationId: applicationId,
      );
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getInviteStatus(String applicationId) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/registration-applications/$applicationId/invite-status',
    );
    return response.data ?? <String, dynamic>{};
  }

  Future<void> revokeInvite(String applicationId) async {
    await _apiClient.post<Map<String, dynamic>>(
      '/platform-admin/registration-applications/$applicationId/revoke-invite',
      data: const <String, dynamic>{},
    );
  }
}

final registrationApplicationsApiProvider =
    Provider<RegistrationApplicationsApi>(
      (ref) => RegistrationApplicationsApi(ref.watch(apiClientProvider)),
    );
