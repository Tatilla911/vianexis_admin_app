import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/localization/localization_keys.dart';
import '../domain/platform_audit_log.dart';

class PlatformAuditLogsApi {
  PlatformAuditLogsApi(this._apiClient);

  final ApiClient _apiClient;

  Future<List<PlatformAuditLog>> listLogs({int limit = 200}) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/audit-logs',
      queryParameters: {'limit': limit},
    );
    final data = response.data;
    if (data == null) {
      throw const ApiException(messageKey: LocalizationKeys.auditLogLoadError);
    }

    final items = data['items'];
    if (items is! List) return const [];

    return items
        .whereType<Map>()
        .map((item) => PlatformAuditLog.fromJson(Map<String, dynamic>.from(item)))
        .toList(growable: false);
  }

  Future<PlatformAuditLog> getLog(String id) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/audit-logs/$id',
    );
    final data = response.data;
    if (data == null) {
      throw const ApiException(messageKey: LocalizationKeys.auditLogLoadError);
    }

    final logJson = data['log'] ?? data['item'] ?? data;
    if (logJson is Map<String, dynamic>) {
      return PlatformAuditLog.fromJson(logJson);
    }
    if (logJson is Map) {
      return PlatformAuditLog.fromJson(Map<String, dynamic>.from(logJson));
    }
    throw const ApiException(messageKey: LocalizationKeys.auditLogLoadError);
  }
}

final platformAuditLogsApiProvider = Provider<PlatformAuditLogsApi>((ref) {
  return PlatformAuditLogsApi(ref.watch(apiClientProvider));
});
