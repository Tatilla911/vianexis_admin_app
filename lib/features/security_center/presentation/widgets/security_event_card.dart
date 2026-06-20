import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/security_event.dart';
import 'security_event_severity_badge.dart';
import 'security_event_type_badge.dart';

class SecurityEventCard extends StatelessWidget {
  const SecurityEventCard({
    super.key,
    required this.event,
    this.onTap,
  });

  final SecurityEvent event;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final created = event.createdAt;
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
              Text(event.title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(event.summary, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  SecurityEventTypeBadge(type: event.type),
                  SecurityEventSeverityBadge(severity: event.severity),
                ],
              ),
              if (event.companyName != null) ...[
                const SizedBox(height: 8),
                Text(
                  resolveSecurityKey(
                    context,
                    'securityEventCompanyLabel',
                    params: {'name': event.companyName!},
                  ),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              const SizedBox(height: 8),
              Text(
                resolveSecurityKey(
                  context,
                  'securityEventCreatedAt',
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
