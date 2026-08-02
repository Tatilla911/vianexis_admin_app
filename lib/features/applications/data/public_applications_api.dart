import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_exception.dart';
import 'activation_invite_diagnostics.dart';

class PublicApplicationsApi {
  PublicApplicationsApi(this._apiClient);

  final ApiClient _apiClient;

  Future<Map<String, dynamic>> listApplications({
    String? type,
    String? status,
    int limit = 100,
    int offset = 0,
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/applications',
      queryParameters: {
        if (type != null && type.isNotEmpty) 'type': type,
        if (status != null && status.isNotEmpty) 'status': status,
        'limit': limit,
        'offset': offset,
      },
    );
    return response.data ?? {'items': [], 'total': 0};
  }

  Future<Map<String, dynamic>> getApplication(int id) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/applications/$id',
    );
    return response.data ?? {};
  }

  Future<Map<String, dynamic>> approve(
    int id, {
    String? reviewNotes,
    int? companyId,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/platform-admin/applications/$id/approve',
      data: {
        'reviewNotes': ?reviewNotes,
        'companyId': ?companyId,
      },
    );
    return response.data ?? {};
  }

  Future<Map<String, dynamic>> reject(
    int id, {
    required String reviewNotes,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/platform-admin/applications/$id/reject',
      data: {'reviewNotes': reviewNotes},
    );
    return response.data ?? {};
  }

  Future<Map<String, dynamic>> requestMoreInfo(
    int id, {
    required String reviewNotes,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/platform-admin/applications/$id/request-more-info',
      data: {'reviewNotes': reviewNotes},
    );
    return response.data ?? {};
  }

  Future<Map<String, dynamic>> getActivationInvite(int id) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/applications/$id/activation-invite',
    );
    return response.data ?? {};
  }

  Future<Map<String, dynamic>> resendActivationInvite(int id) async {
    const method = 'POST';
    final endpoint = '/platform-admin/applications/$id/resend-activation-invite';
    logActivationInviteAction(
      action: 'activation_invite_send',
      method: method,
      endpoint: endpoint,
      applicationId: '$id',
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
        applicationId: '$id',
        companyId: data['companyId']?.toString(),
        inviteId: data['inviteId']?.toString(),
        httpStatus: response.statusCode,
        deliveryStatus:
            data['deliveryStatus']?.toString() ??
            data['emailInviteDeliveryStatus']?.toString(),
        requestId: data['requestId']?.toString(),
        usedMockRepository: false,
      );
      return data;
    } on ApiException catch (error) {
      logActivationInviteApiException(
        action: 'activation_invite_send',
        method: method,
        endpoint: endpoint,
        error: error,
        applicationId: '$id',
      );
      rethrow;
    }
  }
}

final publicApplicationsApiProvider = Provider<PublicApplicationsApi>(
  (ref) => PublicApplicationsApi(ref.watch(apiClientProvider)),
);
