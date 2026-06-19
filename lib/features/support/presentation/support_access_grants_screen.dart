import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/localization_resolver.dart';
import '../../../core/widgets/vianexis_error_view.dart';
import '../../../core/widgets/vianexis_loading_view.dart';
import '../../../l10n/app_localizations.dart';
import '../data/support_access_grants_repository.dart';
import 'support_providers.dart';
import 'widgets/support_access_grant_card.dart';
import 'widgets/support_access_warning_card.dart';
import 'widgets/support_filter_bars.dart';

class SupportAccessGrantsScreen extends ConsumerStatefulWidget {
  const SupportAccessGrantsScreen({super.key});

  @override
  ConsumerState<SupportAccessGrantsScreen> createState() =>
      _SupportAccessGrantsScreenState();
}

class _SupportAccessGrantsScreenState extends ConsumerState<SupportAccessGrantsScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final query = ref.watch(supportAccessGrantListQueryProvider);
    final grantsAsync = ref.watch(filteredSupportAccessGrantsProvider);
    final usesMock = ref.watch(supportAccessGrantsRepositoryProvider).usesMockData;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.supportGrantsTitle),
        actions: [
          if (usesMock)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  resolveSupportKey(context, 'supportMockDataBadge'),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: SupportAccessWarningCard(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: resolveSupportKey(context, 'supportGrantSearchHint'),
              ),
              onChanged: (value) =>
                  ref.read(supportAccessGrantListQueryProvider.notifier).setSearch(value),
            ),
          ),
          SupportAccessGrantFilterBar(
            selected: query.filter,
            onSelected: ref.read(supportAccessGrantListQueryProvider.notifier).setFilter,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: grantsAsync.when(
              loading: () => const VianexisLoadingView(),
              error: (error, _) => VianexisErrorView(
                message: resolveSupportKey(context, 'supportLoadError'),
                onRetry: () => ref.read(supportAccessGrantsProvider.notifier).refresh(),
              ),
              data: (items) {
                if (items.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        resolveSupportKey(context, 'supportGrantListEmpty'),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => ref.read(supportAccessGrantsProvider.notifier).refresh(),
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: items.length,
                    itemBuilder: (context, index) =>
                        SupportAccessGrantCard(grant: items[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
