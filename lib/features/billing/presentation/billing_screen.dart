import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_router.dart';
import '../../../core/localization/localization_resolver.dart';
import '../../../core/widgets/mock_data_badge.dart';
import '../../../core/widgets/vianexis_error_view.dart';
import '../../../core/widgets/vianexis_loading_view.dart';
import '../../../core/widgets/vianexis_metadata_notice.dart';
import '../../../l10n/app_localizations.dart';
import '../data/billing_repository.dart';
import '../domain/pricing_intake_status.dart';
import '../domain/quote_request_status.dart';
import '../domain/subscription_status.dart';
import 'billing_providers.dart';
import 'widgets/billing_overview_card.dart';
import 'widgets/pricing_intake_card.dart';
import 'widgets/quote_request_card.dart';
import 'widgets/subscription_card.dart';

class BillingScreen extends ConsumerStatefulWidget {
  const BillingScreen({super.key});

  @override
  ConsumerState<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends ConsumerState<BillingScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _subscriptionSearchController = TextEditingController();
  final _pricingSearchController = TextEditingController();
  final _quoteSearchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _subscriptionSearchController.dispose();
    _pricingSearchController.dispose();
    _quoteSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final usesMock = ref.watch(billingRepositoryProvider).usesMockData;
    final overviewAsync = ref.watch(billingOverviewProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.billingTitle),
        actions: [
          if (usesMock)
            MockDataBadge(
              label: resolveBillingKey(context, 'billingMockDataBadge'),
            ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Center(
              child: Text(
                resolveBillingKey(context, 'billingMetadataBadge'),
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: resolveBillingKey(context, 'billingTabSubscriptions')),
            Tab(text: resolveBillingKey(context, 'billingTabPricingIntakes')),
            Tab(text: resolveBillingKey(context, 'billingTabQuoteRequests')),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: overviewAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (error, _) => Text(
                resolveBillingKey(context, 'billingLoadError'),
              ),
              data: (overview) => BillingOverviewCard(overview: overview, compact: true),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _SubscriptionsTab(searchController: _subscriptionSearchController),
                _PricingIntakesTab(searchController: _pricingSearchController),
                _QuoteRequestsTab(searchController: _quoteSearchController),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: VianexisMetadataNotice(
              message: resolveBillingKey(context, 'billingPrivacyNotice'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SubscriptionsTab extends ConsumerWidget {
  const _SubscriptionsTab({required this.searchController});

  final TextEditingController searchController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(subscriptionListQueryProvider);
    final subscriptionsAsync = ref.watch(filteredSubscriptionsProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: resolveBillingKey(context, 'billingSubscriptionSearchHint'),
            ),
            onChanged: (value) =>
                ref.read(subscriptionListQueryProvider.notifier).setSearch(value),
          ),
        ),
        _SubscriptionFilterBar(
          selected: query.filter,
          onSelected: ref.read(subscriptionListQueryProvider.notifier).setFilter,
        ),
        const SizedBox(height: 8),
        Expanded(
          child: subscriptionsAsync.when(
            loading: () => const VianexisLoadingView(),
            error: (error, _) => VianexisErrorView.fromError(
              context,
              error,
              fallbackMessage: resolveBillingKey(context, 'billingLoadError'),
              onRetry: () => ref.read(subscriptionsProvider.notifier).refresh(),
            ),
            data: (items) {
              if (items.isEmpty) {
                return Center(
                  child: Text(resolveBillingKey(context, 'billingSubscriptionListEmpty')),
                );
              }
              return RefreshIndicator(
                onRefresh: () => ref.read(subscriptionsProvider.notifier).refresh(),
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final subscription = items[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: SubscriptionCard(
                        subscription: subscription,
                        onTap: () => context.push(
                          AdminRoutes.billingSubscriptionDetail(subscription.id),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SubscriptionFilterBar extends StatelessWidget {
  const _SubscriptionFilterBar({
    required this.selected,
    required this.onSelected,
  });

  final SubscriptionListFilter selected;
  final ValueChanged<SubscriptionListFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: SubscriptionListFilter.values.map((filter) {
          final key = switch (filter) {
            SubscriptionListFilter.all => 'billingSubscriptionFilterAll',
            SubscriptionListFilter.active => 'billingSubscriptionFilterActive',
            SubscriptionListFilter.trial => 'billingSubscriptionFilterTrial',
            SubscriptionListFilter.pastDue => 'billingSubscriptionFilterPastDue',
            SubscriptionListFilter.suspended => 'billingSubscriptionFilterSuspended',
            SubscriptionListFilter.cancelled => 'billingSubscriptionFilterCancelled',
          };
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(resolveBillingKey(context, key)),
              selected: selected == filter,
              onSelected: (_) => onSelected(filter),
            ),
          );
        }).toList(growable: false),
      ),
    );
  }
}

class _PricingIntakesTab extends ConsumerWidget {
  const _PricingIntakesTab({required this.searchController});

  final TextEditingController searchController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(pricingIntakeListQueryProvider);
    final intakesAsync = ref.watch(filteredPricingIntakesProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: resolveBillingKey(context, 'billingPricingIntakeSearchHint'),
            ),
            onChanged: (value) =>
                ref.read(pricingIntakeListQueryProvider.notifier).setSearch(value),
          ),
        ),
        _PricingIntakeFilterBar(
          selected: query.filter,
          onSelected: ref.read(pricingIntakeListQueryProvider.notifier).setFilter,
        ),
        const SizedBox(height: 8),
        Expanded(
          child: intakesAsync.when(
            loading: () => const VianexisLoadingView(),
            error: (error, _) => VianexisErrorView.fromError(
              context,
              error,
              fallbackMessage: resolveBillingKey(context, 'billingLoadError'),
              onRetry: () => ref.read(pricingIntakesProvider.notifier).refresh(),
            ),
            data: (items) {
              if (items.isEmpty) {
                return Center(
                  child: Text(resolveBillingKey(context, 'billingPricingIntakeListEmpty')),
                );
              }
              return RefreshIndicator(
                onRefresh: () => ref.read(pricingIntakesProvider.notifier).refresh(),
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final intake = items[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: PricingIntakeCard(
                        intake: intake,
                        onTap: () => context.push(
                          AdminRoutes.billingPricingIntakeDetail(intake.id),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _PricingIntakeFilterBar extends StatelessWidget {
  const _PricingIntakeFilterBar({
    required this.selected,
    required this.onSelected,
  });

  final PricingIntakeListFilter selected;
  final ValueChanged<PricingIntakeListFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: PricingIntakeListFilter.values.map((filter) {
          final key = switch (filter) {
            PricingIntakeListFilter.all => 'billingPricingIntakeFilterAll',
            PricingIntakeListFilter.newIntake => 'billingPricingIntakeFilterNew',
            PricingIntakeListFilter.reviewing => 'billingPricingIntakeFilterReviewing',
            PricingIntakeListFilter.quoted => 'billingPricingIntakeFilterQuoted',
            PricingIntakeListFilter.accepted => 'billingPricingIntakeFilterAccepted',
            PricingIntakeListFilter.rejected => 'billingPricingIntakeFilterRejected',
          };
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(resolveBillingKey(context, key)),
              selected: selected == filter,
              onSelected: (_) => onSelected(filter),
            ),
          );
        }).toList(growable: false),
      ),
    );
  }
}

class _QuoteRequestsTab extends ConsumerWidget {
  const _QuoteRequestsTab({required this.searchController});

  final TextEditingController searchController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(quoteRequestListQueryProvider);
    final requestsAsync = ref.watch(filteredQuoteRequestsProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: resolveBillingKey(context, 'billingQuoteRequestSearchHint'),
            ),
            onChanged: (value) =>
                ref.read(quoteRequestListQueryProvider.notifier).setSearch(value),
          ),
        ),
        _QuoteRequestFilterBar(
          selected: query.filter,
          onSelected: ref.read(quoteRequestListQueryProvider.notifier).setFilter,
        ),
        const SizedBox(height: 8),
        Expanded(
          child: requestsAsync.when(
            loading: () => const VianexisLoadingView(),
            error: (error, _) => VianexisErrorView.fromError(
              context,
              error,
              fallbackMessage: resolveBillingKey(context, 'billingLoadError'),
              onRetry: () => ref.read(quoteRequestsProvider.notifier).refresh(),
            ),
            data: (items) {
              if (items.isEmpty) {
                return Center(
                  child: Text(resolveBillingKey(context, 'billingQuoteRequestListEmpty')),
                );
              }
              return RefreshIndicator(
                onRefresh: () => ref.read(quoteRequestsProvider.notifier).refresh(),
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final request = items[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: QuoteRequestCard(
                        quoteRequest: request,
                        onTap: () => context.push(
                          AdminRoutes.billingQuoteRequestDetail(request.id),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _QuoteRequestFilterBar extends StatelessWidget {
  const _QuoteRequestFilterBar({
    required this.selected,
    required this.onSelected,
  });

  final QuoteRequestListFilter selected;
  final ValueChanged<QuoteRequestListFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: QuoteRequestListFilter.values.map((filter) {
          final key = switch (filter) {
            QuoteRequestListFilter.all => 'billingQuoteRequestFilterAll',
            QuoteRequestListFilter.submitted => 'billingQuoteRequestFilterSubmitted',
            QuoteRequestListFilter.underReview => 'billingQuoteRequestFilterUnderReview',
            QuoteRequestListFilter.quoted => 'billingQuoteRequestFilterQuoted',
            QuoteRequestListFilter.accepted => 'billingQuoteRequestFilterAccepted',
            QuoteRequestListFilter.rejected => 'billingQuoteRequestFilterRejected',
          };
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(resolveBillingKey(context, key)),
              selected: selected == filter,
              onSelected: (_) => onSelected(filter),
            ),
          );
        }).toList(growable: false),
      ),
    );
  }
}
