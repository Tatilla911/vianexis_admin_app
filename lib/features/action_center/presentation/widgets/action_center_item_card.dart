import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/action_center_item.dart';

class ActionCenterItemCard extends StatelessWidget {
  const ActionCenterItemCard({
    super.key,
    required this.item,
    this.onTap,
  });

  final ActionCenterItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final created = item.createdAt;
    final createdLabel = created != null
        ? DateFormat.yMMMd(locale).add_Hm().format(created.toLocal())
        : '—';

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(item.summary, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(
                    label: Text(resolveActionCenterKey(context, item.type.localizationKey())),
                  ),
                  Chip(
                    label: Text(resolveActionCenterKey(context, item.priority.localizationKey())),
                  ),
                  Chip(
                    label: Text(resolveActionCenterKey(context, item.status.localizationKey())),
                  ),
                ],
              ),
              if (item.companyName != null) ...[
                const SizedBox(height: 8),
                Text(
                  resolveActionCenterKey(
                    context,
                    'actionCenterCompanyLabel',
                    params: {'name': item.companyName!},
                  ),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              const SizedBox(height: 8),
              Text(
                resolveActionCenterKey(
                  context,
                  'actionCenterCreatedAt',
                  params: {'date': createdLabel},
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

class ActionCenterNeedsAttentionCard extends StatelessWidget {
  const ActionCenterNeedsAttentionCard({
    super.key,
    required this.snapshot,
    this.compact = false,
  });

  final ActionCenterSnapshot snapshot;
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
              resolveActionCenterKey(context, 'actionCenterNeedsAttentionTitle'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                Chip(
                  label: Text(
                    resolveActionCenterKey(
                      context,
                      'actionCenterNeedsAttentionOpen',
                      params: {'count': '${snapshot.needsAttentionCount}'},
                    ),
                  ),
                ),
                Chip(
                  label: Text(
                    resolveActionCenterKey(
                      context,
                      'actionCenterNeedsAttentionCritical',
                      params: {'count': '${snapshot.criticalCount}'},
                    ),
                  ),
                ),
                Chip(
                  label: Text(
                    resolveActionCenterKey(
                      context,
                      'actionCenterNeedsAttentionTotal',
                      params: {'count': '${snapshot.total}'},
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
