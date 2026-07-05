import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_config.dart';
import '../domain/platform_operations_snapshot.dart';
import 'operations_api.dart';

abstract class OperationsRepository {
  Future<PlatformOperationsSnapshot> fetchSnapshot();

  bool get usesMockData;
}

class LiveOperationsRepository implements OperationsRepository {
  LiveOperationsRepository(this._api);

  final OperationsApi _api;

  @override
  bool get usesMockData => false;

  @override
  Future<PlatformOperationsSnapshot> fetchSnapshot() => _api.fetchSnapshot();
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
      exchangeRecordsAvailable: false,
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
