import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/app_router.dart';
import '../../../../core/localization/localization_resolver.dart';
import '../../../../core/widgets/vianexis_status_badge.dart';
import '../../domain/support_access_grant.dart';
import '../../domain/support_access_grant_status.dart';
import 'support_access_scope_badge.dart';

class SupportAccessGrantCard extends StatelessWidget {
  const SupportAccessGrantCard({super.key, required this.grant});

  final SupportAccessGrant grant;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final expires = grant.expiresAt;
    final expiresLabel = expires != null
        ? DateFormat.yMMMd(locale).add_Hm().format(expires.toLocal())
        : '—';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push(AdminRoutes.supportGrantDetail(grant.id)),
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
                      grant.companyName ?? grant.companyId,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  VianexisStatusBadge(
                    label: resolveSupportKey(context, grant.status.localizationKey()),
                    tone: _tone(grant.status),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  SupportAccessScopeBadge(scopeType: grant.scopeType),
                  if (grant.scopeId != null)
                    Text(
                      resolveSupportKey(
                        context,
                        'supportGrantScopeIdLabel',
                        params: {'id': grant.scopeId!},
                      ),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                grant.reason,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              Text(
                resolveSupportKey(
                  context,
                  'supportGrantExpiresAt',
                  params: {'date': expiresLabel},
                ),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  VianexisStatusTone _tone(SupportAccessGrantStatus status) {
    return switch (status) {
      SupportAccessGrantStatus.active => VianexisStatusTone.healthy,
      SupportAccessGrantStatus.pending => VianexisStatusTone.unknown,
      SupportAccessGrantStatus.expired || SupportAccessGrantStatus.revoked ||
      SupportAccessGrantStatus.denied =>
        VianexisStatusTone.degraded,
      SupportAccessGrantStatus.unknown => VianexisStatusTone.unknown,
    };
  }
}
