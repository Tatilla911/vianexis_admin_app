import 'package:flutter/foundation.dart';

import 'vn_admin_sound_event_registry.dart';
import 'vn_audio_notification_service.dart';
import 'vn_sound_preferences.dart';
import 'vn_sound_registry.dart';

/// Result of a routed playback attempt (for tests / diagnostics).
class VnSoundPlaybackDecision {
  const VnSoundPlaybackDecision({
    required this.played,
    required this.eventId,
    this.soundId,
    this.ignoredReason,
    this.deduplicated = false,
  });

  final bool played;
  final String eventId;
  final String? soundId;
  final String? ignoredReason;
  final bool deduplicated;
}

/// Central admin domain-event → sound playback.
class VnSoundRouter {
  VnSoundRouter({
    VnAudioNotificationService? audio,
    VnSoundPreferences? preferences,
  }) : _audio = audio ?? VnAudioNotificationService.instance,
       _preferences = preferences ?? VnSoundPreferences();

  static final VnSoundRouter instance = VnSoundRouter();

  final VnAudioNotificationService _audio;
  final VnSoundPreferences _preferences;

  final Set<String> _playedOccurrenceIds = <String>{};
  final Set<String> _playedDedupKeys = <String>{};

  @visibleForTesting
  bool skipActualPlayback = false;

  @visibleForTesting
  void clearDedupeForTests() {
    _playedOccurrenceIds.clear();
    _playedDedupKeys.clear();
    skipActualPlayback = false;
  }

  Future<VnSoundPlaybackDecision> play({
    required String eventId,
    String? occurrenceId,
    String? deduplicationKey,
    String source = 'domain',
    DateTime? eventCreatedAt,
  }) async {
    final def = VnAdminSoundEventRegistry.byId(eventId);
    if (def == null) {
      _log(eventId: eventId, ignoredReason: 'unknown_event', source: source);
      return VnSoundPlaybackDecision(
        played: false,
        eventId: eventId,
        ignoredReason: 'unknown_event',
      );
    }

    if (!def.playsSound || def.defaultCategory == null) {
      _log(eventId: eventId, ignoredReason: 'no_sound_policy', source: source);
      return VnSoundPlaybackDecision(
        played: false,
        eventId: eventId,
        ignoredReason: 'no_sound_policy',
      );
    }

    final occ = (occurrenceId ?? '').trim();
    if (occ.isNotEmpty && _playedOccurrenceIds.contains(occ)) {
      _log(
        eventId: eventId,
        ignoredReason: 'duplicate_occurrence',
        source: source,
        deduplicated: true,
        occurrenceId: occ,
      );
      return VnSoundPlaybackDecision(
        played: false,
        eventId: eventId,
        ignoredReason: 'duplicate_occurrence',
        deduplicated: true,
      );
    }

    final dedup = (deduplicationKey ?? '').trim();
    if (dedup.isNotEmpty && _playedDedupKeys.contains(dedup)) {
      _log(
        eventId: eventId,
        ignoredReason: 'duplicate_dedup_key',
        source: source,
        deduplicated: true,
      );
      return VnSoundPlaybackDecision(
        played: false,
        eventId: eventId,
        ignoredReason: 'duplicate_dedup_key',
        deduplicated: true,
      );
    }

    if (eventCreatedAt != null) {
      final age = DateTime.now().toUtc().difference(eventCreatedAt.toUtc());
      if (age > const Duration(minutes: 10) && !def.loopAllowed) {
        _log(eventId: eventId, ignoredReason: 'stale_event', source: source);
        return VnSoundPlaybackDecision(
          played: false,
          eventId: eventId,
          ignoredReason: 'stale_event',
        );
      }
    }

    final pref = await _preferences.eventPreference(eventId);
    if (!pref.enabled && def.canBeMuted) {
      _log(eventId: eventId, ignoredReason: 'event_muted', source: source);
      return VnSoundPlaybackDecision(
        played: false,
        eventId: eventId,
        ignoredReason: 'event_muted',
      );
    }

    final category = def.defaultCategory!;
    if (!await _preferences.isCategoryEnabled(category) && def.canBeMuted) {
      _log(eventId: eventId, ignoredReason: 'category_muted', source: source);
      return VnSoundPlaybackDecision(
        played: false,
        eventId: eventId,
        ignoredReason: 'category_muted',
      );
    }

    final soundId = await _resolveSoundId(def, pref);
    if (soundId == null) {
      _log(eventId: eventId, ignoredReason: 'invalid_sound', source: source);
      return VnSoundPlaybackDecision(
        played: false,
        eventId: eventId,
        ignoredReason: 'invalid_sound',
      );
    }

    final soundDef = VnSoundRegistry.byId(soundId);
    if (soundDef == null) {
      _log(eventId: eventId, ignoredReason: 'missing_asset', source: source);
      return VnSoundPlaybackDecision(
        played: false,
        eventId: eventId,
        ignoredReason: 'missing_asset',
      );
    }

    if (!def.allowedCategories.contains(soundDef.category)) {
      _log(
        eventId: eventId,
        ignoredReason: 'category_not_allowed',
        source: source,
        soundId: soundId,
      );
      return VnSoundPlaybackDecision(
        played: false,
        eventId: eventId,
        soundId: soundId,
        ignoredReason: 'category_not_allowed',
      );
    }

    if (!skipActualPlayback) {
      await _audio.playDefinition(soundDef, loop: def.loopAllowed);
    }

    if (occ.isNotEmpty) _playedOccurrenceIds.add(occ);
    if (dedup.isNotEmpty) _playedDedupKeys.add(dedup);

    _log(
      eventId: eventId,
      source: source,
      soundId: soundId,
      occurrenceId: occ.isEmpty ? null : occ,
      played: true,
    );

    return VnSoundPlaybackDecision(
      played: true,
      eventId: eventId,
      soundId: soundId,
    );
  }

  Future<String?> _resolveSoundId(
    VnAdminSoundEventDefinition def,
    AdminSoundEventPreference pref,
  ) async {
    if (!pref.useDefault &&
        pref.selectedSoundId != null &&
        pref.selectedSoundId!.trim().isNotEmpty) {
      final custom = pref.selectedSoundId!.trim();
      if (VnAdminSoundEventRegistry.isSoundAllowed(def.id, custom) &&
          VnSoundRegistry.byId(custom) != null) {
        return custom;
      }
    }

    final categoryDefault = await _preferences.selectedSoundId(
      def.defaultCategory!,
    );
    if (VnAdminSoundEventRegistry.isSoundAllowed(def.id, categoryDefault)) {
      return categoryDefault;
    }

    return def.defaultSoundId;
  }

  void _log({
    required String eventId,
    required String source,
    String? soundId,
    String? occurrenceId,
    String? ignoredReason,
    bool played = false,
    bool deduplicated = false,
  }) {
    if (!kDebugMode) return;
    final buf = StringBuffer(
      '[sound-routing] eventType=$eventId source=$source',
    );
    if (soundId != null) buf.write(' selectedSoundId=$soundId');
    if (occurrenceId != null) buf.write(' occurrenceId=$occurrenceId');
    if (ignoredReason != null) buf.write(' ignoredReason=$ignoredReason');
    if (deduplicated) buf.write(' deduplicated=true');
    if (played) buf.write(' played=true');
    debugPrint(buf.toString());
  }
}
