import 'package:flutter/material.dart';

import '../../../app/vianexis_brand.dart';
import '../../../core/localization/localization_resolver.dart';
import '../../../core/widgets/vianexis_admin_card.dart';
import '../../../core/widgets/vianexis_metric_tile.dart';
import '../../../core/widgets/vianexis_section_header.dart';
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
    this.onPendingRegistrationsTap,
  });

  final SystemHealthOverview? systemOverview;
  final int? pendingRegistrations;
  final int? companiesNeedingAttention;
  final int? bulkOnboardingWaiting;
  final int? aiHighRiskReviews;
  final int? supportOpenIssues;
  final int? auditFailedDenied;
  final VoidCallback? onPendingRegistrationsTap;

  @override
  Widget build(BuildContext context) {
    final systemHealthy =
        systemOverview?.overallStatus == SystemHealthOverallStatus.healthy;
    final systemLabel = systemOverview == null
        ? '—'
        : resolveDashboardKey(
            context,
            systemHealthy
                ? 'dashboardSystemStatusHealthy'
                : 'dashboardSystemStatusAttention',
          );

    final metrics = [
      (
        resolveDashboardKey(context, 'dashboardMetricSystemStatus'),
        systemLabel,
        systemOverview == null
            ? VianexisMetricTone.neutral
            : systemHealthy
            ? VianexisMetricTone.success
            : VianexisMetricTone.warning,
        Icons.monitor_heart_outlined,
        null,
      ),
      (
        resolveDashboardKey(context, 'dashboardMetricPendingRegistrations'),
        _formatCount(pendingRegistrations),
        VianexisMetricTone.info,
        Icons.apartment_outlined,
        onPendingRegistrationsTap,
      ),
      (
        resolveDashboardKey(context, 'dashboardMetricCompaniesAttention'),
        _formatCount(companiesNeedingAttention),
        VianexisMetricTone.warning,
        Icons.business_outlined,
        null,
      ),
      (
        resolveDashboardKey(context, 'dashboardMetricBulkOnboardingReview'),
        _formatCount(bulkOnboardingWaiting),
        VianexisMetricTone.info,
        Icons.upload_file_outlined,
        null,
      ),
      (
        resolveDashboardKey(context, 'dashboardMetricAiHighRisk'),
        _formatCount(aiHighRiskReviews),
        VianexisMetricTone.danger,
        Icons.auto_awesome_outlined,
        null,
      ),
      (
        resolveDashboardKey(context, 'dashboardMetricSupportIssues'),
        _formatCount(supportOpenIssues),
        VianexisMetricTone.warning,
        Icons.support_agent_outlined,
        null,
      ),
      (
        resolveDashboardKey(context, 'dashboardMetricAuditRisks'),
        _formatCount(auditFailedDenied),
        VianexisMetricTone.danger,
        Icons.receipt_long_outlined,
        null,
      ),
    ];

    return VianexisAdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VianexisSectionHeader(
            title: resolveDashboardKey(
              context,
              'dashboardOperationalOverviewTitle',
            ),
            subtitle: resolveDashboardKey(
              context,
              'dashboardOperationalOverviewBody',
            ),
          ),
          const SizedBox(height: VianexisBrand.spaceLg),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide =
                  constraints.maxWidth >= VianexisBrand.tabletBreakpoint;
              return Wrap(
                spacing: VianexisBrand.spaceMd,
                runSpacing: VianexisBrand.spaceMd,
                children: [
                  for (final (label, value, tone, icon, onTap) in metrics)
                    SizedBox(
                      width: isWide
                          ? (constraints.maxWidth - VianexisBrand.spaceMd) / 2
                          : double.infinity,
                      child: _maybeTappable(
                        onTap: onTap,
                        child: VianexisMetricTile(
                          key: onTap == null
                              ? null
                              : const Key('dashboard-pending-registrations'),
                          label: label,
                          value: value,
                          tone: tone,
                          icon: icon,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatCount(int? value) => value?.toString() ?? '—';
}

Widget _maybeTappable({
  required Widget child,
  VoidCallback? onTap,
}) {
  if (onTap == null) return child;
  return Material(
    color: Colors.transparent,
    child: InkWell(onTap: onTap, child: child),
  );
}
