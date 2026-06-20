import 'package:flutter/material.dart';

import '../domain/notification_severity.dart';

class NotificationSeverityBadge extends StatelessWidget {
  const NotificationSeverityBadge({super.key, required this.severity});

  final NotificationSeverity severity;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (severity) {
      NotificationSeverity.info => ('Info', Colors.blue),
      NotificationSeverity.warning => ('Warning', Colors.orange),
      NotificationSeverity.critical => ('Critical', Colors.red),
      NotificationSeverity.unknown => ('Unknown', Colors.grey),
    };
    return Chip(
      label: Text(label),
      side: BorderSide(color: color.withValues(alpha: 0.4)),
      backgroundColor: color.withValues(alpha: 0.12),
      visualDensity: VisualDensity.compact,
    );
  }
}
