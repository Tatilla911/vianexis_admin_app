import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/localization_resolver.dart';
import '../../../core/widgets/backend_dependency_card.dart';
import '../../../core/widgets/vianexis_error_view.dart';
import '../../../core/widgets/vianexis_loading_view.dart';
import '../../../core/widgets/vianexis_metadata_notice.dart';
import '../../notifications/data/notifications_repository.dart';
import '../../notifications/widgets/push_provider_status_card.dart';

class NotificationStatusScreen extends ConsumerWidget {
  const NotificationStatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pushStatusAsync = ref.watch(pushProviderStatusProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(resolveNotificationStatusKey(context, 'notificationStatusTitle')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          VianexisMetadataNotice(
            message: resolveNotificationStatusKey(
              context,
              'notificationStatusPrivacyNotice',
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.check_circle_outline, color: Colors.green),
              title: Text(
                resolveNotificationStatusKey(
                  context,
                  'notificationStatusDriverFoundationTitle',
                ),
              ),
              subtitle: Text(
                resolveNotificationStatusKey(
                  context,
                  'notificationStatusDriverFoundationReady',
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          pushStatusAsync.when(
            loading: () => const VianexisLoadingView(),
            error: (error, _) => VianexisErrorView.fromError(
              context,
              error,
              fallbackMessage: resolveNotificationStatusKey(
                context,
                'notificationStatusLoadFailed',
              ),
              onRetry: () => ref.invalidate(pushProviderStatusProvider),
            ),
            data: (status) => PushProviderStatusCard(status: status),
          ),
          const SizedBox(height: 12),
          BackendDependencyCard(
            title: resolveNotificationStatusKey(
              context,
              'notificationStatusDeviceTokenTitle',
            ),
            message: resolveNotificationStatusKey(
              context,
              'notificationStatusDeviceTokenDependency',
            ),
            endpointHint: 'POST /drivers/device-tokens (planned)',
          ),
          const SizedBox(height: 12),
          BackendDependencyCard(
            title: resolveNotificationStatusKey(
              context,
              'notificationStatusEventsTitle',
            ),
            message: resolveNotificationStatusKey(
              context,
              'notificationStatusEventsDependency',
            ),
            endpointHint: 'GET /platform-admin/notification-events (planned)',
          ),
        ],
      ),
    );
  }
}
