# ViaNexis Admin App — Render staging APK runbook

Build and distribute an internal staging APK against the **real Render staging API**.

Related: [`ADMIN_APP_RENDER_STAGING_BUILD.md`](./ADMIN_APP_RENDER_STAGING_BUILD.md), backend [`RENDER_STAGING_EXECUTION_COMMANDS.md`](../../transdoc-backend/docs/RENDER_STAGING_EXECUTION_COMMANDS.md)

## Boundary

- **Do not build** a production-signed APK with a placeholder API URL
- **Do not commit** the real Render hostname in source — pass via `--dart-define` or env at build time
- If `<RENDER_STAGING_API_HOST>` is unknown, run **dry-run only**

## API URL pattern

```text
https://<render-service-name>.onrender.com
```

Example placeholder (not live):

```text
https://vianexis-backend-staging.onrender.com
```

## Dry-run (safe without live backend)

```powershell
cd vianexis_admin_app
dart run tool/prepare_staging_apk_artifact.dart `
  --dry-run `
  --api-base-url=https://vianexis-backend-staging.onrender.com
```

Or:

```powershell
$env:STAGING_APK_API_BASE_URL="https://<RENDER_STAGING_API_HOST>"
$env:STAGING_APK_DRY_RUN="true"
dart run tool/prepare_staging_apk_artifact.dart
```

## Actual artifact (when hostname + signing ready)

```powershell
dart run tool/prepare_staging_apk_artifact.dart `
  --api-base-url=https://<RENDER_STAGING_API_HOST> `
  --copy-to-artifacts
```

Direct Flutter:

```powershell
flutter build apk --release `
  --dart-define=APP_ENV=staging `
  --dart-define=API_BASE_URL=https://<RENDER_STAGING_API_HOST>
```

## Artifact location

- Default: `build/app/outputs/flutter-apk/app-release.apk`
- With `--copy-to-artifacts`: `build/artifacts/staging/ViaNexisAdmin-staging-v<version>.apk`

## Install

```powershell
adb install build\app\outputs\flutter-apk\app-release.apk
```

## First login expectations

- **Staging** environment badge (EN/HU)
- Mock fallback **disabled** when HTTPS Render URL configured
- Login with staging `super_admin` from secret store

## Troubleshooting

| Symptom | Likely cause | Action |
|---------|--------------|--------|
| API unreachable | Service sleeping / wrong URL | Wake Render service; verify dart-define |
| 401 / forbidden | Wrong credentials or role | Re-bootstrap; verify super_admin |
| CORS (web only) | `CORS_ORIGINS` on backend | Mobile APK usually origin-less |
| Stale data | Old APK with wrong URL | Rebuild with correct `API_BASE_URL` |
| HTTP rejected | Staging requires HTTPS | Use `https://` host |

Tool rejects missing URL and non-HTTPS URLs (localhost only with explicit override).

## UAT

Follow [`ADMIN_APP_FIRST_STAGING_UAT_RUNBOOK.md`](./ADMIN_APP_FIRST_STAGING_UAT_RUNBOOK.md).
