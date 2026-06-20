import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/action_center_repository.dart';
import '../domain/action_center_filter.dart';
import '../domain/action_center_item.dart';

final actionCenterProvider =
    AsyncNotifierProvider<ActionCenterNotifier, ActionCenterSnapshot>(
      ActionCenterNotifier.new,
    );

class ActionCenterNotifier extends AsyncNotifier<ActionCenterSnapshot> {
  @override
  Future<ActionCenterSnapshot> build() => _load();

  Future<ActionCenterSnapshot> _load() {
    return ref.read(actionCenterRepositoryProvider).fetchActionCenter();
  }

  Future<void> refresh() async {
    state = const AsyncLoading<ActionCenterSnapshot>();
    state = await AsyncValue.guard(_load);
  }
}

final actionCenterListQueryProvider =
    NotifierProvider<ActionCenterListQueryNotifier, ActionCenterListQuery>(
      ActionCenterListQueryNotifier.new,
    );

class ActionCenterListQueryNotifier extends Notifier<ActionCenterListQuery> {
  @override
  ActionCenterListQuery build() => const ActionCenterListQuery();

  void setSearch(String value) {
    state = state.copyWith(search: value);
  }

  void setFilter(ActionCenterFilter filter) {
    state = state.copyWith(filter: filter);
  }
}

List<ActionCenterItem> filteredActionCenterItems({
  required List<ActionCenterItem> items,
  required ActionCenterListQuery query,
}) {
  return items
      .where((item) => actionCenterItemMatchesFilter(item, query.filter))
      .where((item) => item.matchesSearch(query.search))
      .toList(growable: false);
}

final filteredActionCenterItemsProvider =
    Provider<AsyncValue<List<ActionCenterItem>>>((ref) {
      final query = ref.watch(actionCenterListQueryProvider);
      final snapshot = ref.watch(actionCenterProvider);
      return snapshot.whenData(
        (data) => filteredActionCenterItems(items: data.items, query: query),
      );
    });

final actionCenterSummaryProvider = Provider<AsyncValue<ActionCenterSnapshot>>((ref) {
  return ref.watch(actionCenterProvider);
});
