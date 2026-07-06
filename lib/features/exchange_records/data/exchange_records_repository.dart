import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_config.dart';
import '../../../core/api/api_client.dart';
import '../domain/exchange_record_overview_item.dart';

abstract class ExchangeRecordsRepository {
  Future<ExchangeRecordsListResult> listRecords();

  bool get usesMockData;
}

class LiveExchangeRecordsRepository implements ExchangeRecordsRepository {
  LiveExchangeRecordsRepository([this._apiClient]);

  final ApiClient? _apiClient;

  @override
  bool get usesMockData => false;

  @override
  Future<ExchangeRecordsListResult> listRecords() async {
    final apiClient = _apiClient;
    if (apiClient == null) {
      return const ExchangeRecordsListResult(
        items: [],
        listEndpointReady: false,
        metadataOnly: true,
      );
    }

    final response = await apiClient.get<Map<String, dynamic>>(
      '/platform-admin/exchange-records',
    );
    final data = response.data;
    final rawItems = data?['items'];
    final items = rawItems is List
        ? rawItems
              .whereType<Map<String, dynamic>>()
              .map(ExchangeRecordOverviewItem.fromJson)
              .toList(growable: false)
        : const <ExchangeRecordOverviewItem>[];

    return ExchangeRecordsListResult(
      items: items,
      listEndpointReady: true,
      metadataOnly: true,
    );
  }
}

class MockExchangeRecordsRepository implements ExchangeRecordsRepository {
  @override
  bool get usesMockData => true;

  @override
  Future<ExchangeRecordsListResult> listRecords() async {
    return ExchangeRecordsListResult(
      listEndpointReady: true,
      metadataOnly: true,
      items: [
        ExchangeRecordOverviewItem(
          id: 'ex-1',
          recordType: 'pallet',
          itemLabel: 'EUR',
          tripId: '42',
          driverName: 'Kovács Péter',
          status: 'disputed',
          missingQuantity: 2,
          damagedQuantity: 1,
          stopId: 'stop-3',
          notesPreview: 'Hiány a rakodón',
          recordedAt: DateTime.now().subtract(const Duration(hours: 5)),
        ),
        ExchangeRecordOverviewItem(
          id: 'ex-2',
          recordType: 'packaging',
          itemLabel: 'hűtőláda',
          tripId: '42',
          driverName: 'Kovács Péter',
          status: 'completed',
          missingQuantity: 0,
          damagedQuantity: 0,
          recordedAt: DateTime.now().subtract(const Duration(hours: 4)),
        ),
      ],
    );
  }
}

final exchangeRecordsRepositoryProvider = Provider<ExchangeRecordsRepository>((
  ref,
) {
  if (AppConfig.instance.shouldUseLiveRepositories) {
    return LiveExchangeRecordsRepository(ref.watch(apiClientProvider));
  }
  return MockExchangeRecordsRepository();
});

final exchangeRecordsListProvider =
    FutureProvider.autoDispose<ExchangeRecordsListResult>((ref) {
      return ref.watch(exchangeRecordsRepositoryProvider).listRecords();
    });
