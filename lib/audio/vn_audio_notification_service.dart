import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

import 'vn_sound_definition.dart';
import 'vn_sound_preferences.dart';
import 'vn_sound_registry.dart';

/// Foreground ViaNexis audio playback (Admin App).
///
/// Background Android notification sounds use `android/app/src/main/res/raw`
/// + notification channels — this service does not claim background delivery.
class VnAudioNotificationService {
  VnAudioNotificationService({VnSoundPreferences? preferences})
    : _preferences = preferences ?? VnSoundPreferences();

  static final VnAudioNotificationService instance =
      VnAudioNotificationService();

  final VnSoundPreferences _preferences;

  final Map<VnSoundCategory, AudioPlayer> _players = {};
  String? _previewSoundId;
  String? _activeLoopSoundId;
  VnSoundCategory? _activeLoopCategory;

  bool get isPreviewPlaying => _previewSoundId != null;
  String? get previewSoundId => _previewSoundId;
  String? get activeLoopSoundId => _activeLoopSoundId;

  Future<AudioPlayer> _playerFor(VnSoundCategory category) async {
    final existing = _players[category];
    if (existing != null) return existing;
    final player = AudioPlayer();
    _players[category] = player;
    return player;
  }

  Future<void> playCategory(
    VnSoundCategory category, {
    String? variantId,
    bool? loop,
  }) async {
    final enabled = await _preferences.isCategoryEnabled(category);
    if (!enabled) return;

    if ((category == VnSoundCategory.message ||
            category == VnSoundCategory.sign) &&
        (_activeLoopCategory == VnSoundCategory.alarm ||
            _activeLoopCategory == VnSoundCategory.ring)) {
      return;
    }

    final selectedId = await _preferences.selectedSoundId(category);
    final def = VnSoundRegistry.resolve(
      category: category,
      selectedId: selectedId,
      variantId: variantId,
    );
    final effectiveLoop =
        loop ?? (def.loopAllowed && _shouldAutoLoop(category));
    await playDefinition(def, loop: effectiveLoop);
  }

  bool _shouldAutoLoop(VnSoundCategory category) {
    return category == VnSoundCategory.alarm ||
        category == VnSoundCategory.ring;
  }

  Future<void> playDefinition(
    VnSoundDefinition def, {
    bool loop = false,
  }) async {
    try {
      await _applyInterruptPolicy(def.category);

      if (_activeLoopSoundId == def.id &&
          _activeLoopCategory == def.category &&
          loop) {
        return;
      }

      final player = await _playerFor(def.category);
      final volume = await _preferences.volumeFor(def.category);
      await player.stop();
      await player.setVolume(volume);
      await player.setAsset(def.assetPath);
      await player.setLoopMode(loop ? LoopMode.one : LoopMode.off);
      await player.play();

      if (loop) {
        _activeLoopSoundId = def.id;
        _activeLoopCategory = def.category;
      } else if (_activeLoopCategory == def.category) {
        _activeLoopSoundId = null;
        _activeLoopCategory = null;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[vn-audio] play failed id=${def.id} error=$e');
      }
    }
  }

  Future<void> _applyInterruptPolicy(VnSoundCategory incoming) async {
    switch (incoming) {
      case VnSoundCategory.alarm:
      case VnSoundCategory.ring:
        await stop(VnSoundCategory.message);
        await stop(VnSoundCategory.sign);
        if (incoming == VnSoundCategory.alarm) {
          await stop(VnSoundCategory.ring);
        }
        break;
      case VnSoundCategory.message:
        await stop(VnSoundCategory.message);
        await stop(VnSoundCategory.sign);
        break;
      case VnSoundCategory.sign:
        if (_activeLoopCategory == VnSoundCategory.alarm ||
            _activeLoopCategory == VnSoundCategory.ring) {
          return;
        }
        await stop(VnSoundCategory.sign);
        break;
    }
  }

  Future<void> preview(String soundId) async {
    final def = VnSoundRegistry.byId(soundId);
    if (def == null) return;
    await stopPreview();
    _previewSoundId = def.id;
    try {
      await playDefinition(def, loop: false);
      if (_activeLoopCategory == def.category) {
        _activeLoopSoundId = null;
        _activeLoopCategory = null;
      }
    } finally {
      // Preview ownership cleared when stopped explicitly.
    }
  }

  Future<void> stopPreview() async {
    final id = _previewSoundId;
    _previewSoundId = null;
    if (id == null) return;
    final def = VnSoundRegistry.byId(id);
    if (def != null) {
      await stop(def.category);
    }
  }

  Future<void> stop(VnSoundCategory category) async {
    final player = _players[category];
    if (player == null) return;
    try {
      await player.stop();
    } catch (_) {}
    if (_activeLoopCategory == category) {
      _activeLoopSoundId = null;
      _activeLoopCategory = null;
    }
    final preview = VnSoundRegistry.byId(_previewSoundId);
    if (preview?.category == category) {
      _previewSoundId = null;
    }
  }

  Future<void> stopAll() async {
    for (final category in VnSoundCategory.values) {
      await stop(category);
    }
    _previewSoundId = null;
  }

  Future<void> playSignFeedback() async {
    if (_activeLoopCategory == VnSoundCategory.alarm ||
        _activeLoopCategory == VnSoundCategory.ring) {
      return;
    }
    await playCategory(VnSoundCategory.sign, loop: false);
  }

  Future<void> playMessageCue({String? variantId}) async {
    if (_activeLoopCategory == VnSoundCategory.alarm ||
        _activeLoopCategory == VnSoundCategory.ring) {
      return;
    }
    await playCategory(
      VnSoundCategory.message,
      variantId: variantId,
      loop: false,
    );
  }

  Future<void> startAlarm({String? variantId}) async {
    await playCategory(VnSoundCategory.alarm, variantId: variantId, loop: true);
  }

  Future<void> startRing({String? variantId}) async {
    await playCategory(VnSoundCategory.ring, variantId: variantId, loop: true);
  }

  Future<void> dispose() async {
    await stopAll();
    for (final player in _players.values) {
      try {
        await player.dispose();
      } catch (_) {}
    }
    _players.clear();
  }
}
