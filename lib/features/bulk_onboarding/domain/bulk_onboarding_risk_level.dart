enum BulkOnboardingRiskLevel {
  low('low'),
  medium('medium'),
  high('high'),
  unknown('unknown');

  const BulkOnboardingRiskLevel(this.backendValue);

  final String backendValue;

  static BulkOnboardingRiskLevel fromBackendValue(String? raw) {
    if (raw == null || raw.trim().isEmpty) return unknown;
    for (final level in BulkOnboardingRiskLevel.values) {
      if (level.backendValue == raw) return level;
    }
    return unknown;
  }

  String localizationKey() {
    return switch (this) {
      low => 'bulkOnboardingRiskLow',
      medium => 'bulkOnboardingRiskMedium',
      high => 'bulkOnboardingRiskHigh',
      unknown => 'bulkOnboardingRiskUnknown',
    };
  }
}
