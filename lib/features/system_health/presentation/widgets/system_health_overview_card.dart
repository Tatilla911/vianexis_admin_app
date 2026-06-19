import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/system_health_overview.dart';

class SystemHealthOverviewCard extends StatelessWidget {
  const SystemHealthOverviewCard({
    super.key,
    required this.overview,
    this.compact = false,
  });

  final SystemHealthOverview overview;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final updated = overview.lastUpdatedAt;
    final updatedLabel = updated != null
        ? DateFormat.yMMMd(locale).add_Hm().format(updated.toLocal())
        : '—';

    final metrics = [
      _Metric(
        resolveSystemHealthKey(context, 'systemHealthMetricHealthyServices'),
        overview.healthyServicesCount.toString(),
      ),
      _Metric(
        resolveSystemHealthKey(context, 'systemHealthMetricWarningServices'),
        overview.warningServicesCount.toString(),
      ),
      _Metric(
        resolveSystemHealthKey(context, 'systemHealthMetricCriticalServices'),
        overview.criticalServicesCount.toString(),
      ),
      _Metric(
        resolveSystemHealthKey(context, 'systemHealthMetricCriticalEvents'),
        overview.openCriticalEventsCount.toString(),
      ),
      _Metric(
        resolveSystemHealthKey(context, 'systemHealthMetricWarningEvents'),
        overview.openWarningEventsCount.toString(),
      ),
      _Metric(
        resolveSystemHealthKey(context, 'systemHealthMetricFailedJobs'),
        overview.failedJobsCount.toString(),
      ),
    ];

    return Card(
      child: Padding(
        padding: EdgeInsets.all(compact ? 16 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              resolveSystemHealthKey(
                context,
                'systemHealthOverallStatusLabel',
                params: {
                  'status': resolveSystemHealthKey(
                    context,
                    overview.overallStatus.localizationKey(),
                  ),
                },
              ),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              resolveSystemHealthKey(
                context,
                'systemHealthLastUpdated',
                params: {'date': updatedLabel},
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
