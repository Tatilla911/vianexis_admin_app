import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_exception.dart';
import '../../../../core/api/api_exception_feedback.dart';
import '../../../../core/localization/localization_resolver.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../translation/data/translation_repository.dart';
import '../../domain/send_reply_request.dart';

/// Compose a customer reply. Draft is written in [draftLanguage] (admin
/// preference). Outbound email is translated to [recipientLanguage] (customer
/// sender language) when they differ.
class SendCustomerReplyDialog extends ConsumerStatefulWidget {
  const SendCustomerReplyDialog({
    super.key,
    this.providerDisabled = true,
    required this.threadId,
    required this.draftLanguage,
    required this.recipientLanguage,
    this.companyId,
  });

  final bool providerDisabled;
  final String threadId;
  final String draftLanguage;
  final String recipientLanguage;
  final String? companyId;

  @override
  ConsumerState<SendCustomerReplyDialog> createState() =>
      _SendCustomerReplyDialogState();
}

class _SendCustomerReplyDialogState
    extends ConsumerState<SendCustomerReplyDialog> {
  final _messageController = TextEditingController();
  final _subjectController = TextEditingController();
  bool _humanConfirmed = false;
  bool _sendInCustomerLanguage = true;
  bool _submitting = false;

  @override
  void dispose() {
    _messageController.dispose();
    _subjectController.dispose();
    super.dispose();
  }

  bool get _languagesDiffer =>
      widget.draftLanguage.toLowerCase() !=
      widget.recipientLanguage.toLowerCase();

  bool get _canSubmit =>
      !_submitting &&
      _messageController.text.trim().length >= 5 &&
      _humanConfirmed;

  Future<void> _submit() async {
    final draft = _messageController.text.trim();
    final subject = _subjectController.text.trim();
    final l10n = AppLocalizations.of(context);

    setState(() => _submitting = true);
    try {
      if (!_sendInCustomerLanguage || !_languagesDiffer) {
        if (!mounted) return;
        Navigator.of(context).pop(
          SendCustomerReplyRequest(
            messageText: draft,
            messageLanguage: widget.draftLanguage,
            recipientLanguage: widget.recipientLanguage,
            useTranslatedText: false,
            humanConfirmed: _humanConfirmed,
            subject: subject,
          ),
        );
        return;
      }

      final repo = ref.read(translationRepositoryProvider);
      final preview = await repo.previewReply(
        sourceType: 'customer_communication_thread',
        sourceId: widget.threadId,
        draftText: draft,
        draftLanguage: widget.draftLanguage,
        targetLanguage: widget.recipientLanguage,
        companyId: widget.companyId,
      );
      final approved = await repo.approve(preview.record.id);
      if (!mounted) return;
      Navigator.of(context).pop(
        SendCustomerReplyRequest(
          messageText: draft,
          messageLanguage: widget.draftLanguage,
          recipientLanguage: widget.recipientLanguage,
          translationRecordId: approved.id,
          useTranslatedText: true,
          humanConfirmed: _humanConfirmed,
          subject: subject,
        ),
      );
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() => _submitting = false);
      showApiExceptionSnackBar(context, error);
    } catch (_) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.translationActionError)),
      );
    }
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
                'customerCommunicationReplyLanguageHint',
                params: {
                  'draft': widget.draftLanguage.toUpperCase(),
                  'recipient': widget.recipientLanguage.toUpperCase(),
                },
              ),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
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
              enabled: !_submitting,
              onChanged: (_) => setState(() {}),
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
              enabled: !_submitting,
              decoration: InputDecoration(
                labelText: resolveCustomerCommunicationsKey(
                  context,
                  'customerCommunicationSendReplySubjectLabel',
                ),
              ),
            ),
            if (_languagesDiffer)
              CheckboxListTile(
                value: _sendInCustomerLanguage,
                onChanged: _submitting
                    ? null
                    : (value) => setState(
                          () => _sendInCustomerLanguage = value ?? true,
                        ),
                title: Text(
                  resolveCustomerCommunicationsKey(
                    context,
                    'customerCommunicationSendInCustomerLanguageLabel',
                  ),
                ),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
            CheckboxListTile(
              value: _humanConfirmed,
              onChanged: _submitting
                  ? null
                  : (value) =>
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
          onPressed: _submitting ? null : () => Navigator.of(context).pop(),
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
            _submitting
                ? resolveCustomerCommunicationsKey(
                    context,
                    'customerCommunicationReplyTranslating',
                  )
                : resolveCustomerCommunicationsKey(
                    context,
                    'customerCommunicationSendReplyAction',
                  ),
          ),
        ),
      ],
    );
  }
}
