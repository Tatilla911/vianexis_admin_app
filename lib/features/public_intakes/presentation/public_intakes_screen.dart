import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/localization_resolver.dart';
import '../../../core/widgets/mock_data_badge.dart';
import '../../../core/widgets/vianexis_error_view.dart';
import '../../../core/widgets/vianexis_loading_view.dart';
import '../../../l10n/app_localizations.dart';
import '../data/public_intakes_repository.dart';
import 'public_intakes_providers.dart';
import 'widgets/public_intake_card.dart';
import 'widgets/public_intake_filter_bar.dart';

class PublicIntakesScreen extends ConsumerStatefulWidget {
  const PublicIntakesScreen({super.key});

  @override
  ConsumerState<PublicIntakesScreen> createState() => _PublicIntakesScreenState();
}

class _PublicIntakesScreenState extends ConsumerState<PublicIntakesScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final query = ref.watch(publicIntakeListQueryProvider);
    final intakesAsync = ref.watch(filteredPublicIntakesProvider);
    final usesMock = ref.watch(publicIntakesRepositoryProvider).usesMockData;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.publicIntakesTitle),
        actions: [
          if (usesMock)
            MockDataBadge(
              label: resolvePublicIntakeKey(context, 'publicIntakeMockDataBadge'),
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: resolvePublicIntakeKey(context, 'publicIntakeSearchHint'),
              ),
              onChanged: (value) =>
                  ref.read(publicIntakeListQueryProvider.notifier).setSearch(value),
            ),
          ),
          PublicIntakeFilterBar(
            selected: query.filter,
            onSelected: ref.read(publicIntakeListQueryProvider.notifier).setFilter,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: intakesAsync.when(
              loading: () => const VianexisLoadingView(),
              error: (error, _) => VianexisErrorView.fromError(
                context,
                error,
                fallbackMessage: resolvePublicIntakeKey(context, 'publicIntakeListError'),
                onRetry: () => ref.read(publicIntakesProvider.notifier).refresh(),
              ),
              data: (items) {
                if (items.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        resolvePublicIntakeKey(context, 'publicIntakeListEmpty'),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => ref.read(publicIntakesProvider.notifier).refresh(),
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: items.length,
                    itemBuilder: (context, index) =>
                        PublicIntakeCard(intake: items[index]),
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
