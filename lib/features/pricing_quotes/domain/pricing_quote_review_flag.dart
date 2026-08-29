enum PricingQuoteReviewFlag {
  providerValidationPending('PROVIDER_VALIDATION_PENDING'),
  marginReviewRequired('MARGIN_REVIEW_REQUIRED'),
  usageRateBelowDirectCostFloor('USAGE_RATE_BELOW_DIRECT_COST_FLOOR'),
  enterpriseVolumeReview('ENTERPRISE_VOLUME_REVIEW'),
  ownerReviewEnterprisePositioning('OWNER_REVIEW_ENTERPRISE_POSITIONING'),
  manualDiscountApprovalRequired('MANUAL_DISCOUNT_APPROVAL_REQUIRED'),
  automaticDiscountCapExceeded('AUTOMATIC_DISCOUNT_CAP_EXCEEDED'),
  integrationDiscoveryRequired('INTEGRATION_DISCOVERY_REQUIRED'),
  customRequirements('CUSTOM_REQUIREMENTS');

  const PricingQuoteReviewFlag(this.backendValue);

  final String backendValue;

  static PricingQuoteReviewFlag? fromBackendValue(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    for (final flag in PricingQuoteReviewFlag.values) {
      if (flag.backendValue == raw) return flag;
    }
    return null;
  }

  bool get isImportant =>
      this == providerValidationPending ||
      this == marginReviewRequired ||
      this == usageRateBelowDirectCostFloor ||
      this == manualDiscountApprovalRequired ||
      this == automaticDiscountCapExceeded;

  static const approvalBlockers = {
    'PROVIDER_VALIDATION_PENDING',
    'USAGE_RATE_BELOW_DIRECT_COST_FLOOR',
    'MARGIN_REVIEW_REQUIRED',
    'MANUAL_DISCOUNT_APPROVAL_REQUIRED',
    'AUTOMATIC_DISCOUNT_CAP_EXCEEDED',
  };

  static bool canApproveWithFlags(Iterable<String> flags) {
    return !flags.any(approvalBlockers.contains);
  }
}
