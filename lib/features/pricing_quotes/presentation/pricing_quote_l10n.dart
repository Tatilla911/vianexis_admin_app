import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../domain/pricing_quote_adjustment_type.dart';
import '../domain/pricing_quote_review_flag.dart';
import '../domain/pricing_quote_status.dart';

String pricingQuoteStatusLabel(
  AppLocalizations l10n,
  PricingQuoteStatus status,
) {
  return switch (status) {
    PricingQuoteStatus.draft => l10n.pricingQuoteStatusDraft,
    PricingQuoteStatus.calculated => l10n.pricingQuoteStatusCalculated,
    PricingQuoteStatus.reviewRequired => l10n.pricingQuoteStatusReviewRequired,
    PricingQuoteStatus.approved => l10n.pricingQuoteStatusApproved,
    PricingQuoteStatus.sent => l10n.pricingQuoteStatusSent,
    PricingQuoteStatus.accepted => l10n.pricingQuoteStatusAccepted,
    PricingQuoteStatus.rejected => l10n.pricingQuoteStatusRejected,
    PricingQuoteStatus.expired => l10n.pricingQuoteStatusExpired,
    PricingQuoteStatus.unknown => l10n.pricingQuoteStatusUnknown,
  };
}

String pricingQuoteFlagLabel(AppLocalizations l10n, String raw) {
  final flag = PricingQuoteReviewFlag.fromBackendValue(raw);
  return switch (flag) {
    PricingQuoteReviewFlag.providerValidationPending =>
      l10n.pricingQuoteFlagProviderValidationPending,
    PricingQuoteReviewFlag.marginReviewRequired =>
      l10n.pricingQuoteFlagMarginReviewRequired,
    PricingQuoteReviewFlag.usageRateBelowDirectCostFloor =>
      l10n.pricingQuoteFlagUsageRateBelowFloor,
    PricingQuoteReviewFlag.enterpriseVolumeReview =>
      l10n.pricingQuoteFlagEnterpriseVolumeReview,
    PricingQuoteReviewFlag.ownerReviewEnterprisePositioning =>
      l10n.pricingQuoteFlagOwnerReviewEnterprise,
    PricingQuoteReviewFlag.manualDiscountApprovalRequired =>
      l10n.pricingQuoteFlagManualDiscountApproval,
    PricingQuoteReviewFlag.automaticDiscountCapExceeded =>
      l10n.pricingQuoteFlagAutomaticDiscountCap,
    PricingQuoteReviewFlag.integrationDiscoveryRequired =>
      l10n.pricingQuoteFlagIntegrationDiscovery,
    PricingQuoteReviewFlag.customRequirements =>
      l10n.pricingQuoteFlagCustomRequirements,
    null => raw,
  };
}

String pricingQuoteAdjustmentTypeLabel(
  AppLocalizations l10n,
  PricingQuoteAdjustmentType type,
) {
  return switch (type) {
    PricingQuoteAdjustmentType.discount => l10n.pricingQuoteAdjustmentDiscount,
    PricingQuoteAdjustmentType.surcharge =>
      l10n.pricingQuoteAdjustmentSurcharge,
    PricingQuoteAdjustmentType.pilotCredit =>
      l10n.pricingQuoteAdjustmentPilotCredit,
    PricingQuoteAdjustmentType.negotiatedEnterprise =>
      l10n.pricingQuoteAdjustmentNegotiatedEnterprise,
    PricingQuoteAdjustmentType.other => l10n.pricingQuoteAdjustmentOther,
  };
}

String pricingQuoteConfidenceLabel(AppLocalizations l10n, String? raw) {
  switch (raw?.toUpperCase()) {
    case 'HIGH':
      return l10n.pricingQuoteConfidenceHigh;
    case 'MEDIUM':
      return l10n.pricingQuoteConfidenceMedium;
    case 'LOW':
      return l10n.pricingQuoteConfidenceLow;
    case null:
    case '':
      return l10n.pricingQuoteValueUnavailable;
    default:
      return raw!;
  }
}

String formatPricingQuoteMoney(BuildContext context, String? raw) {
  if (raw == null || raw.trim().isEmpty) {
    return AppLocalizations.of(context).pricingQuoteValueUnavailable;
  }
  final value = double.tryParse(raw);
  if (value == null) return raw;
  return '€${value.toStringAsFixed(2)}';
}

String formatPricingQuoteNumber(Object? raw) {
  if (raw == null) return '—';
  if (raw is num) {
    return raw == raw.roundToDouble()
        ? raw.toInt().toString()
        : raw.toString();
  }
  return raw.toString();
}
