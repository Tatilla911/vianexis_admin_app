import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_config.dart';
import '../domain/driver_access_profile.dart';

abstract class DriverAccessRepository {
  Future<DriverAccessListResult> listDrivers();

  bool get usesMockData;
}

class LiveDriverAccessRepository implements DriverAccessRepository {
  @override
  bool get usesMockData => false;

  @override
  Future<DriverAccessListResult> listDrivers() async {
    return const DriverAccessListResult(
      items: [],
      listEndpointReady: false,
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
    return LiveDriverAccessRepository();
  }
  return MockDriverAccessRepository();
});

final driverAccessListProvider =
    FutureProvider.autoDispose<DriverAccessListResult>((ref) {
  return ref.watch(driverAccessRepositoryProvider).listDrivers();
});
