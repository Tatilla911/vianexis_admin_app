import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/driver_emergency_event.dart';
import 'emergencies_api.dart';

class EmergenciesRepository {
  EmergenciesRepository(this._api);

  final EmergenciesApi _api;

  Future<DriverEmergencyListResult> listOpen() => _api.list(openOnly: true);

  Future<DriverEmergencyListResult> listActive() =>
      _api.list(status: 'ACTIVE');

  Future<DriverEmergencyListResult> listAll() => _api.list();

  Future<DriverEmergencyEvent> getById(String id) => _api.getById(id);
}

final emergenciesRepositoryProvider = Provider<EmergenciesRepository>(
  (ref) => EmergenciesRepository(ref.watch(emergenciesApiProvider)),
);

final openEmergenciesProvider =
    FutureProvider.autoDispose<DriverEmergencyListResult>((ref) {
      return ref.watch(emergenciesRepositoryProvider).listOpen();
    });

final emergencyDetailProvider = FutureProvider.autoDispose
    .family<DriverEmergencyEvent, String>((ref, id) {
      return ref.watch(emergenciesRepositoryProvider).getById(id);
    });
