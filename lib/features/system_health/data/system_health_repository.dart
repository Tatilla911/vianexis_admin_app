import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_config.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/localization/localization_keys.dart';
import '../domain/system_health_action_request.dart';
import '../domain/system_health_event.dart';
import '../domain/system_health_overview.dart';
import '../domain/system_health_severity.dart';
import '../domain/system_health_service_status.dart';
import 'system_health_api.dart';

abstract class SystemHealthRepository {
  Future<SystemHealthSnapshot> fetchSnapshot();

  Future<SystemHealthEvent> fetchEvent(String id);

  Future<SystemHealthEvent> submitAction({
    required String eventId,
    required SystemHealthActionRequest request,
  });

  bool get usesMockData;
}

class LiveSystemHealthRepository implements SystemHealthRepository {
  LiveSystemHealthRepository(this._api);

  final SystemHealthApi _api;
  SystemHealthSnapshot? _cachedSnapshot;

  @override
  bool get usesMockData => false;

  @override
  Future<SystemHealthSnapshot> fetchSnapshot() async {
    var snapshot = await _api.fetchSnapshot();
    snapshot = await _api.fetchEventsSnapshot(snapshot);
    _cachedSnapshot = snapshot;
    return snapshot;
  }

  @override
  Future<SystemHealthEvent> fetchEvent(String id) async {
    try {
      return await _api.fetchEvent(id);
    } on ApiException catch (error) {
      if (error.kind != ApiExceptionKind.notFound) rethrow;
      final cached = _cachedSnapshot;
      if (cached != null) {
        return cached.events.firstWhere(
          (event) => event.id == id,
          orElse: () => throw error,
        );
      }
      rethrow;
    }
  }

  @override
  Future<SystemHealthEvent> submitAction({
    required String eventId,
    required SystemHealthActionRequest request,
  }) async {
    try {
      await _api.submitAction(eventId: eventId, request: request);
    } on ApiException catch (error) {
      if (error.kind == ApiExceptionKind.notFound) {
        throw const ApiException(
          messageKey: LocalizationKeys.systemHealthActionUnavailable,
          kind: ApiExceptionKind.notFound,
        );
      }
      rethrow;
    }

    final updated = await fetchEvent(eventId);
    return switch (request.type) {
      SystemHealthActionType.acknowledge => updated.copyWith(
        status: SystemHealthEventStatus.acknowledged,
        lastSeenAt: DateTime.now().toUtc(),
      ),
      SystemHealthActionType.escalate => updated.copyWith(
        status: SystemHealthEventStatus.investigating,
        lastSeenAt: DateTime.now().toUtc(),
      ),
    };
  }
}

class MockSystemHealthRepository implements SystemHealthRepository {
  MockSystemHealthRepository();

  late SystemHealthSnapshot _snapshot = _buildSnapshot();

  @override
  bool get usesMockData => true;

  @override
  Future<SystemHealthSnapshot> fetchSnapshot() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return _snapshot;
  }

  @override
  Future<SystemHealthEvent> fetchEvent(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return _snapshot.events.firstWhere(
      (event) => event.id == id,
      orElse: () => throw const ApiException(
        messageKey: LocalizationKeys.errorGenericBody,
        kind: ApiExceptionKind.notFound,
      ),
    );
  }

  @override
  Future<SystemHealthEvent> submitAction({
    required String eventId,
    required SystemHealthActionRequest request,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final index = _snapshot.events.indexWhere((event) => event.id == eventId);
    if (index < 0) {
      throw const ApiException(
        messageKey: LocalizationKeys.errorGenericBody,
        kind: ApiExceptionKind.notFound,
      );
    }

    final current = _snapshot.events[index];
    final updated = switch (request.type) {
      SystemHealthActionType.acknowledge => current.copyWith(
        status: SystemHealthEventStatus.acknowledged,
        lastSeenAt: DateTime.now().toUtc(),
      ),
      SystemHealthActionType.escalate => current.copyWith(
        status: SystemHealthEventStatus.investigating,
        lastSeenAt: DateTime.now().toUtc(),
      ),
    };

    final events = [..._snapshot.events];
    events[index] = updated;
    _snapshot = SystemHealthSnapshot(
      overview: SystemHealthOverview.fromServicesAndEvents(
        services: _snapshot.services,
        events: events,
        failedJobsCount: _snapshot.overview.failedJobsCount,
      ),
      services: _snapshot.services,
      events: events,
    );
    return updated;
  }

  static SystemHealthSnapshot _buildSnapshot() {
    final services = [
      const SystemHealthServiceStatus(
        serviceKey: SystemHealthServiceKey.backendApi,
        severity: SystemHealthSeverity.info,
        summary: 'API process healthy',
      ),
      const SystemHealthServiceStatus(
        serviceKey: SystemHealthServiceKey.database,
        severity: SystemHealthSeverity.info,
        summary: 'PostgreSQL reachable',
      ),
      const SystemHealthServiceStatus(
        serviceKey: SystemHealthServiceKey.documentStorage,
        severity: SystemHealthSeverity.warning,
        summary: 'Storage probe latency elevated',
      ),
      const SystemHealthServiceStatus(
        serviceKey: SystemHealthServiceKey.backgroundWorkers,
        severity: SystemHealthSeverity.info,
        summary: 'Escalation worker last run 12m ago',
      ),
      const SystemHealthServiceStatus(
        serviceKey: SystemHealthServiceKey.aiOcrWorkers,
        severity: SystemHealthSeverity.warning,
        summary: 'OCR queue backlog advisory',
      ),
      const SystemHealthServiceStatus(
        serviceKey: SystemHealthServiceKey.translationService,
        severity: SystemHealthSeverity.info,
        summary: 'Translation provider reachable',
      ),
      const SystemHealthServiceStatus(
        serviceKey: SystemHealthServiceKey.emailService,
        severity: SystemHealthSeverity.info,
        summary: 'Email provider console mode',
      ),
      const SystemHealthServiceStatus(
        serviceKey: SystemHealthServiceKey.pushNotificationService,
        severity: SystemHealthSeverity.info,
        summary: 'WebSocket adapter single node',
      ),
      const SystemHealthServiceStatus(
        serviceKey: SystemHealthServiceKey.queueSystem,
        severity: SystemHealthSeverity.critical,
        summary: 'Redis disconnected in staging',
      ),
      const SystemHealthServiceStatus(
        serviceKey: SystemHealthServiceKey.authService,
        severity: SystemHealthSeverity.info,
        summary: 'Auth sessions healthy',
      ),
    ];

    final events = [
      SystemHealthEvent(
        id: '501',
        severity: SystemHealthSeverity.critical,
        serviceName: 'queue',
        status: SystemHealthEventStatus.open,
        title: 'Redis queue unavailable',
        summary: 'Background job dispatch delayed. No tenant document content exposed.',
        tenantImpactLevel: SystemHealthTenantImpactLevel.platformWide,
        startedAt: DateTime.utc(2026, 6, 18, 8, 0),
        lastSeenAt: DateTime.utc(2026, 6, 18, 9, 15),
        failedJobsCount: 14,
        aiDiagnosticSummary:
            'Advisory: Redis connection failure likely infrastructure level. Review deployment readiness blockers before retrying jobs.',
        recommendedAction:
            'Escalate to platform support. Do not trigger automatic repair.',
        correlationId: 'health-501-redis',
        metadataOnly: const {'component': 'worker', 'queue': 'message_escalation'},
      ),
      SystemHealthEvent(
        id: '502',
        severity: SystemHealthSeverity.warning,
        serviceName: 'storage',
        status: SystemHealthEventStatus.open,
        title: 'Document storage latency',
        summary: 'Upload metadata checks slower than baseline.',
        tenantImpactLevel: SystemHealthTenantImpactLevel.singleTenant,
        affectedCompanyName: 'NordTrans Kft.',
        affectedCompanyId: '12',
        startedAt: DateTime.utc(2026, 6, 18, 7, 30),
        lastSeenAt: DateTime.utc(2026, 6, 18, 8, 45),
        failedJobsCount: 2,
        aiDiagnosticSummary:
            'Advisory: storage probe warning for one tenant bucket policy. Metadata only.',
        recommendedAction: 'Acknowledge and monitor. Escalate if persists > 1 hour.',
        correlationId: 'health-502-storage',
      ),
    ];

    return SystemHealthSnapshot(
      overview: SystemHealthOverview.fromServicesAndEvents(
        services: services,
        events: events,
        failedJobsCount: 16,
      ),
      services: services,
      events: events,
    );
  }
}

final systemHealthRepositoryProvider = Provider<SystemHealthRepository>((ref) {

  if (AppConfig.instance.shouldUseLiveRepositories) {
    return LiveSystemHealthRepository(ref.watch(systemHealthApiProvider));
  }
  return MockSystemHealthRepository();
});
