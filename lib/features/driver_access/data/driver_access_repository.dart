import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_config.dart';
import '../../../core/api/api_client.dart';
import '../domain/driver_access_profile.dart';

abstract class DriverAccessRepository {
  Future<DriverAccessListResult> listDrivers();

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
