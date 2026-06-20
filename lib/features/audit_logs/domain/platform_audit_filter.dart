enum PlatformAuditLogFilter {
  all,
  critical,
  warning,
  failures,
  denied,
  registration,
  supportAccess,
  systemHealth,
  security,
}

extension PlatformAuditLogFilterX on PlatformAuditLogFilter {
  String localizationKey() {
    return switch (this) {
      PlatformAuditLogFilter.all => 'auditLogFilterAll',
      PlatformAuditLogFilter.critical => 'auditLogFilterCritical',
      PlatformAuditLogFilter.warning => 'auditLogFilterWarning',
      PlatformAuditLogFilter.failures => 'auditLogFilterFailures',
      PlatformAuditLogFilter.denied => 'auditLogFilterDenied',
      PlatformAuditLogFilter.registration => 'auditLogFilterRegistration',
      PlatformAuditLogFilter.supportAccess => 'auditLogFilterSupportAccess',
      PlatformAuditLogFilter.systemHealth => 'auditLogFilterSystemHealth',
      PlatformAuditLogFilter.security => 'auditLogFilterSecurity',
    };
  }

  Map<String, String> apiQueryParams() {
    return switch (this) {
      PlatformAuditLogFilter.critical => const {'severity': 'critical'},
      PlatformAuditLogFilter.warning => const {'severity': 'warning'},
      PlatformAuditLogFilter.failures => const {'result': 'failure'},
      PlatformAuditLogFilter.denied => const {'result': 'denied'},
      _ => const {},
    };
  }
}
