import '../domain/system_health_event.dart';
import '../domain/system_health_overview.dart';
import '../domain/system_health_service_status.dart';
import '../domain/system_health_severity.dart';

abstract final class SystemHealthMapper {
  static SystemHealthSnapshot fromHealthResponse(Map<String, dynamic> json) {
    final components = _asList(json['components']);
    final recentEvents = _asList(json['recentEvents']);
    final infra = _asMap(json['infra']);

    final serviceMap = <SystemHealthServiceKey, SystemHealthServiceStatus>{};

    for (final item in components) {
      if (item is! Map) continue;
      final status = SystemHealthServiceStatus.fromJson(
        Map<String, dynamic>.from(item),
      );
      // Never let websocket/messaging overwrite the push notification card.
      if (status.serviceKey == SystemHealthServiceKey.pushNotificationService) {
        continue;
      }
      serviceMap[status.serviceKey] = status;
    }

    _applyInfraDerivedServices(serviceMap, infra);

    final services = _ensureAllServices(serviceMap);
    final events = recentEvents
        .whereType<Map>()
        .map(
          (item) => SystemHealthEvent.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList(growable: false);

    final failedJobsCount =
        _asInt(infra['notificationFailures']) ??
        _asInt(_asMap(infra['worker'])['pendingEstimate']) ??
        0;

    final overview = SystemHealthOverview.fromServicesAndEvents(
      services: services,
      events: events,
      failedJobsCount: failedJobsCount,
      lastUpdatedAt: DateTime.now().toUtc(),
    );

    return SystemHealthSnapshot(
      overview: overview,
      services: services,
      events: events,
      privacyNoteKey: json['privacyNoteKey']?.toString(),
    );
  }

  static SystemHealthSnapshot fromEventsResponse(
    Map<String, dynamic> json,
    SystemHealthSnapshot base,
  ) {
    final items = _asList(json['items'] ?? json['events']);
    if (items.isEmpty) return base;

    final events = items
        .whereType<Map>()
        .map(
          (item) => SystemHealthEvent.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList(growable: false);

    return SystemHealthSnapshot(
      overview: SystemHealthOverview.fromServicesAndEvents(
        services: base.services,
        events: events,
        failedJobsCount: base.overview.failedJobsCount,
        lastUpdatedAt: DateTime.now().toUtc(),
      ),
      services: base.services,
      events: events,
      privacyNoteKey: base.privacyNoteKey,
    );
  }

  static void _applyInfraDerivedServices(
    Map<SystemHealthServiceKey, SystemHealthServiceStatus> serviceMap,
    Map<String, dynamic> infra,
  ) {
    if (infra.isEmpty) return;

    final redis = _asMap(infra['redis']);
    final worker = _asMap(infra['worker']);
    final escalation = _asMap(worker['messageEscalation']);
    final push = _asMap(worker['notificationPush']);
    final queueDepth = _asInt(infra['pushQueueDepth']) ?? 0;
    final notificationFailures = _asInt(infra['notificationFailures']) ?? 0;

    serviceMap[SystemHealthServiceKey.queueSystem] = SystemHealthServiceStatus(
      serviceKey: SystemHealthServiceKey.queueSystem,
      severity: _severityFromConnected(redis['connected'], redis['enabled']),
      summary: 'redis=${redis['status'] ?? 'unknown'}',
      lastCheckedAt: DateTime.now().toUtc(),
      currentState: redis['status']?.toString(),
      detailFields: {
        'redis': '${redis['status'] ?? 'unknown'}',
        'websocket': '${infra['websocketMode'] ?? 'unknown'}',
      },
    );

    serviceMap[SystemHealthServiceKey.backgroundWorkers] =
        SystemHealthServiceStatus(
          serviceKey: SystemHealthServiceKey.backgroundWorkers,
          severity: escalation['lastError'] != null
              ? SystemHealthSeverity.warning
              : SystemHealthSeverity.info,
          summary: escalation['lastRunAt']?.toString() ?? 'worker idle',
          lastCheckedAt: SystemHealthEvent.parseDate(escalation['lastRunAt']),
          lastError: escalation['lastError']?.toString(),
          lastSuccessAt: SystemHealthEvent.parseDate(escalation['lastRunAt']),
          currentState: escalation['lastError'] != null ? 'degraded' : 'ok',
        );

    final pushEnabled = push['enabled'] != false;
    final pushLastError = push['lastError']?.toString();
    final pushLastRun = SystemHealthEvent.parseDate(push['lastRunAt']);
    final pushSeverity = _pushSeverity(
      enabled: pushEnabled,
      lastError: pushLastError,
      queueDepth: queueDepth,
      notificationFailures: notificationFailures,
    );

    serviceMap[SystemHealthServiceKey.pushNotificationService] =
        SystemHealthServiceStatus(
          serviceKey: SystemHealthServiceKey.pushNotificationService,
          severity: pushSeverity,
          summary: _pushSummary(
            enabled: pushEnabled,
            lastError: pushLastError,
            queueDepth: queueDepth,
            lastRunAt: push['lastRunAt']?.toString(),
          ),
          lastCheckedAt: DateTime.now().toUtc(),
          lastSuccessAt: pushLastError == null ? pushLastRun : null,
          lastError: pushLastError,
          currentState: !pushEnabled
              ? 'disabled'
              : pushLastError != null
              ? 'error'
              : queueDepth > 50
              ? 'backlog'
              : 'ok',
          affectedPlatform: 'android,ios',
          recommendedAction: _pushRecommendedAction(
            enabled: pushEnabled,
            lastError: pushLastError,
            queueDepth: queueDepth,
          ),
          detailFields: {
            'service': 'notification_push_worker',
            'enabled': '$pushEnabled',
            'queueDepth': '$queueDepth',
            'notificationFailures': '$notificationFailures',
            'lastProcessed': '${push['lastProcessed'] ?? 0}',
            if (push['pendingEstimate'] != null)
              'pendingEstimate': '${push['pendingEstimate']}',
          },
        );

    serviceMap.putIfAbsent(
      SystemHealthServiceKey.authService,
      () => SystemHealthServiceStatus(
        serviceKey: SystemHealthServiceKey.authService,
        severity: SystemHealthSeverity.info,
        summary: 'auth session service reachable',
        lastCheckedAt: DateTime.now().toUtc(),
        currentState: 'ok',
      ),
    );

    serviceMap.putIfAbsent(
      SystemHealthServiceKey.translationService,
      () => SystemHealthServiceStatus(
        serviceKey: SystemHealthServiceKey.translationService,
        severity: SystemHealthSeverity.info,
        summary: 'translation pipeline advisory only',
        lastCheckedAt: DateTime.now().toUtc(),
        currentState: 'ok',
      ),
    );
  }

  static SystemHealthSeverity _pushSeverity({
    required bool enabled,
    required String? lastError,
    required int queueDepth,
    required int notificationFailures,
  }) {
    if (!enabled) return SystemHealthSeverity.info;
    if (lastError != null && lastError.isNotEmpty) {
      return SystemHealthSeverity.critical;
    }
    if (queueDepth > 100 || notificationFailures > 25) {
      return SystemHealthSeverity.critical;
    }
    if (queueDepth > 50 || notificationFailures > 0) {
      return SystemHealthSeverity.warning;
    }
    return SystemHealthSeverity.info;
  }

  static String _pushSummary({
    required bool enabled,
    required String? lastError,
    required int queueDepth,
    required String? lastRunAt,
  }) {
    if (!enabled) return 'push worker disabled';
    if (lastError != null && lastError.isNotEmpty) {
      return 'lastError=$lastError';
    }
    if (queueDepth > 0) return 'queueDepth=$queueDepth';
    return lastRunAt != null ? 'lastRun=$lastRunAt' : 'push worker idle';
  }

  static String? _pushRecommendedAction({
    required bool enabled,
    required String? lastError,
    required int queueDepth,
  }) {
    if (!enabled) {
      return 'Push worker is intentionally disabled in this environment.';
    }
    if (lastError != null && lastError.isNotEmpty) {
      return 'Inspect notification push worker logs and provider credentials '
          '(FCM/APNs). Do not expose tokens in the admin UI.';
    }
    if (queueDepth > 50) {
      return 'Push queue backlog detected. Verify worker process is running '
          'and Redis connectivity is healthy.';
    }
    return null;
  }

  static List<SystemHealthServiceStatus> _ensureAllServices(
    Map<SystemHealthServiceKey, SystemHealthServiceStatus> serviceMap,
  ) {
    return SystemHealthServiceKey.dashboardServices
        .map(
          (key) =>
              serviceMap[key] ??
              SystemHealthServiceStatus(
                serviceKey: key,
                severity: SystemHealthSeverity.unknown,
                summary: null,
              ),
        )
        .toList(growable: false);
  }

  static SystemHealthSeverity _severityFromConnected(
    Object? connected,
    Object? enabled,
  ) {
    if (enabled == false) return SystemHealthSeverity.info;
    if (connected == true) return SystemHealthSeverity.info;
    if (connected == false) return SystemHealthSeverity.critical;
    return SystemHealthSeverity.warning;
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
}
