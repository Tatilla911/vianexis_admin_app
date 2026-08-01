import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_config.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/localization/localization_keys.dart';
import '../domain/system_component_status.dart';
import '../domain/system_diagnostic_suggestion.dart';
import '../domain/system_monitoring_action_request.dart';
import '../domain/system_monitoring_incident.dart';
import '../domain/system_monitoring_overview.dart';
import 'system_monitoring_api.dart';

abstract class SystemMonitoringRepository {
  Future<SystemMonitoringSnapshot> fetchSnapshot();

  Future<SystemComponentDetail> fetchComponent(String componentKey);

  Future<SystemIncidentListPage> fetchIncidents({
    String? status,
    String? severity,
    String? componentKey,
  });

  Future<SystemMonitoringIncident> fetchIncident(String id);

  Future<SystemMonitoringIncident> acknowledgeIncident({
    required String id,
    required SystemMonitoringAcknowledgeRequest request,
  });

  Future<SystemMonitoringIncident> updateIncidentStatus({
    required String id,
    required SystemMonitoringStatusUpdateRequest request,
  });

  Future<SystemMonitoringIncident> addIncidentNote({
    required String id,
    required SystemMonitoringNoteRequest request,
  });

  Future<SystemMonitoringSnapshot> refreshMonitoring();

  bool get usesMockData;
}

class LiveSystemMonitoringRepository implements SystemMonitoringRepository {
  LiveSystemMonitoringRepository(this._api);

  final SystemMonitoringApi _api;
  SystemMonitoringSnapshot? _cachedSnapshot;
  final Map<String, SystemMonitoringIncident> _incidentCache = {};

  @override
  bool get usesMockData => false;

  @override
  Future<SystemMonitoringSnapshot> fetchSnapshot() async {
    // Live path: never invent healthy data. Propagate API failures.
    final overview = await _api.fetchOverview();

    SystemMonitoringMetrics? metrics;
    try {
      metrics = await _api.fetchMetrics();
    } on ApiException {
      metrics = null;
    }

    List<SystemMonitoringIncident> activeIncidents = const [];
    try {
      final page = await _api.fetchIncidents(limit: 20);
      activeIncidents = page.items
          .where((incident) => incident.status.isActive)
          .toList(growable: false);
      for (final incident in page.items) {
        _incidentCache[incident.id] = incident;
      }
    } on ApiException {
      activeIncidents = const [];
    }

    final snapshot = SystemMonitoringSnapshot(
      overview: overview.overview,
      components: overview.components,
      metrics: metrics,
      activeIncidents: activeIncidents,
      privacyNoteKey: overview.privacyNoteKey,
    );
    _cachedSnapshot = snapshot;
    return snapshot;
  }

  @override
  Future<SystemComponentDetail> fetchComponent(String componentKey) {
    return _api.fetchComponent(componentKey);
  }

  @override
  Future<SystemIncidentListPage> fetchIncidents({
    String? status,
    String? severity,
    String? componentKey,
  }) async {
    final page = await _api.fetchIncidents(
      status: status,
      severity: severity,
      componentKey: componentKey,
    );
    for (final incident in page.items) {
      _incidentCache[incident.id] = incident;
    }
    return page;
  }

  @override
  Future<SystemMonitoringIncident> fetchIncident(String id) async {
    try {
      final incident = await _api.fetchIncident(id);
      _incidentCache[id] = incident;
      return incident;
    } on ApiException catch (error) {
      if (error.kind != ApiExceptionKind.notFound) rethrow;
      final cached = _incidentCache[id];
      if (cached != null) return cached;
      final fromSnapshot = _cachedSnapshot?.activeIncidents
          .where((incident) => incident.id == id)
          .firstOrNull;
      if (fromSnapshot != null) return fromSnapshot;
      rethrow;
    }
  }

  @override
  Future<SystemMonitoringIncident> acknowledgeIncident({
    required String id,
    required SystemMonitoringAcknowledgeRequest request,
  }) async {
    try {
      final updated = await _api.acknowledgeIncident(id: id, request: request);
      _incidentCache[id] = updated;
      return updated;
    } on ApiException catch (error) {
      if (error.kind == ApiExceptionKind.notFound) {
        throw const ApiException(
          messageKey: LocalizationKeys.systemMonitoringActionUnavailable,
          kind: ApiExceptionKind.notFound,
        );
      }
      rethrow;
    }
  }

  @override
  Future<SystemMonitoringIncident> updateIncidentStatus({
    required String id,
    required SystemMonitoringStatusUpdateRequest request,
  }) async {
    try {
      final updated = await _api.updateIncidentStatus(id: id, request: request);
      _incidentCache[id] = updated;
      return updated;
    } on ApiException catch (error) {
      if (error.kind == ApiExceptionKind.notFound) {
        throw const ApiException(
          messageKey: LocalizationKeys.systemMonitoringActionUnavailable,
          kind: ApiExceptionKind.notFound,
        );
      }
      rethrow;
    }
  }

  @override
  Future<SystemMonitoringIncident> addIncidentNote({
    required String id,
    required SystemMonitoringNoteRequest request,
  }) async {
    try {
      final updated = await _api.addIncidentNote(id: id, request: request);
      _incidentCache[id] = updated;
      return updated;
    } on ApiException catch (error) {
      if (error.kind == ApiExceptionKind.notFound) {
        throw const ApiException(
          messageKey: LocalizationKeys.systemMonitoringActionUnavailable,
          kind: ApiExceptionKind.notFound,
        );
      }
      rethrow;
    }
  }

  @override
  Future<SystemMonitoringSnapshot> refreshMonitoring() async {
    try {
      await _api.refresh();
    } on ApiException {
      // Refresh endpoint may rate-limit; still reload overview honestly.
    }
    return fetchSnapshot();
  }
}

class MockSystemMonitoringRepository implements SystemMonitoringRepository {
  MockSystemMonitoringRepository() {
    _snapshot = _buildSnapshot();
    _incidents = List.of(_snapshot.activeIncidents);
  }

  late SystemMonitoringSnapshot _snapshot;
  late List<SystemMonitoringIncident> _incidents;

  @override
  bool get usesMockData => true;

  @override
  Future<SystemMonitoringSnapshot> fetchSnapshot() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return _snapshot;
  }

  @override
  Future<SystemComponentDetail> fetchComponent(String componentKey) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    final component = _snapshot.components.firstWhere(
      (item) => item.componentKey == componentKey,
      orElse: () => throw const ApiException(
        messageKey: LocalizationKeys.errorGenericBody,
        kind: ApiExceptionKind.notFound,
      ),
    );

    final suggestion = SystemDiagnosticSuggestion(
      summary: component.status == SystemComponentStatusValue.notConfigured
          ? 'Component is not configured in this environment.'
          : component.status == SystemComponentStatusValue.unknown
          ? 'Insufficient evidence to classify health.'
          : component.message,
      possibleCauses:
          component.status == SystemComponentStatusValue.notConfigured
          ? ['Missing environment credentials or feature flags']
          : ['Transient infrastructure issue', 'Dependency outage'],
      confidence: SystemDiagnosticConfidence.low,
      affectedCapabilities: component.affectedCapabilities,
      recommendedChecks: [
        'Review deployment readiness blockers',
        'Confirm dependency configuration',
      ],
      urgency: component.status == SystemComponentStatusValue.unhealthy
          ? SystemDiagnosticUrgency.high
          : SystemDiagnosticUrgency.medium,
      missingEvidence:
          component.status == SystemComponentStatusValue.unknown ||
              component.status == SystemComponentStatusValue.notConfigured
          ? ['live_probe_result', 'provider_health_payload']
          : const [],
      aiGenerated: false,
      disclaimerKey: 'systemMonitoringAiDisclaimer',
    );

    return SystemComponentDetail(
      component: component,
      diagnosticSuggestion: suggestion,
    );
  }

  @override
  Future<SystemIncidentListPage> fetchIncidents({
    String? status,
    String? severity,
    String? componentKey,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    var items = List<SystemMonitoringIncident>.of(_incidents);
    if (status != null && status.isNotEmpty) {
      items = items
          .where((i) => i.status.backendValue == status)
          .toList(growable: false);
    }
    if (severity != null && severity.isNotEmpty) {
      items = items
          .where((i) => i.severity.backendValue == severity)
          .toList(growable: false);
    }
    if (componentKey != null && componentKey.isNotEmpty) {
      items = items
          .where((i) => i.componentKey == componentKey)
          .toList(growable: false);
    }
    return SystemIncidentListPage(items: items, total: items.length);
  }

  @override
  Future<SystemMonitoringIncident> fetchIncident(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return _incidents.firstWhere(
      (incident) => incident.id == id,
      orElse: () => throw const ApiException(
        messageKey: LocalizationKeys.errorGenericBody,
        kind: ApiExceptionKind.notFound,
      ),
    );
  }

  @override
  Future<SystemMonitoringIncident> acknowledgeIncident({
    required String id,
    required SystemMonitoringAcknowledgeRequest request,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return _mutateIncident(
      id,
      (current) => current.copyWith(
        status: SystemIncidentStatus.investigating,
        acknowledgedAt: DateTime.now().toUtc(),
        timeline: [
          ...current.timeline,
          SystemIncidentTimelineEvent(
            id: 'evt-ack-${DateTime.now().millisecondsSinceEpoch}',
            eventType: 'acknowledged',
            message: request.note?.trim().isNotEmpty == true
                ? request.note!.trim()
                : 'Incident acknowledged',
            createdAt: DateTime.now().toUtc(),
          ),
        ],
      ),
    );
  }

  @override
  Future<SystemMonitoringIncident> updateIncidentStatus({
    required String id,
    required SystemMonitoringStatusUpdateRequest request,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final next = SystemIncidentStatus.fromBackendValue(request.status);
    return _mutateIncident(
      id,
      (current) => current.copyWith(
        status: next,
        resolvedAt: next == SystemIncidentStatus.resolved
            ? DateTime.now().toUtc()
            : current.resolvedAt,
        resolutionSummary: request.resolutionSummary,
        timeline: [
          ...current.timeline,
          SystemIncidentTimelineEvent(
            id: 'evt-status-${DateTime.now().millisecondsSinceEpoch}',
            eventType: 'status_changed',
            message: 'Status changed to ${next.backendValue}',
            createdAt: DateTime.now().toUtc(),
          ),
        ],
      ),
    );
  }

  @override
  Future<SystemMonitoringIncident> addIncidentNote({
    required String id,
    required SystemMonitoringNoteRequest request,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return _mutateIncident(
      id,
      (current) => current.copyWith(
        timeline: [
          ...current.timeline,
          SystemIncidentTimelineEvent(
            id: 'evt-note-${DateTime.now().millisecondsSinceEpoch}',
            eventType: 'note',
            message: request.note.trim(),
            createdAt: DateTime.now().toUtc(),
          ),
        ],
      ),
    );
  }

  @override
  Future<SystemMonitoringSnapshot> refreshMonitoring() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final refreshed = SystemMonitoringSnapshot(
      overview: SystemMonitoringOverview(
        overallStatus: _snapshot.overview.overallStatus,
        componentCount: _snapshot.overview.componentCount,
        healthyCount: _snapshot.overview.healthyCount,
        degradedCount: _snapshot.overview.degradedCount,
        unhealthyCount: _snapshot.overview.unhealthyCount,
        unknownCount: _snapshot.overview.unknownCount,
        notConfiguredCount: _snapshot.overview.notConfiguredCount,
        disabledCount: _snapshot.overview.disabledCount,
        activeIncidentCount: _incidents.where((i) => i.status.isActive).length,
        criticalIncidentCount: _incidents
            .where(
              (i) =>
                  i.status.isActive &&
                  i.severity == SystemIncidentSeverity.critical,
            )
            .length,
        generatedAt: DateTime.now().toUtc(),
        lastRefreshAt: DateTime.now().toUtc(),
        environment: _snapshot.overview.environment,
        privacyNoteKey: _snapshot.overview.privacyNoteKey,
      ),
      components: _snapshot.components,
      metrics: _snapshot.metrics,
      activeIncidents: _incidents
          .where((i) => i.status.isActive)
          .toList(growable: false),
      privacyNoteKey: _snapshot.privacyNoteKey,
    );
    _snapshot = refreshed;
    return refreshed;
  }

  SystemMonitoringIncident _mutateIncident(
    String id,
    SystemMonitoringIncident Function(SystemMonitoringIncident) update,
  ) {
    final index = _incidents.indexWhere((incident) => incident.id == id);
    if (index < 0) {
      throw const ApiException(
        messageKey: LocalizationKeys.errorGenericBody,
        kind: ApiExceptionKind.notFound,
      );
    }
    final updated = update(_incidents[index]);
    _incidents[index] = updated;
    _snapshot = SystemMonitoringSnapshot(
      overview: _snapshot.overview,
      components: _snapshot.components,
      metrics: _snapshot.metrics,
      activeIncidents: _incidents
          .where((i) => i.status.isActive)
          .toList(growable: false),
      privacyNoteKey: _snapshot.privacyNoteKey,
    );
    return updated;
  }

  static SystemMonitoringSnapshot _buildSnapshot() {
    final now = DateTime.utc(2026, 8, 1, 12, 0);

    final components = [
      SystemComponentStatus(
        componentKey: 'backend_api',
        displayName: 'Backend API',
        status: SystemComponentStatusValue.healthy,
        message: 'API process responding',
        checkedAt: now,
        responseTimeMs: 12,
        dependencyType: SystemDependencyType.critical,
        isConfigured: true,
        isCritical: true,
        affectedCapabilities: const ['platform_admin_api'],
        evidence: const ['process_event_loop_responsive'],
      ),
      SystemComponentStatus(
        componentKey: 'postgresql',
        displayName: 'PostgreSQL',
        status: SystemComponentStatusValue.healthy,
        message: 'SELECT 1 succeeded',
        checkedAt: now,
        responseTimeMs: 8,
        dependencyType: SystemDependencyType.critical,
        isConfigured: true,
        isCritical: true,
      ),
      SystemComponentStatus(
        componentKey: 'redis',
        displayName: 'Redis',
        status: SystemComponentStatusValue.notConfigured,
        message: 'Redis disabled in this environment',
        checkedAt: now,
        dependencyType: SystemDependencyType.optional,
        isConfigured: false,
        isCritical: false,
      ),
      SystemComponentStatus(
        componentKey: 'object_storage',
        displayName: 'Object storage',
        status: SystemComponentStatusValue.degraded,
        message: 'Storage probe latency elevated',
        checkedAt: now,
        responseTimeMs: 840,
        dependencyType: SystemDependencyType.critical,
        isConfigured: true,
        isCritical: true,
        consecutiveFailures: 2,
      ),
      SystemComponentStatus(
        componentKey: 'smtp_email',
        displayName: 'SMTP / email',
        status: SystemComponentStatusValue.notConfigured,
        message: 'SMTP credentials not configured',
        checkedAt: now,
        dependencyType: SystemDependencyType.external,
        isConfigured: false,
        isCritical: false,
      ),
      SystemComponentStatus(
        componentKey: 'fcm_push',
        displayName: 'FCM / push',
        status: SystemComponentStatusValue.notConfigured,
        message: 'FCM credentials not configured',
        checkedAt: now,
        dependencyType: SystemDependencyType.external,
        isConfigured: false,
        isCritical: false,
      ),
      SystemComponentStatus(
        componentKey: 'ai_service',
        displayName: 'AI service',
        status: SystemComponentStatusValue.unknown,
        message: 'Insufficient evidence for AI provider health',
        checkedAt: now,
        dependencyType: SystemDependencyType.external,
        isConfigured: false,
        isCritical: false,
      ),
      SystemComponentStatus(
        componentKey: 'translation',
        displayName: 'Translation',
        status: SystemComponentStatusValue.unknown,
        message: 'Translation provider health unknown',
        checkedAt: now,
        dependencyType: SystemDependencyType.external,
        isConfigured: false,
        isCritical: false,
      ),
      SystemComponentStatus(
        componentKey: 'background_jobs',
        displayName: 'Background jobs',
        status: SystemComponentStatusValue.unhealthy,
        message: 'Worker last error present',
        checkedAt: now,
        dependencyType: SystemDependencyType.critical,
        isConfigured: true,
        isCritical: true,
        consecutiveFailures: 3,
      ),
      SystemComponentStatus(
        componentKey: 'authentication',
        displayName: 'Authentication',
        status: SystemComponentStatusValue.healthy,
        message: 'Auth endpoints reachable',
        checkedAt: now,
        dependencyType: SystemDependencyType.critical,
        isConfigured: true,
        isCritical: true,
      ),
    ];

    final incidents = [
      SystemMonitoringIncident(
        id: 'inc-1001',
        title: 'Background jobs unhealthy',
        summary:
            'Worker reported consecutive failures. No tenant content exposed.',
        severity: SystemIncidentSeverity.critical,
        status: SystemIncidentStatus.open,
        source: SystemIncidentSource.alertRule,
        componentKey: 'background_jobs',
        detectedAt: DateTime.utc(2026, 8, 1, 10, 15),
        firstOccurrenceAt: DateTime.utc(2026, 8, 1, 10, 15),
        lastOccurrenceAt: DateTime.utc(2026, 8, 1, 11, 40),
        occurrenceCount: 3,
        technicalCode: 'background_jobs.worker_error',
        alertRuleKey: 'component_unhealthy:background_jobs',
        affectedCapabilities: const ['notifications', 'integrations'],
        timeline: [
          SystemIncidentTimelineEvent(
            id: 'evt-1',
            eventType: 'opened',
            message: 'Incident opened by alert rule',
            createdAt: DateTime.utc(2026, 8, 1, 10, 15),
          ),
        ],
        diagnosticSuggestion: const SystemDiagnosticSuggestion(
          summary:
              'Worker errors may indicate queue or dependency disruption. Advisory only.',
          possibleCauses: [
            'Redis unavailable',
            'Downstream integration timeout',
          ],
          confidence: SystemDiagnosticConfidence.low,
          recommendedChecks: [
            'Inspect worker last error metadata',
            'Confirm Redis configuration',
          ],
          urgency: SystemDiagnosticUrgency.critical,
          aiGenerated: false,
        ),
      ),
      SystemMonitoringIncident(
        id: 'inc-1002',
        title: 'Object storage degraded',
        summary: 'Storage probe latency above warning threshold.',
        severity: SystemIncidentSeverity.high,
        status: SystemIncidentStatus.investigating,
        source: SystemIncidentSource.healthCheck,
        componentKey: 'object_storage',
        detectedAt: DateTime.utc(2026, 8, 1, 9, 50),
        acknowledgedAt: DateTime.utc(2026, 8, 1, 10, 5),
        firstOccurrenceAt: DateTime.utc(2026, 8, 1, 9, 50),
        lastOccurrenceAt: DateTime.utc(2026, 8, 1, 11, 20),
        occurrenceCount: 2,
        technicalCode: 'object_storage.slow_probe',
        affectedCapabilities: const ['document_upload'],
        timeline: [
          SystemIncidentTimelineEvent(
            id: 'evt-2',
            eventType: 'opened',
            message: 'Degraded storage probe detected',
            createdAt: DateTime.utc(2026, 8, 1, 9, 50),
          ),
          SystemIncidentTimelineEvent(
            id: 'evt-3',
            eventType: 'acknowledged',
            message: 'Acknowledged by platform support',
            createdAt: DateTime.utc(2026, 8, 1, 10, 5),
          ),
        ],
      ),
    ];

    final overview = SystemMonitoringOverview.fromComponents(
      components: components,
      activeIncidentCount: incidents.where((i) => i.status.isActive).length,
      criticalIncidentCount: incidents
          .where(
            (i) =>
                i.status.isActive &&
                i.severity == SystemIncidentSeverity.critical,
          )
          .length,
      generatedAt: now,
      lastRefreshAt: now,
      environment: 'mock',
      privacyNoteKey: 'systemMonitoringPrivacyNotice',
    );

    // Override overall to degraded because critical component is unhealthy.
    final adjustedOverview = SystemMonitoringOverview(
      overallStatus: SystemComponentStatusValue.unhealthy,
      componentCount: overview.componentCount,
      healthyCount: overview.healthyCount,
      degradedCount: overview.degradedCount,
      unhealthyCount: overview.unhealthyCount,
      unknownCount: overview.unknownCount,
      notConfiguredCount: overview.notConfiguredCount,
      disabledCount: overview.disabledCount,
      activeIncidentCount: overview.activeIncidentCount,
      criticalIncidentCount: overview.criticalIncidentCount,
      generatedAt: overview.generatedAt,
      lastRefreshAt: overview.lastRefreshAt,
      environment: overview.environment,
      privacyNoteKey: overview.privacyNoteKey,
    );

    return SystemMonitoringSnapshot(
      overview: adjustedOverview,
      components: components,
      metrics: SystemMonitoringMetrics(
        generatedAt: now,
        privacyNoteKey: 'systemMonitoringPrivacyNotice',
        apiErrorsLastHour: 2,
        failedNotificationsCount: 4,
        emailFailures: null,
        storageFailures: 1,
        workerEnabled: true,
        workerLastError: 'queue dispatch failed',
        redisEnabled: false,
        redisConnected: null,
        dbResponseTimeMs: 8,
        activeIncidentCount: 2,
        unresolvedCriticalIncidentCount: 1,
        notes: const ['Mock aggregates only — no tenant identifiers.'],
      ),
      activeIncidents: incidents,
      privacyNoteKey: 'systemMonitoringPrivacyNotice',
    );
  }
}

final systemMonitoringRepositoryProvider = Provider<SystemMonitoringRepository>(
  (ref) {
    if (AppConfig.instance.shouldUseLiveRepositories) {
      return LiveSystemMonitoringRepository(
        ref.watch(systemMonitoringApiProvider),
      );
    }
    return MockSystemMonitoringRepository();
  },
);
