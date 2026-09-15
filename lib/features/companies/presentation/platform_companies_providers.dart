import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/admin_user.dart';
import '../data/platform_companies_repository.dart';
import '../domain/company_data_amendment.dart';
import '../domain/platform_company.dart';
import '../domain/platform_company_member.dart';
import '../domain/platform_company_status.dart';
import '../domain/platform_company_status_request.dart';
import '../domain/platform_company_summary.dart';

extension AdminRolePlatformCompanyDecisions on AdminRole {
  bool get canChangePlatformCompanyStatus => this == AdminRole.superAdmin;

  /// Invite / password-setup for company primary admin (platform staff).
  bool get canManageCompanyInviteOps =>
      this == AdminRole.superAdmin ||
      this == AdminRole.onboardingReviewer ||
      this == AdminRole.supportAdmin ||
      this == AdminRole.billingAdmin;

  /// Soft-delete / archive company (super_admin only).
  bool get canArchivePlatformCompany => this == AdminRole.superAdmin;

  bool get canInitiateCompanyDataAmendment =>
      this == AdminRole.superAdmin ||
      this == AdminRole.onboardingReviewer ||
      this == AdminRole.supportAdmin ||
      this == AdminRole.billingAdmin;

  bool get canApproveCompanyDataAmendment => this == AdminRole.superAdmin;

  bool get canApplyCompanyDataAmendment =>
      this == AdminRole.superAdmin || this == AdminRole.onboardingReviewer;
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
      PlatformCompanyListFilter.pendingReview =>
        PlatformCompanyStatus.pendingReview,
      PlatformCompanyListFilter.suspended => PlatformCompanyStatus.suspended,
      PlatformCompanyListFilter.disabled => PlatformCompanyStatus.disabled,
      PlatformCompanyListFilter.archived => PlatformCompanyStatus.archived,
    };
  }
}

final platformCompanyListQueryProvider =
    NotifierProvider<
      PlatformCompanyListQueryNotifier,
      PlatformCompanyListQuery
    >(PlatformCompanyListQueryNotifier.new);

class PlatformCompanyListQueryNotifier
    extends Notifier<PlatformCompanyListQuery> {
  @override
  PlatformCompanyListQuery build() => const PlatformCompanyListQuery();

  void setSearch(String value) {
    state = state.copyWith(search: value);
  }

  void setFilter(PlatformCompanyListFilter filter) {
    state = state.copyWith(filter: filter);
  }
}

class PlatformCompaniesListState {
  const PlatformCompaniesListState({
    required this.items,
    required this.total,
    this.loadingMore = false,
    this.loadMoreError,
  });

  final List<PlatformCompany> items;
  final int total;
  final bool loadingMore;
  final Object? loadMoreError;

  bool get hasMore => items.length < total;

  PlatformCompaniesListState copyWith({
    List<PlatformCompany>? items,
    int? total,
    bool? loadingMore,
    Object? loadMoreError = _sentinel,
  }) {
    return PlatformCompaniesListState(
      items: items ?? this.items,
      total: total ?? this.total,
      loadingMore: loadingMore ?? this.loadingMore,
      loadMoreError: identical(loadMoreError, _sentinel)
          ? this.loadMoreError
          : loadMoreError,
    );
  }
}

const Object _sentinel = Object();

const int kPlatformCompaniesPageSize = 50;

final platformCompaniesProvider =
    AsyncNotifierProvider<
      PlatformCompaniesNotifier,
      PlatformCompaniesListState
    >(PlatformCompaniesNotifier.new);

class PlatformCompaniesNotifier
    extends AsyncNotifier<PlatformCompaniesListState> {
  @override
  Future<PlatformCompaniesListState> build() {
    ref.watch(platformCompanyListQueryProvider);
    return _loadFirstPage();
  }

  Future<PlatformCompaniesListState> _loadFirstPage() async {
    final query = ref.read(platformCompanyListQueryProvider);
    final search = query.search.trim();
    final page = await ref
        .read(platformCompaniesRepositoryProvider)
        .fetchCompanies(
          status: query.statusForApi(),
          search: search.isEmpty ? null : search,
          limit: kPlatformCompaniesPageSize,
          offset: 0,
        );
    return PlatformCompaniesListState(items: page.items, total: page.total);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_loadFirstPage);
  }

  Future<void> loadMore() async {
    final current = state.asData?.value;
    if (current == null || current.loadingMore || !current.hasMore) {
      return;
    }

    state = AsyncData(current.copyWith(loadingMore: true, loadMoreError: null));
    final queryAtStart = ref.read(platformCompanyListQueryProvider);
    try {
      final search = queryAtStart.search.trim();
      final page = await ref
          .read(platformCompaniesRepositoryProvider)
          .fetchCompanies(
            status: queryAtStart.statusForApi(),
            search: search.isEmpty ? null : search,
            limit: kPlatformCompaniesPageSize,
            offset: current.items.length,
          );
      final queryNow = ref.read(platformCompanyListQueryProvider);
      if (queryNow.search != queryAtStart.search ||
          queryNow.filter != queryAtStart.filter) {
        return;
      }
      final seen = {for (final item in current.items) item.id};
      final merged = [
        ...current.items,
        for (final item in page.items)
          if (!seen.contains(item.id)) item,
      ];
      state = AsyncData(
        PlatformCompaniesListState(items: merged, total: page.total),
      );
    } catch (error) {
      final queryNow = ref.read(platformCompanyListQueryProvider);
      if (queryNow.search != queryAtStart.search ||
          queryNow.filter != queryAtStart.filter) {
        return;
      }
      state = AsyncData(
        current.copyWith(loadingMore: false, loadMoreError: error),
      );
    }
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

/// Exposes list items from the paged notifier (filters already applied server-side).
final filteredPlatformCompaniesProvider =
    Provider<AsyncValue<List<PlatformCompany>>>((ref) {
      return ref
          .watch(platformCompaniesProvider)
          .whenData((state) => state.items);
    });

final platformCompanyDetailProvider = FutureProvider.autoDispose
    .family<PlatformCompany, String>((ref, id) {
      return ref.watch(platformCompaniesRepositoryProvider).fetchCompany(id);
    });

final platformCompanyUsersSummaryProvider = FutureProvider.autoDispose
    .family<PlatformCompanyUsersSummary, String>((ref, id) {
      return ref
          .watch(platformCompaniesRepositoryProvider)
          .fetchUsersSummary(id);
    });

final platformCompanyMembersProvider = FutureProvider.autoDispose
    .family<PlatformCompanyMembersPage, PlatformCompanyMembersQuery>((
      ref,
      query,
    ) async {
      final page = await ref
          .watch(platformCompaniesRepositoryProvider)
          .listCompanyUsers(
            id: query.companyId,
            role: query.roleFilter.apiRole,
            limit: 200,
          );
      if (query.roleFilter == PlatformCompanyMemberRoleFilter.all ||
          query.roleFilter.apiRole != null) {
        return page;
      }
      final filtered = page.items
          .where(query.roleFilter.matches)
          .toList(growable: false);
      return PlatformCompanyMembersPage(
        companyId: page.companyId,
        items: filtered,
        total: filtered.length,
        limit: page.limit,
        offset: page.offset,
        metadataOnly: page.metadataOnly,
      );
    });

final platformCompanySystemSummaryProvider = FutureProvider.autoDispose
    .family<PlatformCompanySystemSummary, String>((ref, id) {
      return ref
          .watch(platformCompaniesRepositoryProvider)
          .fetchSystemSummary(id);
    });

final platformCompanyOnboardingSummaryProvider = FutureProvider.autoDispose
    .family<PlatformCompanyOnboardingSummary, String>((ref, id) {
      return ref
          .watch(platformCompaniesRepositoryProvider)
          .fetchOnboardingSummary(id);
    });

final platformCompanyRegistrationSnapshotProvider = FutureProvider.autoDispose
    .family<CompanyRegistrationSnapshot, String>((ref, id) {
      return ref
          .watch(platformCompaniesRepositoryProvider)
          .fetchRegistrationSnapshot(id);
    });

final platformCompanyAmendmentsProvider = FutureProvider.autoDispose
    .family<List<CompanyDataAmendment>, String>((ref, id) {
      return ref.watch(platformCompaniesRepositoryProvider).fetchAmendments(id);
    });

final platformCompanyAmendmentFieldsProvider = FutureProvider.autoDispose
    .family<List<CompanyAmendmentFieldOption>, String>((ref, id) {
      return ref
          .watch(platformCompaniesRepositoryProvider)
          .fetchAmendmentFields(id);
    });

final platformCompanyDashboardSummaryProvider =
    AsyncNotifierProvider<
      PlatformCompanyDashboardSummaryNotifier,
      PlatformCompanyDashboardSummary
    >(PlatformCompanyDashboardSummaryNotifier.new);

class PlatformCompanyDashboardSummaryNotifier
    extends AsyncNotifier<PlatformCompanyDashboardSummary> {
  @override
  Future<PlatformCompanyDashboardSummary> build() => _load();

  Future<PlatformCompanyDashboardSummary> _load() {
    return ref
        .read(platformCompaniesRepositoryProvider)
        .fetchDashboardSummary();
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
  final updated = await ref
      .read(platformCompaniesRepositoryProvider)
      .updateStatus(id: companyId, request: request);
  ref.invalidate(platformCompanyDetailProvider(companyId));
  ref.invalidate(platformCompanyUsersSummaryProvider(companyId));
  ref.invalidate(platformCompanySystemSummaryProvider(companyId));
  ref.invalidate(platformCompanyOnboardingSummaryProvider(companyId));
  for (final filter in PlatformCompanyMemberRoleFilter.values) {
    ref.invalidate(
      platformCompanyMembersProvider(
        PlatformCompanyMembersQuery(companyId: companyId, roleFilter: filter),
      ),
    );
  }
  await ref.read(platformCompaniesProvider.notifier).refresh();
  await ref.read(platformCompanyDashboardSummaryProvider.notifier).refresh();
  return updated;
}
