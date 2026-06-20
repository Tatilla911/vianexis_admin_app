import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/platform_audit_logs_repository.dart';
import '../domain/platform_audit_filter.dart';
import '../domain/platform_audit_log_query.dart';
import '../domain/platform_audit_log.dart';

final platformAuditLogListQueryProvider =
    NotifierProvider<PlatformAuditLogListQueryNotifier, PlatformAuditLogListQuery>(
      PlatformAuditLogListQueryNotifier.new,
    );

class PlatformAuditLogListQueryNotifier extends Notifier<PlatformAuditLogListQuery> {
  @override
  PlatformAuditLogListQuery build() => const PlatformAuditLogListQuery();

  void setSearch(String value) => state = state.copyWith(search: value);

  void setFilter(PlatformAuditLogFilter filter) {
    state = state.copyWith(filter: filter);
    ref.invalidate(platformAuditLogsProvider);
  }

  void setDateRange(DateTime? from, DateTime? to) {
    state = state.copyWith(dateFrom: from, dateTo: to);
    ref.invalidate(platformAuditLogsProvider);
  }

  void clearDateRange() {
    state = state.copyWith(clearDateFrom: true, clearDateTo: true);
    ref.invalidate(platformAuditLogsProvider);
  }
}

final platformAuditLogsProvider =
    AsyncNotifierProvider<PlatformAuditLogsNotifier, List<PlatformAuditLog>>(
      PlatformAuditLogsNotifier.new,
    );

class PlatformAuditLogsNotifier extends AsyncNotifier<List<PlatformAuditLog>> {
  @override
  Future<List<PlatformAuditLog>> build() => _load();

  Future<List<PlatformAuditLog>> _load() {
    final query = ref.read(platformAuditLogListQueryProvider);
    return ref.read(platformAuditLogsRepositoryProvider).fetchLogs(query: query);
  }

  Future<void> refresh() async {
    state = const AsyncLoading<List<PlatformAuditLog>>();
    state = await AsyncValue.guard(_load);
  }
}

List<PlatformAuditLog> filteredPlatformAuditLogs({
  required List<PlatformAuditLog> items,
  required PlatformAuditLogListQuery query,
}) {
  return items
      .where((item) => item.matchesFilter(query.filter))
      .where((item) => item.matchesSearch(query.search))
      .where((item) => item.matchesDateRange(query.dateFrom, query.dateTo))
      .toList(growable: false);
}

final filteredPlatformAuditLogsProvider =
    Provider<AsyncValue<List<PlatformAuditLog>>>((ref) {
      final query = ref.watch(platformAuditLogListQueryProvider);
      final logs = ref.watch(platformAuditLogsProvider);
      return logs.whenData(
        (items) => filteredPlatformAuditLogs(items: items, query: query),
      );
    });

final platformAuditLogDetailProvider =
    FutureProvider.autoDispose.family<PlatformAuditLog, String>((ref, id) {
      return ref.read(platformAuditLogsRepositoryProvider).fetchLog(id);
    });

final platformAuditLogSummaryProvider =
    AsyncNotifierProvider<PlatformAuditLogSummaryNotifier, PlatformAuditLogSummary>(
      PlatformAuditLogSummaryNotifier.new,
    );

class PlatformAuditLogSummaryNotifier extends AsyncNotifier<PlatformAuditLogSummary> {
  @override
  Future<PlatformAuditLogSummary> build() => _load();

  Future<PlatformAuditLogSummary> _load() async {
    final logs = await ref.read(platformAuditLogsRepositoryProvider).fetchLogs();
    return PlatformAuditLogSummary.fromLogs(logs);
  }

  Future<void> refresh() async {
    state = const AsyncLoading<PlatformAuditLogSummary>();
    state = await AsyncValue.guard(_load);
  }
}

Future<void> refreshPlatformAuditLogDetail(WidgetRef ref, String logId) async {
  ref.invalidate(platformAuditLogDetailProvider(logId));
}
