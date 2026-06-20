import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../domain/security_event.dart';
import '../domain/security_event_severity.dart';
import '../domain/security_event_type.dart';
import '../domain/security_overview.dart';
import 'security_center_api.dart';

abstract class SecurityCenterRepository {
  Future<SecurityOverview> fetchOverview();

  Future<List<SecurityEvent>> fetchEvents({
    SecurityEventType? type,
    SecurityEventSeverity? severity,
    String? search,
  });

  bool get usesMockData;
}

class LiveSecurityCenterRepository implements SecurityCenterRepository {
  LiveSecurityCenterRepository(this._api);

  final SecurityCenterApi _api;

  @override
  bool get usesMockData => false;

  @override
  Future<SecurityOverview> fetchOverview() => _api.getOverview();

  @override
  Future<List<SecurityEvent>> fetchEvents({
    SecurityEventType? type,
    SecurityEventSeverity? severity,
    String? search,
  }) async {
    final page = await _api.listEvents(
      type: type,
      severity: severity,
      search: search,
      limit: 200,
    );
    return page.items;
  }
}

class MockSecurityCenterRepository implements SecurityCenterRepository {
  MockSecurityCenterRepository();

  SecurityOverview _overview = SecurityOverview(
    failedLoginCount: 12,
    permissionDeniedCount: 5,
    activeSupportGrantsCount: 3,
    expiringSupportGrantsCount: 1,
    highRiskAiReviewsCount: 2,
    criticalSystemHealthEventsCount: 1,
    suspiciousBulkOnboardingJobsCount: 1,
    adminRoleChangesCount: 4,
    lastCriticalSecurityEventAt: DateTime.utc(2026, 6, 18, 16, 0),
  );

  final List<SecurityEvent> _events = [
    SecurityEvent(
      id: 'audit:901',
      type: SecurityEventType.failedLogin,
      severity: SecurityEventSeverity.warning,
      title: 'Failed login attempt',
      summary: 'Invalid credentials for support@vianexis.test',
      actorEmail: 'support@vianexis.test',
      sourceType: 'system_audit_log',
      sourceId: '901',
      createdAt: DateTime.utc(2026, 6, 19, 7, 15),
    ),
    SecurityEvent(
      id: 'audit:902',
      type: SecurityEventType.permissionDenied,
      severity: SecurityEventSeverity.warning,
      title: 'Permission denied',
      summary: 'Dispatcher attempted platform admin route',
      actorRole: 'dispatcher',
      sourceType: 'system_audit_log',
      sourceId: '902',
      createdAt: DateTime.utc(2026, 6, 18, 22, 40),
    ),
    SecurityEvent(
      id: 'support_grant:12',
      type: SecurityEventType.supportAccess,
      severity: SecurityEventSeverity.info,
      title: 'Active support access grant',
      summary: 'Read-only company metadata access',
      companyId: '1',
      companyName: 'NordTrans Kft.',
      sourceType: 'support_access_grant',
      sourceId: '12',
      createdAt: DateTime.utc(2026, 6, 17, 10, 0),
    ),
    SecurityEvent(
      id: 'system_health:44',
      type: SecurityEventType.criticalSystem,
      severity: SecurityEventSeverity.critical,
      title: 'Background worker backlog',
      summary: 'Queue depth exceeded warning threshold',
      sourceType: 'system_health_event',
      sourceId: '44',
      correlationId: 'corr-44',
      createdAt: DateTime.utc(2026, 6, 18, 16, 0),
    ),
    SecurityEvent(
      id: 'audit:903',
      type: SecurityEventType.adminRoleChange,
      severity: SecurityEventSeverity.critical,
      title: 'Platform admin access changed',
      summary: 'Role changed for billing@vianexis.test',
      actorEmail: 'super@vianexis.test',
      actorRole: 'super_admin',
      sourceType: 'system_audit_log',
      sourceId: '903',
      createdAt: DateTime.utc(2026, 6, 16, 9, 30),
    ),
    SecurityEvent(
      id: 'bulk_onboarding:77',
      type: SecurityEventType.suspiciousBulkOnboarding,
      severity: SecurityEventSeverity.warning,
      title: 'Suspicious bulk onboarding job',
      summary: 'High Risk Cargo SRL — ready_for_review',
      companyId: '6',
      companyName: 'High Risk Cargo SRL',
      sourceType: 'bulk_onboarding_job',
      sourceId: '77',
      createdAt: DateTime.utc(2026, 6, 15, 13, 20),
    ),
  ];

  @override
  bool get usesMockData => true;

  @override
  Future<SecurityOverview> fetchOverview() async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return _overview;
  }

  @override
  Future<List<SecurityEvent>> fetchEvents({
    SecurityEventType? type,
    SecurityEventSeverity? severity,
    String? search,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    return _events
        .where((event) => type == null || event.type == type)
        .where((event) => severity == null || event.severity == severity)
        .where(
          (event) =>
              search == null ||
              search.trim().isEmpty ||
              event.matchesSearch(search),
        )
        .toList(growable: false);
  }
}

final securityCenterRepositoryProvider = Provider<SecurityCenterRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  if (apiClient.isConfigured) {
    return LiveSecurityCenterRepository(ref.watch(securityCenterApiProvider));
  }
  return MockSecurityCenterRepository();
});
