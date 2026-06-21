import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/customer_message_delivery.dart';

class DeliveryStatusBadge extends StatelessWidget {
  const DeliveryStatusBadge({
    super.key,
    required this.delivery,
  });

  final CustomerMessageDelivery delivery;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final Color background;
    final Color foreground;
    switch (delivery.deliveryStatus) {
      case CustomerMessageDeliveryStatus.sent:
        background = scheme.primaryContainer;
        foreground = scheme.onPrimaryContainer;
      case CustomerMessageDeliveryStatus.failed:
        background = scheme.errorContainer;
        foreground = scheme.onErrorContainer;
      case CustomerMessageDeliveryStatus.skipped:
        background = scheme.surfaceContainerHighest;
        foreground = scheme.onSurfaceVariant;
      default:
        background = scheme.secondaryContainer;
        foreground = scheme.onSecondaryContainer;
    }

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        Chip(
          label: Text(
            resolveCustomerCommunicationsKey(
              context,
              delivery.deliveryStatus.localizationKey(),
            ),
          ),
          backgroundColor: background,
          labelStyle: TextStyle(color: foreground),
        ),
        Chip(
          label: Text(
            resolveCustomerCommunicationsKey(
              context,
              delivery.deliveryChannel.localizationKey(),
            ),
          ),
        ),
        Chip(
          label: Text(delivery.deliveryProvider),
        ),
        if (delivery.humanConfirmed)
          Chip(
            label: Text(
              resolveCustomerCommunicationsKey(
                context,
                'customerCommunicationHumanConfirmedBadge',
              ),
            ),
          ),
        if (delivery.translationApproved)
          Chip(
            label: Text(
              resolveCustomerCommunicationsKey(
                context,
                'customerCommunicationTranslationApprovedBadge',
              ),
            ),
          ),
      ],
    );
  }
}
