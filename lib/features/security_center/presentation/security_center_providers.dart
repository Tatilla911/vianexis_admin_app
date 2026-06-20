import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/security_center_repository.dart';
import '../domain/security_event.dart';
import '../domain/security_event_filter.dart';
import '../domain/security_event_severity.dart';
import '../domain/security_overview.dart';

final securityOverviewProvider =
    AsyncNotifierProvider<SecurityOverviewNotifier, SecurityOverview>(
      SecurityOverviewNotifier.new,
    );

class SecurityOverviewNotifier extends AsyncNotifier<SecurityOverview> {
  @override
  Future<SecurityOverview> build() => _load();

  Future<SecurityOverview> _load() {
    return ref.read(securityCenterRepositoryProvider).fetchOverview();
  }

  Future<void> refresh() async {
    state = const AsyncLoading<SecurityOverview>();
    state = await AsyncValue.guard(_load);
  }
}

final securityEventListQueryProvider =
    NotifierProvider<SecurityEventListQueryNotifier, SecurityEventListQuery>(
      SecurityEventListQueryNotifier.new,
    );

class SecurityEventListQueryNotifier extends Notifier<SecurityEventListQuery> {
  @override
  SecurityEventListQuery build() => const SecurityEventListQuery();

  void setSearch(String value) {
    state = state.copyWith(search: value);
  }

  void setFilter(SecurityEventFilter filter) {
    state = state.copyWith(filter: filter);
  }
}

final securityEventsProvider =
    AsyncNotifierProvider<SecurityEventsNotifier, List<SecurityEvent>>(
      SecurityEventsNotifier.new,
    );

class SecurityEventsNotifier extends AsyncNotifier<List<SecurityEvent>> {
  @override
  Future<List<SecurityEvent>> build() => _load();

  Future<List<SecurityEvent>> _load() {
    return ref.read(securityCenterRepositoryProvider).fetchEvents();
  }

  Future<void> refresh() async {
    state = const AsyncLoading<List<SecurityEvent>>();
    state = await AsyncValue.guard(_load);
  }
}

List<SecurityEvent> filteredSecurityEvents({
  required List<SecurityEvent> items,
  required SecurityEventListQuery query,
}) {
  return items
      .where((event) {
        final filter = query.filter;
        if (filter == SecurityEventFilter.all) return true;
        if (filter == SecurityEventFilter.critical) {
          return event.severity == SecurityEventSeverity.critical;
        }
        if (filter == SecurityEventFilter.warning) {
          return event.severity == SecurityEventSeverity.warning;
        }
        final type = filter.typeForApi();
        return type != null && event.type == type;
      })
      .where((event) => event.matchesSearch(query.search))
      .toList(growable: false);
}

final filteredSecurityEventsProvider =
    Provider<AsyncValue<List<SecurityEvent>>>((ref) {
      final query = ref.watch(securityEventListQueryProvider);
      final events = ref.watch(securityEventsProvider);
      return events.whenData(
        (items) => filteredSecurityEvents(items: items, query: query),
      );
    });

final securityEventDetailProvider =
    Provider.autoDispose.family<SecurityEvent?, String>((ref, eventId) {
      final events = ref.watch(securityEventsProvider);
      return events.maybeWhen(
        data: (items) {
          for (final event in items) {
            if (event.id == eventId) return event;
          }
          return null;
        },
        orElse: () => null,
      );
    });

Future<void> refreshSecurityCenter(WidgetRef ref) async {
  await Future.wait([
    ref.read(securityOverviewProvider.notifier).refresh(),
    ref.read(securityEventsProvider.notifier).refresh(),
  ]);
}
