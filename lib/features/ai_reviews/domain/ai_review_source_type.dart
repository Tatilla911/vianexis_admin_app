enum AiReviewSourceType {
  registrationApplication('registration_application'),
  bulkOnboardingJob('bulk_onboarding_job'),
  systemHealthEvent('system_health'),
  supportTicket('support_ticket'),
  unknown('unknown');

  const AiReviewSourceType(this.backendValue);

  final String backendValue;

  static AiReviewSourceType fromBackendValue(String? raw) {
    if (raw == null || raw.trim().isEmpty) return AiReviewSourceType.unknown;
    return AiReviewSourceType.values.firstWhere(
      (value) => value.backendValue == raw.trim(),
      orElse: () => AiReviewSourceType.unknown,
    );
  }

  String localizationKey() => switch (this) {
    AiReviewSourceType.registrationApplication => 'aiReviewSourceRegistration',
    AiReviewSourceType.bulkOnboardingJob => 'aiReviewSourceBulkOnboarding',
    AiReviewSourceType.systemHealthEvent => 'aiReviewSourceSystemHealth',
    AiReviewSourceType.supportTicket => 'aiReviewSourceSupportTicket',
    AiReviewSourceType.unknown => 'aiReviewSourceUnknown',
  };
}
