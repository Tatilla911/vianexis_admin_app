# ViaNexis Admin branding assets

Project-owned PNG assets for the admin control center UI.

| File | Usage |
|------|--------|
| `vianexis_logo.png` | Login header, marketing-style lockup |
| `vianexis_mark.png` | Compact VN mark in headers and cards |
| `vianexis_watermark.png` | Subtle background watermark |

These were generated for the admin app (Phase 19). The driver app may hold related source art under `transport_driver_app/assets/logo/` when present — copy updated variants here rather than referencing cross-repo paths at runtime.

Regenerate locally:

```bash
python tool/generate_admin_branding.py
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

## App icon / splash

- **App icon:** `flutter_launcher_icons` configured in `pubspec.yaml` (`assets/icons/app_icon.png`).
- **Native splash:** `flutter_native_splash` configured with navy `#0D1B2A` and `assets/branding/vianexis_mark.png`.

Widgets fall back to a styled **VN** mark if assets are missing.
