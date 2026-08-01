import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/system_monitoring/data/system_monitoring_mapper.dart';
import 'package:vianexis_admin_app/features/system_monitoring/domain/system_component_status.dart';
import 'package:vianexis_admin_app/features/system_monitoring/domain/system_monitoring_incident.dart';

void main() {
  group('SystemComponentStatusValue', () {
    test('parses backend values and prefers unknown for unknowns', () {
      expect(
        SystemComponentStatusValue.fromBackendValue('healthy'),
        SystemComponentStatusValue.healthy,
      );
      expect(
        SystemComponentStatusValue.fromBackendValue('degraded'),
        SystemComponentStatusValue.degraded,
      );
      expect(
        SystemComponentStatusValue.fromBackendValue('unhealthy'),
        SystemComponentStatusValue.unhealthy,
      );
      expect(
        SystemComponentStatusValue.fromBackendValue('not_configured'),
        SystemComponentStatusValue.notConfigured,
      );
      expect(
        SystemComponentStatusValue.fromBackendValue('disabled'),
        SystemComponentStatusValue.disabled,
      );
      expect(
        SystemComponentStatusValue.fromBackendValue('weird'),
        SystemComponentStatusValue.unknown,
      );
      expect(
        SystemComponentStatusValue.fromBackendValue(null),
        SystemComponentStatusValue.unknown,
      );
    });

    test('not_configured is never treated as healthy rank', () {
      expect(
        SystemComponentStatusValue.notConfigured.severityRank >
            SystemComponentStatusValue.healthy.severityRank,
        isTrue,
      );
      expect(
        SystemComponentStatusValue
            .notConfigured
            .matchesDegradedOrUnhealthyFilter,
        isFalse,
      );
    });
  });

  group('SystemMonitoringMapper', () {
    test(
      'maps overview components and never invents healthy from empty status',
      () {
        final snapshot = SystemMonitoringMapper.fromOverviewResponse({
          'overallStatus': 'degraded',
          'healthyCount': 1,
          'degradedCount': 1,
          'unhealthyCount': 0,
          'unknownCount': 1,
          'notConfiguredCount': 2,
          'disabledCount': 0,
          'activeIncidentCount': 1,
          'criticalIncidentCount': 0,
          'components': [
            {
              'componentKey': 'redis',
              'displayName': 'Redis',
              'status': 'not_configured',
              'message': 'Redis disabled',
              'isConfigured': false,
              'isCritical': false,
            },
            {
              'componentKey': 'object_storage',
              'displayName': 'Object storage',
              'status': 'degraded',
              'message': 'Slow probe',
              'isConfigured': true,
              'isCritical': true,
            },
          ],
        });

        expect(
          snapshot.overview.overallStatus,
          SystemComponentStatusValue.degraded,
        );
        expect(snapshot.components, hasLength(2));
        expect(
          snapshot.components.first.status,
          SystemComponentStatusValue.notConfigured,
        );
        expect(
          snapshot.components.first.status,
          isNot(SystemComponentStatusValue.healthy),
        );
      },
    );

    test('maps incident severity and status', () {
      final incident = SystemMonitoringMapper.incidentFromJson({
        'id': 'inc-1',
        'title': 'Worker unhealthy',
        'summary': 'Consecutive failures',
        'severity': 'critical',
        'status': 'open',
        'source': 'alert_rule',
        'componentKey': 'background_jobs',
        'events': [
          {
            'id': 'e1',
            'eventType': 'opened',
            'message': 'Opened',
            'createdAt': '2026-08-01T10:00:00.000Z',
          },
        ],
      });

      expect(incident.severity, SystemIncidentSeverity.critical);
      expect(incident.status, SystemIncidentStatus.open);
      expect(incident.timeline, hasLength(1));
      expect(
        incident.matchesFilter(SystemMonitoringIncidentFilter.critical),
        isTrue,
      );
      expect(
        incident.matchesFilter(SystemMonitoringIncidentFilter.resolved),
        isFalse,
      );
    });
  });
}
