import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/localization_resolver.dart';
import '../../../core/widgets/backend_dependency_card.dart';
import '../../../core/widgets/mock_data_badge.dart';
import '../../../core/widgets/vianexis_error_view.dart';
import '../../../core/widgets/vianexis_loading_view.dart';
import '../../../core/widgets/vianexis_metadata_notice.dart';
import '../data/exchange_records_repository.dart';
import '../domain/exchange_record_overview_item.dart';

class ExchangeRecordsScreen extends ConsumerStatefulWidget {
  const ExchangeRecordsScreen({super.key});

  @override
  ConsumerState<ExchangeRecordsScreen> createState() =>
      _ExchangeRecordsScreenState();
}

class _ExchangeRecordsScreenState extends ConsumerState<ExchangeRecordsScreen> {
  ExchangeRecordStatusFilter _filter = ExchangeRecordStatusFilter.all;

  @override
  Widget build(BuildContext context) {
    final recordsAsync = ref.watch(exchangeRecordsListProvider);
    final usesMock = ref.watch(exchangeRecordsRepositoryProvider).usesMockData;

    return Scaffold(
      appBar: AppBar(
        title: Text(resolveExchangeRecordsKey(context, 'exchangeRecordsTitle')),
        actions: [
          if (usesMock)
            MockDataBadge(
              label: resolveExchangeRecordsKey(context, 'exchangeRecordsMockBadge'),
            ),
        ],
      ),
      body: recordsAsync.when(
        loading: () => const VianexisLoadingView(),
        error: (error, _) => VianexisErrorView.fromError(
          context,
          error,
          fallbackMessage:
              resolveExchangeRecordsKey(context, 'exchangeRecordsLoadFailed'),
          onRetry: () => ref.invalidate(exchangeRecordsListProvider),
        ),
        data: (result) {
          if (!result.listEndpointReady) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                VianexisMetadataNotice(
                  message: resolveExchangeRecordsKey(
                    context,
                    'exchangeRecordsPrivacyNotice',
                  ),
                ),
                const SizedBox(height: 12),
                BackendDependencyCard(
                  title: resolveExchangeRecordsKey(
                    context,
                    'exchangeRecordsBackendTitle',
                  ),
                  message: resolveExchangeRecordsKey(
                    context,
                    'exchangeRecordsBackendMessage',
                  ),
                  endpointHint: 'GET /platform-admin/exchange-records (planned)',
                ),
              ],
            );
          }

          final filtered = _applyFilter(result.items);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              VianexisMetadataNotice(
                message: resolveExchangeRecordsKey(
                  context,
                  'exchangeRecordsPrivacyNotice',
                ),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final filter in ExchangeRecordStatusFilter.values)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(
                            resolveExchangeRecordsKey(context, filter.localizationKey),
                          ),
                          selected: _filter == filter,
                          onSelected: (_) => setState(() => _filter = filter),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              if (filtered.isEmpty)
                Text(resolveExchangeRecordsKey(context, 'exchangeRecordsListEmpty'))
              else
                for (final record in filtered)
                  Card(
                    child: ListTile(
                      title: Text(record.itemLabel),
                      subtitle: Text(
                        '${record.driverName} · ${record.tripId}\n'
                        '${resolveExchangeRecordsKey(context, 'exchangeRecordsFieldStatus')}: '
                        '${resolveExchangeRecordStatus(context, record.status)}'
                        '${record.missingQuantity > 0 ? '\n${resolveExchangeRecordsKey(context, 'exchangeRecordsFieldMissing')}: ${record.missingQuantity}' : ''}'
                        '${record.damagedQuantity > 0 ? '\n${resolveExchangeRecordsKey(context, 'exchangeRecordsFieldDamaged')}: ${record.damagedQuantity}' : ''}'
                        '${record.notesPreview != null ? '\n${record.notesPreview}' : ''}',
                      ),
                      isThreeLine: true,
                    ),
                  ),
            ],
          );
        },
      ),
    );
  }

  List<ExchangeRecordOverviewItem> _applyFilter(
    List<ExchangeRecordOverviewItem> items,
  ) {
    return switch (_filter) {
      ExchangeRecordStatusFilter.all => items,
      ExchangeRecordStatusFilter.disputed => items
          .where((item) => item.status.toLowerCase() == 'disputed')
          .toList(growable: false),
      ExchangeRecordStatusFilter.damaged => items
          .where((item) => item.damagedQuantity > 0)
          .toList(growable: false),
      ExchangeRecordStatusFilter.missing => items
          .where((item) => item.missingQuantity > 0)
          .toList(growable: false),
    };
  }
}

String resolveExchangeRecordStatus(BuildContext context, String raw) {
  return switch (raw.toLowerCase()) {
    'completed' => resolveExchangeRecordsKey(context, 'exchangeRecordsStatusCompleted'),
    'disputed' => resolveExchangeRecordsKey(context, 'exchangeRecordsStatusDisputed'),
    'damaged' => resolveExchangeRecordsKey(context, 'exchangeRecordsStatusDamaged'),
    'missing' => resolveExchangeRecordsKey(context, 'exchangeRecordsStatusMissing'),
    _ => resolveExchangeRecordsKey(context, 'exchangeRecordsStatusUnknown'),
  };
}
