import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/app_router.dart';
import '../../../../core/localization/localization_resolver.dart';
import '../../domain/platform_audit_log.dart';
import 'audit_log_action_badge.dart';
import 'audit_log_result_badge.dart';
import 'audit_log_severity_badge.dart';

class AuditLogCard extends StatelessWidget {
  const AuditLogCard({super.key, required this.log});

  final PlatformAuditLog log;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final timestampLabel = DateFormat.yMMMd(locale)
        .add_Hm()
        .format(log.timestamp.toLocal());

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push(AdminRoutes.auditLogDetail(log.id)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      log.targetLabel ?? resolveAuditLogKey(context, log.actionType.localizationKey()),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  AuditLogSeverityBadge(severity: log.severity),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                [
                  if (log.actorEmail != null) log.actorEmail,
                  if (log.companyName != null) log.companyName,
                ].whereType<String>().join(' · '),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  AuditLogActionBadge(actionType: log.actionType),
                  AuditLogResultBadge(result: log.result),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                resolveAuditLogKey(
                  context,
                  'auditLogTimestampLabel',
                  params: {'date': timestampLabel},
                ),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AuditLogSummaryCard extends StatelessWidget {
  const AuditLogSummaryCard({
    super.key,
    required this.summary,
    this.compact = false,
  });

  final PlatformAuditLogSummary summary;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final updated = summary.lastUpdatedAt;
    final updatedLabel = updated != null
        ? DateFormat.yMMMd(locale).add_Hm().format(updated.toLocal())
        : '—';

    final lastCritical = summary.lastCriticalEvent;
    final lastCriticalLabel = lastCritical?.targetLabel ??
        (lastCritical != null
            ? resolveAuditLogKey(context, lastCritical.actionType.localizationKey())
            : resolveAuditLogKey(context, 'auditLogSummaryNoCritical'));

    return Card(
      child: Padding(
        padding: EdgeInsets.all(compact ? 16 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              resolveAuditLogKey(context, 'auditLogSummaryTitle'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            _MetricRow(
              label: resolveAuditLogKey(context, 'auditLogSummaryLastCritical'),
              value: lastCriticalLabel,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _MetricChip(
                  label: resolveAuditLogKey(context, 'auditLogSummaryFailedDenied'),
                  value: '${summary.failedDeniedCount}',
                ),
                _MetricChip(
                  label: resolveAuditLogKey(context, 'auditLogSummaryRecentActions'),
                  value: '${summary.recentPlatformActionsCount}',
                ),
              ],
            ),
            if (!compact) ...[
              const SizedBox(height: 12),
              Text(
                resolveAuditLogKey(
                  context,
                  'auditLogSummaryLastUpdated',
                  params: {'date': updatedLabel},
                ),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        Text(value, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
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
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          Text(value, style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
    );
  }
}
