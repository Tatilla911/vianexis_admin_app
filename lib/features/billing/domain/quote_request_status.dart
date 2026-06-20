enum QuoteRequestStatus {
  draft('draft'),
  submitted('submitted'),
  underReview('under_review'),
  quoted('quoted'),
  accepted('accepted'),
  rejected('rejected'),
  unknown('unknown');

  const QuoteRequestStatus(this.backendValue);

  final String backendValue;

  static QuoteRequestStatus fromBackendValue(String? raw) {
    if (raw == null || raw.trim().isEmpty) return unknown;
    for (final status in QuoteRequestStatus.values) {
      if (status.backendValue == raw) return status;
    }
    return unknown;
  }

  String localizationKey() {
    return switch (this) {
      draft => 'billingQuoteRequestStatusDraft',
      submitted => 'billingQuoteRequestStatusSubmitted',
      underReview => 'billingQuoteRequestStatusUnderReview',
      quoted => 'billingQuoteRequestStatusQuoted',
      accepted => 'billingQuoteRequestStatusAccepted',
      rejected => 'billingQuoteRequestStatusRejected',
      unknown => 'billingQuoteRequestStatusUnknown',
    };
  }

  bool get requiresReason => this == rejected;
}

enum QuoteRequestListFilter {
  all,
  submitted,
  underReview,
  quoted,
  accepted,
  rejected,
}
