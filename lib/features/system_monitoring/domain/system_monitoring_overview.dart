import 'system_component_status.dart';
import 'system_diagnostic_suggestion.dart';
import 'system_monitoring_incident.dart';

class SystemMonitoringOverview {
  const SystemMonitoringOverview({
    required this.overallStatus,
    required this.componentCount,
    required this.healthyCount,
    required this.degradedCount,
    required this.unhealthyCount,
    required this.unknownCount,
    required this.notConfiguredCount,
    required this.disabledCount,
    required this.activeIncidentCount,
    required this.criticalIncidentCount,
    this.generatedAt,
    this.lastRefreshAt,
    this.environment,
    this.privacyNoteKey,
  });

  final SystemComponentStatusValue overallStatus;
  final int componentCount;
  final int healthyCount;
  final int degradedCount;
  final int unhealthyCount;
  final int unknownCount;
  final int notConfiguredCount;
  final int disabledCount;
  final int activeIncidentCount;
  final int criticalIncidentCount;
  final DateTime? generatedAt;
  final DateTime? lastRefreshAt;
  final String? environment;
  final String? privacyNoteKey;

  factory SystemMonitoringOverview.fromComponents({
    required List<SystemComponentStatus> components,
    int activeIncidentCount = 0,
    int criticalIncidentCount = 0,
    DateTime? generatedAt,
    DateTime? lastRefreshAt,
    String? environment,
    String? privacyNoteKey,
  }) {
    var healthy = 0;
    var degraded = 0;
    var unhealthy = 0;
    var unknown = 0;
    var notConfigured = 0;
    var disabled = 0;
    var worst = SystemComponentStatusValue.healthy;

    for (final component in components) {
      switch (component.status) {
        case SystemComponentStatusValue.healthy:
          healthy++;
        case SystemComponentStatusValue.degraded:
          degraded++;
        case SystemComponentStatusValue.unhealthy:
          unhealthy++;
        case SystemComponentStatusValue.unknown:
          unknown++;
        case SystemComponentStatusValue.notConfigured:
          notConfigured++;
        case SystemComponentStatusValue.disabled:
          disabled++;
      }
      if (component.isCritical &&
          component.status.severityRank > worst.severityRank) {
        worst = component.status;
      }
    }

    // Prefer unknown over falsely reporting healthy when nothing critical configured.
    if (components.isEmpty) {
      worst = SystemComponentStatusValue.unknown;
    }

    return SystemMonitoringOverview(
      overallStatus: worst,
      componentCount: components.length,
      healthyCount: healthy,
      degradedCount: degraded,
      unhealthyCount: unhealthy,
      unknownCount: unknown,
      notConfiguredCount: notConfigured,
      disabledCount: disabled,
      activeIncidentCount: activeIncidentCount,
      criticalIncidentCount: criticalIncidentCount,
      generatedAt: generatedAt,
      lastRefreshAt: lastRefreshAt,
      environment: environment,
      privacyNoteKey: privacyNoteKey,
    );
  }
}

class SystemMonitoringMetrics {
  const SystemMonitoringMetrics({
    this.generatedAt,
    this.privacyNoteKey,
    this.apiErrorsLastHour,
    this.failedNotificationsCount,
    this.emailFailures,
    this.storageFailures,
    this.packageGenerationFailures,
    this.pendingUploadFailures,
    this.integrationFailedJobsLast24h,
    this.integrationPendingJobs,
    this.criticalAuditEventsLast24h,
    this.workerEnabled,
    this.workerLastRunAt,
    this.workerLastError,
    this.redisEnabled,
    this.redisConnected,
    this.dbResponseTimeMs,
    this.activeIncidentCount = 0,
    this.unresolvedCriticalIncidentCount = 0,
    this.notes = const [],
  });

  final DateTime? generatedAt;
  final String? privacyNoteKey;
  final int? apiErrorsLastHour;
  final int? failedNotificationsCount;
  final int? emailFailures;
  final int? storageFailures;
  final int? packageGenerationFailures;
  final int? pendingUploadFailures;
  final int? integrationFailedJobsLast24h;
  final int? integrationPendingJobs;
  final int? criticalAuditEventsLast24h;
  final bool? workerEnabled;
  final DateTime? workerLastRunAt;
  final String? workerLastError;
  final bool? redisEnabled;
  final bool? redisConnected;
  final int? dbResponseTimeMs;
  final int activeIncidentCount;
  final int unresolvedCriticalIncidentCount;
  final List<String> notes;
}

class SystemMonitoringSnapshot {
  const SystemMonitoringSnapshot({
    required this.overview,
    required this.components,
    this.metrics,
    this.activeIncidents = const [],
    this.privacyNoteKey,
  });

  final SystemMonitoringOverview overview;
  final List<SystemComponentStatus> components;
  final SystemMonitoringMetrics? metrics;
  final List<SystemMonitoringIncident> activeIncidents;
  final String? privacyNoteKey;
}

class SystemComponentDetail {
  const SystemComponentDetail({
    required this.component,
    this.diagnosticSuggestion,
  });

  final SystemComponentStatus component;
  final SystemDiagnosticSuggestion? diagnosticSuggestion;
}

class SystemIncidentListPage {
  const SystemIncidentListPage({
    required this.items,
    this.total,
    this.offset = 0,
    this.limit = 50,
  });

  final List<SystemMonitoringIncident> items;
  final int? total;
  final int offset;
  final int limit;
}

enum SystemMonitoringComponentFilter { all, degradedOrUnhealthy }

extension SystemMonitoringComponentFilterX on SystemMonitoringComponentFilter {
  String localizationKey() {
    return switch (this) {
      SystemMonitoringComponentFilter.all => 'systemMonitoringFilterAll',
      SystemMonitoringComponentFilter.degradedOrUnhealthy =>
        'systemMonitoringFilterDegradedUnhealthy',
    };
  }
}
