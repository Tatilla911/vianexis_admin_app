import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/system_health_severity.dart';

class SystemHealthSeverityBadge extends StatelessWidget {
  const SystemHealthSeverityBadge({
    super.key,
    required this.severity,
  });

  final SystemHealthSeverity severity;

  Color _color(BuildContext context) {
    return switch (severity) {
      SystemHealthSeverity.info => Theme.of(context).colorScheme.primary,
      SystemHealthSeverity.warning => Colors.orange,
      SystemHealthSeverity.critical => Theme.of(context).colorScheme.error,
      SystemHealthSeverity.unknown => Theme.of(context).colorScheme.outline,
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
        resolveSystemHealthKey(context, severity.localizationKey()),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
