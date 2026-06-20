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
