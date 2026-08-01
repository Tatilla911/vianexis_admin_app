import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/system_monitoring_overview.dart';
import 'system_monitoring_status_badge.dart';

class SystemMonitoringOverviewCard extends StatelessWidget {
  const SystemMonitoringOverviewCard({
    super.key,
    required this.overview,
    this.metricsStrip,
  });

  final SystemMonitoringOverview overview;
  final Widget? metricsStrip;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final refreshed = overview.lastRefreshAt ?? overview.generatedAt;
    final refreshedLabel = refreshed == null
        ? '—'
        : DateFormat.yMMMd(locale).add_Hm().format(refreshed.toLocal());

    final metrics = [
      _Metric(
        resolveSystemMonitoringKey(context, 'systemMonitoringMetricHealthy'),
        overview.healthyCount.toString(),
      ),
      _Metric(
        resolveSystemMonitoringKey(context, 'systemMonitoringMetricDegraded'),
        overview.degradedCount.toString(),
      ),
      _Metric(
        resolveSystemMonitoringKey(context, 'systemMonitoringMetricUnhealthy'),
        overview.unhealthyCount.toString(),
      ),
      _Metric(
        resolveSystemMonitoringKey(context, 'systemMonitoringMetricUnknown'),
        overview.unknownCount.toString(),
      ),
      _Metric(
        resolveSystemMonitoringKey(
          context,
          'systemMonitoringMetricNotConfigured',
        ),
        overview.notConfiguredCount.toString(),
      ),
      _Metric(
        resolveSystemMonitoringKey(
          context,
          'systemMonitoringMetricActiveIncidents',
        ),
        overview.activeIncidentCount.toString(),
      ),
      _Metric(
        resolveSystemMonitoringKey(
          context,
          'systemMonitoringMetricCriticalIncidents',
        ),
        overview.criticalIncidentCount.toString(),
      ),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    resolveSystemMonitoringKey(
                      context,
                      'systemMonitoringOverallStatusLabel',
                      params: {
                        'status': resolveSystemMonitoringKey(
                          context,
                          overview.overallStatus.localizationKey(),
                        ),
                      },
                    ),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                SystemMonitoringStatusBadge(status: overview.overallStatus),
                if (overview.activeIncidentCount > 0) ...[
                  const SizedBox(width: 8),
                  SystemMonitoringIncidentNavBadge(
                    activeCount: overview.activeIncidentCount,
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            Text(
              resolveSystemMonitoringKey(
                context,
                'systemMonitoringLastRefresh',
                params: {'date': refreshedLabel},
              ),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final metric in metrics)
                  _MetricChip(label: metric.label, value: metric.value),
              ],
            ),
            if (metricsStrip != null) ...[
              const SizedBox(height: 16),
              metricsStrip!,
            ],
          ],
        ),
      ),
    );
  }
}

class _Metric {
  const _Metric(this.label, this.value);
  final String label;
  final String value;
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: Theme.of(context).textTheme.titleLarge),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
