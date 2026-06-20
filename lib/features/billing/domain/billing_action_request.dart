import 'pricing_intake_status.dart';
import 'quote_request_status.dart';
import 'subscription_status.dart';

class BillingSubscriptionStatusRequest {
  const BillingSubscriptionStatusRequest({
    required this.status,
    this.reason,
    this.note,
  });

  final SubscriptionStatus status;
  final String? reason;
  final String? note;

  Map<String, dynamic> toJson() {
    return {
      'status': status.backendValue,
      if (reason != null && reason!.trim().isNotEmpty) 'reason': reason!.trim(),
      if (note != null && note!.trim().isNotEmpty) 'note': note!.trim(),
    };
  }

  String? validate() {
    if (status.requiresReason && (reason == null || reason!.trim().length < 3)) {
      return 'billingActionReasonRequired';
    }
    return null;
  }
}

class BillingPricingIntakeStatusRequest {
  const BillingPricingIntakeStatusRequest({
    required this.status,
    this.reason,
  });

  final PricingIntakeStatus status;
  final String? reason;

  Map<String, dynamic> toJson() {
    return {
      'status': status.backendPatchValue(),
      if (reason != null && reason!.trim().isNotEmpty) 'reason': reason!.trim(),
    };
  }

  String? validate() {
    if (status.requiresReason && (reason == null || reason!.trim().length < 3)) {
      return 'billingActionReasonRequired';
    }
    return null;
  }
}

class BillingQuoteRequestStatusRequest {
  const BillingQuoteRequestStatusRequest({
    required this.status,
    this.reason,
  });

  final QuoteRequestStatus status;
  final String? reason;

  Map<String, dynamic> toJson() {
    return {
      'status': status.backendValue,
      if (reason != null && reason!.trim().isNotEmpty) 'reason': reason!.trim(),
    };
  }

  String? validate() {
    if (status.requiresReason && (reason == null || reason!.trim().length < 3)) {
      return 'billingActionReasonRequired';
    }
    return null;
  }
}
