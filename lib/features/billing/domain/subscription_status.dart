enum SubscriptionStatus {
  trial('trial'),
  active('active'),
  pastDue('past_due'),
  suspended('suspended'),
  cancelled('cancelled'),
  customQuotePending('custom_quote_pending'),
  unknown('unknown');

  const SubscriptionStatus(this.backendValue);

  final String backendValue;

  static SubscriptionStatus fromBackendValue(String? raw) {
    if (raw == null || raw.trim().isEmpty) return unknown;
    for (final status in SubscriptionStatus.values) {
      if (status.backendValue == raw) return status;
    }
    return unknown;
  }

  String localizationKey() {
    return switch (this) {
      trial => 'billingSubscriptionStatusTrial',
      active => 'billingSubscriptionStatusActive',
      pastDue => 'billingSubscriptionStatusPastDue',
      suspended => 'billingSubscriptionStatusSuspended',
      cancelled => 'billingSubscriptionStatusCancelled',
      customQuotePending => 'billingSubscriptionStatusCustomQuotePending',
      unknown => 'billingSubscriptionStatusUnknown',
    };
  }

  bool get requiresReason =>
      this == pastDue || this == suspended || this == cancelled;
}

enum SubscriptionListFilter {
  all,
  active,
  trial,
  pastDue,
  suspended,
  cancelled,
}
