import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/customer_communication_message.dart';

class TranslatedMessageView extends StatelessWidget {
  const TranslatedMessageView({
    super.key,
    required this.message,
  });

  final CustomerCommunicationMessage message;

  @override
  Widget build(BuildContext context) {
    if (message.metadataOnly &&
        (message.originalText == null || message.originalText!.isEmpty)) {
      return Text(
        resolveCustomerCommunicationsKey(
          context,
          'customerCommunicationMessageMetadataOnly',
        ),
        style: Theme.of(context).textTheme.bodySmall,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          resolveCustomerCommunicationsKey(
            context,
            'customerCommunicationOriginalLabel',
            params: {'language': message.originalLanguage ?? '—'},
          ),
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 4),
        SelectableText(message.originalText ?? '—'),
        if (message.hasTranslation) ...[
          const SizedBox(height: 12),
          Text(
            resolveCustomerCommunicationsKey(
              context,
              'customerCommunicationTranslatedLabel',
              params: {'language': message.translatedLanguage ?? '—'},
            ),
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 4),
          SelectableText(message.translatedText!),
        ],
      ],
    );
  }
}
