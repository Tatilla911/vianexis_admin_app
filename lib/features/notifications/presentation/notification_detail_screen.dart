import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../data/notifications_repository.dart';

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
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(item.title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              Text(item.body),
              const SizedBox(height: 12),
              Text(l10n.notificationsTypeLabel(item.type.backendValue)),
              Text(l10n.notificationsSeverityLabel(item.severity.backendValue)),
              Text(
                l10n.notificationsInAppOnlyLabel(
                  item.inAppOnly ? l10n.notificationsYes : l10n.notificationsNo,
                ),
              ),
              const SizedBox(height: 12),
              if (item.metadata.isNotEmpty)
                ...item.metadata.entries.map((e) => Text('${e.key}: ${e.value}')),
            ],
          );
        },
      ),
    );
  }
}
