import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../domain/release_overview.dart';
import 'release_center_api.dart';

abstract class ReleaseCenterRepository {
  Future<ReleaseOverview> fetchOverview();

  Future<ReleaseAppVersions> fetchAppVersions();

  Future<ReleaseEnvironment> fetchEnvironment();

  bool get usesMockData;
}

class LiveReleaseCenterRepository implements ReleaseCenterRepository {
  LiveReleaseCenterRepository(this._api);

  final ReleaseCenterApi _api;

  @override
  bool get usesMockData => false;

  @override
  Future<ReleaseOverview> fetchOverview() => _api.getOverview();

  @override
  Future<ReleaseAppVersions> fetchAppVersions() => _api.getAppVersions();

  @override
  Future<ReleaseEnvironment> fetchEnvironment() => _api.getEnvironment();
}

class MockReleaseCenterRepository implements ReleaseCenterRepository {
  MockReleaseCenterRepository();

  @override
  bool get usesMockData => true;

  @override
  Future<ReleaseOverview> fetchOverview() async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return ReleaseOverview(
      backendVersion: '1.4.2',
      backendCommit: 'abc1234',
      environment: 'development',
      nodeEnv: 'development',
      databaseMigrationStatus: 'up_to_date',
      latestAdminAppVersion: '0.9.0',
      latestDriverAppVersion: '2.1.0',
      minimumSupportedDriverAppVersion: '2.0.0',
      minimumSupportedAdminAppVersion: '0.8.0',
      activeDriverAppVersions: const {'2.1.0': 42, '2.0.5': 8},
      activeAdminAppVersions: const {'0.9.0': 5, '0.8.2': 2},
      lastDeploymentAt: DateTime.utc(2026, 6, 10, 18, 0),
      maintenanceMode: false,
      apiBaseUrlPublicName: 'api-dev.vianexis.test',
    );
  }

  @override
  Future<ReleaseAppVersions> fetchAppVersions() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return const ReleaseAppVersions(
      latestAdminAppVersion: '0.9.0',
      latestDriverAppVersion: '2.1.0',
      minimumSupportedDriverAppVersion: '2.0.0',
      minimumSupportedAdminAppVersion: '0.8.0',
      activeDriverAppVersions: {'2.1.0': 42, '2.0.5': 8},
      activeAdminAppVersions: {'0.9.0': 5, '0.8.2': 2},
    );
  }

  @override
  Future<ReleaseEnvironment> fetchEnvironment() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return ReleaseEnvironment(
      environment: 'development',
      nodeEnv: 'development',
      backendVersion: '1.4.2',
      backendCommit: 'abc1234',
      databaseMigrationStatus: 'up_to_date',
      lastDeploymentAt: DateTime.utc(2026, 6, 10, 18, 0),
      maintenanceMode: false,
      apiBaseUrlPublicName: 'api-dev.vianexis.test',
      deploymentReady: true,
      deploymentWarnings: const ['mock_data_mode'],
    );
  }
}

final releaseCenterRepositoryProvider = Provider<ReleaseCenterRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  if (apiClient.isConfigured) {
    return LiveReleaseCenterRepository(ref.watch(releaseCenterApiProvider));
  }
  return MockReleaseCenterRepository();
});
