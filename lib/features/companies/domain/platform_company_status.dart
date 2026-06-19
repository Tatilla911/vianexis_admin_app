enum PlatformCompanyStatus {
  active('active'),
  pendingReview('pending_review'),
  suspended('suspended'),
  disabled('disabled'),
  archived('archived'),
  inactive('inactive'),
  unknown('unknown');

  const PlatformCompanyStatus(this.backendValue);

  final String backendValue;

  static PlatformCompanyStatus fromBackendValue(String? raw) {
    if (raw == null || raw.trim().isEmpty) return unknown;
    for (final status in PlatformCompanyStatus.values) {
      if (status.backendValue == raw) return status;
    }
    return unknown;
  }

  String localizationKey() {
    return switch (this) {
      active => 'platformCompanyStatusActive',
      pendingReview => 'platformCompanyStatusPendingReview',
      suspended => 'platformCompanyStatusSuspended',
      disabled => 'platformCompanyStatusDisabled',
      archived => 'platformCompanyStatusArchived',
      inactive => 'platformCompanyStatusDisabled',
      unknown => 'platformCompanyStatusUnknown',
    };
  }

  bool get isRestrictive =>
      this == suspended || this == disabled || this == archived;
}
