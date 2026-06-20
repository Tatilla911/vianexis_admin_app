import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_exception.dart';
import '../../../../core/api/api_exception_feedback.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/translation_repository.dart';
import '../../domain/reply_translation_preview.dart';
import 'language_selector.dart';
import 'original_text_card.dart';
import 'translated_text_card.dart';

class ReplyTranslationDialogResult {
  const ReplyTranslationDialogResult({
    required this.approved,
    required this.preview,
  });

  final bool approved;
  final ReplyTranslationPreview preview;
}

Future<ReplyTranslationDialogResult?> showReplyTranslationDialog({
  required BuildContext context,
  required WidgetRef ref,
  required String sourceType,
  required String sourceId,
  required String draftText,
  required String draftLanguage,
  String? companyId,
  String initialTargetLanguage = 'en',
}) {
  return showDialog<ReplyTranslationDialogResult>(
    context: context,
    builder: (dialogContext) => _ReplyTranslationDialog(
      ref: ref,
      sourceType: sourceType,
      sourceId: sourceId,
      draftText: draftText,
      draftLanguage: draftLanguage,
      companyId: companyId,
      initialTargetLanguage: initialTargetLanguage,
    ),
  );
}

class _ReplyTranslationDialog extends ConsumerStatefulWidget {
  const _ReplyTranslationDialog({
    required this.ref,
    required this.sourceType,
    required this.sourceId,
    required this.draftText,
    required this.draftLanguage,
    this.companyId,
    required this.initialTargetLanguage,
  });

  final WidgetRef ref;
  final String sourceType;
  final String sourceId;
  final String draftText;
  final String draftLanguage;
  final String? companyId;
  final String initialTargetLanguage;

  @override
  ConsumerState<_ReplyTranslationDialog> createState() =>
      _ReplyTranslationDialogState();
}

class _ReplyTranslationDialogState extends ConsumerState<_ReplyTranslationDialog> {
  late String _targetLanguage = widget.initialTargetLanguage;
  ReplyTranslationPreview? _preview;
  bool _loading = false;
  bool _approving = false;

  Future<void> _generatePreview() async {
    setState(() => _loading = true);
    try {
      final preview = await ref.read(translationRepositoryProvider).previewReply(
        sourceType: widget.sourceType,
        sourceId: widget.sourceId,
        draftText: widget.draftText,
        draftLanguage: widget.draftLanguage,
        targetLanguage: _targetLanguage,
        companyId: widget.companyId,
      );
      if (!mounted) return;
      setState(() {
        _preview = preview;
        _loading = false;
      });
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() => _loading = false);
      showApiExceptionSnackBar(context, error);
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).translationActionError)),
      );
    }
  }

  Future<void> _approvePreview() async {
    final preview = _preview;
    if (preview == null) return;

    setState(() => _approving = true);
    try {
      final approved = await ref
          .read(translationRepositoryProvider)
          .approve(preview.record.id);
      if (!mounted) return;
      Navigator.of(context).pop(
        ReplyTranslationDialogResult(
          approved: true,
          preview: ReplyTranslationPreview(
            enabled: preview.enabled,
            provider: preview.provider,
            originalText: preview.originalText,
            translatedText: approved.translatedText ?? preview.translatedText,
            detectedSourceLanguage: preview.detectedSourceLanguage,
            humanConfirmationRequired: false,
            autoSendAllowed: false,
            record: approved,
          ),
        ),
      );
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() => _approving = false);
      showApiExceptionSnackBar(context, error);
    } catch (_) {
      if (!mounted) return;
      setState(() => _approving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final preview = _preview;

    return AlertDialog(
      title: Text(l10n.translationReplyPreviewTitle),
      content: SizedBox(
        width: 480,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.translationReplyPreviewNotice),
              const SizedBox(height: 12),
              LanguageSelector(
                label: l10n.translationRecipientLanguageLabel,
                selectedCode: _targetLanguage,
                onChanged: (value) => setState(() {
                  _targetLanguage = value;
                  _preview = null;
                }),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: _loading ? null : _generatePreview,
                child: _loading
                    ? Text(l10n.translationTranslating)
                    : Text(l10n.translationGeneratePreviewAction),
              ),
              const SizedBox(height: 12),
              OriginalTextCard(
                text: widget.draftText,
                languageCode: widget.draftLanguage,
              ),
              if (preview != null) ...[
                const SizedBox(height: 12),
                TranslatedTextCard(
                  text: preview.translatedText,
                  record: preview.record,
                  languageCode: preview.record.targetLanguage,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.translationNoAutoSendNotice,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.translationDismissAction),
        ),
        FilledButton(
          onPressed: preview != null && !_approving ? _approvePreview : null,
          child: _approving
              ? Text(l10n.translationApproving)
              : Text(l10n.translationApproveForSendAction),
        ),
      ],
    );
  }
}
