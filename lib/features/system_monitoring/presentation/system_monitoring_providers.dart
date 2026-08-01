import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/system_monitoring_repository.dart';
import '../domain/system_monitoring_action_request.dart';
import '../domain/system_monitoring_incident.dart';
import '../domain/system_monitoring_overview.dart';

class SystemMonitoringComponentFilterState {
  const SystemMonitoringComponentFilterState({
    this.filter = SystemMonitoringComponentFilter.all,
  });

  final SystemMonitoringComponentFilter filter;

  SystemMonitoringComponentFilterState copyWith({
    SystemMonitoringComponentFilter? filter,
  }) {
    return SystemMonitoringComponentFilterState(filter: filter ?? this.filter);
  }
}

final systemMonitoringComponentFilterProvider =
    NotifierProvider<
      SystemMonitoringComponentFilterNotifier,
      SystemMonitoringComponentFilterState
    >(SystemMonitoringComponentFilterNotifier.new);

class SystemMonitoringComponentFilterNotifier
    extends Notifier<SystemMonitoringComponentFilterState> {
  @override
  SystemMonitoringComponentFilterState build() =>
      const SystemMonitoringComponentFilterState();

  void setFilter(SystemMonitoringComponentFilter filter) {
    state = state.copyWith(filter: filter);
  }
}

class SystemMonitoringIncidentFilterState {
  const SystemMonitoringIncidentFilterState({
    this.filter = SystemMonitoringIncidentFilter.all,
  });

  final SystemMonitoringIncidentFilter filter;

  SystemMonitoringIncidentFilterState copyWith({
    SystemMonitoringIncidentFilter? filter,
  }) {
    return SystemMonitoringIncidentFilterState(filter: filter ?? this.filter);
  }
}

final systemMonitoringIncidentFilterProvider =
    NotifierProvider<
      SystemMonitoringIncidentFilterNotifier,
      SystemMonitoringIncidentFilterState
    >(SystemMonitoringIncidentFilterNotifier.new);

class SystemMonitoringIncidentFilterNotifier
    extends Notifier<SystemMonitoringIncidentFilterState> {
  @override
  SystemMonitoringIncidentFilterState build() =>
      const SystemMonitoringIncidentFilterState();

  void setFilter(SystemMonitoringIncidentFilter filter) {
    state = state.copyWith(filter: filter);
  }
}

final systemMonitoringSnapshotProvider =
    AsyncNotifierProvider<
      SystemMonitoringSnapshotNotifier,
      SystemMonitoringSnapshot
    >(SystemMonitoringSnapshotNotifier.new);

class SystemMonitoringSnapshotNotifier
    extends AsyncNotifier<SystemMonitoringSnapshot> {
  @override
  Future<SystemMonitoringSnapshot> build() => _load();

  Future<SystemMonitoringSnapshot> _load() {
    return ref.read(systemMonitoringRepositoryProvider).fetchSnapshot();
  }

  Future<void> refresh() async {
    state = const AsyncLoading<SystemMonitoringSnapshot>();
    state = await AsyncValue.guard(_load);
  }

  Future<void> refreshMonitoring() async {
    state = const AsyncLoading<SystemMonitoringSnapshot>();
    state = await AsyncValue.guard(
      () => ref.read(systemMonitoringRepositoryProvider).refreshMonitoring(),
    );
  }
}

final filteredSystemMonitoringComponentsProvider = Provider((ref) {
  final query = ref.watch(systemMonitoringComponentFilterProvider);
  final snapshot = ref.watch(systemMonitoringSnapshotProvider);
  return snapshot.whenData((data) {
    if (query.filter == SystemMonitoringComponentFilter.all) {
      return data.components;
    }
    return data.components
        .where((c) => c.status.matchesDegradedOrUnhealthyFilter)
        .toList(growable: false);
  });
});

final systemMonitoringIncidentsProvider =
    FutureProvider.autoDispose<SystemIncidentListPage>((ref) {
      return ref.watch(systemMonitoringRepositoryProvider).fetchIncidents();
    });

final filteredSystemMonitoringIncidentsProvider =
    Provider<AsyncValue<List<SystemMonitoringIncident>>>((ref) {
      final query = ref.watch(systemMonitoringIncidentFilterProvider);
      final pageAsync = ref.watch(systemMonitoringIncidentsProvider);
      return pageAsync.whenData(
        (page) => page.items
            .where((incident) => incident.matchesFilter(query.filter))
            .toList(growable: false),
      );
    });

final systemMonitoringComponentDetailProvider = FutureProvider.autoDispose
    .family<SystemComponentDetail, String>((ref, componentKey) {
      return ref
          .watch(systemMonitoringRepositoryProvider)
          .fetchComponent(componentKey);
    });

final systemMonitoringIncidentDetailProvider = FutureProvider.autoDispose
    .family<SystemMonitoringIncident, String>((ref, id) {
      return ref.watch(systemMonitoringRepositoryProvider).fetchIncident(id);
    });

Future<void> refreshSystemMonitoringIncidentDetail(
  WidgetRef ref,
  String incidentId,
) async {
  ref.invalidate(systemMonitoringIncidentDetailProvider(incidentId));
  ref.invalidate(systemMonitoringIncidentsProvider);
}

Future<SystemMonitoringIncident> acknowledgeSystemMonitoringIncident({
  required WidgetRef ref,
  required String incidentId,
  required SystemMonitoringAcknowledgeRequest request,
}) async {
  final updated = await ref
      .read(systemMonitoringRepositoryProvider)
      .acknowledgeIncident(id: incidentId, request: request);
  ref.invalidate(systemMonitoringIncidentDetailProvider(incidentId));
  ref.invalidate(systemMonitoringIncidentsProvider);
  await ref.read(systemMonitoringSnapshotProvider.notifier).refresh();
  return updated;
}

Future<SystemMonitoringIncident> updateSystemMonitoringIncidentStatus({
  required WidgetRef ref,
  required String incidentId,
  required SystemMonitoringStatusUpdateRequest request,
}) async {
  final updated = await ref
      .read(systemMonitoringRepositoryProvider)
      .updateIncidentStatus(id: incidentId, request: request);
  ref.invalidate(systemMonitoringIncidentDetailProvider(incidentId));
  ref.invalidate(systemMonitoringIncidentsProvider);
  await ref.read(systemMonitoringSnapshotProvider.notifier).refresh();
  return updated;
}

Future<SystemMonitoringIncident> addSystemMonitoringIncidentNote({
  required WidgetRef ref,
  required String incidentId,
  required SystemMonitoringNoteRequest request,
}) async {
  final updated = await ref
      .read(systemMonitoringRepositoryProvider)
      .addIncidentNote(id: incidentId, request: request);
  ref.invalidate(systemMonitoringIncidentDetailProvider(incidentId));
  return updated;
}
