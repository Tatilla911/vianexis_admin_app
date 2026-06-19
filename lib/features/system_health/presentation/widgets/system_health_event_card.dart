import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/app_router.dart';
import '../../../../core/localization/localization_resolver.dart';
import '../../domain/system_health_event.dart';
import 'system_health_severity_badge.dart';

class SystemHealthEventCard extends StatelessWidget {
  const SystemHealthEventCard({
    super.key,
    required this.event,
  });

  final SystemHealthEvent event;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final started = event.startedAt;
    final startedLabel = started != null
        ? DateFormat.yMMMd(locale).add_Hm().format(started.toLocal())
        : '—';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push(AdminRoutes.systemHealthEventDetail(event.id)),
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
                      event.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  SystemHealthSeverityBadge(severity: event.severity),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${event.serviceName} · ${resolveSystemHealthKey(context, event.status.localizationKey())}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Text(event.summary, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 8),
              Text(
                resolveSystemHealthKey(
                  context,
                  'systemHealthEventStartedAt',
                  params: {'date': startedLabel},
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
