import 'translation_status.dart';

class TranslationRecord {
  const TranslationRecord({
    required this.id,
    required this.sourceType,
    required this.sourceId,
    required this.sourceField,
    required this.originalTextHash,
    required this.targetLanguage,
    required this.status,
    required this.needsReview,
    required this.metadataOnly,
    required this.humanConfirmationRequired,
    required this.stale,
    this.sourceLanguage,
    this.translatedText,
    this.provider,
    this.providerModel,
    this.confidence,
    this.companyId,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String sourceType;
  final String sourceId;
  final String sourceField;
  final String originalTextHash;
  final String? sourceLanguage;
  final String targetLanguage;
  final String? translatedText;
  final String? provider;
  final String? providerModel;
  final double? confidence;
  final TranslationStatus status;
  final bool needsReview;
  final String? companyId;
  final bool metadataOnly;
  final bool humanConfirmationRequired;
  final bool stale;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory TranslationRecord.fromJson(Map<String, dynamic> json) {
    return TranslationRecord(
      id: json['id']?.toString() ?? '',
      sourceType: json['sourceType']?.toString() ?? '',
      sourceId: json['sourceId']?.toString() ?? '',
      sourceField: json['sourceField']?.toString() ?? '',
      originalTextHash: json['originalTextHash']?.toString() ?? '',
      sourceLanguage: json['sourceLanguage']?.toString(),
      targetLanguage: json['targetLanguage']?.toString() ?? 'en',
      translatedText: json['translatedText']?.toString(),
      provider: json['provider']?.toString(),
      providerModel: json['providerModel']?.toString(),
      confidence: (json['confidence'] as num?)?.toDouble(),
      status:
          TranslationStatusParsing.tryParse(json['status']?.toString()) ??
          TranslationStatus.draft,
      needsReview: json['needsReview'] == true,
      companyId: json['companyId']?.toString(),
      metadataOnly: json['metadataOnly'] == true,
      humanConfirmationRequired: json['humanConfirmationRequired'] != false,
      stale: json['stale'] == true,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? ''),
    );
  }
}
