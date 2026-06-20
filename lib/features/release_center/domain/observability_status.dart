class ObservabilityStatus {
  const ObservabilityStatus({
    required this.logLevel,
    required this.metricsEnabled,
    required this.sentryConfigured,
    required this.otelConfigured,
    required this.correlationIdEnabled,
    this.lastCriticalErrorAt,
    this.metadataOnly = true,
  });

  final String logLevel;
  final bool metricsEnabled;
  final bool sentryConfigured;
  final bool otelConfigured;
  final bool correlationIdEnabled;
  final DateTime? lastCriticalErrorAt;
  final bool metadataOnly;

  factory ObservabilityStatus.fromJson(Map<String, dynamic> json) {
    return ObservabilityStatus(
      logLevel: json['logLevel']?.toString() ?? 'info',
      metricsEnabled: json['metricsEnabled'] == true,
      sentryConfigured: json['sentryConfigured'] == true,
      otelConfigured: json['otelConfigured'] == true,
      correlationIdEnabled: json['correlationIdEnabled'] != false,
      lastCriticalErrorAt: _parseDate(json['lastCriticalErrorAt']),
      metadataOnly: json['metadataOnly'] != false,
    );
  }

  /// Values rendered in the release center observability card.
  List<String> get safeDisplayValues => [
        logLevel,
        metricsEnabled ? 'yes' : 'no',
        sentryConfigured ? 'yes' : 'no',
        otelConfigured ? 'yes' : 'no',
        correlationIdEnabled ? 'yes' : 'no',
      ];
}

DateTime? _parseDate(Object? raw) {
  if (raw == null) return null;
  return DateTime.tryParse(raw.toString());
}
