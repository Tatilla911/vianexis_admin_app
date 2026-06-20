import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_router.dart';
import '../../../l10n/app_localizations.dart';
import '../data/notifications_repository.dart';
import '../widgets/notification_card.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final asyncItems = ref.watch(notificationsProvider);
    final repo = ref.watch(notificationsRepositoryProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notificationsTitle),
        actions: [
          TextButton(
            onPressed: () => context.go(AdminRoutes.notificationPreferences),
            child: Text(l10n.notificationsPreferences),
          ),
          TextButton(
            onPressed: () =>
                ref.read(notificationsProvider.notifier).markAllRead(),
            child: Text(l10n.notificationsMarkAllRead),
          ),
        ],
      ),
      body: Column(
        children: [
          if (repo.inAppOnly)
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(l10n.notificationsInAppOnlyTitle),
              subtitle: Text(l10n.notificationsInAppOnlyBody),
            ),
          Expanded(
            child: asyncItems.when(
              data: (items) {
                if (items.isEmpty) {
                  return Center(child: Text(l10n.notificationsEmpty));
                }
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return NotificationCard(
                      item: item,
                      onTap: () => context.go(AdminRoutes.notificationDetail(item.id)),
                      onMarkRead: () =>
                          ref.read(notificationsProvider.notifier).markRead(item.id),
                    );
                  },
                );
              },
              error: (error, _) => Center(child: Text('Failed: $error')),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }
}
