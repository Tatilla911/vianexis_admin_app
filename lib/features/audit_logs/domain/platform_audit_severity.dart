enum PlatformAuditSeverity {
  info,
  warning,
  critical,
  unknown;

  static PlatformAuditSeverity fromBackendValue(String? raw) {
    if (raw == null || raw.trim().isEmpty) return unknown;
    return switch (raw.trim().toLowerCase()) {
      'info' || 'ok' => info,
      'warning' => warning,
      'critical' || 'error' => critical,
      _ => unknown,
    };
  }

  String localizationKey() {
    return switch (this) {
      PlatformAuditSeverity.info => 'auditLogSeverityInfo',
      PlatformAuditSeverity.warning => 'auditLogSeverityWarning',
      PlatformAuditSeverity.critical => 'auditLogSeverityCritical',
      PlatformAuditSeverity.unknown => 'auditLogSeverityUnknown',
    };
  }
}
