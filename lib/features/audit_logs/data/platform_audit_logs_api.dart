import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/localization/localization_keys.dart';
import '../domain/platform_audit_log.dart';
import '../domain/platform_audit_log_query.dart';

class PlatformAuditLogsApi {
  PlatformAuditLogsApi(this._apiClient);

  final ApiClient _apiClient;

  Future<List<PlatformAuditLog>> listLogs({
    PlatformAuditLogListQuery? query,
    int limit = 200,
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/audit-logs',
      queryParameters: query?.toApiQuery(limit: limit) ?? {'limit': limit},
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

  Future<String> exportCsv({
    PlatformAuditLogListQuery? query,
    int limit = 10000,
  }) async {
    final response = await _apiClient.get<String>(
      '/platform-admin/audit-logs/export.csv',
      queryParameters: query?.toApiQuery(limit: limit) ?? {'limit': limit},
      options: Options(responseType: ResponseType.plain),
    );
    return response.data ?? '';
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
