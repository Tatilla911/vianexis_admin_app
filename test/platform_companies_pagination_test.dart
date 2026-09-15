import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/companies/data/platform_companies_repository.dart';
import 'package:vianexis_admin_app/features/companies/domain/company_data_amendment.dart';
import 'package:vianexis_admin_app/features/companies/domain/platform_company.dart';
import 'package:vianexis_admin_app/features/companies/domain/platform_company_member.dart';
import 'package:vianexis_admin_app/features/companies/domain/platform_company_status.dart';
import 'package:vianexis_admin_app/features/companies/domain/platform_company_status_request.dart';
import 'package:vianexis_admin_app/features/companies/domain/platform_company_summary.dart';
import 'package:vianexis_admin_app/features/companies/presentation/platform_companies_providers.dart';

PlatformCompany _company({
  required String id,
  PlatformCompanyStatus status = PlatformCompanyStatus.active,
  String? name,
}) {
  return PlatformCompany(
    id: id,
    name: name ?? 'Company $id',
    country: 'HU',
    status: status,
    createdAt: DateTime.utc(2025, 1, 1),
    activeUsersCount: 1,
    driversCount: 0,
    vehiclesCount: 0,
    trailersCount: 0,
    openSupportTicketsCount: 0,
    activeSupportAccessGrantsCount: 0,
    pendingRegistrationApplicationsCount: 0,
    pendingBulkOnboardingJobsCount: 0,
  );
}

class _PagingCompaniesRepo implements PlatformCompaniesRepository {
  _PagingCompaniesRepo({this.failOnOffset});

  int? failOnOffset;
  final List<
    ({PlatformCompanyStatus? status, String? search, int limit, int offset})
  >
  calls = [];

  late final List<PlatformCompany> _all = [
    for (var i = 0; i < 1000; i++)
      _company(
        id: 'c-$i',
        status: i % 17 == 0
            ? PlatformCompanyStatus.archived
            : PlatformCompanyStatus.active,
        name: 'Company $i ${i % 17 == 0 ? "Archived" : "Active"}',
      ),
  ];

  @override
  bool get usesMockData => true;

  @override
  Future<PlatformCompaniesPage> fetchCompanies({
    PlatformCompanyStatus? status,
    String? search,
    int limit = 50,
    int offset = 0,
  }) async {
    calls.add((status: status, search: search, limit: limit, offset: offset));
    if (failOnOffset != null && offset == failOnOffset) {
      throw StateError('page failed');
    }
    var filtered = _all;
    if (status != null) {
      filtered = filtered
          .where((c) => c.status == status)
          .toList(growable: false);
    }
    final term = search?.trim().toLowerCase();
    if (term != null && term.isNotEmpty) {
      filtered = filtered
          .where((c) => c.matchesSearch(term))
          .toList(growable: false);
    }
    final total = filtered.length;
    final start = offset.clamp(0, total);
    final end = (start + limit).clamp(0, total);
    return PlatformCompaniesPage(
      items: filtered.sublist(start, end),
      total: total,
      limit: limit,
      offset: offset,
    );
  }

  @override
  Future<PlatformCompany> fetchCompany(String id) =>
      Future.value(_all.firstWhere((c) => c.id == id));

  @override
  Future<PlatformCompanyUsersSummary> fetchUsersSummary(String id) {
    throw UnimplementedError();
  }

  @override
  Future<PlatformCompanyMembersPage> listCompanyUsers({
    required String id,
    String? role,
    String? status,
    String? q,
    int limit = 100,
    int offset = 0,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<PlatformCompanySystemSummary> fetchSystemSummary(String id) {
    throw UnimplementedError();
  }

  @override
  Future<PlatformCompanyOnboardingSummary> fetchOnboardingSummary(String id) {
    throw UnimplementedError();
  }

  @override
  Future<PlatformCompany> updateStatus({
    required String id,
    required PlatformCompanyStatusRequest request,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<PlatformCompanyDashboardSummary> fetchDashboardSummary() {
    throw UnimplementedError();
  }

  @override
  Future<CompanyRegistrationSnapshot> fetchRegistrationSnapshot(String id) {
    throw UnimplementedError();
  }

  @override
  Future<List<CompanyDataAmendment>> fetchAmendments(String id) {
    throw UnimplementedError();
  }

  @override
  Future<List<CompanyAmendmentFieldOption>> fetchAmendmentFields(String id) {
    throw UnimplementedError();
  }

  @override
  Future<CompanyDataAmendment> createAmendment({
    required String id,
    required CreateCompanyAmendmentRequest request,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<CompanyDataAmendment> approveAmendment({
    required String companyId,
    required String amendmentId,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<CompanyDataAmendment> rejectAmendment({
    required String companyId,
    required String amendmentId,
    required String rejectionReason,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<CompanyDataAmendment> applyAmendment({
    required String companyId,
    required String amendmentId,
    int? expectedDataVersion,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> resendInvite(String id) {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> sendPasswordSetup(String id) {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> softDelete({
    required String id,
    required String reason,
  }) {
    throw UnimplementedError();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<ProviderContainer> readyContainer(_PagingCompaniesRepo repo) async {
    final container = ProviderContainer(
      overrides: [platformCompaniesRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);
    container.listen(platformCompaniesProvider, (_, _) {});
    await container.read(platformCompaniesProvider.future);
    return container;
  }

  test('A: page 1 loads 50 of 1000+', () async {
    final repo = _PagingCompaniesRepo();
    final container = await readyContainer(repo);
    final state = container.read(platformCompaniesProvider).requireValue;
    expect(state.items, hasLength(50));
    expect(state.total, greaterThanOrEqualTo(1000));
    expect(state.hasMore, isTrue);
    expect(repo.calls.single.offset, 0);
    expect(repo.calls.single.limit, 50);
  });

  test('B: page 2 appends', () async {
    final repo = _PagingCompaniesRepo();
    final container = await readyContainer(repo);
    await container.read(platformCompaniesProvider.notifier).loadMore();
    final state = container.read(platformCompaniesProvider).requireValue;
    expect(state.items, hasLength(100));
    expect(repo.calls.map((c) => c.offset), [0, 50]);
  });

  test('C: no duplicates across pages', () async {
    final repo = _PagingCompaniesRepo();
    final container = await readyContainer(repo);
    await container.read(platformCompaniesProvider.notifier).loadMore();
    final state = container.read(platformCompaniesProvider).requireValue;
    final ids = state.items.map((c) => c.id).toList();
    expect(ids.toSet(), hasLength(ids.length));
  });

  test('D: end state when items.length == total', () async {
    final repo = _PagingCompaniesRepo();
    final container = await readyContainer(repo);
    final notifier = container.read(platformCompaniesProvider.notifier);
    // 1000 / 50 = 20 pages; first already loaded
    for (var i = 0; i < 19; i++) {
      await notifier.loadMore();
    }
    final state = container.read(platformCompaniesProvider).requireValue;
    expect(state.items.length, state.total);
    expect(state.hasMore, isFalse);
    await notifier.loadMore();
    expect(repo.calls.length, 20); // no extra call
  });

  test('E: status change resets to first page only', () async {
    final repo = _PagingCompaniesRepo();
    final container = await readyContainer(repo);
    await container.read(platformCompaniesProvider.notifier).loadMore();
    expect(
      container.read(platformCompaniesProvider).requireValue.items,
      hasLength(100),
    );

    container
        .read(platformCompanyListQueryProvider.notifier)
        .setFilter(PlatformCompanyListFilter.archived);
    await container.read(platformCompaniesProvider.future);
    final state = container.read(platformCompaniesProvider).requireValue;
    expect(state.items.length, lessThanOrEqualTo(50));
    expect(
      state.items.every((c) => c.status == PlatformCompanyStatus.archived),
      isTrue,
    );
    expect(repo.calls.last.offset, 0);
    expect(repo.calls.last.status, PlatformCompanyStatus.archived);
  });

  test('F: search change resets to first page', () async {
    final repo = _PagingCompaniesRepo();
    final container = await readyContainer(repo);
    await container.read(platformCompaniesProvider.notifier).loadMore();
    container
        .read(platformCompanyListQueryProvider.notifier)
        .setSearch('Company 12');
    await container.read(platformCompaniesProvider.future);
    final state = container.read(platformCompaniesProvider).requireValue;
    expect(repo.calls.last.offset, 0);
    expect(repo.calls.last.search, 'Company 12');
    expect(state.items, isNotEmpty);
    expect(state.items.length, lessThanOrEqualTo(50));
  });

  test('G: retry after page failure', () async {
    final repo = _PagingCompaniesRepo(failOnOffset: 50);
    final container = await readyContainer(repo);
    await container.read(platformCompaniesProvider.notifier).loadMore();
    var state = container.read(platformCompaniesProvider).requireValue;
    expect(state.items, hasLength(50));
    expect(state.loadMoreError, isNotNull);
    expect(state.loadingMore, isFalse);

    repo.failOnOffset = null;
    await container.read(platformCompaniesProvider.notifier).loadMore();
    state = container.read(platformCompaniesProvider).requireValue;
    expect(state.loadMoreError, isNull);
    expect(state.items, hasLength(100));
  });

  test('H: archived filter still works (status passed to API)', () async {
    final repo = _PagingCompaniesRepo();
    final container = await readyContainer(repo);
    container
        .read(platformCompanyListQueryProvider.notifier)
        .setFilter(PlatformCompanyListFilter.archived);
    await container.read(platformCompaniesProvider.future);
    expect(repo.calls.last.status, PlatformCompanyStatus.archived);
    final state = container.read(platformCompaniesProvider).requireValue;
    expect(
      state.items.every((c) => c.status == PlatformCompanyStatus.archived),
      isTrue,
    );
  });
}
