import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/driver_access/data/driver_access_repository.dart';
import 'package:vianexis_admin_app/features/driver_access/domain/driver_access_profile.dart';
import 'package:vianexis_admin_app/features/driver_access/domain/driver_device_notification_status.dart';
import 'package:vianexis_admin_app/features/driver_access/domain/driver_operational_health_detail.dart';

DriverAccessProfile _driver({
  required String id,
  DriverRegistrationStatus status = DriverRegistrationStatus.active,
  String? name,
}) {
  return DriverAccessProfile(
    id: id,
    displayName: name ?? 'Driver $id',
    companyName: 'Fleet Co',
    companyId: '1',
    registrationStatus: status,
  );
}

class _PagingDriversRepo implements DriverAccessRepository {
  _PagingDriversRepo({this.failOnOffset});

  int? failOnOffset;
  final List<({String? status, String? q, int limit, int offset})> calls = [];

  late final List<DriverAccessProfile> _all = [
    for (var i = 0; i < 1000; i++) _driver(id: 'd-$i', name: 'Driver $i'),
    for (var i = 0; i < 40; i++)
      _driver(
        id: 'disabled-$i',
        status: DriverRegistrationStatus.disabled,
        name: 'Disabled $i',
      ),
  ];

  @override
  bool get usesMockData => true;

  @override
  Future<DriverAccessListResult> listDrivers({
    String? status,
    String? q,
    int limit = 50,
    int offset = 0,
  }) async {
    calls.add((status: status, q: q, limit: limit, offset: offset));
    if (failOnOffset != null && offset == failOnOffset) {
      throw StateError('page failed');
    }
    var items = List<DriverAccessProfile>.from(_all);
    final statusFilter = status?.trim().toLowerCase();
    if (statusFilter != null && statusFilter.isNotEmpty) {
      items = items
          .where((d) {
            if (statusFilter == 'operational') {
              return d.registrationStatus != DriverRegistrationStatus.disabled;
            }
            return d.registrationStatus ==
                DriverRegistrationStatus.fromBackend(statusFilter);
          })
          .toList(growable: false);
    }
    final term = q?.trim().toLowerCase() ?? '';
    if (term.isNotEmpty) {
      items = items
          .where((d) => d.displayName.toLowerCase().contains(term))
          .toList(growable: false);
    }
    final total = items.length;
    final start = offset.clamp(0, total);
    final end = (start + limit).clamp(0, total);
    return DriverAccessListResult(
      items: items.sublist(start, end),
      total: total,
      listEndpointReady: true,
      metadataOnly: true,
    );
  }

  @override
  Future<DriverAccessProfile?> fetchDriver(String driverProfileId) async {
    for (final item in _all) {
      if (item.id == driverProfileId) return item;
    }
    return null;
  }

  @override
  Future<void> patchDriverStatus(
    String driverProfileId, {
    required String status,
    String? reason,
  }) async {}

  @override
  Future<Map<String, dynamic>> resendInvite(String driverProfileId) async =>
      const <String, dynamic>{};

  @override
  Future<Map<String, dynamic>> sendPasswordSetup(
    String driverProfileId,
  ) async => const <String, dynamic>{};

  @override
  Future<Map<String, dynamic>> softDelete({
    required String driverProfileId,
    required String reason,
  }) async => const <String, dynamic>{};

  @override
  Future<DriverDeviceNotificationStatus?> fetchDeviceNotificationStatus(
    String driverProfileId,
  ) async => null;

  @override
  Future<DriverOperationalHealthDetail?> fetchOperationalHealth(
    String driverProfileId,
  ) async => null;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<ProviderContainer> readyContainer(_PagingDriversRepo repo) async {
    final container = ProviderContainer(
      overrides: [driverAccessRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);
    container.listen(driverAccessListProvider, (_, _) {});
    await container.read(driverAccessListProvider.future);
    return container;
  }

  test('A: page 1 loads 50 of 1000+', () async {
    final repo = _PagingDriversRepo();
    final container = await readyContainer(repo);
    final state = container.read(driverAccessListProvider).requireValue;
    expect(state.items, hasLength(50));
    expect(state.total, 1000);
    expect(repo.calls.single.status, 'operational');
    expect(state.hasMore, isTrue);
    expect(state.listEndpointReady, isTrue);
    expect(repo.calls.single.offset, 0);
    expect(repo.calls.single.limit, 50);
  });

  test('B: page 2 appends', () async {
    final repo = _PagingDriversRepo();
    final container = await readyContainer(repo);
    await container.read(driverAccessListProvider.notifier).loadMore();
    final state = container.read(driverAccessListProvider).requireValue;
    expect(state.items, hasLength(100));
    expect(repo.calls.map((c) => c.offset), [0, 50]);
  });

  test('C: no duplicates across pages', () async {
    final repo = _PagingDriversRepo();
    final container = await readyContainer(repo);
    await container.read(driverAccessListProvider.notifier).loadMore();
    final ids = container
        .read(driverAccessListProvider)
        .requireValue
        .items
        .map((d) => d.id)
        .toList();
    expect(ids.toSet(), hasLength(ids.length));
  });

  test('D: end state when items.length == total', () async {
    final repo = _PagingDriversRepo();
    final container = await readyContainer(repo);
    final notifier = container.read(driverAccessListProvider.notifier);
    for (var i = 0; i < 19; i++) {
      await notifier.loadMore();
    }
    final state = container.read(driverAccessListProvider).requireValue;
    expect(state.items.length, state.total);
    expect(state.hasMore, isFalse);
    await notifier.loadMore();
    expect(repo.calls.length, 20);
  });

  test('E: status filter change resets to first page', () async {
    final repo = _PagingDriversRepo();
    final container = await readyContainer(repo);
    await container.read(driverAccessListProvider.notifier).loadMore();
    container
        .read(driverAccessListQueryProvider.notifier)
        .setFilter(DriverAccessListFilter.disabled);
    await container.read(driverAccessListProvider.future);
    final state = container.read(driverAccessListProvider).requireValue;
    expect(state.items.length, lessThanOrEqualTo(50));
    expect(
      state.items.every(
        (d) => d.registrationStatus == DriverRegistrationStatus.disabled,
      ),
      isTrue,
    );
    expect(repo.calls.last.offset, 0);
    expect(repo.calls.last.status, 'disabled');
  });

  test('F: search change resets to first page', () async {
    final repo = _PagingDriversRepo();
    final container = await readyContainer(repo);
    await container.read(driverAccessListProvider.notifier).loadMore();
    container
        .read(driverAccessListQueryProvider.notifier)
        .setSearch('Driver 12');
    await container.read(driverAccessListProvider.future);
    expect(repo.calls.last.offset, 0);
    expect(repo.calls.last.q, 'Driver 12');
    final state = container.read(driverAccessListProvider).requireValue;
    expect(state.items.length, lessThanOrEqualTo(50));
  });

  test('G: retry after page failure', () async {
    final repo = _PagingDriversRepo(failOnOffset: 50);
    final container = await readyContainer(repo);
    await container.read(driverAccessListProvider.notifier).loadMore();
    var state = container.read(driverAccessListProvider).requireValue;
    expect(state.items, hasLength(50));
    expect(state.loadMoreError, isNotNull);

    repo.failOnOffset = null;
    await container.read(driverAccessListProvider.notifier).loadMore();
    state = container.read(driverAccessListProvider).requireValue;
    expect(state.loadMoreError, isNull);
    expect(state.items, hasLength(100));
  });

  test('H: disabled filter still passes status to API', () async {
    final repo = _PagingDriversRepo();
    final container = await readyContainer(repo);
    container
        .read(driverAccessListQueryProvider.notifier)
        .setFilter(DriverAccessListFilter.disabled);
    await container.read(driverAccessListProvider.future);
    expect(repo.calls.last.status, 'disabled');
  });
}
