enum SystemComponentStatusValue {
  healthy,
  degraded,
  unhealthy,
  unknown,
  disabled,
  notConfigured;

  static SystemComponentStatusValue fromBackendValue(String? raw) {
    if (raw == null || raw.trim().isEmpty) return unknown;
    return switch (raw.trim().toLowerCase()) {
      'healthy' || 'ok' => healthy,
      'degraded' => degraded,
      'unhealthy' || 'error' || 'critical' => unhealthy,
      'disabled' => disabled,
      'not_configured' || 'notconfigured' => notConfigured,
      'unknown' => unknown,
      _ => unknown,
    };
  }

  String get backendValue => switch (this) {
    healthy => 'healthy',
    degraded => 'degraded',
    unhealthy => 'unhealthy',
    unknown => 'unknown',
    disabled => 'disabled',
    notConfigured => 'not_configured',
  };

  String localizationKey() {
    return switch (this) {
      healthy => 'systemMonitoringStatusHealthy',
      degraded => 'systemMonitoringStatusDegraded',
      unhealthy => 'systemMonitoringStatusUnhealthy',
      unknown => 'systemMonitoringStatusUnknown',
      disabled => 'systemMonitoringStatusDisabled',
      notConfigured => 'systemMonitoringStatusNotConfigured',
    };
  }

  /// Severity rank for overall aggregation (higher = worse).
  int get severityRank => switch (this) {
    unhealthy => 5,
    degraded => 4,
    unknown => 3,
    notConfigured => 2,
    disabled => 1,
    healthy => 0,
  };

  bool get isProblem =>
      this == degraded || this == unhealthy || this == unknown;

  bool get matchesDegradedOrUnhealthyFilter =>
      this == degraded || this == unhealthy;
}

enum SystemDependencyType {
  critical,
  optional,
  colocated,
  external,
  unknown;

  static SystemDependencyType fromBackendValue(String? raw) {
    if (raw == null || raw.trim().isEmpty) return unknown;
    return switch (raw.trim().toLowerCase()) {
      'critical' => critical,
      'optional' => optional,
      'colocated' => colocated,
      'external' => external,
      _ => unknown,
    };
  }

  String localizationKey() {
    return switch (this) {
      critical => 'systemMonitoringDependencyCritical',
      optional => 'systemMonitoringDependencyOptional',
      colocated => 'systemMonitoringDependencyColocated',
      external => 'systemMonitoringDependencyExternal',
      unknown => 'systemMonitoringDependencyUnknown',
    };
  }
}

class SystemComponentStatus {
  const SystemComponentStatus({
    required this.componentKey,
    required this.displayName,
    required this.status,
    required this.message,
    this.checkedAt,
    this.responseTimeMs,
    this.technicalCode,
    this.environment,
    this.dependencyType = SystemDependencyType.unknown,
    this.lastHealthyAt,
    this.lastFailureAt,
    this.consecutiveFailures = 0,
    this.affectedCapabilities = const [],
    this.detailsSanitized = const {},
    this.evidence = const [],
    this.isConfigured = true,
    this.isCritical = false,
  });

  final String componentKey;
  final String displayName;
  final SystemComponentStatusValue status;
  final String message;
  final DateTime? checkedAt;
  final int? responseTimeMs;
  final String? technicalCode;
  final String? environment;
  final SystemDependencyType dependencyType;
  final DateTime? lastHealthyAt;
  final DateTime? lastFailureAt;
  final int consecutiveFailures;
  final List<String> affectedCapabilities;
  final Map<String, dynamic> detailsSanitized;
  final List<String> evidence;
  final bool isConfigured;
  final bool isCritical;

  String localizationKeyForComponent() =>
      'systemMonitoringComponent_$componentKey';
}
