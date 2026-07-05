import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/localization_resolver.dart';
import '../../../core/widgets/backend_dependency_card.dart';
import '../../../core/widgets/mock_data_badge.dart';
import '../../../core/widgets/vianexis_error_view.dart';
import '../../../core/widgets/vianexis_loading_view.dart';
import '../../../core/widgets/vianexis_metadata_notice.dart';
import '../../operations/data/operations_repository.dart';
import '../data/trips_overview_repository.dart';

class TripsOverviewScreen extends ConsumerWidget {
  const TripsOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(platformOperationsSnapshotProvider);
    final tripsAsync = ref.watch(tripOverviewListProvider);
    final usesMock = ref.watch(tripsOverviewRepositoryProvider).usesMockData;

    return Scaffold(
      appBar: AppBar(
        title: Text(resolveTripsOverviewKey(context, 'tripsOverviewTitle')),
        actions: [
          if (usesMock)
            MockDataBadge(label: resolveTripsOverviewKey(context, 'tripsOverviewMockBadge')),
        ],
      ),
      body: snapshotAsync.when(
        loading: () => const VianexisLoadingView(),
        error: (error, _) => VianexisErrorView.fromError(
          context,
          error,
          fallbackMessage: resolveTripsOverviewKey(context, 'tripsOverviewLoadFailed'),
          onRetry: () {
            ref.invalidate(platformOperationsSnapshotProvider);
            ref.invalidate(tripOverviewListProvider);
          },
        ),
        data: (snapshot) => tripsAsync.when(
          loading: () => const VianexisLoadingView(),
          error: (error, _) => VianexisErrorView.fromError(
            context,
            error,
            fallbackMessage: resolveTripsOverviewKey(context, 'tripsOverviewLoadFailed'),
            onRetry: () => ref.invalidate(tripOverviewListProvider),
          ),
          data: (result) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                VianexisMetadataNotice(
                  message: resolveTripsOverviewKey(context, 'tripsOverviewPrivacyNotice'),
                ),
                const SizedBox(height: 12),
                _summaryRow(
                  context,
                  resolveTripsOverviewKey(context, 'tripsOverviewActiveCount'),
                  '${snapshot.tripsActive}',
                ),
                _summaryRow(
                  context,
                  resolveTripsOverviewKey(context, 'tripsOverviewCompletedCount'),
                  '${snapshot.tripsCompleted}',
                ),
                _summaryRow(
                  context,
                  resolveTripsOverviewKey(context, 'tripsOverviewParkedCount'),
                  '${snapshot.tripsParked}',
                ),
                const SizedBox(height: 16),
                if (!result.listEndpointReady)
                  BackendDependencyCard(
                    title: resolveTripsOverviewKey(context, 'tripsOverviewBackendTitle'),
                    message: resolveTripsOverviewKey(context, 'tripsOverviewBackendMessage'),
                    endpointHint: 'GET /platform-admin/trips (planned)',
                  )
                else ...[
                  Text(
                    resolveTripsOverviewKey(context, 'tripsOverviewListTitle'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  for (final trip in result.items)
                    Card(
                      child: ListTile(
                        title: Text(trip.reference),
                        subtitle: Text(
                          '${trip.companyName} · ${trip.driverName}\n'
                          '${resolveTripsOverviewKey(context, trip.status.localizationKey)}'
                          '${trip.hasExchangeRecords ? ' · ${resolveTripsOverviewKey(context, 'tripsOverviewExchangeIndicator')}' : ''}'
                          '${trip.hasExchangeAttention ? ' · ${resolveTripsOverviewKey(context, 'tripsOverviewExchangeAttention')}' : ''}'
                          '${trip.pendingSyncWarning ? ' · ${resolveTripsOverviewKey(context, 'tripsOverviewPendingSync')}' : ''}',
                        ),
                        isThreeLine: true,
                      ),
                    ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _summaryRow(BuildContext context, String label, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      trailing: Text(value, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}
