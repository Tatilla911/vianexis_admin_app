import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/app_router.dart';
import '../../../../core/localization/localization_resolver.dart';
import '../../domain/system_monitoring_incident.dart';
import 'system_monitoring_status_badge.dart';

class SystemMonitoringIncidentCard extends StatelessWidget {
  const SystemMonitoringIncidentCard({super.key, required this.incident});

  final SystemMonitoringIncident incident;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final detected = incident.detectedAt;
    final detectedLabel = detected == null
        ? '—'
        : DateFormat.yMMMd(locale).add_Hm().format(detected.toLocal());

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push(
          AdminRoutes.systemMonitoringIncidentDetail(incident.id),
        ),
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
                      incident.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  SystemMonitoringIncidentSeverityBadge(
                    severity: incident.severity,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  SystemMonitoringIncidentStatusBadge(status: incident.status),
                  Text(
                    incident.componentKey,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                incident.summary,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                resolveSystemMonitoringKey(
                  context,
                  'systemMonitoringIncidentDetectedAt',
                  params: {'date': detectedLabel},
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
