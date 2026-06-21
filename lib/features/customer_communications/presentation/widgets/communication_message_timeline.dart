import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/customer_communication_message.dart';
import 'delivery_status_badge.dart';
import 'translated_message_view.dart';

class CommunicationMessageTimeline extends StatelessWidget {
  const CommunicationMessageTimeline({
    super.key,
    required this.messages,
    this.deliveryCountForMessage,
  });

  final List<CustomerCommunicationMessage> messages;
  final int Function(String messageId)? deliveryCountForMessage;

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return Text(
        resolveCustomerCommunicationsKey(
          context,
          'customerCommunicationMessagesEmpty',
        ),
      );
    }

    return Column(
      children: [
        for (final message in messages)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        Chip(
                          label: Text(
                            resolveCustomerCommunicationsKey(
                              context,
                              message.direction.localizationKey(),
                            ),
                          ),
                        ),
                        Chip(
                          label: Text(
                            resolveCustomerCommunicationsKey(
                              context,
                              message.senderType.localizationKey(),
                            ),
                          ),
                        ),
                        if (message.humanReviewedTranslation)
                          Chip(
                            label: Text(
                              resolveCustomerCommunicationsKey(
                                context,
                                'customerCommunicationHumanReviewedBadge',
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TranslatedMessageView(message: message),
                    if (message.delivery != null) ...[
                      const SizedBox(height: 12),
                      DeliveryStatusBadge(delivery: message.delivery!),
                      if (deliveryCountForMessage != null &&
                          deliveryCountForMessage!(message.id) > 1) ...[
                        const SizedBox(height: 8),
                        Text(
                          resolveCustomerCommunicationsKey(
                            context,
                            'customerCommunicationDeliveryMultipleAttempts',
                          ),
                        ),
                      ],
                      if (message.delivery!.failureMessageSafe != null &&
                          message.delivery!.failureMessageSafe!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          message.delivery!.failureMessageSafe!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
