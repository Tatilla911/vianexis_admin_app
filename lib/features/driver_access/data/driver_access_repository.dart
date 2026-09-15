import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_config.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_exception.dart';
import '../domain/driver_access_profile.dart';
import '../domain/driver_device_notification_status.dart';
import '../domain/driver_operational_health_detail.dart';

abstract class DriverAccessRepository {
  Future<DriverAccessListResult> listDrivers();

  Future<void> patchDriverStatus(
    String driverProfileId, {
    required String status,
    String? reason,
  });

  Future<DriverDeviceNotificationStatus?> fetchDeviceNotificationStatus(
    String driverProfileId,
  );

  Future<DriverOperationalHealthDetail?> fetchOperationalHealth(
    String driverProfileId,
  ) async => null;

  bool get usesMockData;
}

class LiveDriverAccessRepository implements DriverAccessRepository {
  LiveDriverAccessRepository([this._apiClient]);

  final ApiClient? _apiClient;

  @override
  bool get usesMockData => false;

  @override
  Future<DriverAccessListResult> listDrivers() async {
    final apiClient = _apiClient;
    if (apiClient == null) {
      return const DriverAccessListResult(
        items: [],
        listEndpointReady: false,
        metadataOnly: true,
      );
    }

    try {
      final response = await apiClient.get<Map<String, dynamic>>(
        '/platform-admin/drivers',
      );
      final data = response.data;
      final rawItems = data?['items'];
      final items = rawItems is List
          ? rawItems
                .whereType<Map<String, dynamic>>()
                .map(DriverAccessProfile.fromJson)
                .toList(growable: false)
          : const <DriverAccessProfile>[];

      return DriverAccessListResult(
        items: items,
        listEndpointReady: true,
        metadataOnly: true,
      );
    } on DioException catch (error) {
      final status = error.response?.statusCode;
      if (status == 404 || status == 501) {
        return const DriverAccessListResult(
          items: [],
          listEndpointReady: false,
          metadataOnly: true,
        );
      }
      rethrow;
    }
  }

  @override
  Future<void> patchDriverStatus(
    String driverProfileId, {
    required String status,
    String? reason,
  }) async {
    final apiClient = _apiClient;
    if (apiClient == null) {
      throw StateError('Driver status endpoint unavailable');
    }
    await apiClient.patch<Map<String, dynamic>>(
      '/platform-admin/drivers/$driverProfileId/status',
      data: {
        'status': status,
        if (reason != null && reason.trim().isNotEmpty) 'reason': reason.trim(),
      },
    );
  }

  @override
  Future<DriverDeviceNotificationStatus?> fetchDeviceNotificationStatus(
    String driverProfileId,
  ) async {
    final apiClient = _apiClient;
    if (apiClient == null) return null;
    final response = await apiClient.get<Map<String, dynamic>>(
      '/platform-admin/drivers/$driverProfileId/device-notification-status',
    );
    final data = response.data;
    if (data == null) return null;
    return DriverDeviceNotificationStatus.fromJson(data);
  }

  @override
  Future<DriverOperationalHealthDetail?> fetchOperationalHealth(
    String driverProfileId,
  ) async {
    final apiClient = _apiClient;
    if (apiClient == null) return null;
    try {
      final response = await apiClient.get<Map<String, dynamic>>(
        '/platform-admin/drivers/$driverProfileId/operational-health',
      );
      final data = response.data;
      if (data == null) return null;
      return DriverOperationalHealthDetail.fromJson(data);
    } on ApiException catch (error) {
      if (error.kind == ApiExceptionKind.notFound ||
          error.statusCode == 404 ||
          error.statusCode == 501) {
        return null;
      }
      rethrow;
    } on DioException catch (error) {
      final status = error.response?.statusCode;
      if (status == 404 || status == 501) return null;
      rethrow;
    }
  }
}

class MockDriverAccessRepository implements DriverAccessRepository {
  @override
  bool get usesMockData => true;

  @override
  Future<DriverAccessListResult> listDrivers() async {
    return DriverAccessListResult(
      listEndpointReady: true,
      metadataOnly: true,
      items: [
        DriverAccessProfile(
          id: 'd-101',
          displayName: 'Kovács Péter',
          companyName: 'NordTrans Kft.',
          companyId: '1',
          registrationStatus: DriverRegistrationStatus.active,
          lastActivityAt: DateTime.now().subtract(const Duration(hours: 2)),
          deviceLabel: 'Samsung Galaxy A54',
          activeSessionCount: 1,
          operationalHealth: const DriverOperationalHealthSummary(
            level: DriverOperationalHealthLevel.yellow,
            activeIssueCount: 1,
            labelKey: 'driverHealthWarning',
          ),
        ),
        DriverAccessProfile(
          id: 'd-102',
          displayName: 'Nagy Anna',
          companyName: 'EuroFleet Zrt.',
          companyId: '2',
          registrationStatus: DriverRegistrationStatus.invited,
          deviceLabel: '—',
          activeSessionCount: 0,
        ),
      ],
    );
  }

  @override
  Future<void> patchDriverStatus(
    String driverProfileId, {
    required String status,
    String? reason,
  }) async {}

  @override
  Future<DriverDeviceNotificationStatus?> fetchDeviceNotificationStatus(
    String driverProfileId,
  ) async {
    return const DriverDeviceNotificationStatus(
      metadataOnly: true,
      sourceUnavailable: false,
      hasPushToken: true,
      tokenProvider: 'fcm',
      platform: 'android',
      appVersion: '2.0.1',
      tokenLast4: '7890',
      deliveryEnabled: false,
      notificationPermissionStatus: 'granted',
    );
  }

  @override
  Future<DriverOperationalHealthDetail?> fetchOperationalHealth(
    String driverProfileId,
  ) async {
    if (driverProfileId == 'd-101') {
      return DriverOperationalHealthDetail(
        overallLevel: DriverOperationalHealthLevel.yellow,
        activeIssueCount: 1,
        issues: [
          DriverOperationalHealthIssueView(
            id: '1',
            category: 'profile_sync',
            code: 'sync.profile.failed',
            severity: 'yellow',
            status: 'active',
            attemptCount: 1,
            lastAttemptedAt: DateTime.now().subtract(
              const Duration(minutes: 12),
            ),
            safeErrorCode: 'network',
            source: 'driver_app_sync',
          ),
        ],
      );
    }
    return null;
  }
}

final driverAccessRepositoryProvider = Provider<DriverAccessRepository>((ref) {
  if (AppConfig.instance.shouldUseLiveRepositories) {
    return LiveDriverAccessRepository(ref.watch(apiClientProvider));
  }
  return MockDriverAccessRepository();
});

final driverAccessListProvider =
    FutureProvider.autoDispose<DriverAccessListResult>((ref) {
      return ref.watch(driverAccessRepositoryProvider).listDrivers();
    });

final driverDeviceNotificationStatusProvider = FutureProvider.autoDispose
    .family<DriverDeviceNotificationStatus?, String>((ref, driverId) {
      return ref
          .watch(driverAccessRepositoryProvider)
          .fetchDeviceNotificationStatus(driverId);
    });

final driverOperationalHealthProvider = FutureProvider.autoDispose
    .family<DriverOperationalHealthDetail?, String>((ref, driverId) {
      return ref
          .watch(driverAccessRepositoryProvider)
          .fetchOperationalHealth(driverId);
    });
