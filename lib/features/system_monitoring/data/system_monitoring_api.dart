import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/localization/localization_keys.dart';
import '../domain/system_component_status.dart';
import '../domain/system_monitoring_action_request.dart';
import '../domain/system_monitoring_incident.dart';
import '../domain/system_monitoring_overview.dart';
import 'system_monitoring_mapper.dart';

class SystemMonitoringApi {
  SystemMonitoringApi(this._apiClient);

  final ApiClient _apiClient;

  static const _base = '/platform-admin/system-monitoring';

  Future<SystemMonitoringSnapshot> fetchOverview() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '$_base/overview',
    );
    final data = response.data;
    if (data == null) {
      throw const ApiException(
        messageKey: LocalizationKeys.systemMonitoringLoadError,
      );
    }
    return SystemMonitoringMapper.fromOverviewResponse(data);
  }

  Future<List<SystemComponentStatus>> fetchComponents() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '$_base/components',
    );
    final data = response.data;
    if (data == null) {
      throw const ApiException(
        messageKey: LocalizationKeys.systemMonitoringLoadError,
      );
    }
    final items = data['components'] ?? data['items'] ?? data['data'];
    if (items is List) {
      return items
          .whereType<Map>()
          .map(
            (item) => SystemMonitoringMapper.componentFromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList(growable: false);
    }
    return const [];
  }

  Future<SystemComponentDetail> fetchComponent(String componentKey) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '$_base/components/${Uri.encodeComponent(componentKey)}',
    );
    final data = response.data;
    if (data == null) {
      throw const ApiException(
        messageKey: LocalizationKeys.systemMonitoringLoadError,
      );
    }
    return SystemMonitoringMapper.componentDetailFromJson(data);
  }

  Future<SystemMonitoringMetrics> fetchMetrics() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '$_base/metrics',
    );
    final data = response.data;
    if (data == null) {
      throw const ApiException(
        messageKey: LocalizationKeys.systemMonitoringLoadError,
      );
    }
    return SystemMonitoringMapper.metricsFromJson(data);
  }

  Future<SystemIncidentListPage> fetchIncidents({
    String? status,
    String? severity,
    String? componentKey,
    int offset = 0,
    int limit = 50,
  }) async {
    final query = <String, dynamic>{
      'offset': offset,
      'limit': limit,
      if (status != null && status.isNotEmpty) 'status': status,
      if (severity != null && severity.isNotEmpty) 'severity': severity,
      if (componentKey != null && componentKey.isNotEmpty)
        'componentKey': componentKey,
    };

    final response = await _apiClient.get<Map<String, dynamic>>(
      '$_base/incidents',
      queryParameters: query,
    );
    final data = response.data;
    if (data == null) {
      throw const ApiException(
        messageKey: LocalizationKeys.systemMonitoringLoadError,
      );
    }
    return SystemMonitoringMapper.incidentListFromJson(data);
  }

  Future<SystemMonitoringIncident> fetchIncident(String id) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '$_base/incidents/${Uri.encodeComponent(id)}',
    );
    final data = response.data;
    if (data == null) {
      throw const ApiException(
        messageKey: LocalizationKeys.systemMonitoringLoadError,
      );
    }
    final incidentJson = data['incident'] ?? data;
    if (incidentJson is Map<String, dynamic>) {
      return SystemMonitoringMapper.incidentFromJson(incidentJson);
    }
    if (incidentJson is Map) {
      return SystemMonitoringMapper.incidentFromJson(
        Map<String, dynamic>.from(incidentJson),
      );
    }
    throw const ApiException(
      messageKey: LocalizationKeys.systemMonitoringLoadError,
    );
  }

  Future<SystemMonitoringIncident> updateIncidentStatus({
    required String id,
    required SystemMonitoringStatusUpdateRequest request,
  }) async {
    final response = await _apiClient.patch<Map<String, dynamic>>(
      '$_base/incidents/${Uri.encodeComponent(id)}/status',
      data: request.toJson(),
    );
    return _parseIncidentResponse(response.data);
  }

  Future<SystemMonitoringIncident> acknowledgeIncident({
    required String id,
    required SystemMonitoringAcknowledgeRequest request,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '$_base/incidents/${Uri.encodeComponent(id)}/acknowledge',
      data: request.toJson(),
    );
    return _parseIncidentResponse(response.data);
  }

  Future<SystemMonitoringIncident> addIncidentNote({
    required String id,
    required SystemMonitoringNoteRequest request,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '$_base/incidents/${Uri.encodeComponent(id)}/notes',
      data: request.toJson(),
    );
    return _parseIncidentResponse(response.data);
  }

  Future<SystemMonitoringSnapshot> refresh() async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '$_base/refresh',
    );
    final data = response.data;
    if (data == null) {
      throw const ApiException(
        messageKey: LocalizationKeys.systemMonitoringLoadError,
      );
    }
    return SystemMonitoringMapper.fromOverviewResponse(data);
  }

  SystemMonitoringIncident _parseIncidentResponse(Map<String, dynamic>? data) {
    if (data == null) {
      throw const ApiException(
        messageKey: LocalizationKeys.systemMonitoringActionUnavailable,
      );
    }
    final incidentJson = data['incident'] ?? data;
    if (incidentJson is Map<String, dynamic>) {
      return SystemMonitoringMapper.incidentFromJson(incidentJson);
    }
    if (incidentJson is Map) {
      return SystemMonitoringMapper.incidentFromJson(
        Map<String, dynamic>.from(incidentJson),
      );
    }
    throw const ApiException(
      messageKey: LocalizationKeys.systemMonitoringActionUnavailable,
    );
  }
}

final systemMonitoringApiProvider = Provider<SystemMonitoringApi>((ref) {
  return SystemMonitoringApi(ref.watch(apiClientProvider));
});
