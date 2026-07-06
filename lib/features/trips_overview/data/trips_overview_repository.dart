import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_config.dart';
import '../../../core/api/api_client.dart';
import '../domain/trip_overview_item.dart';

abstract class TripsOverviewRepository {
  Future<TripOverviewListResult> listTrips();

  bool get usesMockData;
}

class LiveTripsOverviewRepository implements TripsOverviewRepository {
  LiveTripsOverviewRepository([this._apiClient]);

  final ApiClient? _apiClient;

  @override
  bool get usesMockData => false;

  @override
  Future<TripOverviewListResult> listTrips() async {
    final apiClient = _apiClient;
    if (apiClient == null) {
      return const TripOverviewListResult(
        items: [],
        listEndpointReady: false,
        metadataOnly: true,
      );
    }

    final response = await apiClient.get<Map<String, dynamic>>(
      '/platform-admin/trips',
    );
    final data = response.data;
    final rawItems = data?['items'];
    final items = rawItems is List
        ? rawItems
              .whereType<Map<String, dynamic>>()
              .map(TripOverviewItem.fromJson)
              .toList(growable: false)
        : const <TripOverviewItem>[];

    return TripOverviewListResult(
      items: items,
      listEndpointReady: true,
      metadataOnly: true,
    );
  }
}

class MockTripsOverviewRepository implements TripsOverviewRepository {
  @override
  bool get usesMockData => true;

  @override
  Future<TripOverviewListResult> listTrips() async {
    return TripOverviewListResult(
      listEndpointReady: true,
      metadataOnly: true,
      items: [
        const TripOverviewItem(
          id: '42',
          reference: 'TR-42',
          companyName: 'NordTrans Kft.',
          driverName: 'Kovács Péter',
          status: TripOverviewStatus.active,
          hasExchangeRecords: true,
          hasExchangeAttention: true,
          hasPackage: false,
          pendingSyncWarning: true,
        ),
        const TripOverviewItem(
          id: '41',
          reference: 'TR-41',
          companyName: 'EuroFleet Zrt.',
          driverName: 'Nagy Anna',
          status: TripOverviewStatus.completed,
          hasExchangeRecords: false,
          hasExchangeAttention: false,
          hasPackage: true,
          pendingSyncWarning: false,
        ),
      ],
    );
  }
}

final tripsOverviewRepositoryProvider = Provider<TripsOverviewRepository>((
  ref,
) {
  if (AppConfig.instance.shouldUseLiveRepositories) {
    return LiveTripsOverviewRepository(ref.watch(apiClientProvider));
  }
  return MockTripsOverviewRepository();
});

final tripOverviewListProvider =
    FutureProvider.autoDispose<TripOverviewListResult>((ref) {
      return ref.watch(tripsOverviewRepositoryProvider).listTrips();
    });
