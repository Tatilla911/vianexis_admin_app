enum AiReviewRiskLevel {
  low('low'),
  medium('medium'),
  high('high'),
  unknown('unknown');

  const AiReviewRiskLevel(this.backendValue);

  final String backendValue;

  static AiReviewRiskLevel fromBackendValue(String? raw) {
    if (raw == null || raw.trim().isEmpty) return AiReviewRiskLevel.unknown;
    return AiReviewRiskLevel.values.firstWhere(
      (value) => value.backendValue == raw.trim(),
      orElse: () => AiReviewRiskLevel.unknown,
    );
  }

  String localizationKey() => switch (this) {
    AiReviewRiskLevel.low => 'aiReviewRiskLow',
    AiReviewRiskLevel.medium => 'aiReviewRiskMedium',
    AiReviewRiskLevel.high => 'aiReviewRiskHigh',
    AiReviewRiskLevel.unknown => 'aiReviewRiskUnknown',
  };
}
