import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_config.dart';
import '../domain/operational_metrics_snapshot.dart';
import '../domain/platform_operations_snapshot.dart';
import 'operations_api.dart';

abstract class OperationsRepository {
  Future<PlatformOperationsSnapshot> fetchSnapshot();

  Future<OperationalMetricsSnapshot?> fetchOperationalMetrics();

  bool get usesMockData;
}

class LiveOperationsRepository implements OperationsRepository {
  LiveOperationsRepository(this._api);

  final OperationsApi _api;

  @override
  bool get usesMockData => false;

  @override
  Future<PlatformOperationsSnapshot> fetchSnapshot() => _api.fetchSnapshot();

  @override
  Future<OperationalMetricsSnapshot?> fetchOperationalMetrics() =>
      _api.fetchOperationalMetrics();
}

class MockOperationsRepository implements OperationsRepository {
  @override
  bool get usesMockData => true;

  @override
  Future<PlatformOperationsSnapshot> fetchSnapshot() async {
    return const PlatformOperationsSnapshot(
      companiesTotal: 12,
      companiesActive: 9,
      usersActive: 48,
      usersInvited: 6,
      driversEstimate: 32,
      tripsTotal: 156,
      tripsActive: 24,
      tripsCompleted: 118,
      tripsParked: 4,
      activeSupportGrants: 2,
      expiringSupportGrants: 1,
      pendingPublicIntakes: 3,
      pendingRegistrations: 2,
      documentsTotal: 890,
      packagesGenerated: 45,
      privacyNote: 'Mock metadata only.',
      exchangeRecordsAvailable: true,
    );
  }

  @override
  Future<OperationalMetricsSnapshot?> fetchOperationalMetrics() async {
    return const OperationalMetricsSnapshot(
      metadataOnly: true,
      exchangeRecordsTotal: 18,
      exchangeDisputed: 2,
      exchangeDamaged: 1,
      exchangeMissing: 3,
      pendingSyncCount: null,
      pendingSyncSourceUnavailable: true,
      driversActive: 28,
      driversDisabled: 2,
      driversPending: 2,
    );
  }
}

final operationsRepositoryProvider = Provider<OperationsRepository>((ref) {
  if (AppConfig.instance.shouldUseLiveRepositories) {
    return LiveOperationsRepository(ref.watch(operationsApiProvider));
  }
  return MockOperationsRepository();
});

final platformOperationsSnapshotProvider =
    FutureProvider.autoDispose<PlatformOperationsSnapshot>((ref) {
  return ref.watch(operationsRepositoryProvider).fetchSnapshot();
});

final operationalMetricsProvider =
    FutureProvider.autoDispose<OperationalMetricsSnapshot?>((ref) {
  return ref.watch(operationsRepositoryProvider).fetchOperationalMetrics();
});
