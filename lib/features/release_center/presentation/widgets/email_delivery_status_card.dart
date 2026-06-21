import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../../../core/widgets/vianexis_metadata_notice.dart';
import '../../domain/email_delivery_status.dart';

class EmailDeliveryStatusCard extends StatelessWidget {
  const EmailDeliveryStatusCard({super.key, required this.status});

  final EmailDeliveryStatus status;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              resolveReleaseCenterKey(context, 'releaseEmailDeliveryTitle'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            _row(
              context,
              'releaseEmailDeliveryProvider',
              _providerLabel(context, status.provider),
            ),
            _row(
              context,
              'releaseEmailDeliveryEnabled',
              status.deliveryEnabled
                  ? resolveReleaseCenterKey(context, 'releaseYes')
                  : resolveReleaseCenterKey(context, 'releaseNo'),
            ),
            _row(
              context,
              'releaseEmailDeliveryAllowlistEnabled',
              status.stagingAllowlistEnabled
                  ? resolveReleaseCenterKey(context, 'releaseYes')
                  : resolveReleaseCenterKey(context, 'releaseNo'),
            ),
            if (status.stagingAllowlistEnabled) ...[
              _row(
                context,
                'releaseEmailDeliveryAllowlistDomains',
                status.allowedDomainCount.toString(),
              ),
              _row(
                context,
                'releaseEmailDeliveryAllowlistRecipients',
                status.allowedRecipientCount.toString(),
              ),
            ],
            if (status.lastFailureCode != null)
              _row(
                context,
                'releaseEmailDeliveryLastFailureCode',
                status.lastFailureCode!,
              ),
            if (status.lastDeliveryStatus != null)
              _row(
                context,
                'releaseEmailDeliveryLastStatus',
                status.lastDeliveryStatus!,
              ),
            if (!status.deliveryEnabled || status.noopMode) ...[
              const SizedBox(height: 8),
              Text(
                resolveCustomerCommunicationsKey(
                  context,
                  'customerCommunicationDeliveryProviderDisabledNotice',
                ),
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            if (status.stagingAllowlistMissing) ...[
              const SizedBox(height: 8),
              Text(
                resolveReleaseCenterKey(
                  context,
                  'releaseEmailDeliveryStagingAllowlistMissing',
                ),
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: 12),
            VianexisMetadataNotice(
              message: resolveReleaseCenterKey(context, 'releaseEmailDeliveryNotice'),
            ),
          ],
        ),
      ),
    );
  }

  String _providerLabel(BuildContext context, String provider) {
    return switch (provider) {
      'noop' => resolveReleaseCenterKey(context, 'releaseEmailProviderNoop'),
      'smtp' => resolveReleaseCenterKey(context, 'releaseEmailProviderSmtp'),
      'provider_placeholder' =>
        resolveReleaseCenterKey(context, 'releaseEmailProviderPlaceholder'),
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
              resolveReleaseCenterKey(context, key),
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
