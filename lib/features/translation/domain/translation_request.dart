class TranslationRequest {
  const TranslationRequest({
    required this.sourceType,
    required this.sourceId,
    required this.sourceField,
    required this.text,
    required this.targetLanguage,
    this.sourceLanguage,
    this.companyId,
  });

  final String sourceType;
  final String sourceId;
  final String sourceField;
  final String text;
  final String targetLanguage;
  final String? sourceLanguage;
  final String? companyId;

  Map<String, dynamic> toJson() {
    return {
      'sourceType': sourceType,
      'sourceId': sourceId,
      'sourceField': sourceField,
      'text': text,
      'targetLanguage': targetLanguage,
      if (sourceLanguage != null) 'sourceLanguage': sourceLanguage,
      if (companyId != null) 'companyId': int.tryParse(companyId!) ?? companyId,
    };
  }
}

class DetectedLanguageResult {
  const DetectedLanguageResult({
    required this.enabled,
    required this.provider,
    this.language,
    this.confidence,
  });

  final bool enabled;
  final String provider;
  final String? language;
  final double? confidence;

  factory DetectedLanguageResult.fromJson(Map<String, dynamic> json) {
    final rawConfidence = json['confidence'];
    return DetectedLanguageResult(
      enabled: json['enabled'] == true,
      provider: json['provider']?.toString() ?? 'none',
      language: json['language']?.toString(),
      confidence: rawConfidence is num
          ? rawConfidence.toDouble()
          : double.tryParse(rawConfidence?.toString() ?? ''),
    );
  }
}
