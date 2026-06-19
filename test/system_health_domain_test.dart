import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/system_health/domain/system_health_event.dart';
import 'package:vianexis_admin_app/features/system_health/domain/system_health_overview.dart';
import 'package:vianexis_admin_app/features/system_health/domain/system_health_service_status.dart';
import 'package:vianexis_admin_app/features/system_health/domain/system_health_severity.dart';

void main() {
  group('SystemHealthSeverity', () {
    test('parses backend values', () {
      expect(SystemHealthSeverity.fromBackendValue('ok'), SystemHealthSeverity.info);
      expect(SystemHealthSeverity.fromBackendValue('info'), SystemHealthSeverity.info);
      expect(SystemHealthSeverity.fromBackendValue('warning'), SystemHealthSeverity.warning);
      expect(SystemHealthSeverity.fromBackendValue('error'), SystemHealthSeverity.critical);
      expect(SystemHealthSeverity.fromBackendValue('critical'), SystemHealthSeverity.critical);
      expect(SystemHealthSeverity.fromBackendValue(null), SystemHealthSeverity.unknown);
    });
  });

  group('SystemHealthServiceStatus', () {
    test('parses component json', () {
      final status = SystemHealthServiceStatus.fromJson({
        'component': 'database',
        'severity': 'ok',
        'detailSummary': 'PostgreSQL reachable',
        'lastEventAt': '2026-06-18T08:00:00.000Z',
      });

      expect(status.serviceKey, SystemHealthServiceKey.database);
      expect(status.severity, SystemHealthSeverity.info);
      expect(status.summary, 'PostgreSQL reachable');
      expect(status.lastCheckedAt, DateTime.parse('2026-06-18T08:00:00.000Z'));
    });
  });

  group('SystemHealthEvent', () {
    test('parses full event json', () {
      final event = SystemHealthEvent.fromJson({
        'id': '501',
        'severity': 'critical',
        'component': 'queue',
        'status': 'open',
        'title': 'Redis queue unavailable',
        'summary': 'Background job dispatch delayed.',
        'tenantImpactLevel': 'platform_wide',
        'affectedCompanyName': 'NordTrans Kft.',
        'affectedCompanyId': '12',
        'startedAt': '2026-06-18T08:00:00.000Z',
        'lastSeenAt': '2026-06-18T09:15:00.000Z',
        'failedJobsCount': 14,
        'aiDiagnosticSummary': 'Advisory summary',
        'recommendedAction': 'Escalate to support',
        'correlationId': 'health-501-redis',
        'metadataOnly': {'queue': 'message_escalation'},
      });

      expect(event.id, '501');
      expect(event.severity, SystemHealthSeverity.critical);
      expect(event.serviceName, 'queue');
      expect(event.status, SystemHealthEventStatus.open);
      expect(event.tenantImpactLevel, SystemHealthTenantImpactLevel.platformWide);
      expect(event.affectedCompanyName, 'NordTrans Kft.');
      expect(event.failedJobsCount, 14);
      expect(event.aiDiagnosticSummary, 'Advisory summary');
      expect(event.correlationId, 'health-501-redis');
      expect(event.metadataOnly['queue'], 'message_escalation');
    });

    test('matches filters', () {
      const event = SystemHealthEvent(
        id: '1',
        severity: SystemHealthSeverity.warning,
        serviceName: 'storage',
        status: SystemHealthEventStatus.open,
        title: 'Latency',
        summary: 'Slow storage',
        tenantImpactLevel: SystemHealthTenantImpactLevel.singleTenant,
      );

      expect(event.matchesFilter(SystemHealthEventFilter.warning), isTrue);
      expect(event.matchesFilter(SystemHealthEventFilter.critical), isFalse);
      expect(event.matchesFilter(SystemHealthEventFilter.tenantImpacting), isTrue);
    });
  });

  group('SystemHealthOverview', () {
    test('computes counts from services and events', () {
      final services = [
        const SystemHealthServiceStatus(
          serviceKey: SystemHealthServiceKey.backendApi,
          severity: SystemHealthSeverity.info,
        ),
        const SystemHealthServiceStatus(
          serviceKey: SystemHealthServiceKey.queueSystem,
          severity: SystemHealthSeverity.critical,
        ),
        const SystemHealthServiceStatus(
          serviceKey: SystemHealthServiceKey.documentStorage,
          severity: SystemHealthSeverity.warning,
        ),
      ];

      final events = [
        SystemHealthEvent(
          id: '1',
          severity: SystemHealthSeverity.critical,
          serviceName: 'queue',
          status: SystemHealthEventStatus.open,
          title: 'Queue down',
          summary: 'Redis unavailable',
          tenantImpactLevel: SystemHealthTenantImpactLevel.platformWide,
        ),
        SystemHealthEvent(
          id: '2',
          severity: SystemHealthSeverity.warning,
          serviceName: 'storage',
          status: SystemHealthEventStatus.resolved,
          title: 'Resolved warning',
          summary: 'Done',
          tenantImpactLevel: SystemHealthTenantImpactLevel.none,
        ),
      ];

      final overview = SystemHealthOverview.fromServicesAndEvents(
        services: services,
        events: events,
        failedJobsCount: 9,
        lastUpdatedAt: DateTime.utc(2026, 6, 18, 10),
      );

      expect(overview.overallStatus, SystemHealthOverallStatus.critical);
      expect(overview.healthyServicesCount, 1);
      expect(overview.warningServicesCount, 1);
      expect(overview.criticalServicesCount, 1);
      expect(overview.openCriticalEventsCount, 1);
      expect(overview.openWarningEventsCount, 0);
      expect(overview.failedJobsCount, 9);
      expect(overview.lastUpdatedAt, DateTime.utc(2026, 6, 18, 10));
    });
  });
}
