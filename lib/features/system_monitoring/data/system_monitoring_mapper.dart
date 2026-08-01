import '../domain/system_component_status.dart';
import '../domain/system_diagnostic_suggestion.dart';
import '../domain/system_monitoring_incident.dart';
import '../domain/system_monitoring_overview.dart';

abstract final class SystemMonitoringMapper {
  static SystemMonitoringSnapshot fromOverviewResponse(
    Map<String, dynamic> json, {
    SystemMonitoringMetrics? metrics,
    List<SystemMonitoringIncident> activeIncidents = const [],
  }) {
    final components = _asList(json['components'])
        .whereType<Map>()
        .map((item) => componentFromJson(Map<String, dynamic>.from(item)))
        .toList(growable: false);

    final overview = SystemMonitoringOverview(
      overallStatus: SystemComponentStatusValue.fromBackendValue(
        json['overallStatus']?.toString(),
      ),
      componentCount: _asInt(json['componentCount']) ?? components.length,
      healthyCount: _asInt(json['healthyCount']) ?? 0,
      degradedCount: _asInt(json['degradedCount']) ?? 0,
      unhealthyCount: _asInt(json['unhealthyCount']) ?? 0,
      unknownCount: _asInt(json['unknownCount']) ?? 0,
      notConfiguredCount: _asInt(json['notConfiguredCount']) ?? 0,
      disabledCount: _asInt(json['disabledCount']) ?? 0,
      activeIncidentCount:
          _asInt(json['activeIncidentCount']) ??
          activeIncidents.where((i) => i.status.isActive).length,
      criticalIncidentCount:
          _asInt(json['criticalIncidentCount']) ??
          activeIncidents
              .where((i) => i.severity == SystemIncidentSeverity.critical)
              .length,
      generatedAt: parseDate(json['generatedAt']),
      lastRefreshAt: parseDate(json['lastRefreshAt'] ?? json['generatedAt']),
      environment: json['environment']?.toString(),
      privacyNoteKey: json['privacyNoteKey']?.toString(),
    );

    return SystemMonitoringSnapshot(
      overview: overview,
      components: components,
      metrics: metrics,
      activeIncidents: activeIncidents,
      privacyNoteKey: json['privacyNoteKey']?.toString(),
    );
  }

  static SystemComponentStatus componentFromJson(Map<String, dynamic> json) {
    final key =
        json['componentKey']?.toString() ??
        json['component']?.toString() ??
        'unknown';
    final displayName =
        json['displayName']?.toString() ?? json['name']?.toString() ?? key;

    return SystemComponentStatus(
      componentKey: key,
      displayName: displayName,
      status: SystemComponentStatusValue.fromBackendValue(
        json['status']?.toString(),
      ),
      message:
          json['message']?.toString() ??
          json['detailSummary']?.toString() ??
          '',
      checkedAt: parseDate(json['checkedAt'] ?? json['lastCheckedAt']),
      responseTimeMs: _asInt(json['responseTimeMs']),
      technicalCode: json['technicalCode']?.toString(),
      environment: json['environment']?.toString(),
      dependencyType: SystemDependencyType.fromBackendValue(
        json['dependencyType']?.toString(),
      ),
      lastHealthyAt: parseDate(json['lastHealthyAt']),
      lastFailureAt: parseDate(json['lastFailureAt']),
      consecutiveFailures: _asInt(json['consecutiveFailures']) ?? 0,
      affectedCapabilities: _asStringList(json['affectedCapabilities']),
      detailsSanitized: _asMap(json['detailsSanitized']),
      evidence: _asStringList(json['evidence']),
      isConfigured: json['isConfigured'] != false,
      isCritical: json['isCritical'] == true,
    );
  }

  static SystemComponentDetail componentDetailFromJson(
    Map<String, dynamic> json,
  ) {
    final componentJson = json['component'] is Map
        ? Map<String, dynamic>.from(json['component'] as Map)
        : json;
    final diagnosticRaw =
        json['diagnosticSuggestion'] ??
        json['diagnostic'] ??
        json['suggestion'];

    return SystemComponentDetail(
      component: componentFromJson(componentJson),
      diagnosticSuggestion: diagnosticRaw is Map
          ? diagnosticFromJson(Map<String, dynamic>.from(diagnosticRaw))
          : null,
    );
  }

  static SystemMonitoringMetrics metricsFromJson(Map<String, dynamic> json) {
    final aggregates = _asMap(json['aggregates'] ?? json);

    return SystemMonitoringMetrics(
      generatedAt: parseDate(json['generatedAt']),
      privacyNoteKey: json['privacyNoteKey']?.toString(),
      apiErrorsLastHour: _asInt(aggregates['apiErrorsLastHour']),
      failedNotificationsCount: _asInt(aggregates['failedNotificationsCount']),
      emailFailures: _asInt(aggregates['emailFailures']),
      storageFailures: _asInt(aggregates['storageFailures']),
      packageGenerationFailures: _asInt(
        aggregates['packageGenerationFailures'],
      ),
      pendingUploadFailures: _asInt(aggregates['pendingUploadFailures']),
      integrationFailedJobsLast24h: _asInt(
        aggregates['integrationFailedJobsLast24h'],
      ),
      integrationPendingJobs: _asInt(aggregates['integrationPendingJobs']),
      criticalAuditEventsLast24h: _asInt(
        aggregates['criticalAuditEventsLast24h'],
      ),
      workerEnabled: _asBool(aggregates['workerEnabled']),
      workerLastRunAt: parseDate(aggregates['workerLastRunAt']),
      workerLastError: aggregates['workerLastError']?.toString(),
      redisEnabled: _asBool(aggregates['redisEnabled']),
      redisConnected: _asBool(aggregates['redisConnected']),
      dbResponseTimeMs: _asInt(aggregates['dbResponseTimeMs']),
      activeIncidentCount: _asInt(aggregates['activeIncidentCount']) ?? 0,
      unresolvedCriticalIncidentCount:
          _asInt(aggregates['unresolvedCriticalIncidentCount']) ?? 0,
      notes: _asStringList(json['notes']),
    );
  }

  static SystemMonitoringIncident incidentFromJson(Map<String, dynamic> json) {
    final timeline =
        _asList(json['events'] ?? json['timeline'] ?? json['history'])
            .whereType<Map>()
            .map(
              (item) => timelineEventFromJson(Map<String, dynamic>.from(item)),
            )
            .toList(growable: false);

    final diagnosticRaw =
        json['diagnosticSuggestion'] ??
        json['diagnostic'] ??
        json['suggestion'];

    return SystemMonitoringIncident(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '—',
      summary:
          json['summary']?.toString() ??
          json['publicMessage']?.toString() ??
          '—',
      severity: SystemIncidentSeverity.fromBackendValue(
        json['severity']?.toString(),
      ),
      status: SystemIncidentStatus.fromBackendValue(json['status']?.toString()),
      source: SystemIncidentSource.fromBackendValue(json['source']?.toString()),
      componentKey:
          json['componentKey']?.toString() ??
          json['component']?.toString() ??
          'unknown',
      detectedAt: parseDate(json['detectedAt'] ?? json['createdAt']),
      acknowledgedAt: parseDate(json['acknowledgedAt']),
      resolvedAt: parseDate(json['resolvedAt']),
      affectedCapabilities: _asStringList(json['affectedCapabilities']),
      occurrenceCount: _asInt(json['occurrenceCount']) ?? 1,
      firstOccurrenceAt: parseDate(json['firstOccurrenceAt']),
      lastOccurrenceAt: parseDate(json['lastOccurrenceAt']),
      technicalCode: json['technicalCode']?.toString(),
      publicMessage: json['publicMessage']?.toString(),
      resolutionSummary: json['resolutionSummary']?.toString(),
      alertRuleKey: json['alertRuleKey']?.toString(),
      evidenceSanitized: _asMap(json['evidenceSanitized']),
      timeline: timeline,
      diagnosticSuggestion: diagnosticRaw is Map
          ? diagnosticFromJson(Map<String, dynamic>.from(diagnosticRaw))
          : null,
    );
  }

  static SystemIncidentListPage incidentListFromJson(
    Map<String, dynamic> json,
  ) {
    final items = _asList(json['items'] ?? json['incidents'] ?? json['data'])
        .whereType<Map>()
        .map((item) => incidentFromJson(Map<String, dynamic>.from(item)))
        .toList(growable: false);

    return SystemIncidentListPage(
      items: items,
      total: _asInt(json['total'] ?? json['count']),
      offset: _asInt(json['offset']) ?? 0,
      limit: _asInt(json['limit']) ?? items.length,
    );
  }

  static SystemIncidentTimelineEvent timelineEventFromJson(
    Map<String, dynamic> json,
  ) {
    return SystemIncidentTimelineEvent(
      id: json['id']?.toString() ?? '',
      eventType:
          json['eventType']?.toString() ?? json['type']?.toString() ?? 'note',
      message: json['message']?.toString() ?? '',
      actorUserId: _asInt(json['actorUserId']),
      metadataSanitized: _asMap(json['metadataSanitized'] ?? json['metadata']),
      createdAt: parseDate(json['createdAt']),
    );
  }

  static SystemDiagnosticSuggestion diagnosticFromJson(
    Map<String, dynamic> json,
  ) {
    return SystemDiagnosticSuggestion(
      summary: json['summary']?.toString() ?? '',
      possibleCauses: _asStringList(json['possibleCauses']),
      confidence: SystemDiagnosticConfidence.fromBackendValue(
        json['confidence']?.toString(),
      ),
      affectedCapabilities: _asStringList(json['affectedCapabilities']),
      recommendedChecks: _asStringList(json['recommendedChecks']),
      urgency: SystemDiagnosticUrgency.fromBackendValue(
        json['urgency']?.toString(),
      ),
      missingEvidence: _asStringList(json['missingEvidence']),
      aiGenerated: json['aiGenerated'] == true,
      disclaimerKey:
          json['disclaimerKey']?.toString() ?? 'systemMonitoringAiDisclaimer',
    );
  }

  static DateTime? parseDate(Object? raw) {
    if (raw == null) return null;
    if (raw is DateTime) return raw;
    return DateTime.tryParse(raw.toString());
  }

  static List<dynamic> _asList(Object? raw) => raw is List ? raw : const [];

  static Map<String, dynamic> _asMap(Object? raw) {
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) return Map<String, dynamic>.from(raw);
    return const {};
  }

  static int? _asInt(Object? raw) {
    if (raw is int) return raw;
    if (raw is num) return raw.toInt();
    if (raw is String) return int.tryParse(raw);
    return null;
  }

  static bool? _asBool(Object? raw) {
    if (raw is bool) return raw;
    if (raw is String) {
      final normalized = raw.trim().toLowerCase();
      if (normalized == 'true' || normalized == '1') return true;
      if (normalized == 'false' || normalized == '0') return false;
    }
    return null;
  }

  static List<String> _asStringList(Object? raw) {
    if (raw is! List) return const [];
    return raw.map((e) => e.toString()).toList(growable: false);
  }
}
