import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_config.dart';
import '../domain/reply_translation_preview.dart';
import '../domain/translation_record.dart';
import '../domain/translation_request.dart';
import '../domain/translation_status.dart';
import 'translation_api.dart';

abstract class TranslationRepository {
  Future<TranslationProviderStatus> fetchProviderStatus();

  Future<TranslationOperationResult> translate(TranslationRequest request);

  Future<DetectedLanguageResult> detectLanguage(String text);

  Future<ReplyTranslationPreview> previewReply({
    required String sourceType,
    required String sourceId,
    required String draftText,
    required String draftLanguage,
    required String targetLanguage,
    String? companyId,
  });

  Future<TranslationRecord> approve(String recordId);

  bool get usesMockData;
}

class TranslationProviderStatus {
  const TranslationProviderStatus({
    required this.enabled,
    required this.provider,
    required this.requireHumanConfirmation,
  });

  final bool enabled;
  final String provider;
  final bool requireHumanConfirmation;
}

class LiveTranslationRepository implements TranslationRepository {
  LiveTranslationRepository(this._api);

  final TranslationApi _api;

  @override
  bool get usesMockData => false;

  @override
  Future<TranslationProviderStatus> fetchProviderStatus() async {
    final json = await _api.fetchStatus();
    return TranslationProviderStatus(
      enabled: json['enabled'] == true,
      provider: json['provider']?.toString() ?? 'none',
      requireHumanConfirmation: json['requireHumanConfirmation'] != false,
    );
  }

  @override
  Future<TranslationOperationResult> translate(
    TranslationRequest request,
  ) async {
    return _api.translate(request);
  }

  @override
  Future<DetectedLanguageResult> detectLanguage(String text) {
    return _api.detectLanguage(text);
  }

  @override
  Future<ReplyTranslationPreview> previewReply({
    required String sourceType,
    required String sourceId,
    required String draftText,
    required String draftLanguage,
    required String targetLanguage,
    String? companyId,
  }) {
    return _api.replyPreview(
      sourceType: sourceType,
      sourceId: sourceId,
      draftText: draftText,
      draftLanguage: draftLanguage,
      targetLanguage: targetLanguage,
      companyId: companyId,
    );
  }

  @override
  Future<TranslationRecord> approve(String recordId) {
    return _api.approve(recordId);
  }
}

class MockTranslationRepository implements TranslationRepository {
  @override
  bool get usesMockData => true;

  @override
  Future<TranslationProviderStatus> fetchProviderStatus() async {
    await Future<void>.delayed(const Duration(milliseconds: 80));
    return const TranslationProviderStatus(
      enabled: false,
      provider: 'none',
      requireHumanConfirmation: true,
    );
  }

  @override
  Future<TranslationOperationResult> translate(
    TranslationRequest request,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    final record = TranslationRecord(
      id: 'mock-translate-1',
      sourceType: request.sourceType,
      sourceId: request.sourceId,
      sourceField: request.sourceField,
      originalTextHash: 'mock-hash',
      sourceLanguage: request.sourceLanguage,
      targetLanguage: request.targetLanguage,
      translatedText: '[${request.targetLanguage}] ${request.text}',
      provider: 'mock',
      status: TranslationStatus.machineTranslated,
      needsReview: true,
      metadataOnly: false,
      humanConfirmationRequired: true,
      stale: false,
    );
    return TranslationOperationResult(
      enabled: true,
      provider: 'mock',
      originalText: request.text,
      translatedText: record.translatedText,
      detectedSourceLanguage: request.sourceLanguage,
      humanConfirmationRequired: true,
      autoSendAllowed: false,
      record: record,
    );
  }

  @override
  Future<DetectedLanguageResult> detectLanguage(String text) async {
    await Future<void>.delayed(const Duration(milliseconds: 40));
    final lower = text.toLowerCase();
    final language = lower.contains('the ') || lower.contains(' and ')
        ? 'en'
        : 'hu';
    return DetectedLanguageResult(
      enabled: true,
      provider: 'mock',
      language: language,
      confidence: 0.9,
    );
  }

  @override
  Future<ReplyTranslationPreview> previewReply({
    required String sourceType,
    required String sourceId,
    required String draftText,
    required String draftLanguage,
    required String targetLanguage,
    String? companyId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    final record = TranslationRecord(
      id: 'mock-1',
      sourceType: sourceType,
      sourceId: sourceId,
      sourceField: 'reply_draft',
      originalTextHash: 'mock-hash',
      sourceLanguage: draftLanguage,
      targetLanguage: targetLanguage,
      translatedText: '[$targetLanguage] $draftText',
      provider: 'mock',
      status: TranslationStatus.machineTranslated,
      needsReview: true,
      metadataOnly: false,
      humanConfirmationRequired: true,
      stale: false,
    );
    return ReplyTranslationPreview(
      enabled: true,
      provider: 'mock',
      originalText: draftText,
      translatedText: record.translatedText,
      detectedSourceLanguage: draftLanguage,
      humanConfirmationRequired: true,
      autoSendAllowed: false,
      record: record,
    );
  }

  @override
  Future<TranslationRecord> approve(String recordId) async {
    await Future<void>.delayed(const Duration(milliseconds: 80));
    return TranslationRecord(
      id: recordId,
      sourceType: 'support_ticket',
      sourceId: '1',
      sourceField: 'reply_draft',
      originalTextHash: 'mock-hash',
      targetLanguage: 'en',
      translatedText: '[en] Approved mock',
      provider: 'mock',
      status: TranslationStatus.approved,
      needsReview: false,
      metadataOnly: false,
      humanConfirmationRequired: false,
      stale: false,
    );
  }
}

final translationRepositoryProvider = Provider<TranslationRepository>((ref) {
  if (AppConfig.instance.shouldUseLiveRepositories) {
    return LiveTranslationRepository(ref.watch(translationApiProvider));
  }
  return MockTranslationRepository();
});
