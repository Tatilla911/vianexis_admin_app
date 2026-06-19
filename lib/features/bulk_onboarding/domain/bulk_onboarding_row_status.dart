enum BulkOnboardingRowStatus {
  pending('pending'),
  valid('valid'),
  warning('warning'),
  invalid('invalid'),
  duplicate('duplicate'),
  approved('approved'),
  skipped('skipped'),
  processed('processed'),
  failed('failed'),
  unknown('unknown');

  const BulkOnboardingRowStatus(this.backendValue);

  final String backendValue;

  static BulkOnboardingRowStatus fromBackendValue(String? raw) {
    if (raw == null || raw.trim().isEmpty) return unknown;
    for (final status in BulkOnboardingRowStatus.values) {
      if (status.backendValue == raw) return status;
    }
    return unknown;
  }

  String localizationKey() {
    return switch (this) {
      pending => 'bulkOnboardingRowStatusPending',
      valid => 'bulkOnboardingRowStatusValid',
      warning => 'bulkOnboardingRowStatusWarning',
      invalid => 'bulkOnboardingRowStatusInvalid',
      duplicate => 'bulkOnboardingRowStatusDuplicate',
      approved => 'bulkOnboardingRowStatusApproved',
      skipped => 'bulkOnboardingRowStatusSkipped',
      processed => 'bulkOnboardingRowStatusProcessed',
      failed => 'bulkOnboardingRowStatusFailed',
      unknown => 'bulkOnboardingRowStatusUnknown',
    };
  }
}
