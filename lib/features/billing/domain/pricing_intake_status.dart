enum PricingIntakeStatus {
  newIntake('new'),
  reviewing('reviewing'),
  quoted('quoted'),
  accepted('accepted'),
  rejected('rejected'),
  unknown('unknown');

  const PricingIntakeStatus(this.adminValue);

  final String adminValue;

  static PricingIntakeStatus fromBackendValue(String? raw) {
    if (raw == null || raw.trim().isEmpty) return unknown;
    final normalized = raw.trim().toLowerCase();
    return switch (normalized) {
      'new' || 'draft' || 'submitted' => newIntake,
      'reviewing' || 'ai_reviewed' => reviewing,
      'quoted' || 'admin_approved' => quoted,
      'accepted' || 'applied' => accepted,
      'rejected' || 'closed' => rejected,
      _ => unknown,
    };
  }

  String backendPatchValue() => adminValue;

  String localizationKey() {
    return switch (this) {
      newIntake => 'billingPricingIntakeStatusNew',
      reviewing => 'billingPricingIntakeStatusReviewing',
      quoted => 'billingPricingIntakeStatusQuoted',
      accepted => 'billingPricingIntakeStatusAccepted',
      rejected => 'billingPricingIntakeStatusRejected',
      unknown => 'billingPricingIntakeStatusUnknown',
    };
  }

  bool get requiresReason => this == rejected;
}

enum PricingIntakeListFilter {
  all,
  newIntake,
  reviewing,
  quoted,
  accepted,
  rejected,
}
