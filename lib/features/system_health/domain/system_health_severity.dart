enum SystemHealthSeverity {
  info,
  warning,
  critical,
  unknown;

  static SystemHealthSeverity fromBackendValue(String? raw) {
    if (raw == null || raw.trim().isEmpty) return unknown;
    return switch (raw.trim().toLowerCase()) {
      'ok' || 'info' => info,
      'warning' => warning,
      'error' || 'critical' => critical,
      _ => unknown,
    };
  }

  String localizationKey() {
    return switch (this) {
      SystemHealthSeverity.info => 'systemHealthSeverityInfo',
      SystemHealthSeverity.warning => 'systemHealthSeverityWarning',
      SystemHealthSeverity.critical => 'systemHealthSeverityCritical',
      SystemHealthSeverity.unknown => 'systemHealthSeverityUnknown',
    };
  }
}

enum SystemHealthOverallStatus {
  healthy,
  degraded,
  critical,
  unknown;

  static SystemHealthOverallStatus fromSeverityCounts({
    required int critical,
    required int warning,
  }) {
    if (critical > 0) return SystemHealthOverallStatus.critical;
    if (warning > 0) return SystemHealthOverallStatus.degraded;
    return SystemHealthOverallStatus.healthy;
  }

  String localizationKey() {
    return switch (this) {
      SystemHealthOverallStatus.healthy => 'systemHealthOverallHealthy',
      SystemHealthOverallStatus.degraded => 'systemHealthOverallDegraded',
      SystemHealthOverallStatus.critical => 'systemHealthOverallCritical',
      SystemHealthOverallStatus.unknown => 'systemHealthOverallUnknown',
    };
  }
}
