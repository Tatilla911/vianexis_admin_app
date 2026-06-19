import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/admin_user.dart';
import '../data/bulk_onboarding_repository.dart';
import '../domain/bulk_onboarding_action_request.dart';
import '../domain/bulk_onboarding_dashboard_summary.dart';
import '../domain/bulk_onboarding_job.dart';
import '../domain/bulk_onboarding_row.dart';
import '../domain/bulk_onboarding_row_status.dart';

extension AdminRoleBulkOnboardingDecisions on AdminRole {
  bool get canDecideBulkOnboarding {
    return this == AdminRole.superAdmin ||
        this == AdminRole.onboardingReviewer;
  }

  bool get canUploadBulkOnboarding => canDecideBulkOnboarding;
}

class BulkOnboardingListQuery {
  const BulkOnboardingListQuery({
    this.search = '',
    this.filter = BulkOnboardingListFilter.all,
  });

  final String search;
  final BulkOnboardingListFilter filter;

  BulkOnboardingListQuery copyWith({
    String? search,
    BulkOnboardingListFilter? filter,
  }) {
    return BulkOnboardingListQuery(
      search: search ?? this.search,
      filter: filter ?? this.filter,
    );
  }
}

final bulkOnboardingListQueryProvider =
    NotifierProvider<BulkOnboardingListQueryNotifier, BulkOnboardingListQuery>(
      BulkOnboardingListQueryNotifier.new,
    );

class BulkOnboardingListQueryNotifier extends Notifier<BulkOnboardingListQuery> {
  @override
  BulkOnboardingListQuery build() => const BulkOnboardingListQuery();

  void setSearch(String value) {
    state = state.copyWith(search: value);
  }

  void setFilter(BulkOnboardingListFilter filter) {
    state = state.copyWith(filter: filter);
  }
}

final bulkOnboardingJobsProvider =
    AsyncNotifierProvider<BulkOnboardingJobsNotifier, List<BulkOnboardingJob>>(
      BulkOnboardingJobsNotifier.new,
    );

class BulkOnboardingJobsNotifier extends AsyncNotifier<List<BulkOnboardingJob>> {
  @override
  Future<List<BulkOnboardingJob>> build() => _load();

  Future<List<BulkOnboardingJob>> _load() {
    return ref.read(bulkOnboardingRepositoryProvider).fetchJobs();
  }

  Future<void> refresh() async {
    state = const AsyncLoading<List<BulkOnboardingJob>>();
    state = await AsyncValue.guard(_load);
  }
}

List<BulkOnboardingJob> filteredBulkOnboardingJobs({
  required List<BulkOnboardingJob> items,
  required BulkOnboardingListQuery query,
}) {
  return items
      .where((item) => item.matchesFilter(query.filter))
      .where((item) => item.matchesSearch(query.search))
      .toList(growable: false);
}

final filteredBulkOnboardingJobsProvider =
    Provider<AsyncValue<List<BulkOnboardingJob>>>((ref) {
      final query = ref.watch(bulkOnboardingListQueryProvider);
      final jobs = ref.watch(bulkOnboardingJobsProvider);
      return jobs.whenData(
        (items) => filteredBulkOnboardingJobs(items: items, query: query),
      );
    });

final bulkOnboardingJobDetailProvider =
    FutureProvider.autoDispose.family<BulkOnboardingJob, String>((ref, id) {
      return ref.watch(bulkOnboardingRepositoryProvider).fetchJob(id);
    });

final bulkOnboardingRowsProvider = FutureProvider.autoDispose
    .family<List<BulkOnboardingRow>, ({String jobId, BulkOnboardingRowStatus? status, String search})>(
      (ref, query) {
        return ref.watch(bulkOnboardingRepositoryProvider).fetchRows(
          query.jobId,
          status: query.status,
          search: query.search.trim().isEmpty ? null : query.search.trim(),
        );
      },
    );

final bulkOnboardingSummaryProvider =
    AsyncNotifierProvider<BulkOnboardingSummaryNotifier, BulkOnboardingDashboardSummary>(
      BulkOnboardingSummaryNotifier.new,
    );

class BulkOnboardingSummaryNotifier
    extends AsyncNotifier<BulkOnboardingDashboardSummary> {
  @override
  Future<BulkOnboardingDashboardSummary> build() => _load();

  Future<BulkOnboardingDashboardSummary> _load() {
    return ref.read(bulkOnboardingRepositoryProvider).fetchDashboardSummary();
  }

  Future<void> refresh() async {
    state = const AsyncLoading<BulkOnboardingDashboardSummary>();
    state = await AsyncValue.guard(_load);
  }
}

Future<void> submitBulkOnboardingAction(
  WidgetRef ref, {
  required String jobId,
  required BulkOnboardingActionRequest request,
}) async {
  await ref.read(bulkOnboardingRepositoryProvider).submitAction(
    jobId: jobId,
    request: request,
  );
  ref.invalidate(bulkOnboardingJobDetailProvider(jobId));
  ref.invalidate(
    bulkOnboardingRowsProvider((
      jobId: jobId,
      status: null,
      search: '',
    )),
  );
  await ref.read(bulkOnboardingJobsProvider.notifier).refresh();
  await ref.read(bulkOnboardingSummaryProvider.notifier).refresh();
}
