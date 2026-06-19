enum PlatformAuditResult {
  success,
  failure,
  denied,
  partial,
  unknown;

  static PlatformAuditResult fromBackendValue(String? raw) {
    if (raw == null || raw.trim().isEmpty) return unknown;
    return switch (raw.trim().toLowerCase()) {
      'success' => success,
      'failure' || 'failed' || 'error' => failure,
      'denied' => denied,
      'partial' => partial,
      _ => unknown,
    };
  }

  String localizationKey() {
    return switch (this) {
      PlatformAuditResult.success => 'auditLogResultSuccess',
      PlatformAuditResult.failure => 'auditLogResultFailure',
      PlatformAuditResult.denied => 'auditLogResultDenied',
      PlatformAuditResult.partial => 'auditLogResultPartial',
      PlatformAuditResult.unknown => 'auditLogResultUnknown',
    };
  }
}
