import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../domain/driver_registration_request.dart';

class DriverRegistrationRequestsApi {
  DriverRegistrationRequestsApi(this._apiClient);

  final ApiClient _apiClient;

  Future<DriverRegistrationRequestsPage> listPending({
    int limit = 100,
    int offset = 0,
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/driver-registration-requests',
      queryParameters: {
        'status': 'pending',
        'limit': limit,
        'offset': offset,
      },
    );
    return DriverRegistrationRequestsPage.fromJson(response.data);
  }

  Future<void> approve({
    required String requestId,
    int? companyId,
    String? reviewNotes,
  }) async {
    await _apiClient.post<Map<String, dynamic>>(
      '/platform-admin/driver-registration-requests/$requestId/approve',
      data: {
        if (companyId != null) 'companyId': companyId,
        if (reviewNotes != null && reviewNotes.trim().isNotEmpty)
          'reviewNotes': reviewNotes.trim(),
      },
    );
  }

  Future<void> reject({
    required String requestId,
    required String reviewNotes,
  }) async {
    await _apiClient.post<Map<String, dynamic>>(
      '/platform-admin/driver-registration-requests/$requestId/reject',
      data: {'reviewNotes': reviewNotes.trim()},
    );
  }
}

final driverRegistrationRequestsApiProvider =
    Provider<DriverRegistrationRequestsApi>((ref) {
  return DriverRegistrationRequestsApi(ref.watch(apiClientProvider));
});
