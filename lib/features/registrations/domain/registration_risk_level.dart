enum RegistrationRiskLevel {
  low,
  medium,
  high,
  unknown;

  static RegistrationRiskLevel fromRiskScore(double? score) {
    if (score == null) return unknown;
    if (score >= 0.7) return high;
    if (score >= 0.4) return medium;
    return low;
  }

  static RegistrationRiskLevel fromBackendFlags(Map<String, dynamic>? flags) {
    if (flags == null || flags.isEmpty) return unknown;
    final level = flags['level']?.toString().toLowerCase();
    return switch (level) {
      'high' => high,
      'medium' => medium,
      'low' => low,
      _ => unknown,
    };
  }

  String localizationKey() {
    return switch (this) {
      RegistrationRiskLevel.low => 'registrationRiskLow',
      RegistrationRiskLevel.medium => 'registrationRiskMedium',
      RegistrationRiskLevel.high => 'registrationRiskHigh',
      RegistrationRiskLevel.unknown => 'registrationRiskUnknown',
    };
  }
}
