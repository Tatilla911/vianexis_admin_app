import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/localization_resolver.dart';
import '../../../core/widgets/mock_data_badge.dart';
import '../../../core/widgets/vianexis_error_view.dart';
import '../../../core/widgets/vianexis_loading_view.dart';
import '../../../core/widgets/vianexis_status_badge.dart';
import '../../../l10n/app_localizations.dart';
import '../data/ai_reviews_repository.dart';
import 'ai_review_providers.dart';
import 'widgets/ai_review_card.dart';
import 'widgets/ai_review_filter_bar.dart';

class AiReviewSummaryScreen extends ConsumerStatefulWidget {
  const AiReviewSummaryScreen({super.key});

  @override
  ConsumerState<AiReviewSummaryScreen> createState() =>
      _AiReviewSummaryScreenState();
}

class _AiReviewSummaryScreenState extends ConsumerState<AiReviewSummaryScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final query = ref.watch(aiReviewListQueryProvider);
    final reviewsAsync = ref.watch(filteredAiReviewsProvider);
    final usesMock = ref.watch(aiReviewsRepositoryProvider).usesMockData;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.aiReviewsTitle),
        actions: [
          if (usesMock)
            MockDataBadge(
              label: resolveAiReviewKey(context, 'aiReviewMockDataBadge'),
            ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: VianexisStatusBadge(
                label: l10n.privacyMetadataOnlyBadge,
                tone: VianexisStatusTone.unknown,
              ),
            ),
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
                hintText: resolveAiReviewKey(context, 'aiReviewSearchHint'),
              ),
              onChanged: (value) =>
                  ref.read(aiReviewListQueryProvider.notifier).setSearch(value),
            ),
          ),
          AiReviewFilterBar(
            selected: query.filter,
            onSelected: ref.read(aiReviewListQueryProvider.notifier).setFilter,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: reviewsAsync.when(
              loading: () => const VianexisLoadingView(),
              error: (error, _) => VianexisErrorView(
                message: resolveAiReviewKey(context, 'aiReviewLoadError'),
                onRetry: () => ref.read(aiReviewsProvider.notifier).refresh(),
              ),
              data: (items) {
                if (items.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        resolveAiReviewKey(context, 'aiReviewListEmpty'),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => ref.read(aiReviewsProvider.notifier).refresh(),
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: items.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            resolveAiReviewKey(context, 'aiReviewAdvisoryNotice'),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        );
                      }
                      return AiReviewCard(review: items[index - 1]);
                    },
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
