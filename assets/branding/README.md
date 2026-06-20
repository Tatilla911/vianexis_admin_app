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
```

## App icon / splash

- **App icon generation:** pending — no `flutter_launcher_icons` config in this repo yet.
- **Native splash generation:** pending — Android uses navy `#0D1B2A` launch background; full branded splash tooling deferred.

Widgets fall back to a styled **VN** mark if assets are missing.
