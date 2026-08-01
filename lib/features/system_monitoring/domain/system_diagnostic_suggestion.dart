enum SystemDiagnosticConfidence {
  low,
  medium,
  high,
  unknown;

  static SystemDiagnosticConfidence fromBackendValue(String? raw) {
    if (raw == null || raw.trim().isEmpty) return unknown;
    return switch (raw.trim().toLowerCase()) {
      'low' => low,
      'medium' => medium,
      'high' => high,
      _ => unknown,
    };
  }

  String localizationKey() {
    return switch (this) {
      low => 'systemMonitoringDiagnosticConfidenceLow',
      medium => 'systemMonitoringDiagnosticConfidenceMedium',
      high => 'systemMonitoringDiagnosticConfidenceHigh',
      unknown => 'systemMonitoringDiagnosticConfidenceUnknown',
    };
  }
}

enum SystemDiagnosticUrgency {
  low,
  medium,
  high,
  critical,
  unknown;

  static SystemDiagnosticUrgency fromBackendValue(String? raw) {
    if (raw == null || raw.trim().isEmpty) return unknown;
    return switch (raw.trim().toLowerCase()) {
      'low' => low,
      'medium' => medium,
      'high' => high,
      'critical' => critical,
      _ => unknown,
    };
  }

  String localizationKey() {
    return switch (this) {
      low => 'systemMonitoringDiagnosticUrgencyLow',
      medium => 'systemMonitoringDiagnosticUrgencyMedium',
      high => 'systemMonitoringDiagnosticUrgencyHigh',
      critical => 'systemMonitoringDiagnosticUrgencyCritical',
      unknown => 'systemMonitoringDiagnosticUrgencyUnknown',
    };
  }
}

class SystemDiagnosticSuggestion {
  const SystemDiagnosticSuggestion({
    required this.summary,
    this.possibleCauses = const [],
    this.confidence = SystemDiagnosticConfidence.unknown,
    this.affectedCapabilities = const [],
    this.recommendedChecks = const [],
    this.urgency = SystemDiagnosticUrgency.unknown,
    this.missingEvidence = const [],
    this.aiGenerated = false,
    this.disclaimerKey = 'systemMonitoringAiDisclaimer',
  });

  final String summary;
  final List<String> possibleCauses;
  final SystemDiagnosticConfidence confidence;
  final List<String> affectedCapabilities;
  final List<String> recommendedChecks;
  final SystemDiagnosticUrgency urgency;
  final List<String> missingEvidence;
  final bool aiGenerated;
  final String disclaimerKey;
}
