class LanguageOption {
  const LanguageOption({
    required this.code,
    required this.englishName,
    required this.nativeName,
    this.enabledForTranslation = true,
  });

  final String code;
  final String englishName;
  final String nativeName;
  final bool enabledForTranslation;

  String get displayLabel => '$nativeName ($code)';

  static const List<LanguageOption> adminDefaults = [
    LanguageOption(code: 'hu', englishName: 'Hungarian', nativeName: 'Magyar'),
    LanguageOption(code: 'en', englishName: 'English', nativeName: 'English'),
    LanguageOption(code: 'de', englishName: 'German', nativeName: 'Deutsch'),
    LanguageOption(code: 'ro', englishName: 'Romanian', nativeName: 'Română'),
    LanguageOption(code: 'sk', englishName: 'Slovak', nativeName: 'Slovenčina'),
    LanguageOption(code: 'pl', englishName: 'Polish', nativeName: 'Polski'),
  ];

  static LanguageOption? findByCode(String? code) {
    if (code == null) return null;
    final normalized = code.toLowerCase();
    for (final option in adminDefaults) {
      if (option.code == normalized) return option;
    }
    return null;
  }
}
