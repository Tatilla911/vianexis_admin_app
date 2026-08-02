enum VnSoundCategory { alarm, message, ring, sign }

extension VnSoundCategoryX on VnSoundCategory {
  String get wireName => name;

  static VnSoundCategory? tryParse(String? raw) {
    final normalized = (raw ?? '').trim().toLowerCase();
    for (final value in VnSoundCategory.values) {
      if (value.name == normalized) return value;
    }
    return null;
  }
}

class VnSoundDefinition {
  const VnSoundDefinition({
    required this.id,
    required this.category,
    required this.assetPath,
    required this.androidResourceName,
    required this.localizationKey,
    this.loopAllowed = false,
    this.critical = false,
  });

  final String id;
  final VnSoundCategory category;
  final String assetPath;
  final String androidResourceName;
  final String localizationKey;
  final bool loopAllowed;
  final bool critical;
}
