import 'package:flutter/material.dart';
import 'package:vianexis_admin_app/core/theme/admin_status_colors.dart';

import '../../../l10n/app_localizations.dart';
import '../domain/notification_severity.dart';

class NotificationSeverityBadge extends StatelessWidget {
  const NotificationSeverityBadge({super.key, required this.severity});

  final NotificationSeverity severity;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final (label, color) = switch (severity) {
      NotificationSeverity.info => (
        l10n.notificationsSeverityInfo,
        Colors.blue,
      ),
      NotificationSeverity.warning => (
        l10n.notificationsSeverityWarning,
        Colors.orange,
      ),
      NotificationSeverity.critical => (
        l10n.notificationsSeverityCritical,
        Colors.red,
      ),
      NotificationSeverity.unknown => (
        l10n.notificationsSeverityUnknown,
        AdminStatusColors.neutral,
      ),
    };
    return Chip(
      label: Text(label),
      side: BorderSide(color: color.withValues(alpha: 0.4)),
      backgroundColor: color.withValues(alpha: 0.12),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
