import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/system_component_status.dart';
import '../../domain/system_monitoring_incident.dart';

class SystemMonitoringStatusBadge extends StatelessWidget {
  const SystemMonitoringStatusBadge({super.key, required this.status});

  final SystemComponentStatusValue status;

  Color _color(BuildContext context) {
    return switch (status) {
      SystemComponentStatusValue.healthy => Theme.of(
        context,
      ).colorScheme.primary,
      SystemComponentStatusValue.degraded => Colors.orange,
      SystemComponentStatusValue.unhealthy => Theme.of(
        context,
      ).colorScheme.error,
      SystemComponentStatusValue.unknown => Theme.of(
        context,
      ).colorScheme.outline,
      SystemComponentStatusValue.disabled => Theme.of(
        context,
      ).colorScheme.outline,
      SystemComponentStatusValue.notConfigured => Theme.of(
        context,
      ).colorScheme.tertiary,
    };
  }

  @override
  Widget build(BuildContext context) {
    final color = _color(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.48)),
      ),
      child: Text(
        resolveSystemMonitoringKey(context, status.localizationKey()),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class SystemMonitoringIncidentSeverityBadge extends StatelessWidget {
  const SystemMonitoringIncidentSeverityBadge({
    super.key,
    required this.severity,
  });

  final SystemIncidentSeverity severity;

  Color _color(BuildContext context) {
    return switch (severity) {
      SystemIncidentSeverity.info => Theme.of(context).colorScheme.primary,
      SystemIncidentSeverity.warning => Colors.orange,
      SystemIncidentSeverity.high => Colors.deepOrange,
      SystemIncidentSeverity.critical => Theme.of(context).colorScheme.error,
      SystemIncidentSeverity.unknown => Theme.of(context).colorScheme.outline,
    };
  }

  @override
  Widget build(BuildContext context) {
    final color = _color(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.48)),
      ),
      child: Text(
        resolveSystemMonitoringKey(context, severity.localizationKey()),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class SystemMonitoringIncidentStatusBadge extends StatelessWidget {
  const SystemMonitoringIncidentStatusBadge({super.key, required this.status});

  final SystemIncidentStatus status;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.secondary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        resolveSystemMonitoringKey(context, status.localizationKey()),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Compact badge for nav / dashboard showing active incident count.
class SystemMonitoringIncidentNavBadge extends StatelessWidget {
  const SystemMonitoringIncidentNavBadge({
    super.key,
    required this.activeCount,
  });

  final int activeCount;

  @override
  Widget build(BuildContext context) {
    if (activeCount <= 0) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.error.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        resolveSystemMonitoringKey(
          context,
          'systemMonitoringActiveIncidentsBadge',
          params: {'count': '$activeCount'},
        ),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.error,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
