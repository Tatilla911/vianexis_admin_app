import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../data/notifications_repository.dart';
import '../widgets/notification_preferences_form.dart';
import '../widgets/push_provider_status_card.dart';

class NotificationPreferencesScreen extends ConsumerWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final asyncValue = ref.watch(notificationPreferencesProvider);
    final pushStatusAsync = ref.watch(pushProviderStatusProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.notificationsPreferencesTitle)),
      body: asyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Failed: $error')),
        data: (value) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            pushStatusAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (error, stackTrace) => const SizedBox.shrink(),
              data: (status) => PushProviderStatusCard(status: status),
            ),
            const SizedBox(height: 16),
            NotificationPreferencesForm(
              initialValue: value,
              onSave: (next) async {
                await ref.read(notificationPreferencesProvider.notifier).save(next);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.notificationsSaved)),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
