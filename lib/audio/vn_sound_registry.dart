import 'vn_sound_definition.dart';

/// Central ViaNexis sound registry (Admin App).
class VnSoundRegistry {
  VnSoundRegistry._();

  static const List<VnSoundDefinition> all = [
    VnSoundDefinition(
      id: 'alarm1',
      category: VnSoundCategory.alarm,
      assetPath: 'assets/sounds/alarm/alarm1.mp3',
      androidResourceName: 'vn_alarm_1',
      localizationKey: 'settingsSoundAlarm1',
      loopAllowed: true,
      critical: true,
    ),
    VnSoundDefinition(
      id: 'alarm2',
      category: VnSoundCategory.alarm,
      assetPath: 'assets/sounds/alarm/alarm2.mp3',
      androidResourceName: 'vn_alarm_2',
      localizationKey: 'settingsSoundAlarm2',
      loopAllowed: true,
      critical: true,
    ),
    VnSoundDefinition(
      id: 'alarm3',
      category: VnSoundCategory.alarm,
      assetPath: 'assets/sounds/alarm/alarm3.mp3',
      androidResourceName: 'vn_alarm_3',
      localizationKey: 'settingsSoundAlarm3',
      loopAllowed: true,
      critical: true,
    ),
    VnSoundDefinition(
      id: 'message1',
      category: VnSoundCategory.message,
      assetPath: 'assets/sounds/message/message1.mp3',
      androidResourceName: 'vn_message_1',
      localizationKey: 'settingsSoundMessage1',
    ),
    VnSoundDefinition(
      id: 'message2',
      category: VnSoundCategory.message,
      assetPath: 'assets/sounds/message/message2.mp3',
      androidResourceName: 'vn_message_2',
      localizationKey: 'settingsSoundMessage2',
    ),
    VnSoundDefinition(
      id: 'message3',
      category: VnSoundCategory.message,
      assetPath: 'assets/sounds/message/message3.mp3',
      androidResourceName: 'vn_message_3',
      localizationKey: 'settingsSoundMessage3',
    ),
    VnSoundDefinition(
      id: 'message4',
      category: VnSoundCategory.message,
      assetPath: 'assets/sounds/message/message4.mp3',
      androidResourceName: 'vn_message_4',
      localizationKey: 'settingsSoundMessage4',
    ),
    VnSoundDefinition(
      id: 'ring1',
      category: VnSoundCategory.ring,
      assetPath: 'assets/sounds/ring/ring1.mp3',
      androidResourceName: 'vn_ring_1',
      localizationKey: 'settingsSoundRing1',
      loopAllowed: true,
    ),
    VnSoundDefinition(
      id: 'ring2',
      category: VnSoundCategory.ring,
      assetPath: 'assets/sounds/ring/ring2.mp3',
      androidResourceName: 'vn_ring_2',
      localizationKey: 'settingsSoundRing2',
      loopAllowed: true,
    ),
    VnSoundDefinition(
      id: 'ring3',
      category: VnSoundCategory.ring,
      assetPath: 'assets/sounds/ring/ring3.mp3',
      androidResourceName: 'vn_ring_3',
      localizationKey: 'settingsSoundRing3',
      loopAllowed: true,
    ),
    VnSoundDefinition(
      id: 'ring4',
      category: VnSoundCategory.ring,
      assetPath: 'assets/sounds/ring/ring4.mp3',
      androidResourceName: 'vn_ring_4',
      localizationKey: 'settingsSoundRing4',
      loopAllowed: true,
    ),
    VnSoundDefinition(
      id: 'sign1',
      category: VnSoundCategory.sign,
      assetPath: 'assets/sounds/sign/sign1.mp3',
      androidResourceName: 'vn_sign_1',
      localizationKey: 'settingsSoundSign1',
    ),
    VnSoundDefinition(
      id: 'sign2',
      category: VnSoundCategory.sign,
      assetPath: 'assets/sounds/sign/sign2.mp3',
      androidResourceName: 'vn_sign_2',
      localizationKey: 'settingsSoundSign2',
    ),
    VnSoundDefinition(
      id: 'sign3',
      category: VnSoundCategory.sign,
      assetPath: 'assets/sounds/sign/sign3.mp3',
      androidResourceName: 'vn_sign_3',
      localizationKey: 'settingsSoundSign3',
    ),
    VnSoundDefinition(
      id: 'sign4',
      category: VnSoundCategory.sign,
      assetPath: 'assets/sounds/sign/sign4.mp3',
      androidResourceName: 'vn_sign_4',
      localizationKey: 'settingsSoundSign4',
    ),
  ];

  static const Map<VnSoundCategory, String> defaults = {
    VnSoundCategory.alarm: 'alarm1',
    VnSoundCategory.message: 'message1',
    VnSoundCategory.ring: 'ring1',
    VnSoundCategory.sign: 'sign1',
  };

  static VnSoundDefinition? byId(String? id) {
    final normalized = (id ?? '').trim();
    if (normalized.isEmpty) return null;
    for (final sound in all) {
      if (sound.id == normalized) return sound;
    }
    return null;
  }

  static List<VnSoundDefinition> forCategory(VnSoundCategory category) {
    return all.where((s) => s.category == category).toList(growable: false);
  }

  static VnSoundDefinition defaultFor(VnSoundCategory category) {
    return byId(defaults[category]) ?? forCategory(category).first;
  }

  static VnSoundDefinition resolve({
    required VnSoundCategory category,
    String? selectedId,
    String? variantId,
  }) {
    final variant = byId(variantId);
    if (variant != null && variant.category == category) {
      return variant;
    }
    final selected = byId(selectedId);
    if (selected != null && selected.category == category) {
      return selected;
    }
    return defaultFor(category);
  }
}
