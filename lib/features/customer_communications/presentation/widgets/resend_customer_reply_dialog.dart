import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/send_reply_request.dart';

class ResendCustomerReplyDialog extends StatefulWidget {
  const ResendCustomerReplyDialog({
    super.key,
    required this.providerDisabled,
    this.translationApproved = false,
  });

  final bool providerDisabled;
  final bool translationApproved;

  @override
  State<ResendCustomerReplyDialog> createState() =>
      _ResendCustomerReplyDialogState();
}

class _ResendCustomerReplyDialogState extends State<ResendCustomerReplyDialog> {
  final _reasonController = TextEditingController();
  bool _humanConfirmed = false;
  String? _reasonError;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        resolveCustomerCommunicationsKey(
          context,
          'customerCommunicationResendTitle',
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              resolveCustomerCommunicationsKey(
                context,
                'customerCommunicationResendAuditNotice',
              ),
            ),
            if (widget.providerDisabled) ...[
              const SizedBox(height: 12),
              Text(
                resolveCustomerCommunicationsKey(
                  context,
                  'customerCommunicationDeliveryProviderDisabledNotice',
                ),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ],
            if (widget.translationApproved) ...[
              const SizedBox(height: 12),
              Text(
                resolveCustomerCommunicationsKey(
                  context,
                  'customerCommunicationResendTranslationNotice',
                ),
              ),
            ],
            const SizedBox(height: 16),
            TextField(
              controller: _reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: resolveCustomerCommunicationsKey(
                  context,
                  'customerCommunicationReasonLabel',
                ),
                errorText: _reasonError,
              ),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                resolveCustomerCommunicationsKey(
                  context,
                  'customerCommunicationHumanConfirmationLabel',
                ),
              ),
              value: _humanConfirmed,
              onChanged: (value) =>
                  setState(() => _humanConfirmed = value ?? false),
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
          onPressed: _submit,
          child: Text(
            resolveCustomerCommunicationsKey(
              context,
              'customerCommunicationResendAction',
            ),
          ),
        ),
      ],
    );
  }

  void _submit() {
    final reason = _reasonController.text.trim();
    if (reason.length < 5) {
      setState(() {
        _reasonError = resolveCustomerCommunicationsKey(
          context,
          'customerCommunicationReasonRequired',
        );
      });
      return;
    }
    if (!_humanConfirmed) {
      setState(() {
        _reasonError = resolveCustomerCommunicationsKey(
          context,
          'customerCommunicationHumanConfirmRequired',
        );
      });
      return;
    }
    Navigator.of(context).pop(
      ResendCustomerReplyRequest(
        reason: reason,
        humanConfirmed: true,
      ),
    );
  }
}
