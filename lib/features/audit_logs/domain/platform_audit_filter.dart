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
}
