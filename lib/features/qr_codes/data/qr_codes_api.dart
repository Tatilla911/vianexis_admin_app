import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';

class QrCodesApi {
  QrCodesApi(this._apiClient);

  final ApiClient _apiClient;

  Future<Map<String, dynamic>> list({
    String? entityType,
    int? entityId,
    String? purpose,
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/qr-codes',
      queryParameters: {
        'entityType': ?entityType,
        'entityId': ?entityId,
        'purpose': ?purpose,
      },
    );
    return response.data ?? {'items': []};
  }

  Future<Map<String, dynamic>> create(Map<String, dynamic> body) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/platform-admin/qr-codes',
      data: body,
    );
    return response.data ?? {};
  }

  Future<Map<String, dynamic>> send(int id, Map<String, dynamic> body) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/platform-admin/qr-codes/$id/send',
      data: body,
    );
    return response.data ?? {};
  }

  Future<Map<String, dynamic>> revoke(int id) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/platform-admin/qr-codes/$id/revoke',
      data: const <String, dynamic>{},
    );
    return response.data ?? {};
  }

  Future<Map<String, dynamic>> regenerate(int id) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/platform-admin/qr-codes/$id/regenerate',
      data: const <String, dynamic>{},
    );
    return response.data ?? {};
  }

  Future<Map<String, dynamic>> purposePolicies() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/qr-codes/purpose-policies',
    );
    return response.data ?? {'items': []};
  }
}

final qrCodesApiProvider = Provider<QrCodesApi>(
  (ref) => QrCodesApi(ref.watch(apiClientProvider)),
);
