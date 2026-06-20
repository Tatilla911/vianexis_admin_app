import 'package:flutter/material.dart';

import '../../../core/localization/localization_resolver.dart';
import '../../system_health/domain/system_health_overview.dart';
import '../../system_health/domain/system_health_severity.dart';

class DashboardOperationalOverview extends StatelessWidget {
  const DashboardOperationalOverview({
    super.key,
    this.systemOverview,
    this.pendingRegistrations,
    this.companiesNeedingAttention,
    this.bulkOnboardingWaiting,
    this.aiHighRiskReviews,
    this.supportOpenIssues,
    this.auditFailedDenied,
  });

  final SystemHealthOverview? systemOverview;
  final int? pendingRegistrations;
  final int? companiesNeedingAttention;
  final int? bulkOnboardingWaiting;
  final int? aiHighRiskReviews;
  final int? supportOpenIssues;
  final int? auditFailedDenied;

  @override
  Widget build(BuildContext context) {
    final systemLabel = systemOverview == null
        ? '—'
        : resolveDashboardKey(
            context,
            systemOverview!.overallStatus == SystemHealthOverallStatus.healthy
                ? 'dashboardSystemStatusHealthy'
                : 'dashboardSystemStatusAttention',
          );

    final metrics = [
      _Metric(resolveDashboardKey(context, 'dashboardMetricSystemStatus'), systemLabel),
      _Metric(
        resolveDashboardKey(context, 'dashboardMetricPendingRegistrations'),
        _formatCount(pendingRegistrations),
      ),
      _Metric(
        resolveDashboardKey(context, 'dashboardMetricCompaniesAttention'),
        _formatCount(companiesNeedingAttention),
      ),
      _Metric(
        resolveDashboardKey(context, 'dashboardMetricBulkOnboardingReview'),
        _formatCount(bulkOnboardingWaiting),
      ),
      _Metric(
        resolveDashboardKey(context, 'dashboardMetricAiHighRisk'),
        _formatCount(aiHighRiskReviews),
      ),
      _Metric(
        resolveDashboardKey(context, 'dashboardMetricSupportIssues'),
        _formatCount(supportOpenIssues),
      ),
      _Metric(
        resolveDashboardKey(context, 'dashboardMetricAuditRisks'),
        _formatCount(auditFailedDenied),
      ),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              resolveDashboardKey(context, 'dashboardOperationalOverviewTitle'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              resolveDashboardKey(context, 'dashboardOperationalOverviewBody'),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: metrics
                  .map(
                    (metric) => _OverviewChip(
                      label: metric.label,
                      value: metric.value,
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCount(int? value) => value?.toString() ?? '—';
}

class _Metric {
  const _Metric(this.label, this.value);

  final String label;
  final String value;
}

class _OverviewChip extends StatelessWidget {
  const _OverviewChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 4),
          Text(value, style: Theme.of(context).textTheme.titleSmall),
        ],
      ),
    );
  }
}
