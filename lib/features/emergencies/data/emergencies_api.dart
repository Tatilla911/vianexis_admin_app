import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../domain/driver_emergency_event.dart';

class EmergenciesApi {
  EmergenciesApi(this._apiClient);

  final ApiClient _apiClient;

  Future<DriverEmergencyListResult> list({
    bool openOnly = false,
    String? status,
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/emergencies',
      queryParameters: {
        if (openOnly) 'openOnly': 'true',
        if (!openOnly && status != null && status.isNotEmpty) 'status': status,
      },
    );
    final data = response.data;
    if (data == null) {
      return const DriverEmergencyListResult(items: [], total: 0);
    }
    return DriverEmergencyListResult.fromJson(data);
  }

  Future<DriverEmergencyEvent> getById(String id) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/emergencies/${Uri.encodeComponent(id)}',
    );
    final data = response.data;
    if (data == null) {
      throw StateError('Emergency $id not found');
    }
    return DriverEmergencyEvent.fromJson(data);
  }
}

final emergenciesApiProvider = Provider<EmergenciesApi>(
  (ref) => EmergenciesApi(ref.watch(apiClientProvider)),
);
