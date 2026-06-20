enum SecurityEventSeverity {
  info('info'),
  warning('warning'),
  critical('critical'),
  unknown('unknown');

  const SecurityEventSeverity(this.backendValue);

  final String backendValue;

  static SecurityEventSeverity fromBackendValue(String? raw) {
    if (raw == null || raw.trim().isEmpty) return unknown;
    for (final severity in SecurityEventSeverity.values) {
      if (severity.backendValue == raw) return severity;
    }
    return unknown;
  }

  String localizationKey() {
    return switch (this) {
      info => 'securityEventSeverityInfo',
      warning => 'securityEventSeverityWarning',
      critical => 'securityEventSeverityCritical',
      unknown => 'securityEventSeverityUnknown',
    };
  }
}
