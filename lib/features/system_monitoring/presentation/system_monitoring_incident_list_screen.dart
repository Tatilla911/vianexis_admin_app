import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/localization_resolver.dart';
import '../../../core/widgets/mock_data_badge.dart';
import '../../../core/widgets/vianexis_error_view.dart';
import '../../../core/widgets/vianexis_loading_view.dart';
import '../../../l10n/app_localizations.dart';
import '../data/system_monitoring_repository.dart';
import '../domain/system_monitoring_incident.dart';
import 'system_monitoring_providers.dart';
import 'widgets/system_monitoring_incident_card.dart';

class SystemMonitoringIncidentListScreen extends ConsumerWidget {
  const SystemMonitoringIncidentListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final incidentsAsync = ref.watch(filteredSystemMonitoringIncidentsProvider);
    final filter = ref.watch(systemMonitoringIncidentFilterProvider);
    final usesMock = ref.watch(systemMonitoringRepositoryProvider).usesMockData;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.systemMonitoringIncidentsTitle),
        actions: [
          if (usesMock)
            MockDataBadge(
              label: resolveSystemMonitoringKey(
                context,
                'systemMonitoringMockDataBadge',
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                for (final item in SystemMonitoringIncidentFilter.values)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(
                        resolveSystemMonitoringKey(
                          context,
                          item.localizationKey(),
                        ),
                      ),
                      selected: filter.filter == item,
                      onSelected: (_) => ref
                          .read(systemMonitoringIncidentFilterProvider.notifier)
                          .setFilter(item),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: incidentsAsync.when(
              loading: () => const VianexisLoadingView(),
              error: (error, _) => VianexisErrorView.fromError(
                context,
                error,
                fallbackMessage: resolveSystemMonitoringKey(
                  context,
                  'systemMonitoringLoadError',
                ),
                onRetry: () =>
                    ref.invalidate(systemMonitoringIncidentsProvider),
              ),
              data: (incidents) {
                if (incidents.isEmpty) {
                  return Center(
                    child: Text(
                      resolveSystemMonitoringKey(
                        context,
                        'systemMonitoringIncidentsEmpty',
                      ),
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(systemMonitoringIncidentsProvider);
                    await ref.read(systemMonitoringIncidentsProvider.future);
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: incidents.length,
                    itemBuilder: (context, index) =>
                        SystemMonitoringIncidentCard(
                          incident: incidents[index],
                        ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
