import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_config.dart';
import '../domain/email_delivery_status.dart';
import '../domain/observability_status.dart';
import '../domain/release_overview.dart';
import 'release_center_api.dart';

abstract class ReleaseCenterRepository {
  Future<ReleaseOverview> fetchOverview();

  Future<ReleaseAppVersions> fetchAppVersions();

  Future<ReleaseEnvironment> fetchEnvironment();

  Future<EmailDeliveryStatus> fetchEmailDeliveryStatus();

  Future<EmailDeliveryLogsPage> fetchEmailDeliveryLogs();

  Future<ObservabilityStatus> fetchObservabilityStatus();

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

  @override
  Future<EmailDeliveryStatus> fetchEmailDeliveryStatus() =>
      _api.getEmailDeliveryStatus();

  @override
  Future<EmailDeliveryLogsPage> fetchEmailDeliveryLogs() =>
      _api.getEmailDeliveryLogs();

  @override
  Future<ObservabilityStatus> fetchObservabilityStatus() =>
      _api.getObservabilityStatus();
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

  @override
  Future<EmailDeliveryStatus> fetchEmailDeliveryStatus() async {
    await Future<void>.delayed(const Duration(milliseconds: 80));
    return const EmailDeliveryStatus(
      provider: 'noop',
      deliveryEnabled: false,
      lastDeliveryStatus: 'skipped',
      lastDeliveryAt: null,
    );
  }

  @override
  Future<EmailDeliveryLogsPage> fetchEmailDeliveryLogs() async {
    await Future<void>.delayed(const Duration(milliseconds: 80));
    return EmailDeliveryLogsPage(
      total: 1,
      items: [
        EmailDeliveryLog(
          id: 1,
          type: 'admin_invite',
          recipientEmailHash: 'a1b2c3d4',
          recipientEmailDomain: 'vianexis.test',
          status: 'skipped',
          provider: 'noop',
          createdAt: DateTime.utc(2026, 6, 20, 10, 0),
        ),
      ],
    );
  }

  @override
  Future<ObservabilityStatus> fetchObservabilityStatus() async {
    await Future<void>.delayed(const Duration(milliseconds: 80));
    return const ObservabilityStatus(
      logLevel: 'info',
      metricsEnabled: false,
      sentryConfigured: false,
      otelConfigured: false,
      correlationIdEnabled: true,
    );
  }
}

final releaseCenterRepositoryProvider = Provider<ReleaseCenterRepository>((ref) {

  if (AppConfig.instance.shouldUseLiveRepositories) {
    return LiveReleaseCenterRepository(ref.watch(releaseCenterApiProvider));
  }
  return MockReleaseCenterRepository();
});
