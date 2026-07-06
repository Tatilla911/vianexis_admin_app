import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/app_router.dart';
import '../../../core/localization/localization_resolver.dart';
import '../../../core/widgets/backend_dependency_card.dart';
import '../../../core/widgets/mock_data_badge.dart';
import '../../../core/widgets/vianexis_admin_card.dart';
import '../../../core/widgets/vianexis_error_view.dart';
import '../../../core/widgets/vianexis_loading_view.dart';
import '../../../core/widgets/vianexis_metadata_notice.dart';
import '../../../core/widgets/vianexis_metric_tile.dart';
import '../../../app/vianexis_brand.dart';
import '../../../l10n/app_localizations.dart';
import '../data/operations_repository.dart';
import '../domain/operational_metrics_snapshot.dart';
import '../domain/platform_operations_snapshot.dart';

class OperationsScreen extends ConsumerWidget {
  const OperationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(platformOperationsSnapshotProvider);
    final usesMock = ref.watch(operationsRepositoryProvider).usesMockData;

    return Scaffold(
      appBar: AppBar(
        title: Text(resolveOperationsKey(context, 'operationsTitle')),
        actions: [
          if (usesMock)
            MockDataBadge(label: resolveOperationsKey(context, 'operationsMockBadge')),
        ],
      ),
      body: snapshotAsync.when(
        loading: () => const VianexisLoadingView(),
        error: (error, _) => VianexisErrorView.fromError(
          context,
          error,
          fallbackMessage: resolveOperationsKey(context, 'operationsLoadFailed'),
          onRetry: () => ref.invalidate(platformOperationsSnapshotProvider),
        ),
        data: (snapshot) {
          final metricsAsync = ref.watch(operationalMetricsProvider);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              VianexisMetadataNotice(
                message: resolveOperationsKey(context, 'operationsPrivacyNotice'),
              ),
              const SizedBox(height: 12),
              _metricsGrid(
              context,
              snapshot,
              metricsAsync.asData?.value,
            ),
              const SizedBox(height: 16),
              _moduleLinks(context, snapshot),
              const SizedBox(height: 16),
              metricsAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, __) => BackendDependencyCard(
                  title: resolveOperationsKey(
                    context,
                    'operationsPendingSyncTitle',
                  ),
                  message: resolveOperationsKey(
                    context,
                    'operationsPendingSyncDependency',
                  ),
                  endpointHint: 'GET /platform-admin/operational-metrics',
                ),
                data: (metrics) {
                  if (metrics == null) {
                    return const SizedBox.shrink();
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Card(
                        child: ListTile(
                          leading: const Icon(Icons.swap_horiz_outlined),
                          title: Text(
                            resolveOperationsKey(
                              context,
                              'operationsExchangeRecordsTitle',
                            ),
                          ),
                          subtitle: Text(
                            AppLocalizations.of(context).operationsExchangeMetricsSummary(
                              metrics.exchangeRecordsTotal,
                              metrics.exchangeDisputed,
                              metrics.exchangeMissing,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (metrics.pendingSyncSourceUnavailable)
                        BackendDependencyCard(
                          title: resolveOperationsKey(
                            context,
                            'operationsPendingSyncTitle',
                          ),
                          message: resolveOperationsKey(
                            context,
                            'operationsPendingSyncUnavailable',
                          ),
                          endpointHint: 'pendingSync.sourceUnavailable',
                        )
                      else
                        Card(
                          child: ListTile(
                            leading: const Icon(Icons.sync_problem_outlined),
                            title: Text(
                              resolveOperationsKey(
                                context,
                                'operationsPendingSyncTitle',
                              ),
                            ),
                            subtitle: Text('${metrics.pendingSyncCount ?? 0}'),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _metricsGrid(
    BuildContext context,
    PlatformOperationsSnapshot snapshot,
    OperationalMetricsSnapshot? operationalMetrics,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= VianexisBrand.tabletBreakpoint;
        final tileWidth = isWide
            ? (constraints.maxWidth - VianexisBrand.spaceMd) / 2
            : double.infinity;
        final metricTiles = _buildMetrics(
          context,
          snapshot,
          operationalMetrics,
        );
        return Wrap(
          spacing: VianexisBrand.spaceMd,
          runSpacing: VianexisBrand.spaceMd,
          children: [
            for (final metric in metricTiles)
              SizedBox(
                width: tileWidth,
                child: VianexisMetricTile(
                  label: metric.$1,
                  value: metric.$2,
                  tone: metric.$3,
                  icon: metric.$4,
                ),
              ),
          ],
        );
      },
    );
  }

  List<(String, String, VianexisMetricTone, IconData)> _buildMetrics(
    BuildContext context,
    PlatformOperationsSnapshot snapshot,
    OperationalMetricsSnapshot? operationalMetrics,
  ) {
    final driversValue = operationalMetrics != null
        ? '${operationalMetrics.driversActive}'
        : '${snapshot.driversEstimate}';
    return [
      (
        resolveOperationsKey(context, 'operationsCompanyCount'),
        '${snapshot.companiesActive}/${snapshot.companiesTotal}',
        VianexisMetricTone.info,
        Icons.business_outlined,
      ),
      (
        resolveOperationsKey(context, 'operationsActiveDrivers'),
        driversValue,
        VianexisMetricTone.success,
        Icons.local_shipping_outlined,
      ),
      (
        resolveOperationsKey(context, 'operationsActiveTrips'),
        '${snapshot.tripsActive}',
        VianexisMetricTone.info,
        Icons.route_outlined,
      ),
      (
        resolveOperationsKey(context, 'operationsCompletedTrips'),
        '${snapshot.tripsCompleted}',
        VianexisMetricTone.neutral,
        Icons.check_circle_outline,
      ),
      (
        resolveOperationsKey(context, 'operationsSupportAccess'),
        '${snapshot.activeSupportGrants}',
        VianexisMetricTone.warning,
        Icons.vpn_key_outlined,
      ),
      (
        resolveOperationsKey(context, 'operationsPublicIntakes'),
        '${snapshot.pendingPublicIntakes}',
        VianexisMetricTone.info,
        Icons.public_outlined,
      ),
      (
        resolveOperationsKey(context, 'operationsPendingRegistrations'),
        '${snapshot.pendingRegistrations}',
        VianexisMetricTone.warning,
        Icons.apartment_outlined,
      ),
      (
        resolveOperationsKey(context, 'operationsPackagesGenerated'),
        '${snapshot.packagesGenerated}',
        VianexisMetricTone.neutral,
        Icons.inventory_2_outlined,
      ),
    ];
  }

  Widget _moduleLinks(BuildContext context, PlatformOperationsSnapshot snapshot) {
    final links = [
      (
        resolveOperationsKey(context, 'operationsLinkDriverAccess'),
        Icons.badge_outlined,
        AdminRoutes.driverAccess,
      ),
      (
        resolveOperationsKey(context, 'operationsLinkTrips'),
        Icons.route_outlined,
        AdminRoutes.tripsOverview,
      ),
      (
        resolveOperationsKey(context, 'operationsLinkExchangeRecords'),
        Icons.swap_horiz_outlined,
        AdminRoutes.exchangeRecords,
      ),
      (
        resolveOperationsKey(context, 'operationsLinkNotificationStatus'),
        Icons.notifications_active_outlined,
        AdminRoutes.notificationStatus,
      ),
      (
        resolveOperationsKey(context, 'operationsLinkSupportAccess'),
        Icons.vpn_key_outlined,
        AdminRoutes.supportGrants,
      ),
      (
        resolveOperationsKey(context, 'operationsLinkPublicIntakes'),
        Icons.public_outlined,
        AdminRoutes.publicIntakes,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          resolveOperationsKey(context, 'operationsModulesTitle'),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        for (final (label, icon, route) in links)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: VianexisAdminCard(
              onTap: () => context.push(route),
              child: ListTile(
                leading: Icon(icon),
                title: Text(label),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
          ),
      ],
    );
  }
}

String formatOperationsDate(BuildContext context, DateTime? value) {
  if (value == null) return '—';
  return DateFormat.yMMMd().add_Hm().format(value.toLocal());
}
