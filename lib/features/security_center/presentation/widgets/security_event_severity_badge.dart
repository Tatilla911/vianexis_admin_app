import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/security_event_severity.dart';

class SecurityEventSeverityBadge extends StatelessWidget {
  const SecurityEventSeverityBadge({super.key, required this.severity});

  final SecurityEventSeverity severity;

  @override
  Widget build(BuildContext context) {
    final color = switch (severity) {
      SecurityEventSeverity.info => Colors.blue,
      SecurityEventSeverity.warning => Colors.orange,
      SecurityEventSeverity.critical => Colors.red,
      SecurityEventSeverity.unknown => Colors.black54,
    };

    return Chip(
      label: Text(resolveSecurityKey(context, severity.localizationKey())),
      backgroundColor: color.withValues(alpha: 0.12),
      side: BorderSide(color: color.withValues(alpha: 0.4)),
    );
  }
}
