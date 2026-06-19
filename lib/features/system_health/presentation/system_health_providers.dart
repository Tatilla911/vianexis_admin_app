import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/system_health_repository.dart';
import '../domain/system_health_action_request.dart';
import '../domain/system_health_event.dart';
import '../domain/system_health_overview.dart';

class SystemHealthEventListQuery {
  const SystemHealthEventListQuery({
    this.filter = SystemHealthEventFilter.all,
  });

  final SystemHealthEventFilter filter;

  SystemHealthEventListQuery copyWith({SystemHealthEventFilter? filter}) {
    return SystemHealthEventListQuery(filter: filter ?? this.filter);
  }
}

final systemHealthEventFilterProvider =
    NotifierProvider<SystemHealthEventFilterNotifier, SystemHealthEventListQuery>(
      SystemHealthEventFilterNotifier.new,
    );

class SystemHealthEventFilterNotifier extends Notifier<SystemHealthEventListQuery> {
  @override
  SystemHealthEventListQuery build() => const SystemHealthEventListQuery();

  void setFilter(SystemHealthEventFilter filter) {
    state = state.copyWith(filter: filter);
  }
}

final systemHealthSnapshotProvider =
    AsyncNotifierProvider<SystemHealthSnapshotNotifier, SystemHealthSnapshot>(
      SystemHealthSnapshotNotifier.new,
    );

class SystemHealthSnapshotNotifier extends AsyncNotifier<SystemHealthSnapshot> {
  @override
  Future<SystemHealthSnapshot> build() => _load();

  Future<SystemHealthSnapshot> _load() {
    return ref.read(systemHealthRepositoryProvider).fetchSnapshot();
  }

  Future<void> refresh() async {
    state = const AsyncLoading<SystemHealthSnapshot>();
    state = await AsyncValue.guard(_load);
  }
}

final filteredSystemHealthEventsProvider =
    Provider<AsyncValue<List<SystemHealthEvent>>>((ref) {
      final query = ref.watch(systemHealthEventFilterProvider);
      final snapshot = ref.watch(systemHealthSnapshotProvider);
      return snapshot.whenData(
        (data) => data.events
            .where((event) => event.matchesFilter(query.filter))
            .toList(growable: false),
      );
    });

final systemHealthEventDetailProvider =
    FutureProvider.autoDispose.family<SystemHealthEvent, String>((ref, id) {
      return ref.watch(systemHealthRepositoryProvider).fetchEvent(id);
    });

Future<void> refreshSystemHealthEventDetail(WidgetRef ref, String eventId) async {
  ref.invalidate(systemHealthEventDetailProvider(eventId));
}

Future<SystemHealthEvent> submitSystemHealthAction({
  required WidgetRef ref,
  required String eventId,
  required SystemHealthActionRequest request,
}) async {
  final updated = await ref
      .read(systemHealthRepositoryProvider)
      .submitAction(eventId: eventId, request: request);
  ref.invalidate(systemHealthEventDetailProvider(eventId));
  await ref.read(systemHealthSnapshotProvider.notifier).refresh();
  return updated;
}
