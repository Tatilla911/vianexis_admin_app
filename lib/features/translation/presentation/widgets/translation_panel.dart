import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_exception.dart';
import '../../../../core/api/api_exception_feedback.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/translation_repository.dart';
import '../../domain/reply_translation_preview.dart';
import '../../domain/translation_request.dart';
import 'language_selector.dart';
import 'original_text_card.dart';
import 'translated_text_card.dart';

class TranslationPanel extends ConsumerStatefulWidget {
  const TranslationPanel({
    super.key,
    required this.sourceType,
    required this.sourceId,
    required this.sourceField,
    required this.originalText,
    this.companyId,
    this.initialTargetLanguage = 'en',
  });

  final String sourceType;
  final String sourceId;
  final String sourceField;
  final String originalText;
  final String? companyId;
  final String initialTargetLanguage;

  @override
  ConsumerState<TranslationPanel> createState() => _TranslationPanelState();
}

class _TranslationPanelState extends ConsumerState<TranslationPanel> {
  late String _targetLanguage = widget.initialTargetLanguage;
  bool _loadingStatus = true;
  bool _translating = false;
  TranslationProviderStatus? _status;
  ReplyTranslationPreview? _lastResult;
  String? _errorKey;

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    setState(() {
      _loadingStatus = true;
      _errorKey = null;
    });
    try {
      final status = await ref.read(translationRepositoryProvider).fetchProviderStatus();
      if (!mounted) return;
      setState(() {
        _status = status;
        _loadingStatus = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loadingStatus = false;
        _status = const TranslationProviderStatus(
          enabled: false,
          provider: 'none',
          requireHumanConfirmation: true,
        );
      });
    }
  }

  Future<void> _translate() async {
    final l10n = AppLocalizations.of(context);
    if (_status?.enabled != true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.translationProviderDisabled)),
      );
      return;
    }

    setState(() {
      _translating = true;
      _errorKey = null;
    });

    try {
      final result = await ref.read(translationRepositoryProvider).translate(
        TranslationRequest(
          sourceType: widget.sourceType,
          sourceId: widget.sourceId,
          sourceField: widget.sourceField,
          text: widget.originalText,
          targetLanguage: _targetLanguage,
          companyId: widget.companyId,
        ),
      );
      if (!mounted) return;
      setState(() {
        _lastResult = ReplyTranslationPreview(
          enabled: result.enabled,
          provider: result.provider,
          originalText: result.originalText,
          translatedText: result.translatedText,
          detectedSourceLanguage: result.detectedSourceLanguage,
          humanConfirmationRequired: result.humanConfirmationRequired,
          autoSendAllowed: result.autoSendAllowed,
          record: result.record,
        );
        _translating = false;
      });
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() => _translating = false);
      showApiExceptionSnackBar(context, error);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _translating = false;
        _errorKey = 'translationActionError';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (_loadingStatus) {
      return const LinearProgressIndicator();
    }

    final enabled = _status?.enabled == true;
    final result = _lastResult;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.translationPanelTitle, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        if (!enabled)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(l10n.translationProviderDisabled),
            ),
          ),
        LanguageSelector(
          label: l10n.translationTargetLanguageLabel,
          selectedCode: _targetLanguage,
          onChanged: (value) => setState(() => _targetLanguage = value),
        ),
        const SizedBox(height: 8),
        FilledButton(
          onPressed: enabled && !_translating ? _translate : null,
          child: _translating
              ? Text(l10n.translationTranslating)
              : Text(l10n.translationTranslateAction),
        ),
        if (_errorKey != null) ...[
          const SizedBox(height: 8),
          Text(l10n.translationActionError, style: TextStyle(color: Theme.of(context).colorScheme.error)),
        ],
        const SizedBox(height: 12),
        OriginalTextCard(text: widget.originalText),
        if (result != null) ...[
          const SizedBox(height: 12),
          TranslatedTextCard(
            text: result.translatedText,
            record: result.record,
            languageCode: result.record.targetLanguage,
          ),
          if (result.humanConfirmationRequired)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                l10n.translationHumanConfirmationRequired,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
        ],
      ],
    );
  }
}
