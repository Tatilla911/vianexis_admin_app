import 'package:flutter/material.dart';

import '../../../app/vianexis_brand.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/admin_notification.dart';
import '../domain/admin_notification_presentation.dart';
import '../domain/notification_severity.dart';
import '../domain/notification_type.dart';
import 'notification_severity_badge.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onMarkRead,
    this.onDelete,
    this.now,
  });

  final AdminNotification item;
  final VoidCallback onTap;
  final VoidCallback onMarkRead;
  final VoidCallback? onDelete;
  final DateTime? now;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = AdminNotificationPresentation.displayTitle(context, item);
    final body = AdminNotificationPresentation.displayBody(context, item);
    final timestamp = AdminNotificationPresentation.formatTimestamp(
      context,
      item.createdAt,
      now: now,
    );
    final unread = !item.isRead;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: VianexisBrand.spaceMd,
        vertical: VianexisBrand.spaceXs,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(VianexisBrand.radiusMd),
          child: Ink(
            decoration: BoxDecoration(
              color: item.type == NotificationType.emergencyAlert ||
                      item.severity == NotificationSeverity.critical
                  ? Theme.of(context).colorScheme.errorContainer
                  : VianexisBrand.surfaceOf(theme.brightness),
              borderRadius: BorderRadius.circular(VianexisBrand.radiusMd),
              border: Border.all(
                color: item.type == NotificationType.emergencyAlert ||
                        item.severity == NotificationSeverity.critical
                    ? Theme.of(context).colorScheme.error.withValues(alpha: 0.55)
                    : unread
                    ? VianexisBrand.goldAccent.withValues(alpha: 0.55)
                    : VianexisBrand.borderOf(theme.brightness),
              ),
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 4,
                    decoration: BoxDecoration(
                      color: unread
                          ? VianexisBrand.goldAccent
                          : Colors.transparent,
                      borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(VianexisBrand.radiusMd),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        VianexisBrand.spaceMd,
                        VianexisBrand.spaceMd,
                        VianexisBrand.spaceSm,
                        VianexisBrand.spaceMd,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  title,
                                  maxLines: AdminNotificationPresentation
                                      .titleMaxLines,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: unread
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(width: VianexisBrand.spaceSm),
                              Text(
                                timestamp,
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: theme.textTheme.bodySmall?.color,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: VianexisBrand.spaceSm),
                          Text(
                            body,
                            maxLines: AdminNotificationPresentation
                                .bodyPreviewMaxLines,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium,
                          ),
                          const SizedBox(height: VianexisBrand.spaceMd),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Wrap(
                                  spacing: VianexisBrand.spaceSm,
                                  runSpacing: VianexisBrand.spaceXs,
                                  children: [
                                    NotificationSeverityBadge(
                                      severity: item.severity,
                                    ),
                                    if (item.inAppOnly)
                                      Chip(
                                        label: Text(
                                          l10n.notificationsInAppChip,
                                        ),
                                        visualDensity: VisualDensity.compact,
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                  ],
                                ),
                              ),
                              Wrap(
                                spacing: 0,
                                children: [
                                  if (unread)
                                    IconButton(
                                      visualDensity: VisualDensity.compact,
                                      tooltip: l10n.notificationsMarkAllRead,
                                      onPressed: onMarkRead,
                                      icon: const Icon(
                                        Icons.mark_email_read_outlined,
                                      ),
                                    )
                                  else
                                    const Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Icon(Icons.drafts_outlined),
                                    ),
                                  if (onDelete != null)
                                    IconButton(
                                      visualDensity: VisualDensity.compact,
                                      tooltip: l10n.notificationsDeleteTitle,
                                      onPressed: onDelete,
                                      icon: const Icon(Icons.delete_outline),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
