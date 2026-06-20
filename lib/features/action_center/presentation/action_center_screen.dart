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
    context.go(routeHint);
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: snapshotAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (_, _) => Text(resolveActionCenterKey(context, 'actionCenterLoadError')),
              data: (snapshot) =>
                  ActionCenterNeedsAttentionCard(snapshot: snapshot, compact: true),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: resolveActionCenterKey(context, 'actionCenterSearchHint'),
              ),
              onChanged: (value) =>
                  ref.read(actionCenterListQueryProvider.notifier).setSearch(value),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: ActionCenterFilter.values.map((filter) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(resolveActionCenterKey(context, filter.localizationKey())),
                    selected: query.filter == filter,
                    onSelected: (_) =>
                        ref.read(actionCenterListQueryProvider.notifier).setFilter(filter),
                  ),
                );
              }).toList(growable: false),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: itemsAsync.when(
              loading: () => const VianexisLoadingView(),
              error: (error, _) => VianexisErrorView.fromError(
                context,
                error,
                fallbackMessage: resolveActionCenterKey(context, 'actionCenterLoadError'),
                onRetry: () => ref.read(actionCenterProvider.notifier).refresh(),
              ),
              data: (items) {
                if (items.isEmpty) {
                  return Center(
                    child: Text(resolveActionCenterKey(context, 'actionCenterListEmpty')),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () => ref.read(actionCenterProvider.notifier).refresh(),
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ActionCenterItemCard(
                          item: item,
                          onTap: () => _openItem(item.actionRouteHint),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: VianexisMetadataNotice(
              message: resolveActionCenterKey(context, 'actionCenterPrivacyNotice'),
            ),
          ),
        ],
      ),
    );
  }
}
