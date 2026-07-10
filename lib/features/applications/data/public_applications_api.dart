import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';

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

  Future<Map<String, dynamic>> approve(int id, {String? reviewNotes, int? companyId}) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/platform-admin/applications/$id/approve',
      data: {
        if (reviewNotes != null) 'reviewNotes': reviewNotes,
        if (companyId != null) 'companyId': companyId,
      },
    );
    return response.data ?? {};
  }

  Future<Map<String, dynamic>> reject(int id, {required String reviewNotes}) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/platform-admin/applications/$id/reject',
      data: {'reviewNotes': reviewNotes},
    );
    return response.data ?? {};
  }

  Future<Map<String, dynamic>> requestMoreInfo(int id, {required String reviewNotes}) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/platform-admin/applications/$id/request-more-info',
      data: {'reviewNotes': reviewNotes},
    );
    return response.data ?? {};
  }
}

final publicApplicationsApiProvider = Provider<PublicApplicationsApi>(
  (ref) => PublicApplicationsApi(ref.watch(apiClientProvider)),
);
