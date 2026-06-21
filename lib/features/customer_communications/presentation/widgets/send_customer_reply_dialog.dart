import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/send_reply_request.dart';

class SendCustomerReplyDialog extends StatefulWidget {
  const SendCustomerReplyDialog({
    super.key,
    this.providerDisabled = true,
  });

  final bool providerDisabled;

  @override
  State<SendCustomerReplyDialog> createState() => _SendCustomerReplyDialogState();
}

class _SendCustomerReplyDialogState extends State<SendCustomerReplyDialog> {
  final _messageController = TextEditingController();
  final _subjectController = TextEditingController();
  bool _humanConfirmed = false;
  bool _useTranslatedText = false;

  @override
  void dispose() {
    _messageController.dispose();
    _subjectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        resolveCustomerCommunicationsKey(
          context,
          'customerCommunicationSendReplyTitle',
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              resolveCustomerCommunicationsKey(
                context,
                'customerCommunicationTranslatedReplyWarning',
              ),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (widget.providerDisabled) ...[
              const SizedBox(height: 12),
              Text(
                resolveCustomerCommunicationsKey(
                  context,
                  'customerCommunicationDeliveryProviderDisabledNotice',
                ),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ],
            const SizedBox(height: 12),
            TextField(
              controller: _messageController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: resolveCustomerCommunicationsKey(
                  context,
                  'customerCommunicationSendReplyMessageLabel',
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(
                labelText: resolveCustomerCommunicationsKey(
                  context,
                  'customerCommunicationSendReplySubjectLabel',
                ),
              ),
            ),
            CheckboxListTile(
              value: _useTranslatedText,
              onChanged: (value) =>
                  setState(() => _useTranslatedText = value ?? false),
              title: Text(
                resolveCustomerCommunicationsKey(
                  context,
                  'customerCommunicationUseTranslatedTextLabel',
                ),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            CheckboxListTile(
              value: _humanConfirmed,
              onChanged: (value) =>
                  setState(() => _humanConfirmed = value ?? false),
              title: Text(
                resolveCustomerCommunicationsKey(
                  context,
                  'customerCommunicationHumanConfirmationLabel',
                ),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            resolveCustomerCommunicationsKey(
              context,
              'customerCommunicationCancel',
            ),
          ),
        ),
        FilledButton(
          onPressed: _canSubmit ? _submit : null,
          child: Text(
            resolveCustomerCommunicationsKey(
              context,
              'customerCommunicationSendReplyAction',
            ),
          ),
        ),
      ],
    );
  }

  bool get _canSubmit =>
      _messageController.text.trim().length >= 5 && _humanConfirmed;

  void _submit() {
    Navigator.of(context).pop(
      SendCustomerReplyRequest(
        messageText: _messageController.text.trim(),
        messageLanguage: 'en',
        recipientLanguage: 'en',
        useTranslatedText: _useTranslatedText,
        humanConfirmed: _humanConfirmed,
        subject: _subjectController.text.trim(),
      ),
    );
  }
}
