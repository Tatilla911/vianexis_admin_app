import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/security_overview.dart';

class SecurityOverviewCard extends StatelessWidget {
  const SecurityOverviewCard({
    super.key,
    required this.overview,
    this.compact = false,
  });

  final SecurityOverview overview;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final lastCritical = overview.lastCriticalSecurityEventAt;
    final lastCriticalLabel = lastCritical != null
        ? DateFormat.yMMMd(locale).add_Hm().format(lastCritical.toLocal())
        : resolveSecurityKey(context, 'securityOverviewNoCritical');

    return Card(
      child: Padding(
        padding: EdgeInsets.all(compact ? 12 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              resolveSecurityKey(context, 'securityOverviewTitle'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _chip(context, 'securityOverviewFailedLogins', overview.failedLoginCount),
                _chip(context, 'securityOverviewDeniedActions', overview.permissionDeniedCount),
                _chip(context, 'securityOverviewActiveGrants', overview.activeSupportGrantsCount),
                _chip(context, 'securityOverviewCriticalEvents', overview.criticalSecurityEventsCount),
                if (!compact) ...[
                  _chip(context, 'securityOverviewExpiringGrants', overview.expiringSupportGrantsCount),
                  _chip(context, 'securityOverviewHighRiskAi', overview.highRiskAiReviewsCount),
                  _chip(context, 'securityOverviewSuspiciousBulk', overview.suspiciousBulkOnboardingJobsCount),
                ],
              ],
            ),
            if (!compact) ...[
              const SizedBox(height: 12),
              Text(
                resolveSecurityKey(
                  context,
                  'securityOverviewLastCritical',
                  params: {'date': lastCriticalLabel},
                ),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _chip(BuildContext context, String key, int count) {
    return Chip(
      label: Text(resolveSecurityKey(context, key, params: {'count': '$count'})),
    );
  }
}
