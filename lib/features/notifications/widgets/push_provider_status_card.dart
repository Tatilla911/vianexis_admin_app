import 'package:flutter/material.dart';

import '../../../core/localization/localization_resolver.dart';
import '../../../core/widgets/vianexis_metadata_notice.dart';
import '../domain/push_provider_status.dart';

class PushProviderStatusCard extends StatelessWidget {
  const PushProviderStatusCard({super.key, required this.status});

  final PushProviderStatus status;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              resolveNotificationsKey(context, 'notificationsPushProviderTitle'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              _stateLabel(context),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _row(
              context,
              'notificationsPushProviderField',
              _providerLabel(context, status.provider),
            ),
            _row(
              context,
              'notificationsPushDeliveryEnabled',
              status.deliveryEnabled
                  ? resolveNotificationsKey(context, 'notificationsYes')
                  : resolveNotificationsKey(context, 'notificationsNo'),
            ),
            _row(
              context,
              'notificationsPushTokenStorage',
              status.tokenStorageMode,
            ),
            if (status.lastFailureCode != null)
              _row(
                context,
                'notificationsPushLastFailureCode',
                status.lastFailureCode!,
              ),
            const SizedBox(height: 12),
            VianexisMetadataNotice(
              message: resolveNotificationsKey(context, 'notificationsPushProviderNotice'),
            ),
          ],
        ),
      ),
    );
  }

  String _stateLabel(BuildContext context) {
    return switch (status.uiState) {
      PushProviderUiState.inAppOnly =>
        resolveNotificationsKey(context, 'notificationsPushStateInAppOnly'),
      PushProviderUiState.externalNotConfigured => resolveNotificationsKey(
        context,
        'notificationsPushStateExternalNotConfigured',
      ),
      PushProviderUiState.configured =>
        resolveNotificationsKey(context, 'notificationsPushStateConfigured'),
    };
  }

  String _providerLabel(BuildContext context, String provider) {
    return switch (provider) {
      'none' => resolveNotificationsKey(context, 'notificationsPushProviderNone'),
      'fcm' => resolveNotificationsKey(context, 'notificationsPushProviderFcm'),
      'apns' => resolveNotificationsKey(context, 'notificationsPushProviderApns'),
      _ => provider,
    };
  }

  Widget _row(BuildContext context, String key, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: Text(
              resolveNotificationsKey(context, key),
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
