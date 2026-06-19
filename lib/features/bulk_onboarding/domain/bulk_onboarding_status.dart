enum BulkOnboardingJobStatus {
  draft('draft'),
  uploaded('uploaded'),
  validating('validating'),
  validationFailed('validation_failed'),
  readyForReview('ready_for_review'),
  approvedForProcessing('approved_for_processing'),
  processing('processing'),
  partiallyCompleted('partially_completed'),
  completed('completed'),
  rejected('rejected'),
  cancelled('cancelled'),
  unknown('unknown');

  const BulkOnboardingJobStatus(this.backendValue);

  final String backendValue;

  static BulkOnboardingJobStatus fromBackendValue(String? raw) {
    if (raw == null || raw.trim().isEmpty) return unknown;
    for (final status in BulkOnboardingJobStatus.values) {
      if (status.backendValue == raw) return status;
    }
    return unknown;
  }

  String localizationKey() {
    return switch (this) {
      draft => 'bulkOnboardingStatusDraft',
      uploaded => 'bulkOnboardingStatusUploaded',
      validating => 'bulkOnboardingStatusValidating',
      validationFailed => 'bulkOnboardingStatusValidationFailed',
      readyForReview => 'bulkOnboardingStatusReadyForReview',
      approvedForProcessing => 'bulkOnboardingStatusApprovedForProcessing',
      processing => 'bulkOnboardingStatusProcessing',
      partiallyCompleted => 'bulkOnboardingStatusPartiallyCompleted',
      completed => 'bulkOnboardingStatusCompleted',
      rejected => 'bulkOnboardingStatusRejected',
      cancelled => 'bulkOnboardingStatusCancelled',
      unknown => 'bulkOnboardingStatusUnknown',
    };
  }

  bool get isTerminal {
    return this == completed ||
        this == partiallyCompleted ||
        this == rejected ||
        this == cancelled;
  }
}
