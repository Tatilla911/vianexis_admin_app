import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/localization/localization_keys.dart';
import '../domain/system_health_action_request.dart';
import '../domain/system_health_event.dart';
import '../domain/system_health_overview.dart';
import 'system_health_mapper.dart';

class SystemHealthApi {
  SystemHealthApi(this._apiClient);

  final ApiClient _apiClient;
  bool eventsEndpointAvailable = false;

  Future<SystemHealthSnapshot> fetchSnapshot() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/system-health',
    );
    final data = response.data;
    if (data == null) {
      throw const ApiException(messageKey: LocalizationKeys.systemHealthLoadError);
    }
    return SystemHealthMapper.fromHealthResponse(data);
  }

  Future<SystemHealthSnapshot> fetchEventsSnapshot(SystemHealthSnapshot base) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/platform-admin/system-health/events',
      );
      final data = response.data;
      if (data == null) return base;
      eventsEndpointAvailable = true;
      return SystemHealthMapper.fromEventsResponse(data, base);
    } on ApiException catch (error) {
      if (error.kind == ApiExceptionKind.notFound) {
        eventsEndpointAvailable = false;
        return base;
      }
      rethrow;
    }
  }

  Future<SystemHealthEvent> fetchEvent(String id) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/system-health/events/$id',
    );
    final data = response.data;
    if (data == null) {
      throw const ApiException(messageKey: LocalizationKeys.systemHealthLoadError);
    }

    final eventJson = data['event'] ?? data;
    if (eventJson is Map<String, dynamic>) {
      return SystemHealthEvent.fromJson(eventJson);
    }
    if (eventJson is Map) {
      return SystemHealthEvent.fromJson(Map<String, dynamic>.from(eventJson));
    }
    throw const ApiException(messageKey: LocalizationKeys.systemHealthLoadError);
  }

  Future<void> submitAction({
    required String eventId,
    required SystemHealthActionRequest request,
  }) async {
    final path =
        '/platform-admin/system-health/events/$eventId/${request.endpointSuffix()}';

    if (request.httpMethod() == 'PATCH') {
      await _apiClient.patch<Map<String, dynamic>>(path, data: request.toJson());
    } else {
      await _apiClient.post<Map<String, dynamic>>(path, data: request.toJson());
    }
  }
}

final systemHealthApiProvider = Provider<SystemHealthApi>((ref) {
  return SystemHealthApi(ref.watch(apiClientProvider));
});
