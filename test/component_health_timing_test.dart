import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/system_monitoring/data/system_monitoring_mapper.dart';
import 'package:vianexis_admin_app/features/system_monitoring/domain/component_health_timing.dart';
import 'package:vianexis_admin_app/features/system_monitoring/domain/system_component_status.dart';
import 'package:vianexis_admin_app/features/system_monitoring/domain/system_monitoring_incident.dart';

void main() {
  final t1820 = DateTime.utc(2026, 9, 17, 18, 20);
  final t1825 = DateTime.utc(2026, 9, 17, 18, 25);
  final t1830 = DateTime.utc(2026, 9, 17, 18, 30);
  final t1835 = DateTime.utc(2026, 9, 17, 18, 35);
  final t1840 = DateTime.utc(2026, 9, 17, 18, 40);
  final t1850 = DateTime.utc(2026, 9, 17, 18, 50);

  SystemComponentStatus component({
    SystemComponentStatusValue status = SystemComponentStatusValue.healthy,
    DateTime? checkedAt,
    DateTime? incidentStartedAt,
    DateTime? lastFailureAt,
    DateTime? lastHealthyAt,
    int consecutiveFailures = 0,
  }) {
    return SystemComponentStatus(
      componentKey: 'postgresql',
      displayName: 'PostgreSQL',
      status: status,
      message: 'probe',
      checkedAt: checkedAt,
      incidentStartedAt: incidentStartedAt,
      firstFailureAt: incidentStartedAt,
      lastFailureAt: lastFailureAt,
      lastHealthyAt: lastHealthyAt,
      consecutiveFailures: consecutiveFailures,
      isConfigured: true,
      isCritical: true,
    );
  }

  group('ComponentHealthTimingResolver A–F', () {
    test('A: healthy component → no active error start shown', () {
      final timing = ComponentHealthTimingResolver.resolve(
        component: component(
          status: SystemComponentStatusValue.healthy,
          checkedAt: t1840,
        ),
        now: t1840,
      );

      expect(timing.mode, ComponentHealthTimingMode.healthy);
      expect(timing.showIncidentStarted, isFalse);
      expect(timing.incidentStartedAt, isNull);
      expect(timing.lastCheckedAt, t1840);
      expect(timing.tiedToActiveIncident, isFalse);
    });

    test('B: new failure → first failed timestamp shown', () {
      final timing = ComponentHealthTimingResolver.resolve(
        component: component(
          status: SystemComponentStatusValue.unhealthy,
          checkedAt: t1825,
          incidentStartedAt: t1825,
          lastFailureAt: t1825,
          consecutiveFailures: 1,
        ),
        now: t1825,
      );

      expect(timing.mode, ComponentHealthTimingMode.activeIncident);
      expect(timing.incidentStartedAt, t1825);
      expect(timing.lastCheckedAt, t1825);
      expect(timing.showDurationSoFar, isTrue);
      expect(timing.tiedToActiveIncident, isTrue);
    });

    test('C: repeated failed checks → original incident start preserved', () {
      final timing = ComponentHealthTimingResolver.resolve(
        component: component(
          status: SystemComponentStatusValue.unhealthy,
          checkedAt: t1835,
          incidentStartedAt: t1825,
          lastFailureAt: t1835,
          consecutiveFailures: 3,
        ),
        consecutiveSamples: [
          ComponentHealthSample(checkedAt: t1820, failing: false),
          ComponentHealthSample(checkedAt: t1825, failing: true),
          ComponentHealthSample(checkedAt: t1830, failing: true),
          ComponentHealthSample(checkedAt: t1835, failing: true),
        ],
        now: t1835,
      );

      expect(timing.incidentStartedAt, t1825);
      expect(timing.lastCheckedAt, t1835);
      expect(timing.incidentStartedAt, isNot(timing.lastCheckedAt));
      expect(timing.duration, const Duration(minutes: 10));
    });

    test('D: recovery → recovery timestamp + duration shown', () {
      final timing = ComponentHealthTimingResolver.resolve(
        component: component(
          status: SystemComponentStatusValue.healthy,
          checkedAt: t1840,
          lastHealthyAt: t1840,
        ),
        relatedIncidents: [
          SystemMonitoringIncident(
            id: 'inc-1',
            title: 'DB unhealthy',
            summary: 'fail',
            severity: SystemIncidentSeverity.high,
            status: SystemIncidentStatus.monitoring,
            source: SystemIncidentSource.alertRule,
            componentKey: 'postgresql',
            detectedAt: t1825,
            firstOccurrenceAt: t1825,
            lastOccurrenceAt: t1835,
            timeline: [
              SystemIncidentTimelineEvent(
                id: 'e-rec',
                eventType: 'recovery_observed',
                message: 'recovered',
                createdAt: t1840,
                metadataSanitized: const {
                  'recoveredAt': '2026-09-17T18:40:00.000Z',
                },
              ),
            ],
          ),
        ],
        now: t1840,
      );

      expect(timing.mode, ComponentHealthTimingMode.recovered);
      expect(timing.incidentStartedAt, t1825);
      expect(timing.recoveredAt, t1840);
      expect(timing.duration, const Duration(minutes: 15));
      expect(timing.lastCheckedAt, t1840);
      expect(timing.showRecovered, isTrue);
      expect(timing.showClosedDuration, isTrue);
      expect(timing.tiedToActiveIncident, isFalse);
    });

    test('E: second later failure → new incident start', () {
      final samples = [
        ComponentHealthSample(checkedAt: t1820, failing: false),
        ComponentHealthSample(checkedAt: t1825, failing: true),
        ComponentHealthSample(checkedAt: t1830, failing: true),
        ComponentHealthSample(checkedAt: t1835, failing: true),
        ComponentHealthSample(checkedAt: t1840, failing: false),
        ComponentHealthSample(checkedAt: t1850, failing: true),
      ];

      final closed = ComponentHealthTimingResolver.recoveredWindowFromSamples(
        samples.sublist(0, 5),
      );
      expect(closed?.startedAt, t1825);
      expect(closed?.recoveredAt, t1840);
      expect(closed?.duration, const Duration(minutes: 15));

      final newStart =
          ComponentHealthTimingResolver.startOfLatestFailureWindow(samples);
      expect(newStart, t1850);
      expect(newStart, isNot(t1825));

      final timing = ComponentHealthTimingResolver.resolve(
        component: component(
          status: SystemComponentStatusValue.unhealthy,
          checkedAt: t1850,
          incidentStartedAt: t1850,
          lastFailureAt: t1850,
          consecutiveFailures: 1,
        ),
        consecutiveSamples: samples,
        now: t1850,
      );
      expect(timing.incidentStartedAt, t1850);
    });

    test('F: refresh/restart → incident start remains stable', () {
      final first = ComponentHealthTimingResolver.resolve(
        component: component(
          status: SystemComponentStatusValue.unhealthy,
          checkedAt: t1830,
          incidentStartedAt: t1825,
          lastFailureAt: t1830,
          consecutiveFailures: 2,
        ),
        now: t1830,
      );
      final afterRefresh = ComponentHealthTimingResolver.resolve(
        component: component(
          status: SystemComponentStatusValue.unhealthy,
          checkedAt: t1835,
          incidentStartedAt: t1825,
          lastFailureAt: t1835,
          consecutiveFailures: 3,
        ),
        now: t1835,
      );

      expect(first.incidentStartedAt, t1825);
      expect(afterRefresh.incidentStartedAt, t1825);
      expect(afterRefresh.lastCheckedAt, t1835);
      expect(afterRefresh.lastCheckedAt, isNot(afterRefresh.incidentStartedAt));
    });
  });

  group('ComponentHealthTimingResolver source priority', () {
    test('never uses checkedAt as incident start', () {
      final timing = ComponentHealthTimingResolver.resolve(
        component: component(
          status: SystemComponentStatusValue.unhealthy,
          checkedAt: t1835,
          consecutiveFailures: 3,
          lastFailureAt: t1835,
        ),
        now: t1835,
      );
      // consecutiveFailures > 1 without start field → do not fabricate.
      expect(timing.incidentStartedAt, isNull);
      expect(timing.lastCheckedAt, t1835);
    });

    test('maps backend incidentStartedAt aliases', () {
      final mapped = SystemMonitoringMapper.componentFromJson({
        'componentKey': 'redis',
        'displayName': 'Redis',
        'status': 'degraded',
        'message': 'slow',
        'checkedAt': '2026-09-17T18:35:00.000Z',
        'firstFailureAt': '2026-09-17T18:25:00.000Z',
        'consecutiveFailures': 3,
      });
      expect(mapped.incidentStartedAt, t1825);
      expect(mapped.checkedAt, t1835);
      expect(mapped.incidentStartedAt, isNot(mapped.checkedAt));
    });

    test('prefers explicit start over later lastFailureAt', () {
      final timing = ComponentHealthTimingResolver.resolve(
        component: component(
          status: SystemComponentStatusValue.degraded,
          checkedAt: t1835,
          incidentStartedAt: t1825,
          lastFailureAt: t1835,
          consecutiveFailures: 3,
        ),
        relatedIncidents: [
          SystemMonitoringIncident(
            id: 'inc-late',
            title: 'late',
            summary: 'late',
            severity: SystemIncidentSeverity.warning,
            status: SystemIncidentStatus.open,
            source: SystemIncidentSource.healthCheck,
            componentKey: 'postgresql',
            detectedAt: t1830,
            firstOccurrenceAt: t1830,
          ),
        ],
        now: t1835,
      );
      expect(timing.incidentStartedAt, t1825);
    });
  });

  group('ComponentHealthDurationFormat', () {
    test('formats HU and EN', () {
      expect(
        ComponentHealthDurationFormat.format(
          duration: const Duration(hours: 2, minutes: 15),
          localeLanguageCode: 'hu',
        ),
        '2 óra 15 perc',
      );
      expect(
        ComponentHealthDurationFormat.format(
          duration: const Duration(minutes: 15),
          localeLanguageCode: 'hu',
        ),
        '15 perc',
      );
      expect(
        ComponentHealthDurationFormat.format(
          duration: const Duration(hours: 2, minutes: 15),
          localeLanguageCode: 'en',
        ),
        '2 h 15 min',
      );
    });
  });
}
