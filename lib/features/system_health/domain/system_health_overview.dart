import 'system_health_event.dart';
import 'system_health_service_status.dart';
import 'system_health_severity.dart';

class SystemHealthOverview {
  const SystemHealthOverview({
    required this.overallStatus,
    required this.healthyServicesCount,
    required this.warningServicesCount,
    required this.criticalServicesCount,
    required this.openCriticalEventsCount,
    required this.openWarningEventsCount,
    required this.failedJobsCount,
    this.lastUpdatedAt,
  });

  final SystemHealthOverallStatus overallStatus;
  final int healthyServicesCount;
  final int warningServicesCount;
  final int criticalServicesCount;
  final int openCriticalEventsCount;
  final int openWarningEventsCount;
  final int failedJobsCount;
  final DateTime? lastUpdatedAt;

  factory SystemHealthOverview.fromServicesAndEvents({
    required List<SystemHealthServiceStatus> services,
    required List<SystemHealthEvent> events,
    int failedJobsCount = 0,
    DateTime? lastUpdatedAt,
  }) {
    var healthy = 0;
    var warning = 0;
    var critical = 0;

    for (final service in services) {
      switch (service.severity) {
        case SystemHealthSeverity.info:
          healthy++;
        case SystemHealthSeverity.warning:
          warning++;
        case SystemHealthSeverity.critical:
          critical++;
        case SystemHealthSeverity.unknown:
          break;
      }
    }

    var openCriticalEvents = 0;
    var openWarningEvents = 0;
    for (final event in events) {
      if (event.status == SystemHealthEventStatus.resolved) continue;
      switch (event.severity) {
        case SystemHealthSeverity.critical:
          openCriticalEvents++;
        case SystemHealthSeverity.warning:
          openWarningEvents++;
        default:
          break;
      }
    }

    return SystemHealthOverview(
      overallStatus: SystemHealthOverallStatus.fromSeverityCounts(
        critical: critical + openCriticalEvents,
        warning: warning + openWarningEvents,
      ),
      healthyServicesCount: healthy,
      warningServicesCount: warning,
      criticalServicesCount: critical,
      openCriticalEventsCount: openCriticalEvents,
      openWarningEventsCount: openWarningEvents,
      failedJobsCount: failedJobsCount,
      lastUpdatedAt: lastUpdatedAt ?? DateTime.now().toUtc(),
    );
  }
}

class SystemHealthSnapshot {
  const SystemHealthSnapshot({
    required this.overview,
    required this.services,
    required this.events,
    this.privacyNoteKey,
  });

  final SystemHealthOverview overview;
  final List<SystemHealthServiceStatus> services;
  final List<SystemHealthEvent> events;
  final String? privacyNoteKey;
}
