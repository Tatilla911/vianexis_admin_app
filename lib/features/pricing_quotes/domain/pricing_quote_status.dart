enum PricingQuoteStatus {
  draft('DRAFT'),
  calculated('CALCULATED'),
  reviewRequired('REVIEW_REQUIRED'),
  approved('APPROVED'),
  sent('SENT'),
  accepted('ACCEPTED'),
  rejected('REJECTED'),
  expired('EXPIRED'),
  unknown('UNKNOWN');

  const PricingQuoteStatus(this.backendValue);

  final String backendValue;

  static PricingQuoteStatus fromBackendValue(String? raw) {
    if (raw == null || raw.trim().isEmpty) return unknown;
    for (final status in PricingQuoteStatus.values) {
      if (status.backendValue == raw) return status;
    }
    return unknown;
  }

  bool get isTerminal =>
      this == accepted || this == rejected || this == expired;

  /// User-triggered status transitions via POST /status.
  /// CALCULATION / APPROVED are produced by dedicated endpoints.
  List<PricingQuoteStatus> get allowedManualTransitions {
    return switch (this) {
      approved => const [sent],
      sent => const [accepted, rejected, expired],
      _ => const [],
    };
  }
}
