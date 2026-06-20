# ViaNexis Admin — brand and visual system

Phase 19 establishes a consistent enterprise control-center look aligned with ViaNexis navy/blue/gold direction (driver app reference).

## Brand colors

| Token | Hex | Usage |
|-------|-----|--------|
| Deep navy | `#0D1B2A` | Scaffold / splash base |
| Panel navy | `#152238` | Navigation, metric tiles |
| Surface elevated | `#1B2A44` | Cards, inputs |
| ViaNexis blue | `#4FA3E3` | Primary accent |
| Accent blue | `#4DA3FF` | Buttons, selected nav |
| Gold accent | `#D4AF37` | Subtle highlights, metadata badges |
| Success | `#3DDC97` | Healthy status |
| Warning | `#FFB347` | Attention |
| Danger | `#FF6B6B` | Critical / denied |

Source of truth: `lib/app/vianexis_brand.dart` and `lib/app/app_theme.dart`.

## Assets

```
assets/branding/
  vianexis_logo.png
  vianexis_mark.png
  vianexis_watermark.png
assets/backgrounds/
  admin_background.png
assets/icons/
  app_icon.png
```

Regenerate:

```powershell
python tool/generate_admin_branding.py
flutter pub get
```

**Rules**

- Project-owned PNGs only — no external copyrighted assets.
- Do not reference `transport_driver_app` paths at runtime; copy refreshed art into `assets/branding/` when updating.
- Widgets (`VianexisLogoMark`, `VianexisWatermarkBackground`) render a styled **VN** fallback if assets are missing.

## Shared widgets

| Widget | Path | Role |
|--------|------|------|
| `VianexisAdminBackground` | `lib/core/widgets/vianexis_admin_background.dart` | Deep navy base + optional gradient/watermark |
| `VianexisLogoMark` | `lib/core/widgets/vianexis_logo_mark.dart` | Logo/mark with safe fallback |
| `VianexisAdminCard` | `lib/core/widgets/vianexis_admin_card.dart` | Standard card surface |
| `VianexisMetricTile` | `lib/core/widgets/vianexis_metric_tile.dart` | Dashboard metric chips |
| `VianexisMetadataNotice` | `lib/core/widgets/vianexis_metadata_notice.dart` | Metadata-only privacy styling |
| `VianexisBrandHeader` | `lib/core/widgets/vianexis_brand_header.dart` | Dashboard/settings header |

Background watermark is enabled on login; authenticated module chrome uses a lighter background (watermark off) for readability.

## App icon / splash status

| Item | Status |
|------|--------|
| Android app label | **ViaNexis Admin** |
| iOS display name | **ViaNexis Admin** |
| Android launch background | Navy `#0D1B2A` |
| Launcher icon tooling | **Pending** — source asset at `assets/icons/app_icon.png`; run `flutter_launcher_icons` when ready |
| Native splash tooling | **Pending** — use `assets/backgrounds/admin_background.png` with `flutter_native_splash` when ready |

## Adding future logo variants

1. Export PNG (transparent where needed) into `assets/branding/`.
2. Run `python tool/generate_admin_branding.py` or replace files manually.
3. Declare paths in `pubspec.yaml` if new filenames are used.
4. Keep `VianexisLogoMark` fallbacks — never assume assets exist on all platforms.
5. Run `flutter test` including `test/vianexis_brand_widgets_test.dart`.
