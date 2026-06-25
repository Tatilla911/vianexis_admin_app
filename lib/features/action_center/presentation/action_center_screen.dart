import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/localization_resolver.dart';
import '../../../core/widgets/mock_data_badge.dart';
import '../../../core/widgets/vianexis_error_view.dart';
import '../../../core/widgets/vianexis_loading_view.dart';
import '../../../core/widgets/vianexis_metadata_notice.dart';
import '../../../l10n/app_localizations.dart';
import '../data/action_center_repository.dart';
import '../domain/action_center_filter.dart';
import 'action_center_providers.dart';
import 'widgets/action_center_item_card.dart';

class ActionCenterScreen extends ConsumerStatefulWidget {
  const ActionCenterScreen({super.key});

  @override
  ConsumerState<ActionCenterScreen> createState() => _ActionCenterScreenState();
}

class _ActionCenterScreenState extends ConsumerState<ActionCenterScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openItem(String? routeHint) {
    if (routeHint == null || routeHint.trim().isEmpty) return;
    context.push(routeHint);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final snapshotAsync = ref.watch(actionCenterProvider);
    final itemsAsync = ref.watch(filteredActionCenterItemsProvider);
    final query = ref.watch(actionCenterListQueryProvider);
    final usesMock = ref.watch(actionCenterRepositoryProvider).usesMockData;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.actionCenterTitle),
        actions: [
          if (usesMock)
            MockDataBadge(label: resolveActionCenterKey(context, 'actionCenterMockDataBadge')),
        ],
      ),
      body: itemsAsync.when(
        loading: () => const VianexisLoadingView(),
        error: (error, _) => VianexisErrorView.fromError(
          context,
          error,
          fallbackMessage: resolveActionCenterKey(context, 'actionCenterLoadError'),
          onRetry: () => ref.read(actionCenterProvider.notifier).refresh(),
        ),
        data: (items) {
          return RefreshIndicator(
            onRefresh: () => ref.read(actionCenterProvider.notifier).refresh(),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: VianexisMetadataNotice(
                      message: resolveActionCenterKey(
                        context,
                        'actionCenterReadOnlyNotice',
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: snapshotAsync.when(
                      loading: () => const LinearProgressIndicator(),
                      error: (_, _) =>
                          Text(resolveActionCenterKey(context, 'actionCenterLoadError')),
                      data: (snapshot) => ActionCenterNeedsAttentionCard(
                        snapshot: snapshot,
                        compact: true,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: resolveActionCenterKey(
                          context,
                          'actionCenterSearchHint',
                        ),
                      ),
                      onChanged: (value) => ref
                          .read(actionCenterListQueryProvider.notifier)
                          .setSearch(value),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: ActionCenterFilter.values.map((filter) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(
                              resolveActionCenterKey(
                                context,
                                filter.localizationKey(),
                              ),
                            ),
                            selected: query.filter == filter,
                            onSelected: (_) => ref
                                .read(actionCenterListQueryProvider.notifier)
                                .setFilter(filter),
                          ),
                        );
                      }).toList(growable: false),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 8)),
                if (items.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              resolveActionCenterKey(
                                context,
                                'actionCenterListEmpty',
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              resolveActionCenterKey(
                                context,
                                'actionCenterListEmptyDetail',
                              ),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final item = items[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: ActionCenterItemCard(
                              item: item,
                              onTap: () => _openItem(item.actionRouteHint),
                            ),
                          );
                        },
                        childCount: items.length,
                      ),
                    ),
                  ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: VianexisMetadataNotice(
                      message: resolveActionCenterKey(
                        context,
                        'actionCenterPrivacyNotice',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
