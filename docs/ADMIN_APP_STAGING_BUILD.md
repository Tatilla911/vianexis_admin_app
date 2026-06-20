# ViaNexis Admin App — staging APK build

First internal staging build workflow. **Do not commit** real `API_BASE_URL` values or signing files.

## Pre-build checklist

```powershell
cd vianexis_admin_app
flutter clean
flutter pub get
flutter gen-l10n
flutter analyze
flutter test
dart run tool/admin_release_readiness_check.dart
dart run tool/admin_app_smoke_check.dart
dart run tool/admin_staging_build_check.dart
```

Optional CI env for staging build check:

```powershell
$env:STAGING_BUILD_APP_ENV="staging"
$env:STAGING_BUILD_API_BASE_URL="https://api-staging.example.com"
dart run tool/admin_staging_build_check.dart
```

## Requirements

| Item | Rule |
|------|------|
| `APP_ENV` | Must be `staging` |
| `API_BASE_URL` | Required — HTTPS staging API hostname |
| Mock fallback | Disabled for staging by default |
| Icon / splash | Generated (`flutter_launcher_icons`, `flutter_native_splash`) |
| Version | Set in `pubspec.yaml` (e.g. `1.0.0+1`) |

## Build command

Replace `<STAGING_API_URL>` with your staging API base URL (no trailing slash recommended):

```powershell
flutter build apk --release `
  --dart-define=APP_ENV=staging `
  --dart-define=API_BASE_URL=https://api-staging.example.com
```

Optional App Bundle (when Play internal track is ready — signing required):

```powershell
flutter build appbundle --release `
  --dart-define=APP_ENV=staging `
  --dart-define=API_BASE_URL=https://api-staging.example.com
```

Debug smoke build (invalid host example — fast compile check only):

```powershell
flutter build apk --debug `
  --dart-define=APP_ENV=staging `
  --dart-define=API_BASE_URL=https://staging.example.invalid
```

## Post-build verification

- [ ] APK installs on test device
- [ ] Environment badge shows **Staging**
- [ ] Settings shows configured API host (not full secrets)
- [ ] Login with staging `super_admin`
- [ ] Run [`ADMIN_APP_INTERNAL_UAT_CHECKLIST.md`](./ADMIN_APP_INTERNAL_UAT_CHECKLIST.md)

## Not in scope

- Play Store publishing
- Release signing keystore in repo
- Firebase/APNS live push (in-app notifications only)

## Related

- [`ADMIN_APP_INTERNAL_DISTRIBUTION.md`](./ADMIN_APP_INTERNAL_DISTRIBUTION.md)
- [`ADMIN_APP_RELEASE_CHECKLIST.md`](./ADMIN_APP_RELEASE_CHECKLIST.md)
