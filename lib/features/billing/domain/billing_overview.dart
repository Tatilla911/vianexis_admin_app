class BillingOverview {
  const BillingOverview({
    required this.activeSubscriptions,
    required this.trialSubscriptions,
    required this.pastDueSubscriptions,
    required this.suspendedSubscriptions,
    required this.pricingIntakesNew,
    required this.quoteRequestsPending,
    this.lastUpdatedAt,
    this.metadataOnly = true,
  });

  final int activeSubscriptions;
  final int trialSubscriptions;
  final int pastDueSubscriptions;
  final int suspendedSubscriptions;
  final int pricingIntakesNew;
  final int quoteRequestsPending;
  final DateTime? lastUpdatedAt;
  final bool metadataOnly;

  int get attentionCount =>
      pastDueSubscriptions + suspendedSubscriptions + pricingIntakesNew + quoteRequestsPending;

  factory BillingOverview.fromJson(Map<String, dynamic> json) {
    return BillingOverview(
      activeSubscriptions: _parseInt(json['activeSubscriptions']),
      trialSubscriptions: _parseInt(json['trialSubscriptions']),
      pastDueSubscriptions: _parseInt(json['pastDueSubscriptions']),
      suspendedSubscriptions: _parseInt(json['suspendedSubscriptions']),
      pricingIntakesNew: _parseInt(json['pricingIntakesNew']),
      quoteRequestsPending: _parseInt(json['quoteRequestsPending']),
      lastUpdatedAt: _parseDate(json['lastUpdatedAt']),
      metadataOnly: json['metadataOnly'] != false,
    );
  }
}

DateTime? _parseDate(Object? raw) {
  if (raw == null) return null;
  return DateTime.tryParse(raw.toString());
}

int _parseInt(Object? raw) {
  if (raw is int) return raw;
  return int.tryParse(raw?.toString() ?? '') ?? 0;
}
