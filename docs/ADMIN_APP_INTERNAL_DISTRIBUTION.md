# ViaNexis Admin App — internal distribution

How to distribute the first internal staging APK to operators without Play Store.

## Artifact

- Output: `build/app/outputs/flutter-apk/app-release.apk` (or `app-debug.apk`)
- Naming: `ViaNexisAdmin-staging-v<version>.apk` — see [`ADMIN_APP_STAGING_APK_ARTIFACT.md`](./ADMIN_APP_STAGING_APK_ARTIFACT.md)
- Prepare: `dart run tool/prepare_staging_apk_artifact.dart`

## Distribution channels (choose one)

| Channel | Notes |
|---------|--------|
| Secure file share | Encrypted link; expire after 7 days |
| MDM / enterprise | Preferred for fleet devices |
| Direct USB / ADB | `adb install app-release.apk` |
| Firebase App Distribution | Requires Firebase project — configure outside repo |

### Render staging

When backend is on Render, build with the Render API hostname — see [`ADMIN_APP_RENDER_STAGING_BUILD.md`](./ADMIN_APP_RENDER_STAGING_BUILD.md). Do not commit the real URL.

## Signing

- **Debug builds** — for developer devices only
- **Release builds** — require keystore outside repository:

```powershell
# Example — store passwords in CI secrets, not in git
# key.properties and *.jks must stay in .gitignore
flutter build apk --release `
  --dart-define=APP_ENV=staging `
  --dart-define=API_BASE_URL=https://api-staging.example.com
```

Document keystore owner in platform ops runbook and backend `docs/SECRETS_HANDOVER_CHECKLIST.md`.

## Operator instructions

1. Enable install from unknown sources (Android) or use MDM
2. Install APK
3. Confirm staging badge before entering credentials
4. Follow [`ADMIN_APP_OPERATOR_TEST_FLOW.md`](./ADMIN_APP_OPERATOR_TEST_FLOW.md)

## Security

- Do not share APK with embedded production URLs publicly
- Revoke tester access when UAT completes
- Rotate staging super_admin password after UAT

## Credentials outside repo

| Item | Location |
|------|----------|
| `API_BASE_URL` | Build-time dart-define |
| Keystore | CI / secure vault |
| Firebase config | Only when officially adopted |
| APNS | iOS builds — Apple Developer portal |
