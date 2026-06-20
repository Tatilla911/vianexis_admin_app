import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../domain/admin_notification.dart';
import 'notification_severity_badge.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onMarkRead,
  });

  final AdminNotification item;
  final VoidCallback onTap;
  final VoidCallback onMarkRead;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      child: ListTile(
        onTap: onTap,
        title: Text(item.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(item.body),
            const SizedBox(height: 8),
            Row(
              children: [
                NotificationSeverityBadge(severity: item.severity),
                const SizedBox(width: 8),
                if (item.inAppOnly)
                  Chip(
                    label: Text(l10n.notificationsInAppChip),
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
          ],
        ),
        trailing: item.isRead
            ? const Icon(Icons.drafts_outlined)
            : IconButton(
                onPressed: onMarkRead,
                icon: const Icon(Icons.mark_email_read_outlined),
              ),
      ),
    );
  }
}
