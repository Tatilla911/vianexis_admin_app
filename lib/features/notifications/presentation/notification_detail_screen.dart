import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/localization_resolver.dart';
import '../../../l10n/app_localizations.dart';
import '../data/notifications_repository.dart';
import '../domain/admin_notification_routing.dart';
import '../domain/notification_type.dart';

class NotificationDetailScreen extends ConsumerWidget {
  const NotificationDetailScreen({super.key, required this.notificationId});

  final String notificationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final asyncItems = ref.watch(notificationsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.notificationsDetailTitle)),
      body: asyncItems.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            Center(child: Text(l10n.notificationsLoadError('$error'))),
        data: (items) {
          final index = items.indexWhere((e) => e.id == notificationId);
          final item = index < 0 ? null : items[index];
          if (item == null) {
            return Center(child: Text(l10n.notificationsNotFound));
          }
          final destination = resolveAdminNotificationDestination(item);
          final canOpenReview =
              item.deepLink != null || item.applicationId != null;
          final fallbackTitleKey =
              item.type == NotificationType.companyApplicationSubmitted
              ? 'notificationCompanyApplicationTitle'
              : 'notificationDriverRegistrationTitle';
          final fallbackBodyKey =
              item.type == NotificationType.companyApplicationSubmitted
              ? 'notificationCompanyApplicationBody'
              : 'notificationDriverRegistrationBody';
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                item.title.isNotEmpty
                    ? item.title
                    : item.type.isRegistrationReview
                    ? resolveNotificationsKey(context, fallbackTitleKey)
                    : l10n.notificationsDetailTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Text(
                item.body.isNotEmpty
                    ? item.body
                    : item.type.isRegistrationReview
                    ? resolveNotificationsKey(context, fallbackBodyKey)
                    : '',
              ),
              const SizedBox(height: 12),
              Text(l10n.notificationsTypeLabel(item.type.backendValue)),
              Text(l10n.notificationsSeverityLabel(item.severity.backendValue)),
              Text(
                l10n.notificationsInAppOnlyLabel(
                  item.inAppOnly ? l10n.notificationsYes : l10n.notificationsNo,
                ),
              ),
              if (canOpenReview) ...[
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => context.go(destination),
                  child: Text(
                    resolveNotificationsKey(
                      context,
                      'notificationOpenRegistration',
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              if (item.displayMetadata.isNotEmpty)
                ...item.displayMetadata.entries.map(
                  (e) => Text('${e.key}: ${e.value}'),
                ),
            ],
          );
        },
      ),
    );
  }
}
