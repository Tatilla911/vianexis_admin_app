enum PricingQuoteAdjustmentType {
  discount('DISCOUNT'),
  surcharge('SURCHARGE'),
  pilotCredit('PILOT_CREDIT'),
  negotiatedEnterprise('NEGOTIATED_ENTERPRISE'),
  other('OTHER');

  const PricingQuoteAdjustmentType(this.backendValue);

  final String backendValue;

  static PricingQuoteAdjustmentType fromBackendValue(String? raw) {
    if (raw == null || raw.trim().isEmpty) return other;
    for (final type in PricingQuoteAdjustmentType.values) {
      if (type.backendValue == raw) return type;
    }
    return other;
  }
}
