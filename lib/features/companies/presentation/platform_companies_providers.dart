import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/admin_user.dart';
import '../data/platform_companies_repository.dart';
import '../domain/platform_company.dart';
import '../domain/platform_company_status.dart';
import '../domain/platform_company_status_request.dart';
import '../domain/platform_company_summary.dart';

extension AdminRolePlatformCompanyDecisions on AdminRole {
  bool get canChangePlatformCompanyStatus => this == AdminRole.superAdmin;
}

class PlatformCompanyListQuery {
  const PlatformCompanyListQuery({
    this.search = '',
    this.filter = PlatformCompanyListFilter.all,
  });

  final String search;
  final PlatformCompanyListFilter filter;

  PlatformCompanyListQuery copyWith({
    String? search,
    PlatformCompanyListFilter? filter,
  }) {
    return PlatformCompanyListQuery(
      search: search ?? this.search,
      filter: filter ?? this.filter,
    );
  }

  PlatformCompanyStatus? statusForApi() {
    return switch (filter) {
      PlatformCompanyListFilter.all => null,
      PlatformCompanyListFilter.active => PlatformCompanyStatus.active,
      PlatformCompanyListFilter.pendingReview => PlatformCompanyStatus.pendingReview,
      PlatformCompanyListFilter.suspended => PlatformCompanyStatus.suspended,
      PlatformCompanyListFilter.disabled => PlatformCompanyStatus.disabled,
    };
  }
}

final platformCompanyListQueryProvider =
    NotifierProvider<PlatformCompanyListQueryNotifier, PlatformCompanyListQuery>(
      PlatformCompanyListQueryNotifier.new,
    );

class PlatformCompanyListQueryNotifier extends Notifier<PlatformCompanyListQuery> {
  @override
  PlatformCompanyListQuery build() => const PlatformCompanyListQuery();

  void setSearch(String value) {
    state = state.copyWith(search: value);
  }

  void setFilter(PlatformCompanyListFilter filter) {
    state = state.copyWith(filter: filter);
  }
}

final platformCompaniesProvider =
    AsyncNotifierProvider<PlatformCompaniesNotifier, List<PlatformCompany>>(
      PlatformCompaniesNotifier.new,
    );

class PlatformCompaniesNotifier extends AsyncNotifier<List<PlatformCompany>> {
  @override
  Future<List<PlatformCompany>> build() => _load();

  Future<List<PlatformCompany>> _load() {
    return ref.read(platformCompaniesRepositoryProvider).fetchCompanies();
  }

  Future<void> refresh() async {
    state = const AsyncLoading<List<PlatformCompany>>();
    state = await AsyncValue.guard(_load);
  }
}

List<PlatformCompany> filteredPlatformCompanies({
  required List<PlatformCompany> items,
  required PlatformCompanyListQuery query,
}) {
  return items
      .where((item) => item.matchesFilter(query.filter))
      .where((item) => item.matchesSearch(query.search))
      .toList(growable: false);
}

final filteredPlatformCompaniesProvider =
    Provider<AsyncValue<List<PlatformCompany>>>((ref) {
      final query = ref.watch(platformCompanyListQueryProvider);
      final companies = ref.watch(platformCompaniesProvider);
      return companies.whenData(
        (items) => filteredPlatformCompanies(items: items, query: query),
      );
    });

final platformCompanyDetailProvider =
    FutureProvider.autoDispose.family<PlatformCompany, String>((ref, id) {
      return ref.watch(platformCompaniesRepositoryProvider).fetchCompany(id);
    });

final platformCompanyUsersSummaryProvider = FutureProvider.autoDispose
    .family<PlatformCompanyUsersSummary, String>((ref, id) {
      return ref.watch(platformCompaniesRepositoryProvider).fetchUsersSummary(id);
    });

final platformCompanySystemSummaryProvider = FutureProvider.autoDispose
    .family<PlatformCompanySystemSummary, String>((ref, id) {
      return ref.watch(platformCompaniesRepositoryProvider).fetchSystemSummary(id);
    });

final platformCompanyOnboardingSummaryProvider = FutureProvider.autoDispose
    .family<PlatformCompanyOnboardingSummary, String>((ref, id) {
      return ref
          .watch(platformCompaniesRepositoryProvider)
          .fetchOnboardingSummary(id);
    });

final platformCompanyDashboardSummaryProvider =
    AsyncNotifierProvider<PlatformCompanyDashboardSummaryNotifier,
        PlatformCompanyDashboardSummary>(
      PlatformCompanyDashboardSummaryNotifier.new,
    );

class PlatformCompanyDashboardSummaryNotifier
    extends AsyncNotifier<PlatformCompanyDashboardSummary> {
  @override
  Future<PlatformCompanyDashboardSummary> build() => _load();

  Future<PlatformCompanyDashboardSummary> _load() {
    return ref.read(platformCompaniesRepositoryProvider).fetchDashboardSummary();
  }

  Future<void> refresh() async {
    state = const AsyncLoading<PlatformCompanyDashboardSummary>();
    state = await AsyncValue.guard(_load);
  }
}

Future<PlatformCompany> submitPlatformCompanyStatusChange(
  WidgetRef ref, {
  required String companyId,
  required PlatformCompanyStatusRequest request,
}) async {
  final updated = await ref.read(platformCompaniesRepositoryProvider).updateStatus(
    id: companyId,
    request: request,
  );
  ref.invalidate(platformCompanyDetailProvider(companyId));
  ref.invalidate(platformCompanyUsersSummaryProvider(companyId));
  ref.invalidate(platformCompanySystemSummaryProvider(companyId));
  ref.invalidate(platformCompanyOnboardingSummaryProvider(companyId));
  await ref.read(platformCompaniesProvider.notifier).refresh();
  await ref.read(platformCompanyDashboardSummaryProvider.notifier).refresh();
  return updated;
}
