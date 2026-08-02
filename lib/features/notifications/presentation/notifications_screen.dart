import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_router.dart';
import '../../../core/widgets/vianexis_confirm_dialog.dart';
import '../../../l10n/app_localizations.dart';
import '../../audit_logs/presentation/event_log_pdf_archive_screen.dart';
import '../data/notifications_repository.dart';
import '../widgets/notification_card.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  Future<void> _deleteOne(
    BuildContext context,
    WidgetRef ref,
    String id,
  ) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showVianexisConfirmDialog(
      context: context,
      title: l10n.notificationsDeleteTitle,
      body: l10n.notificationsDeleteBody,
      confirmLabel: l10n.notificationsDeleteConfirm,
      isDestructive: true,
    );
    if (confirmed != true) return;
    await ref.read(notificationsProvider.notifier).deleteNotification(id);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.notificationsDeleted)),
    );
  }

  Future<void> _deleteNotificationsOnly(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showVianexisConfirmDialog(
      context: context,
      title: l10n.notificationsDeleteAllTitle,
      body: l10n.notificationsDeleteAllBody,
      confirmLabel: l10n.notificationsDeleteConfirm,
      isDestructive: true,
    );
    if (confirmed != true) return;
    await ref.read(notificationsProvider.notifier).deleteAllNotifications();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.notificationsDeleted)),
    );
  }

  Future<void> _deleteActivitiesOnly(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showVianexisConfirmDialog(
      context: context,
      title: l10n.eventLogPdfDeleteAllTitle,
      body: l10n.eventLogPdfDeleteAllBody,
      confirmLabel: l10n.eventLogPdfDeleteConfirm,
      isDestructive: true,
    );
    if (confirmed != true) return;
    await ref.read(eventLogPdfArchiveStoreProvider).deleteAll();
    ref.invalidate(eventLogPdfArchiveListProvider);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.eventLogPdfDeleted)),
    );
  }

  Future<void> _deleteBoth(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showVianexisConfirmDialog(
      context: context,
      title: l10n.notificationsDeleteBothTitle,
      body: l10n.notificationsDeleteBothBody,
      confirmLabel: l10n.notificationsDeleteConfirm,
      isDestructive: true,
    );
    if (confirmed != true) return;
    await ref.read(notificationsProvider.notifier).deleteAllNotifications();
    await ref.read(eventLogPdfArchiveStoreProvider).deleteAll();
    ref.invalidate(eventLogPdfArchiveListProvider);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.notificationsDeletedBoth)),
    );
  }

  Future<void> _showDeleteMenu(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final choice = await showModalBottomSheet<String>(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.notifications_off_outlined),
                title: Text(l10n.notificationsDeleteAllTitle),
                onTap: () => Navigator.pop(sheetContext, 'notifications'),
              ),
              ListTile(
                leading: const Icon(Icons.picture_as_pdf_outlined),
                title: Text(l10n.eventLogPdfDeleteAllTitle),
                onTap: () => Navigator.pop(sheetContext, 'activities'),
              ),
              ListTile(
                leading: const Icon(Icons.delete_forever_outlined),
                title: Text(l10n.notificationsDeleteBothTitle),
                onTap: () => Navigator.pop(sheetContext, 'both'),
              ),
            ],
          ),
        );
      },
    );
    if (!context.mounted || choice == null) return;
    switch (choice) {
      case 'notifications':
        await _deleteNotificationsOnly(context, ref);
      case 'activities':
        await _deleteActivitiesOnly(context, ref);
      case 'both':
        await _deleteBoth(context, ref);
    }
  }

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
            onPressed: () => context.push(AdminRoutes.notificationPreferences),
            child: Text(l10n.notificationsPreferences),
          ),
          TextButton(
            onPressed: () =>
                ref.read(notificationsProvider.notifier).markAllRead(),
            child: Text(l10n.notificationsMarkAllRead),
          ),
          IconButton(
            tooltip: l10n.notificationsDeleteMenu,
            onPressed: () => _showDeleteMenu(context, ref),
            icon: const Icon(Icons.delete_outline),
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
                    return Dismissible(
                      key: ValueKey(item.id),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (_) async {
                        final confirmed = await showVianexisConfirmDialog(
                          context: context,
                          title: l10n.notificationsDeleteTitle,
                          body: l10n.notificationsDeleteBody,
                          confirmLabel: l10n.notificationsDeleteConfirm,
                          isDestructive: true,
                        );
                        return confirmed == true;
                      },
                      onDismissed: (_) async {
                        await ref
                            .read(notificationsProvider.notifier)
                            .deleteNotification(item.id);
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.notificationsDeleted)),
                        );
                      },
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        color: Theme.of(context).colorScheme.error,
                        child: Icon(
                          Icons.delete_outline,
                          color: Theme.of(context).colorScheme.onError,
                        ),
                      ),
                      child: NotificationCard(
                        item: item,
                        onTap: () => context.push(
                          AdminRoutes.notificationDetail(item.id),
                        ),
                        onMarkRead: () => ref
                            .read(notificationsProvider.notifier)
                            .markRead(item.id),
                        onDelete: () => _deleteOne(context, ref, item.id),
                      ),
                    );
                  },
                );
              },
              error: (error, _) =>
                  Center(child: Text(l10n.notificationsLoadError('$error'))),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }
}
