import 'system_diagnostic_suggestion.dart';

enum SystemIncidentSeverity {
  info,
  warning,
  high,
  critical,
  unknown;

  static SystemIncidentSeverity fromBackendValue(String? raw) {
    if (raw == null || raw.trim().isEmpty) return unknown;
    return switch (raw.trim().toLowerCase()) {
      'info' => info,
      'warning' => warning,
      'high' => high,
      'critical' => critical,
      _ => unknown,
    };
  }

  String get backendValue => switch (this) {
    info => 'info',
    warning => 'warning',
    high => 'high',
    critical => 'critical',
    unknown => 'unknown',
  };

  String localizationKey() {
    return switch (this) {
      info => 'systemMonitoringIncidentSeverityInfo',
      warning => 'systemMonitoringIncidentSeverityWarning',
      high => 'systemMonitoringIncidentSeverityHigh',
      critical => 'systemMonitoringIncidentSeverityCritical',
      unknown => 'systemMonitoringIncidentSeverityUnknown',
    };
  }
}

enum SystemIncidentStatus {
  open,
  investigating,
  monitoring,
  resolved,
  dismissed,
  unknown;

  static SystemIncidentStatus fromBackendValue(String? raw) {
    if (raw == null || raw.trim().isEmpty) return unknown;
    return switch (raw.trim().toLowerCase()) {
      'open' => open,
      'investigating' => investigating,
      'monitoring' => monitoring,
      'resolved' => resolved,
      'dismissed' => dismissed,
      _ => unknown,
    };
  }

  String get backendValue => switch (this) {
    open => 'open',
    investigating => 'investigating',
    monitoring => 'monitoring',
    resolved => 'resolved',
    dismissed => 'dismissed',
    unknown => 'unknown',
  };

  String localizationKey() {
    return switch (this) {
      open => 'systemMonitoringIncidentStatusOpen',
      investigating => 'systemMonitoringIncidentStatusInvestigating',
      monitoring => 'systemMonitoringIncidentStatusMonitoring',
      resolved => 'systemMonitoringIncidentStatusResolved',
      dismissed => 'systemMonitoringIncidentStatusDismissed',
      unknown => 'systemMonitoringIncidentStatusUnknown',
    };
  }

  bool get isActive =>
      this == open || this == investigating || this == monitoring;
}

enum SystemIncidentSource {
  alertRule,
  manual,
  healthCheck,
  recovery,
  unknown;

  static SystemIncidentSource fromBackendValue(String? raw) {
    if (raw == null || raw.trim().isEmpty) return unknown;
    return switch (raw.trim().toLowerCase()) {
      'alert_rule' => alertRule,
      'manual' => manual,
      'health_check' => healthCheck,
      'recovery' => recovery,
      _ => unknown,
    };
  }

  String localizationKey() {
    return switch (this) {
      alertRule => 'systemMonitoringIncidentSourceAlertRule',
      manual => 'systemMonitoringIncidentSourceManual',
      healthCheck => 'systemMonitoringIncidentSourceHealthCheck',
      recovery => 'systemMonitoringIncidentSourceRecovery',
      unknown => 'systemMonitoringIncidentSourceUnknown',
    };
  }
}

class SystemIncidentTimelineEvent {
  const SystemIncidentTimelineEvent({
    required this.id,
    required this.eventType,
    required this.message,
    this.actorUserId,
    this.metadataSanitized = const {},
    this.createdAt,
  });

  final String id;
  final String eventType;
  final String message;
  final int? actorUserId;
  final Map<String, dynamic> metadataSanitized;
  final DateTime? createdAt;
}

class SystemMonitoringIncident {
  const SystemMonitoringIncident({
    required this.id,
    required this.title,
    required this.summary,
    required this.severity,
    required this.status,
    required this.source,
    required this.componentKey,
    this.detectedAt,
    this.acknowledgedAt,
    this.resolvedAt,
    this.affectedCapabilities = const [],
    this.occurrenceCount = 1,
    this.firstOccurrenceAt,
    this.lastOccurrenceAt,
    this.technicalCode,
    this.publicMessage,
    this.resolutionSummary,
    this.alertRuleKey,
    this.evidenceSanitized = const {},
    this.timeline = const [],
    this.diagnosticSuggestion,
  });

  final String id;
  final String title;
  final String summary;
  final SystemIncidentSeverity severity;
  final SystemIncidentStatus status;
  final SystemIncidentSource source;
  final String componentKey;
  final DateTime? detectedAt;
  final DateTime? acknowledgedAt;
  final DateTime? resolvedAt;
  final List<String> affectedCapabilities;
  final int occurrenceCount;
  final DateTime? firstOccurrenceAt;
  final DateTime? lastOccurrenceAt;
  final String? technicalCode;
  final String? publicMessage;
  final String? resolutionSummary;
  final String? alertRuleKey;
  final Map<String, dynamic> evidenceSanitized;
  final List<SystemIncidentTimelineEvent> timeline;
  final SystemDiagnosticSuggestion? diagnosticSuggestion;

  bool matchesFilter(SystemMonitoringIncidentFilter filter) {
    return switch (filter) {
      SystemMonitoringIncidentFilter.all => true,
      SystemMonitoringIncidentFilter.open =>
        status == SystemIncidentStatus.open,
      SystemMonitoringIncidentFilter.investigating =>
        status == SystemIncidentStatus.investigating,
      SystemMonitoringIncidentFilter.monitoring =>
        status == SystemIncidentStatus.monitoring,
      SystemMonitoringIncidentFilter.resolved =>
        status == SystemIncidentStatus.resolved,
      SystemMonitoringIncidentFilter.dismissed =>
        status == SystemIncidentStatus.dismissed,
      SystemMonitoringIncidentFilter.critical =>
        severity == SystemIncidentSeverity.critical,
      SystemMonitoringIncidentFilter.high =>
        severity == SystemIncidentSeverity.high,
    };
  }

  SystemMonitoringIncident copyWith({
    SystemIncidentStatus? status,
    DateTime? acknowledgedAt,
    DateTime? resolvedAt,
    String? resolutionSummary,
    List<SystemIncidentTimelineEvent>? timeline,
  }) {
    return SystemMonitoringIncident(
      id: id,
      title: title,
      summary: summary,
      severity: severity,
      status: status ?? this.status,
      source: source,
      componentKey: componentKey,
      detectedAt: detectedAt,
      acknowledgedAt: acknowledgedAt ?? this.acknowledgedAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      affectedCapabilities: affectedCapabilities,
      occurrenceCount: occurrenceCount,
      firstOccurrenceAt: firstOccurrenceAt,
      lastOccurrenceAt: lastOccurrenceAt,
      technicalCode: technicalCode,
      publicMessage: publicMessage,
      resolutionSummary: resolutionSummary ?? this.resolutionSummary,
      alertRuleKey: alertRuleKey,
      evidenceSanitized: evidenceSanitized,
      timeline: timeline ?? this.timeline,
      diagnosticSuggestion: diagnosticSuggestion,
    );
  }
}

enum SystemMonitoringIncidentFilter {
  all,
  open,
  investigating,
  monitoring,
  resolved,
  dismissed,
  critical,
  high,
}

extension SystemMonitoringIncidentFilterX on SystemMonitoringIncidentFilter {
  String localizationKey() {
    return switch (this) {
      SystemMonitoringIncidentFilter.all => 'systemMonitoringFilterAll',
      SystemMonitoringIncidentFilter.open => 'systemMonitoringFilterOpen',
      SystemMonitoringIncidentFilter.investigating =>
        'systemMonitoringFilterInvestigating',
      SystemMonitoringIncidentFilter.monitoring =>
        'systemMonitoringFilterMonitoring',
      SystemMonitoringIncidentFilter.resolved =>
        'systemMonitoringFilterResolved',
      SystemMonitoringIncidentFilter.dismissed =>
        'systemMonitoringFilterDismissed',
      SystemMonitoringIncidentFilter.critical =>
        'systemMonitoringFilterCritical',
      SystemMonitoringIncidentFilter.high => 'systemMonitoringFilterHigh',
    };
  }
}
