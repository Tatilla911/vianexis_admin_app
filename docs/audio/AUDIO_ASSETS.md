# ViaNexis Admin App — Audio Assets

> **LICENSE_REVIEW_REQUIRED** — All bundled sound files require legal/license review before production release.

## Source of truth

Flutter assets under `assets/sounds/` are the **canonical** sound library:

| Category | Asset path | Registry id | Android raw copy |
|----------|------------|-------------|------------------|
| alarm | `assets/sounds/alarm/alarm1.mp3` | `alarm1` | `vn_alarm_1.mp3` |
| alarm | `assets/sounds/alarm/alarm2.mp3` | `alarm2` | `vn_alarm_2.mp3` |
| alarm | `assets/sounds/alarm/alarm3.mp3` | `alarm3` | `vn_alarm_3.mp3` |
| message | `assets/sounds/message/message1.mp3` | `message1` | `vn_message_1.mp3` |
| message | `assets/sounds/message/message2.mp3` | `message2` | `vn_message_2.mp3` |
| message | `assets/sounds/message/message3.mp3` | `message3` | `vn_message_3.mp3` |
| message | `assets/sounds/message/message4.mp3` | `message4` | `vn_message_4.mp3` |
| ring | `assets/sounds/ring/ring1.mp3` | `ring1` | `vn_ring_1.mp3` |
| ring | `assets/sounds/ring/ring2.mp3` | `ring2` | `vn_ring_2.mp3` |
| ring | `assets/sounds/ring/ring3.mp3` | `ring3` | `vn_ring_3.mp3` |
| ring | `assets/sounds/ring/ring4.mp3` | `ring4` | `vn_ring_4.mp3` |
| sign | `assets/sounds/sign/sign1.mp3` | `sign1` | `vn_sign_1.mp3` |
| sign | `assets/sounds/sign/sign2.mp3` | `sign2` | `vn_sign_2.mp3` |
| sign | `assets/sounds/sign/sign3.mp3` | `sign3` | `vn_sign_3.mp3` |
| sign | `assets/sounds/sign/sign4.mp3` | `sign4` | `vn_sign_4.mp3` |

## Android raw copies

`android/app/src/main/res/raw/vn_*.mp3` files are **derived copies** for Android notification channels and background delivery. They must stay in sync with Flutter assets.

Sync command (from repo root):

```bash
./tool/sync_android_raw_sounds.sh
```

## Runtime usage

- **Foreground (in-app):** `lib/audio/vn_audio_notification_service.dart` plays from Flutter assets via `just_audio`.
- **Background (Android):** notification handlers reference `res/raw` resource names from `VnSoundRegistry.androidResourceName`.
- **Preferences:** per-admin-user scoped keys in SharedPreferences (`vianexis_admin_sound_prefs_v1` prefix).

## Categories

| Category | Admin use |
|----------|-----------|
| `alarm` | Critical platform / security alerts (may loop, require acknowledge) |
| `message` | Normal operational notifications |
| `ring` | Incoming internal call signal (loop; UI not implemented yet) |
| `sign` | Successful admin action feedback |

See `lib/audio/vn_sound_event_matrix.dart` for event → category mapping.
