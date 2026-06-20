import 'translation_record.dart';

class ReplyTranslationPreview {
  const ReplyTranslationPreview({
    required this.originalText,
    required this.translatedText,
    required this.humanConfirmationRequired,
    required this.autoSendAllowed,
    required this.record,
    this.detectedSourceLanguage,
    this.provider,
    this.enabled = true,
  });

  final bool enabled;
  final String? provider;
  final String originalText;
  final String? translatedText;
  final String? detectedSourceLanguage;
  final bool humanConfirmationRequired;
  final bool autoSendAllowed;
  final TranslationRecord record;

  factory ReplyTranslationPreview.fromJson(Map<String, dynamic> json) {
    final recordJson = json['record'];
    return ReplyTranslationPreview(
      enabled: json['enabled'] == true,
      provider: json['provider']?.toString(),
      originalText: json['originalText']?.toString() ?? '',
      translatedText: json['translatedText']?.toString(),
      detectedSourceLanguage: json['detectedSourceLanguage']?.toString(),
      humanConfirmationRequired: json['humanConfirmationRequired'] != false,
      autoSendAllowed: json['autoSendAllowed'] == true,
      record: recordJson is Map<String, dynamic>
          ? TranslationRecord.fromJson(recordJson)
          : TranslationRecord.fromJson(
              Map<String, dynamic>.from(recordJson as Map),
            ),
    );
  }
}

class TranslationOperationResult {
  const TranslationOperationResult({
    required this.enabled,
    required this.originalText,
    required this.translatedText,
    required this.humanConfirmationRequired,
    required this.autoSendAllowed,
    required this.record,
    this.provider,
    this.detectedSourceLanguage,
  });

  final bool enabled;
  final String? provider;
  final String originalText;
  final String? translatedText;
  final String? detectedSourceLanguage;
  final bool humanConfirmationRequired;
  final bool autoSendAllowed;
  final TranslationRecord record;

  factory TranslationOperationResult.fromJson(Map<String, dynamic> json) {
    final recordJson = json['record'];
    return TranslationOperationResult(
      enabled: json['enabled'] == true,
      provider: json['provider']?.toString(),
      originalText: json['originalText']?.toString() ?? '',
      translatedText: json['translatedText']?.toString(),
      detectedSourceLanguage: json['detectedSourceLanguage']?.toString(),
      humanConfirmationRequired: json['humanConfirmationRequired'] != false,
      autoSendAllowed: json['autoSendAllowed'] == true,
      record: recordJson is Map<String, dynamic>
          ? TranslationRecord.fromJson(recordJson)
          : TranslationRecord.fromJson(
              Map<String, dynamic>.from(recordJson as Map),
            ),
    );
  }
}
