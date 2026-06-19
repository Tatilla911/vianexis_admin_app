import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/localization/localization_keys.dart';
import '../domain/platform_audit_action_type.dart';
import '../domain/platform_audit_log.dart';
import '../domain/platform_audit_result.dart';
import '../domain/platform_audit_severity.dart';
import 'platform_audit_logs_api.dart';

abstract class PlatformAuditLogsRepository {
  Future<List<PlatformAuditLog>> fetchLogs();

  Future<PlatformAuditLog> fetchLog(String id);

  bool get usesMockData;
}

class LivePlatformAuditLogsRepository implements PlatformAuditLogsRepository {
  LivePlatformAuditLogsRepository(this._api);

  final PlatformAuditLogsApi _api;
  List<PlatformAuditLog>? _cachedLogs;

  @override
  bool get usesMockData => false;

  @override
  Future<List<PlatformAuditLog>> fetchLogs() async {
    final logs = await _api.listLogs();
    _cachedLogs = logs;
    return logs;
  }

  @override
  Future<PlatformAuditLog> fetchLog(String id) async {
    try {
      return await _api.getLog(id);
    } on ApiException catch (error) {
      if (error.kind != ApiExceptionKind.notFound) rethrow;
      final cached = _cachedLogs;
      if (cached != null) {
        return cached.firstWhere(
          (log) => log.id == id,
          orElse: () => throw error,
        );
      }
      rethrow;
    }
  }
}

class MockPlatformAuditLogsRepository implements PlatformAuditLogsRepository {
  MockPlatformAuditLogsRepository();

  final List<PlatformAuditLog> _logs = _buildLogs();

  @override
  bool get usesMockData => true;

  @override
  Future<List<PlatformAuditLog>> fetchLogs() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return _logs;
  }

  @override
  Future<PlatformAuditLog> fetchLog(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return _logs.firstWhere(
      (log) => log.id == id,
      orElse: () => throw const ApiException(
        messageKey: LocalizationKeys.errorGenericBody,
        kind: ApiExceptionKind.notFound,
      ),
    );
  }

  static List<PlatformAuditLog> _buildLogs() {
    return [
      PlatformAuditLog(
        id: '1001',
        timestamp: DateTime.utc(2026, 6, 18, 9, 30),
        actorUserId: '1',
        actorName: 'Platform Super Admin',
        actorEmail: 'super@platform.example',
        actorRole: 'super_admin',
        actionType: PlatformAuditActionType.registrationApproved,
        targetType: 'registration_application',
        targetId: '101',
        targetLabel: 'NordTrans Kft. registration approved',
        companyId: '12',
        companyName: 'NordTrans Kft.',
        result: PlatformAuditResult.success,
        severity: PlatformAuditSeverity.info,
        note: 'Approved after metadata review.',
        correlationId: 'audit-reg-101',
        registrationApplicationId: '101',
        metadataOnly: const {'decision': 'approve'},
      ),
      PlatformAuditLog(
        id: '1002',
        timestamp: DateTime.utc(2026, 6, 18, 9, 0),
        actorUserId: '2',
        actorName: 'Support Admin',
        actorEmail: 'support@platform.example',
        actorRole: 'support_admin',
        actionType: PlatformAuditActionType.supportAccessGranted,
        targetType: 'support_access_grant',
        targetId: '901',
        targetLabel: 'Scoped grant for system health issue',
        companyId: '12',
        companyName: 'NordTrans Kft.',
        result: PlatformAuditResult.success,
        severity: PlatformAuditSeverity.warning,
        reason: 'Investigate Redis queue health event metadata.',
        correlationId: 'audit-grant-901',
        supportAccessGrantId: '901',
        systemHealthEventId: '501',
        metadataOnly: const {'scopeType': 'system_health_issue'},
      ),
      PlatformAuditLog(
        id: '1003',
        timestamp: DateTime.utc(2026, 6, 18, 8, 45),
        actorUserId: '3',
        actorEmail: 'reviewer@platform.example',
        actorRole: 'onboarding_reviewer',
        actionType: PlatformAuditActionType.permissionDenied,
        targetType: 'platform_admin_route',
        targetId: 'support-access-grants',
        targetLabel: 'Denied support grant creation',
        result: PlatformAuditResult.denied,
        severity: PlatformAuditSeverity.critical,
        reason: 'Role lacks support grant permission.',
        ipAddress: '203.0.113.10',
        deviceLabel: 'Chrome on Windows',
        correlationId: 'audit-deny-1003',
        metadataOnly: const {'route': '/support/grants'},
      ),
      PlatformAuditLog(
        id: '1004',
        timestamp: DateTime.utc(2026, 6, 18, 8, 15),
        actorUserId: '2',
        actorName: 'Support Admin',
        actorEmail: 'support@platform.example',
        actorRole: 'support_admin',
        actionType: PlatformAuditActionType.systemHealthEscalated,
        targetType: 'system_health_event',
        targetId: '501',
        targetLabel: 'Redis queue unavailable',
        result: PlatformAuditResult.success,
        severity: PlatformAuditSeverity.critical,
        note: 'Escalated to platform support.',
        correlationId: 'health-501-redis',
        systemHealthEventId: '501',
        metadataOnly: const {'escalationNote': 'Need infra review'},
      ),
      PlatformAuditLog(
        id: '1005',
        timestamp: DateTime.utc(2026, 6, 18, 7, 50),
        actorUserId: '99',
        actorEmail: 'unknown@example.com',
        actorRole: 'unknown',
        actionType: PlatformAuditActionType.loginFailed,
        targetType: 'auth',
        targetId: 'login',
        targetLabel: 'Failed platform admin login',
        result: PlatformAuditResult.failure,
        severity: PlatformAuditSeverity.warning,
        ipAddress: '198.51.100.4',
        deviceLabel: 'Safari on macOS',
        correlationId: 'audit-login-fail-1005',
        metadataOnly: const {'attempts': 1},
      ),
    ];
  }
}

final platformAuditLogsRepositoryProvider = Provider<PlatformAuditLogsRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  if (apiClient.isConfigured) {
    return LivePlatformAuditLogsRepository(ref.watch(platformAuditLogsApiProvider));
  }
  return MockPlatformAuditLogsRepository();
});
