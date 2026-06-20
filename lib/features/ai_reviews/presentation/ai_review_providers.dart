import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/ai_reviews_repository.dart';
import '../domain/ai_review_item.dart';

class AiReviewListQuery {
  const AiReviewListQuery({
    this.search = '',
    this.filter = AiReviewFilter.all,
  });

  final String search;
  final AiReviewFilter filter;

  AiReviewListQuery copyWith({String? search, AiReviewFilter? filter}) {
    return AiReviewListQuery(
      search: search ?? this.search,
      filter: filter ?? this.filter,
    );
  }
}

final aiReviewListQueryProvider =
    NotifierProvider<AiReviewListQueryNotifier, AiReviewListQuery>(
      AiReviewListQueryNotifier.new,
    );

class AiReviewListQueryNotifier extends Notifier<AiReviewListQuery> {
  @override
  AiReviewListQuery build() => const AiReviewListQuery();

  void setSearch(String value) {
    state = state.copyWith(search: value);
  }

  void setFilter(AiReviewFilter filter) {
    state = state.copyWith(filter: filter);
  }
}

final aiReviewsProvider =
    AsyncNotifierProvider<AiReviewsNotifier, List<AiReviewItem>>(
      AiReviewsNotifier.new,
    );

class AiReviewsNotifier extends AsyncNotifier<List<AiReviewItem>> {
  @override
  Future<List<AiReviewItem>> build() => _load();

  Future<List<AiReviewItem>> _load() {
    return ref.read(aiReviewsRepositoryProvider).fetchReviews();
  }

  Future<void> refresh() async {
    state = const AsyncLoading<List<AiReviewItem>>();
    state = await AsyncValue.guard(_load);
  }
}

List<AiReviewItem> filteredAiReviews({
  required List<AiReviewItem> items,
  required AiReviewListQuery query,
}) {
  return items
      .where((item) => item.matchesFilter(query.filter))
      .where((item) => item.matchesSearch(query.search))
      .toList(growable: false);
}

final filteredAiReviewsProvider = Provider<AsyncValue<List<AiReviewItem>>>((ref) {
  final query = ref.watch(aiReviewListQueryProvider);
  final reviews = ref.watch(aiReviewsProvider);
  return reviews.whenData(
    (items) => filteredAiReviews(items: items, query: query),
  );
});

final aiReviewDetailProvider =
    FutureProvider.autoDispose.family<AiReviewItem, String>((ref, id) {
      return ref.watch(aiReviewsRepositoryProvider).fetchReview(id);
    });

final aiReviewSummaryProvider = Provider<AsyncValue<AiReviewSummary>>((ref) {
  final reviews = ref.watch(aiReviewsProvider);
  return reviews.whenData(AiReviewSummary.fromItems);
});
