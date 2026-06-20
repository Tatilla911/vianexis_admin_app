import 'subscription_status.dart';

class PlatformSubscription {
  const PlatformSubscription({
    required this.id,
    required this.companyId,
    this.companyName,
    required this.status,
    this.planName,
    this.planTier,
    this.billingCycle,
    this.currency,
    this.seatsIncluded,
    this.seatsUsed,
    this.driverAppsIncluded,
    this.driverAppsUsed,
    this.aiAddOnEnabled,
    this.startedAt,
    this.renewsAt,
    this.cancelledAt,
    this.lastPaymentStatus,
    this.pricingSource,
    this.operatingModel,
    this.metadataOnly = true,
  });

  final String id;
  final String companyId;
  final String? companyName;
  final SubscriptionStatus status;
  final String? planName;
  final String? planTier;
  final String? billingCycle;
  final String? currency;
  final int? seatsIncluded;
  final int? seatsUsed;
  final int? driverAppsIncluded;
  final int? driverAppsUsed;
  final bool? aiAddOnEnabled;
  final DateTime? startedAt;
  final DateTime? renewsAt;
  final DateTime? cancelledAt;
  final String? lastPaymentStatus;
  final String? pricingSource;
  final String? operatingModel;
  final bool metadataOnly;

  factory PlatformSubscription.fromJson(Map<String, dynamic> json) {
    final plan = json['plan'];
    final planName = json['planName']?.toString() ??
        (plan is Map ? plan['name']?.toString() : null);
    final planTier =
        plan is Map ? plan['tier']?.toString() : json['planTier']?.toString();

    return PlatformSubscription(
      id: (json['id'] ?? json['subscriptionId'])?.toString() ?? '',
      companyId: (json['companyId'])?.toString() ?? '',
      companyName: json['companyName']?.toString(),
      status: SubscriptionStatus.fromBackendValue(json['status']?.toString()),
      planName: planName,
      planTier: planTier,
      billingCycle: (json['billingCycle'] ?? json['billingMode'])?.toString(),
      currency: json['currency']?.toString(),
      seatsIncluded: _parseNullableInt(json['seatsIncluded']),
      seatsUsed: _parseNullableInt(json['seatsUsed']),
      driverAppsIncluded: _parseNullableInt(json['driverAppsIncluded']),
      driverAppsUsed: _parseNullableInt(json['driverAppsUsed']),
      aiAddOnEnabled: json['aiAddOnEnabled'] is bool ? json['aiAddOnEnabled'] as bool : null,
      startedAt: _parseDate(json['startedAt'] ?? json['startsAt']),
      renewsAt: _parseDate(json['renewsAt']),
      cancelledAt: _parseDate(json['cancelledAt'] ?? json['endsAt']),
      lastPaymentStatus: json['lastPaymentStatus']?.toString(),
      pricingSource: json['pricingSource']?.toString(),
      operatingModel: json['operatingModel']?.toString(),
      metadataOnly: json['metadataOnly'] != false,
    );
  }

  bool matchesSearch(String query) {
    final term = query.trim().toLowerCase();
    if (term.isEmpty) return true;
    final haystack = [
      companyName,
      planName,
      companyId,
      id,
    ].whereType<String>().join(' ').toLowerCase();
    return haystack.contains(term);
  }

  bool matchesFilter(SubscriptionListFilter filter) {
    return switch (filter) {
      SubscriptionListFilter.all => true,
      SubscriptionListFilter.active => status == SubscriptionStatus.active,
      SubscriptionListFilter.trial => status == SubscriptionStatus.trial,
      SubscriptionListFilter.pastDue => status == SubscriptionStatus.pastDue,
      SubscriptionListFilter.suspended => status == SubscriptionStatus.suspended,
      SubscriptionListFilter.cancelled => status == SubscriptionStatus.cancelled,
    };
  }
}

class PlatformSubscriptionsPage {
  const PlatformSubscriptionsPage({
    required this.items,
    required this.total,
    this.metadataOnly = true,
  });

  final List<PlatformSubscription> items;
  final int total;
  final bool metadataOnly;

  factory PlatformSubscriptionsPage.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    final items = rawItems is List
        ? rawItems
            .whereType<Map<String, dynamic>>()
            .map(PlatformSubscription.fromJson)
            .toList(growable: false)
        : const <PlatformSubscription>[];
    return PlatformSubscriptionsPage(
      items: items,
      total: _parseInt(json['total']),
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

int? _parseNullableInt(Object? raw) {
  if (raw == null) return null;
  if (raw is int) return raw;
  return int.tryParse(raw.toString());
}
