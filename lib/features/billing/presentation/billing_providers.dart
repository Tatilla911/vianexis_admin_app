import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/admin_user.dart';
import '../data/billing_repository.dart';
import '../domain/billing_action_request.dart';
import '../domain/billing_overview.dart';
import '../domain/platform_subscription.dart';
import '../domain/pricing_intake.dart';
import '../domain/pricing_intake_status.dart';
import '../domain/quote_request.dart';
import '../domain/quote_request_status.dart';
import '../domain/subscription_status.dart';

extension AdminRoleBillingDecisions on AdminRole {
  bool get canChangeBillingStatus =>
      this == AdminRole.superAdmin || this == AdminRole.billingAdmin;
}

class SubscriptionListQuery {
  const SubscriptionListQuery({
    this.search = '',
    this.filter = SubscriptionListFilter.all,
  });

  final String search;
  final SubscriptionListFilter filter;

  SubscriptionListQuery copyWith({
    String? search,
    SubscriptionListFilter? filter,
  }) {
    return SubscriptionListQuery(
      search: search ?? this.search,
      filter: filter ?? this.filter,
    );
  }

  SubscriptionStatus? statusForApi() {
    return switch (filter) {
      SubscriptionListFilter.all => null,
      SubscriptionListFilter.active => SubscriptionStatus.active,
      SubscriptionListFilter.trial => SubscriptionStatus.trial,
      SubscriptionListFilter.pastDue => SubscriptionStatus.pastDue,
      SubscriptionListFilter.suspended => SubscriptionStatus.suspended,
      SubscriptionListFilter.cancelled => SubscriptionStatus.cancelled,
    };
  }
}

class PricingIntakeListQuery {
  const PricingIntakeListQuery({
    this.search = '',
    this.filter = PricingIntakeListFilter.all,
  });

  final String search;
  final PricingIntakeListFilter filter;

  PricingIntakeListQuery copyWith({
    String? search,
    PricingIntakeListFilter? filter,
  }) {
    return PricingIntakeListQuery(
      search: search ?? this.search,
      filter: filter ?? this.filter,
    );
  }
}

class QuoteRequestListQuery {
  const QuoteRequestListQuery({
    this.search = '',
    this.filter = QuoteRequestListFilter.all,
  });

  final String search;
  final QuoteRequestListFilter filter;

  QuoteRequestListQuery copyWith({
    String? search,
    QuoteRequestListFilter? filter,
  }) {
    return QuoteRequestListQuery(
      search: search ?? this.search,
      filter: filter ?? this.filter,
    );
  }
}

final subscriptionListQueryProvider =
    NotifierProvider<SubscriptionListQueryNotifier, SubscriptionListQuery>(
      SubscriptionListQueryNotifier.new,
    );

class SubscriptionListQueryNotifier extends Notifier<SubscriptionListQuery> {
  @override
  SubscriptionListQuery build() => const SubscriptionListQuery();

  void setSearch(String value) {
    state = state.copyWith(search: value);
  }

  void setFilter(SubscriptionListFilter filter) {
    state = state.copyWith(filter: filter);
  }
}

final pricingIntakeListQueryProvider =
    NotifierProvider<PricingIntakeListQueryNotifier, PricingIntakeListQuery>(
      PricingIntakeListQueryNotifier.new,
    );

class PricingIntakeListQueryNotifier extends Notifier<PricingIntakeListQuery> {
  @override
  PricingIntakeListQuery build() => const PricingIntakeListQuery();

  void setSearch(String value) {
    state = state.copyWith(search: value);
  }

  void setFilter(PricingIntakeListFilter filter) {
    state = state.copyWith(filter: filter);
  }
}

final quoteRequestListQueryProvider =
    NotifierProvider<QuoteRequestListQueryNotifier, QuoteRequestListQuery>(
      QuoteRequestListQueryNotifier.new,
    );

class QuoteRequestListQueryNotifier extends Notifier<QuoteRequestListQuery> {
  @override
  QuoteRequestListQuery build() => const QuoteRequestListQuery();

  void setSearch(String value) {
    state = state.copyWith(search: value);
  }

  void setFilter(QuoteRequestListFilter filter) {
    state = state.copyWith(filter: filter);
  }
}

final billingOverviewProvider =
    AsyncNotifierProvider<BillingOverviewNotifier, BillingOverview>(
      BillingOverviewNotifier.new,
    );

class BillingOverviewNotifier extends AsyncNotifier<BillingOverview> {
  @override
  Future<BillingOverview> build() => _load();

  Future<BillingOverview> _load() {
    return ref.read(billingRepositoryProvider).fetchOverview();
  }

  Future<void> refresh() async {
    state = const AsyncLoading<BillingOverview>();
    state = await AsyncValue.guard(_load);
  }
}

final subscriptionsProvider =
    AsyncNotifierProvider<SubscriptionsNotifier, List<PlatformSubscription>>(
      SubscriptionsNotifier.new,
    );

class SubscriptionsNotifier extends AsyncNotifier<List<PlatformSubscription>> {
  @override
  Future<List<PlatformSubscription>> build() => _load();

  Future<List<PlatformSubscription>> _load() {
    return ref.read(billingRepositoryProvider).fetchSubscriptions();
  }

  Future<void> refresh() async {
    state = const AsyncLoading<List<PlatformSubscription>>();
    state = await AsyncValue.guard(_load);
  }
}

List<PlatformSubscription> filteredSubscriptions({
  required List<PlatformSubscription> items,
  required SubscriptionListQuery query,
}) {
  return items
      .where((item) => item.matchesFilter(query.filter))
      .where((item) => item.matchesSearch(query.search))
      .toList(growable: false);
}

final filteredSubscriptionsProvider =
    Provider<AsyncValue<List<PlatformSubscription>>>((ref) {
      final query = ref.watch(subscriptionListQueryProvider);
      final subscriptions = ref.watch(subscriptionsProvider);
      return subscriptions.whenData(
        (items) => filteredSubscriptions(items: items, query: query),
      );
    });

final pricingIntakesProvider =
    AsyncNotifierProvider<PricingIntakesNotifier, List<PricingIntake>>(
      PricingIntakesNotifier.new,
    );

class PricingIntakesNotifier extends AsyncNotifier<List<PricingIntake>> {
  @override
  Future<List<PricingIntake>> build() => _load();

  Future<List<PricingIntake>> _load() {
    return ref.read(billingRepositoryProvider).fetchPricingIntakes();
  }

  Future<void> refresh() async {
    state = const AsyncLoading<List<PricingIntake>>();
    state = await AsyncValue.guard(_load);
  }
}

List<PricingIntake> filteredPricingIntakes({
  required List<PricingIntake> items,
  required PricingIntakeListQuery query,
}) {
  return items
      .where((item) => item.matchesFilter(query.filter))
      .where((item) => item.matchesSearch(query.search))
      .toList(growable: false);
}

final filteredPricingIntakesProvider =
    Provider<AsyncValue<List<PricingIntake>>>((ref) {
      final query = ref.watch(pricingIntakeListQueryProvider);
      final intakes = ref.watch(pricingIntakesProvider);
      return intakes.whenData(
        (items) => filteredPricingIntakes(items: items, query: query),
      );
    });

final quoteRequestsProvider =
    AsyncNotifierProvider<QuoteRequestsNotifier, List<QuoteRequest>>(
      QuoteRequestsNotifier.new,
    );

class QuoteRequestsNotifier extends AsyncNotifier<List<QuoteRequest>> {
  @override
  Future<List<QuoteRequest>> build() => _load();

  Future<List<QuoteRequest>> _load() {
    return ref.read(billingRepositoryProvider).fetchQuoteRequests();
  }

  Future<void> refresh() async {
    state = const AsyncLoading<List<QuoteRequest>>();
    state = await AsyncValue.guard(_load);
  }
}

List<QuoteRequest> filteredQuoteRequests({
  required List<QuoteRequest> items,
  required QuoteRequestListQuery query,
}) {
  return items
      .where((item) => item.matchesFilter(query.filter))
      .where((item) => item.matchesSearch(query.search))
      .toList(growable: false);
}

final filteredQuoteRequestsProvider =
    Provider<AsyncValue<List<QuoteRequest>>>((ref) {
      final query = ref.watch(quoteRequestListQueryProvider);
      final requests = ref.watch(quoteRequestsProvider);
      return requests.whenData(
        (items) => filteredQuoteRequests(items: items, query: query),
      );
    });

final subscriptionDetailProvider =
    FutureProvider.autoDispose.family<PlatformSubscription, String>((ref, id) {
      return ref.watch(billingRepositoryProvider).fetchSubscription(id);
    });

final pricingIntakeDetailProvider =
    FutureProvider.autoDispose.family<PricingIntake, String>((ref, id) {
      return ref.watch(billingRepositoryProvider).fetchPricingIntake(id);
    });

final quoteRequestDetailProvider =
    FutureProvider.autoDispose.family<QuoteRequest, String>((ref, id) {
      return ref.watch(billingRepositoryProvider).fetchQuoteRequest(id);
    });

Future<PlatformSubscription> submitSubscriptionStatusChange(
  WidgetRef ref, {
  required String subscriptionId,
  required BillingSubscriptionStatusRequest request,
}) async {
  final updated = await ref.read(billingRepositoryProvider).updateSubscriptionStatus(
    id: subscriptionId,
    request: request,
  );
  ref.invalidate(subscriptionDetailProvider(subscriptionId));
  await ref.read(subscriptionsProvider.notifier).refresh();
  await ref.read(billingOverviewProvider.notifier).refresh();
  return updated;
}

Future<PricingIntake> submitPricingIntakeStatusChange(
  WidgetRef ref, {
  required String intakeId,
  required BillingPricingIntakeStatusRequest request,
}) async {
  final updated = await ref.read(billingRepositoryProvider).updatePricingIntakeStatus(
    id: intakeId,
    request: request,
  );
  ref.invalidate(pricingIntakeDetailProvider(intakeId));
  await ref.read(pricingIntakesProvider.notifier).refresh();
  await ref.read(billingOverviewProvider.notifier).refresh();
  return updated;
}

Future<QuoteRequest> submitQuoteRequestStatusChange(
  WidgetRef ref, {
  required String quoteRequestId,
  required BillingQuoteRequestStatusRequest request,
}) async {
  final updated = await ref.read(billingRepositoryProvider).updateQuoteRequestStatus(
    id: quoteRequestId,
    request: request,
  );
  ref.invalidate(quoteRequestDetailProvider(quoteRequestId));
  await ref.read(quoteRequestsProvider.notifier).refresh();
  await ref.read(billingOverviewProvider.notifier).refresh();
  return updated;
}

Future<void> refreshAllBillingLists(WidgetRef ref) async {
  await Future.wait([
    ref.read(subscriptionsProvider.notifier).refresh(),
    ref.read(pricingIntakesProvider.notifier).refresh(),
    ref.read(quoteRequestsProvider.notifier).refresh(),
    ref.read(billingOverviewProvider.notifier).refresh(),
  ]);
}
