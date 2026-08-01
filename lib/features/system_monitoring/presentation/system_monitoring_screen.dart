import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_router.dart';
import '../../../core/localization/localization_resolver.dart';
import '../../../core/widgets/mock_data_badge.dart';
import '../../../core/widgets/vianexis_error_view.dart';
import '../../../core/widgets/vianexis_loading_view.dart';
import '../../../l10n/app_localizations.dart';
import '../data/system_monitoring_repository.dart';
import '../domain/system_monitoring_overview.dart';
import 'system_monitoring_providers.dart';
import 'widgets/system_monitoring_component_card.dart';
import 'widgets/system_monitoring_incident_card.dart';
import 'widgets/system_monitoring_overview_card.dart';

class SystemMonitoringScreen extends ConsumerWidget {
  const SystemMonitoringScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final snapshotAsync = ref.watch(systemMonitoringSnapshotProvider);
    final componentsAsync = ref.watch(
      filteredSystemMonitoringComponentsProvider,
    );
    final filter = ref.watch(systemMonitoringComponentFilterProvider);
    final usesMock = ref.watch(systemMonitoringRepositoryProvider).usesMockData;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.systemMonitoringTitle),
        actions: [
          if (usesMock)
            MockDataBadge(
              label: resolveSystemMonitoringKey(
                context,
                'systemMonitoringMockDataBadge',
              ),
            ),
          IconButton(
            tooltip: resolveSystemMonitoringKey(
              context,
              'systemMonitoringRefreshAction',
            ),
            onPressed: () => ref
                .read(systemMonitoringSnapshotProvider.notifier)
                .refreshMonitoring(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: snapshotAsync.when(
        loading: () => const VianexisLoadingView(),
        error: (error, _) => VianexisErrorView.fromError(
          context,
          error,
          fallbackMessage: resolveSystemMonitoringKey(
            context,
            'systemMonitoringLoadError',
          ),
          onRetry: () =>
              ref.read(systemMonitoringSnapshotProvider.notifier).refresh(),
        ),
        data: (snapshot) {
          return RefreshIndicator(
            onRefresh: () =>
                ref.read(systemMonitoringSnapshotProvider.notifier).refresh(),
            child: ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: SystemMonitoringOverviewCard(
                    overview: snapshot.overview,
                    metricsStrip: snapshot.metrics == null
                        ? null
                        : _MetricsStrip(snapshot: snapshot),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          resolveSystemMonitoringKey(
                            context,
                            'systemMonitoringComponentsTitle',
                          ),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      FilterChip(
                        label: Text(
                          resolveSystemMonitoringKey(
                            context,
                            'systemMonitoringFilterDegradedUnhealthy',
                          ),
                        ),
                        selected:
                            filter.filter ==
                            SystemMonitoringComponentFilter.degradedOrUnhealthy,
                        onSelected: (selected) {
                          ref
                              .read(
                                systemMonitoringComponentFilterProvider
                                    .notifier,
                              )
                              .setFilter(
                                selected
                                    ? SystemMonitoringComponentFilter
                                          .degradedOrUnhealthy
                                    : SystemMonitoringComponentFilter.all,
                              );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: componentsAsync.when(
                    loading: () => const VianexisLoadingView(),
                    error: (_, _) => Text(
                      resolveSystemMonitoringKey(
                        context,
                        'systemMonitoringLoadError',
                      ),
                    ),
                    data: (components) {
                      if (components.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            resolveSystemMonitoringKey(
                              context,
                              'systemMonitoringComponentsEmpty',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          final crossAxisCount = constraints.maxWidth >= 900
                              ? 3
                              : constraints.maxWidth >= 600
                              ? 2
                              : 1;
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: crossAxisCount == 1
                                      ? 2.8
                                      : 1.55,
                                ),
                            itemCount: components.length,
                            itemBuilder: (context, index) =>
                                SystemMonitoringComponentCard(
                                  component: components[index],
                                ),
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          resolveSystemMonitoringKey(
                            context,
                            'systemMonitoringActiveIncidentsTitle',
                          ),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      TextButton(
                        onPressed: () =>
                            context.push(AdminRoutes.systemMonitoringIncidents),
                        child: Text(
                          resolveSystemMonitoringKey(
                            context,
                            'systemMonitoringViewAllIncidents',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                if (snapshot.activeIncidents.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      resolveSystemMonitoringKey(
                        context,
                        'systemMonitoringIncidentsEmpty',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        for (final incident in snapshot.activeIncidents)
                          SystemMonitoringIncidentCard(incident: incident),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Text(
                    resolveSystemMonitoringKey(
                      context,
                      snapshot.privacyNoteKey ??
                          'systemMonitoringPrivacyNotice',
                    ),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MetricsStrip extends StatelessWidget {
  const _MetricsStrip({required this.snapshot});

  final SystemMonitoringSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final metrics = snapshot.metrics!;
    final items = <String>[
      if (metrics.apiErrorsLastHour != null)
        resolveSystemMonitoringKey(
          context,
          'systemMonitoringMetricApiErrors',
          params: {'count': '${metrics.apiErrorsLastHour}'},
        ),
      if (metrics.failedNotificationsCount != null)
        resolveSystemMonitoringKey(
          context,
          'systemMonitoringMetricFailedNotifications',
          params: {'count': '${metrics.failedNotificationsCount}'},
        ),
      if (metrics.dbResponseTimeMs != null)
        resolveSystemMonitoringKey(
          context,
          'systemMonitoringMetricDbLatency',
          params: {'ms': '${metrics.dbResponseTimeMs}'},
        ),
      if (metrics.redisConnected != null)
        resolveSystemMonitoringKey(
          context,
          metrics.redisConnected == true
              ? 'systemMonitoringMetricRedisConnected'
              : 'systemMonitoringMetricRedisDisconnected',
        ),
    ];

    if (items.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final item in items)
          Chip(
            label: Text(item, style: Theme.of(context).textTheme.labelSmall),
          ),
      ],
    );
  }
}
