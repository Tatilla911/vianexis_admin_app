# ViaNexis Admin App — release checklist

## Pre-build

- [ ] `flutter analyze` — no issues
- [ ] `flutter test` — all pass
- [ ] `dart run tool/admin_release_readiness_check.dart` — pass
- [ ] Correct `APP_ENV` and `API_BASE_URL` for target environment
- [ ] Version/build in `pubspec.yaml` reviewed
- [ ] EN + HU strings reviewed for new UI
- [ ] Notification center smoke-tested (in-app mode)
- [ ] Bulk onboarding dry-run/execute safety dialog verified

## Build

```powershell
# Staging
flutter build apk --release --dart-define=APP_ENV=staging --dart-define=API_BASE_URL=<STAGING_API_URL>

# Production
flutter build apk --release --dart-define=APP_ENV=production --dart-define=API_BASE_URL=<PRODUCTION_API_URL>
```

iOS (when signing is configured):

```powershell
flutter build ipa --release --dart-define=APP_ENV=production --dart-define=API_BASE_URL=<PRODUCTION_API_URL>
```

## Post-build smoke (metadata-only)

- [ ] Login with platform role succeeds
- [ ] Dashboard loads without mock badge (staging/production)
- [ ] Settings shows correct environment + API host
- [ ] Release Center loads overview (super_admin / support_admin)
- [ ] One module per role smoke (registrations, support, billing as applicable)
- [ ] Sign out works

## Not in scope for this release

- [ ] App Store / Play Store publishing pipeline
- [ ] External push provider live delivery (FCM/APNS)
- [ ] Forced app update enforcement
- [ ] Real payment processing

## App icon / splash

Status: **configured** — `flutter_launcher_icons` and `flutter_native_splash` are declared in `pubspec.yaml`.

Regenerate after updating source PNGs:

```powershell
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

Source assets: `assets/icons/app_icon.png`, splash mark `assets/branding/vianexis_mark.png`, background `#0D1B2A`.
