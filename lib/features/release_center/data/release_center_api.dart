import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../domain/release_overview.dart';

class ReleaseCenterApi {
  ReleaseCenterApi(this._apiClient);

  final ApiClient _apiClient;

  Future<ReleaseOverview> getOverview() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/release/overview',
    );
    final data = response.data;
    if (data == null) {
      return const ReleaseOverview(
        backendVersion: '0.0.0',
        environment: 'unknown',
        nodeEnv: 'development',
        databaseMigrationStatus: 'unknown',
        maintenanceMode: false,
      );
    }
    return ReleaseOverview.fromJson(data);
  }

  Future<ReleaseAppVersions> getAppVersions() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/release/app-versions',
    );
    final data = response.data;
    if (data == null) {
      return const ReleaseAppVersions();
    }
    return ReleaseAppVersions.fromJson(data);
  }

  Future<ReleaseEnvironment> getEnvironment() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/release/environment',
    );
    final data = response.data;
    if (data == null) {
      return const ReleaseEnvironment(
        environment: 'unknown',
        nodeEnv: 'development',
        databaseMigrationStatus: 'unknown',
        maintenanceMode: false,
        deploymentReady: false,
      );
    }
    return ReleaseEnvironment.fromJson(data);
  }
}

final releaseCenterApiProvider = Provider<ReleaseCenterApi>(
  (ref) => ReleaseCenterApi(ref.watch(apiClientProvider)),
);
