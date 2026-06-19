enum RegistrationApplicationStatus {
  pending('pending'),
  needsMoreInfo('needs_more_info'),
  approved('approved'),
  rejected('rejected'),
  cancelled('cancelled'),
  unknown('unknown');

  const RegistrationApplicationStatus(this.backendValue);

  final String backendValue;

  static RegistrationApplicationStatus fromBackendValue(String? raw) {
    if (raw == null || raw.trim().isEmpty) return unknown;
    for (final status in RegistrationApplicationStatus.values) {
      if (status.backendValue == raw) return status;
    }
    return unknown;
  }

  bool get isPending => this == pending;

  bool get isNeedsInfo => this == needsMoreInfo;

  bool get isApproved => this == approved;

  bool get isRejected => this == rejected;

  bool get isTerminal => isApproved || isRejected || this == cancelled;

  String localizationKey() {
    return switch (this) {
      RegistrationApplicationStatus.pending => 'registrationStatusPending',
      RegistrationApplicationStatus.needsMoreInfo => 'registrationStatusNeedsInfo',
      RegistrationApplicationStatus.approved => 'registrationStatusApproved',
      RegistrationApplicationStatus.rejected => 'registrationStatusRejected',
      RegistrationApplicationStatus.cancelled => 'registrationStatusCancelled',
      RegistrationApplicationStatus.unknown => 'registrationStatusUnknown',
    };
  }
}

/// Client-side list filters (some combine status + derived fields).
enum RegistrationListFilter {
  all,
  pending,
  needsInfo,
  aiReviewed,
  approved,
  rejected,
  highRisk,
}

extension RegistrationListFilterX on RegistrationListFilter {
  String localizationKey() {
    return switch (this) {
      RegistrationListFilter.all => 'registrationFilterAll',
      RegistrationListFilter.pending => 'registrationFilterPending',
      RegistrationListFilter.needsInfo => 'registrationFilterNeedsInfo',
      RegistrationListFilter.aiReviewed => 'registrationFilterAiReviewed',
      RegistrationListFilter.approved => 'registrationFilterApproved',
      RegistrationListFilter.rejected => 'registrationFilterRejected',
      RegistrationListFilter.highRisk => 'registrationFilterHighRisk',
    };
  }
}
