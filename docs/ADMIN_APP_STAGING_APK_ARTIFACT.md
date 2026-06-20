# ViaNexis Admin App — staging APK artifact

Repeatable internal staging APK generation without committing `API_BASE_URL` or signing secrets.

## Pre-build checks

```powershell
cd vianexis_admin_app
dart run tool/admin_staging_build_check.dart
dart run tool/prepare_staging_apk_artifact.dart
```

## Dry-run (default)

Prints safe build command and artifact name — **does not build**:

```powershell
$env:STAGING_APK_API_BASE_URL="https://api-staging.example.com"
dart run tool/prepare_staging_apk_artifact.dart
```

## Execute build

```powershell
$env:STAGING_APK_API_BASE_URL="https://api-staging.example.com"
$env:STAGING_APK_DRY_RUN="false"
$env:STAGING_APK_EXECUTE="true"
dart run tool/prepare_staging_apk_artifact.dart
```

Optional copy to `build/artifacts/staging/`:

```powershell
$env:STAGING_APK_COPY="true"
```

## Artifact naming

`ViaNexisAdmin-staging-v<version-from-pubspec>.apk`

Example: `ViaNexisAdmin-staging-v1.0.0+1.apk`

Default Flutter output: `build/app/outputs/flutter-apk/app-release.apk` — rename when distributing.

## Manual build command

```powershell
flutter build apk --release `
  --dart-define=APP_ENV=staging `
  --dart-define=API_BASE_URL=https://api-staging.example.com
```

## Rules

- No production keystore in repo
- No API URL committed to git
- `APP_ENV=production` rejected unless `STAGING_APK_ALLOW_PRODUCTION=true`
- Signing configured outside repo for release builds

## Related

- [`ADMIN_APP_STAGING_BUILD.md`](./ADMIN_APP_STAGING_BUILD.md)
- [`ADMIN_APP_INTERNAL_DISTRIBUTION.md`](./ADMIN_APP_INTERNAL_DISTRIBUTION.md)
- [`ADMIN_APP_STAGING_END_TO_END_UAT.md`](./ADMIN_APP_STAGING_END_TO_END_UAT.md)
