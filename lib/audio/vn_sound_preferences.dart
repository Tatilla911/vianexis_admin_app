import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../core/api/auth_token_storage.dart';
import 'vn_admin_sound_event_registry.dart';
import 'vn_sound_definition.dart';
import 'vn_sound_registry.dart';

class AdminSoundEventPreference {
  const AdminSoundEventPreference({
    required this.eventId,
    this.enabled = true,
    this.useDefault = true,
    this.selectedSoundId,
  });

  final String eventId;
  final bool enabled;
  final bool useDefault;
  final String? selectedSoundId;

  Map<String, dynamic> toJson() => {
    'eventId': eventId,
    'enabled': enabled,
    'useDefault': useDefault,
    'selectedSoundId': selectedSoundId,
  };

  factory AdminSoundEventPreference.fromJson(Map<String, dynamic> json) {
    return AdminSoundEventPreference(
      eventId: '${json['eventId'] ?? ''}',
      enabled: json['enabled'] != false,
      useDefault: json['useDefault'] != false,
      selectedSoundId: json['selectedSoundId']?.toString(),
    );
  }

  AdminSoundEventPreference copyWith({
    bool? enabled,
    bool? useDefault,
    String? selectedSoundId,
    bool clearSoundId = false,
  }) {
    return AdminSoundEventPreference(
      eventId: eventId,
      enabled: enabled ?? this.enabled,
      useDefault: useDefault ?? this.useDefault,
      selectedSoundId: clearSoundId
          ? null
          : (selectedSoundId ?? this.selectedSoundId),
    );
  }
}

/// User-scoped sound preferences (Admin App).
class VnSoundPreferences {
  VnSoundPreferences({
    AuthTokenStorage? tokenStorage,
    Future<SharedPreferences> Function()? prefsLoader,
    Future<String?> Function()? userIdResolver,
  }) : _tokenStorage = tokenStorage ?? AuthTokenStorage(),
       _prefsLoader = prefsLoader ?? SharedPreferences.getInstance,
       _userIdResolver = userIdResolver;

  final AuthTokenStorage _tokenStorage;
  final Future<SharedPreferences> Function() _prefsLoader;
  final Future<String?> Function()? _userIdResolver;

  static const String basePrefix = 'vianexis_admin_sound_prefs_v1';

  Future<String?> _currentUserId() async {
    final resolver = _userIdResolver;
    if (resolver != null) {
      final resolved = await resolver();
      final trimmed = resolved?.trim();
      if (trimmed == null || trimmed.isEmpty) return null;
      return trimmed;
    }
    final user = await _tokenStorage.readCachedUser();
    final id = user?.id.trim();
    if (id == null || id.isEmpty) return null;
    return id;
  }

  String _scopedKey(String baseKey, String? userId) {
    final id = userId?.trim();
    if (id == null || id.isEmpty) {
      return '${baseKey}__nouser';
    }
    return '${baseKey}__u_$id';
  }

  Future<String> _key(String suffix) async {
    final userId = await _currentUserId();
    return _scopedKey('${basePrefix}_$suffix', userId);
  }

  Future<String> selectedSoundId(VnSoundCategory category) async {
    final prefs = await _prefsLoader();
    final key = await _key('selected_${category.name}');
    final stored = prefs.getString(key);
    final resolved = VnSoundRegistry.resolve(
      category: category,
      selectedId: stored,
    );
    return resolved.id;
  }

  Future<void> setSelectedSoundId(
    VnSoundCategory category,
    String soundId,
  ) async {
    final def = VnSoundRegistry.byId(soundId);
    if (def == null || def.category != category) return;
    final prefs = await _prefsLoader();
    final key = await _key('selected_${category.name}');
    await prefs.setString(key, def.id);
  }

  Future<bool> isCategoryEnabled(VnSoundCategory category) async {
    final prefs = await _prefsLoader();
    final key = await _key('enabled_${category.name}');
    return prefs.getBool(key) ?? true;
  }

  Future<void> setCategoryEnabled(
    VnSoundCategory category,
    bool enabled,
  ) async {
    final prefs = await _prefsLoader();
    final key = await _key('enabled_${category.name}');
    await prefs.setBool(key, enabled);
  }

  Future<double> volumeFor(VnSoundCategory category) async {
    final prefs = await _prefsLoader();
    final key = await _key('volume_${category.name}');
    final value = prefs.getDouble(key);
    if (value == null) return 1.0;
    return value.clamp(0.0, 1.0);
  }

  Future<void> setVolume(VnSoundCategory category, double volume) async {
    final prefs = await _prefsLoader();
    final key = await _key('volume_${category.name}');
    await prefs.setDouble(key, volume.clamp(0.0, 1.0));
  }

  Future<Map<String, AdminSoundEventPreference>> _loadEvents() async {
    final prefs = await _prefsLoader();
    final key = await _key('events_v1');
    final raw = prefs.getString(key);
    if (raw == null || raw.isEmpty) return {};
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return {};
      final out = <String, AdminSoundEventPreference>{};
      for (final entry in decoded.entries) {
        if (entry.value is Map) {
          final pref = AdminSoundEventPreference.fromJson(
            Map<String, dynamic>.from(entry.value as Map),
          );
          if (pref.eventId.isNotEmpty) out[pref.eventId] = pref;
        }
      }
      return out;
    } catch (_) {
      return {};
    }
  }

  Future<void> _saveEvents(Map<String, AdminSoundEventPreference> map) async {
    final prefs = await _prefsLoader();
    final key = await _key('events_v1');
    await prefs.setString(
      key,
      jsonEncode({for (final e in map.entries) e.key: e.value.toJson()}),
    );
  }

  Future<AdminSoundEventPreference> eventPreference(String eventId) async {
    final map = await _loadEvents();
    return map[eventId] ??
        AdminSoundEventPreference(
          eventId: eventId,
          selectedSoundId: VnAdminSoundEventRegistry.byId(
            eventId,
          )?.defaultSoundId,
        );
  }

  Future<void> setEventSoundId(String eventId, String? soundId) async {
    final map = await _loadEvents();
    final current = map[eventId] ?? AdminSoundEventPreference(eventId: eventId);
    if (soundId == null || soundId.isEmpty) {
      map[eventId] = current.copyWith(useDefault: true, clearSoundId: true);
    } else if (VnAdminSoundEventRegistry.isSoundAllowed(eventId, soundId)) {
      map[eventId] = current.copyWith(
        useDefault: false,
        selectedSoundId: soundId,
      );
    } else {
      return;
    }
    await _saveEvents(map);
  }

  Future<void> setEventEnabled(String eventId, bool enabled) async {
    final map = await _loadEvents();
    final current = map[eventId] ?? AdminSoundEventPreference(eventId: eventId);
    map[eventId] = current.copyWith(enabled: enabled);
    await _saveEvents(map);
  }

  Future<void> restoreDefaults() async {
    for (final category in VnSoundCategory.values) {
      await setSelectedSoundId(category, VnSoundRegistry.defaults[category]!);
      await setCategoryEnabled(category, true);
      await setVolume(category, 1.0);
    }
    await _saveEvents({});
  }
}
