import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/audit_logs/domain/platform_audit_action_type.dart';
import 'package:vianexis_admin_app/features/audit_logs/domain/platform_audit_filter.dart';
import 'package:vianexis_admin_app/features/audit_logs/domain/platform_audit_log.dart';
import 'package:vianexis_admin_app/features/audit_logs/domain/platform_audit_result.dart';
import 'package:vianexis_admin_app/features/audit_logs/domain/platform_audit_severity.dart';

void main() {
  group('PlatformAuditActionType', () {
    test('parses backend event types', () {
      expect(
        PlatformAuditActionType.fromBackendValue('platform.registration.approved'),
        PlatformAuditActionType.registrationApproved,
      );
      expect(
        PlatformAuditActionType.fromBackendValue('platform.support_grant.created'),
        PlatformAuditActionType.supportAccessGranted,
      );
      expect(
        PlatformAuditActionType.fromBackendValue('login_failed'),
        PlatformAuditActionType.loginFailed,
      );
    });
  });

  group('PlatformAuditResult', () {
    test('parses backend values', () {
      expect(PlatformAuditResult.fromBackendValue('success'), PlatformAuditResult.success);
      expect(PlatformAuditResult.fromBackendValue('denied'), PlatformAuditResult.denied);
    });
  });

  group('PlatformAuditSeverity', () {
    test('parses backend values', () {
      expect(PlatformAuditSeverity.fromBackendValue('critical'), PlatformAuditSeverity.critical);
      expect(PlatformAuditSeverity.fromBackendValue('warning'), PlatformAuditSeverity.warning);
    });
  });

  group('PlatformAuditLog', () {
    test('parses backend list item json', () {
      final log = PlatformAuditLog.fromJson({
        'id': 1001,
        'eventType': 'platform.registration.approved',
        'description': 'Approved registration application #101',
        'companyId': 12,
        'userId': 1,
        'registrationApplicationId': 101,
        'platformAdminRole': 'super_admin',
        'createdAt': '2026-06-18T09:30:00.000Z',
        'metadata': {
          'actorEmail': 'super@platform.example',
          'correlationId': 'audit-reg-101',
        },
      });

      expect(log.id, '1001');
      expect(log.actionType, PlatformAuditActionType.registrationApproved);
      expect(log.actorUserId, '1');
      expect(log.actorEmail, 'super@platform.example');
      expect(log.registrationApplicationId, '101');
      expect(log.result, PlatformAuditResult.success);
    });

    test('matches filters and search', () {
      final log = PlatformAuditLog(
        id: '1',
        timestamp: DateTime.utc(2026, 6, 18),
        actionType: PlatformAuditActionType.permissionDenied,
        result: PlatformAuditResult.denied,
        severity: PlatformAuditSeverity.critical,
        actorEmail: 'reviewer@platform.example',
        correlationId: 'audit-deny-1',
      );

      expect(log.matchesFilter(PlatformAuditLogFilter.denied), isTrue);
      expect(log.matchesFilter(PlatformAuditLogFilter.security), isTrue);
      expect(log.matchesFilter(PlatformAuditLogFilter.critical), isTrue);
      expect(log.matchesSearch('reviewer@'), isTrue);
    });
  });

  group('PlatformAuditLogSummary', () {
    test('computes dashboard summary', () {
      final summary = PlatformAuditLogSummary.fromLogs([
        PlatformAuditLog(
          id: '1',
          timestamp: DateTime.now().toUtc(),
          actionType: PlatformAuditActionType.systemHealthEscalated,
          result: PlatformAuditResult.success,
          severity: PlatformAuditSeverity.critical,
        ),
        PlatformAuditLog(
          id: '2',
          timestamp: DateTime.now().toUtc(),
          actionType: PlatformAuditActionType.loginFailed,
          result: PlatformAuditResult.failure,
          severity: PlatformAuditSeverity.warning,
        ),
        PlatformAuditLog(
          id: '3',
          timestamp: DateTime.now().toUtc(),
          actionType: PlatformAuditActionType.registrationApproved,
          result: PlatformAuditResult.success,
          severity: PlatformAuditSeverity.info,
        ),
      ]);

      expect(summary.lastCriticalEvent?.id, '1');
      expect(summary.failedDeniedCount, 1);
      expect(summary.recentPlatformActionsCount, greaterThan(0));
    });
  });
}
