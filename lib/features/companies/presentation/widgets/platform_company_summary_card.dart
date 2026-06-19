import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/platform_company_summary.dart';

class PlatformCompanySummaryCard extends StatelessWidget {
  const PlatformCompanySummaryCard({
    super.key,
    required this.summary,
    this.compact = false,
  });

  final PlatformCompanyDashboardSummary summary;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(compact ? 12 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              resolvePlatformCompanyKey(context, 'platformCompanyDashboardTitle'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _chip(context, 'platformCompanyDashboardActive', summary.activeCompanies),
                _chip(context, 'platformCompanyDashboardPendingReview', summary.pendingReviewCompanies),
                _chip(context, 'platformCompanyDashboardSuspended', summary.suspendedCompanies),
                _chip(context, 'platformCompanyDashboardOpenSupport', summary.companiesWithOpenSupportIssues),
                _chip(context, 'platformCompanyDashboardPendingOnboarding', summary.companiesWithPendingOnboarding),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(BuildContext context, String key, int count) {
    return Chip(
      label: Text(
        resolvePlatformCompanyKey(context, key, params: {'count': '$count'}),
      ),
    );
  }
}
