# ViaNexis Admin App — Render staging build

Build an internal staging APK pointing at the **real Render staging API** after backend deploy.

**Boundary:** This document does not perform a live build with signing secrets. Run commands locally or in CI when keystore and Render API URL are available.

## Prerequisites

- [ ] Render backend deployed — see `transdoc-backend/docs/RENDER_FIRST_DEPLOY_RUNBOOK.md`
- [ ] Health checks pass: `GET /health`, `GET /health/ready`
- [ ] Staging `super_admin` bootstrapped
- [ ] Render API hostname noted (secure channel only — not committed to git)

## API URL placeholder

After deploy, Render provides a hostname like:

```text
https://<render-service-name>.onrender.com
```

Example placeholder (not a real URL):

```text
https://vianexis-backend-staging.onrender.com
```

**Do not commit** the real URL in source. Pass it at build time via `--dart-define`.

## Build commands

### Direct Flutter build

```powershell
cd vianexis_admin_app
flutter build apk --release `
  --dart-define=APP_ENV=staging `
  --dart-define=API_BASE_URL=https://<RENDER_STAGING_API_HOST>
```

### Artifact preparation tool (recommended)

Dry-run (prints command, no build):

```powershell
dart run tool/prepare_staging_apk_artifact.dart `
  --dry-run `
  --api-base-url=https://<RENDER_STAGING_API_HOST>
```

Real build (when signing configured):

```powershell
dart run tool/prepare_staging_apk_artifact.dart `
  --api-base-url=https://<RENDER_STAGING_API_HOST> `
  --copy-to-artifacts
```

Output naming: `ViaNexisAdmin-staging-v<version>.apk`

## Install

See [`ADMIN_APP_INTERNAL_DISTRIBUTION.md`](./ADMIN_APP_INTERNAL_DISTRIBUTION.md).

```powershell
adb install build\app\outputs\flutter-apk\app-release.apk
```

## First login

1. Open app — confirm **Staging** badge (EN/HU)
2. Settings → verify API host matches Render hostname (host only, no tokens)
3. Login with staging `super_admin` credentials (from secret store)
4. Follow [`ADMIN_APP_RENDER_STAGING_UAT.md`](./ADMIN_APP_RENDER_STAGING_UAT.md)

## Troubleshooting

| Symptom | Likely cause | Action |
|---------|--------------|--------|
| API unreachable | Render service sleeping / wrong URL | Wake service; verify `API_BASE_URL` dart-define |
| CORS error (browser only) | `CORS_ORIGINS` on backend | Mobile APK usually unaffected; fix backend CORS for web clients |
| Unauthorized | Wrong credentials / user not super_admin | Re-check bootstrap; verify role |
| Session expired | JWT TTL | Re-login; expected behavior |
| Production warning | `APP_ENV=production` | Use `APP_ENV=staging` only |
| Mock data shown | Missing `API_BASE_URL` | Rebuild with dart-define; staging disables mock fallback by default |

## CORS note (backend)

Admin APK calls API directly — CORS applies mainly to browser clients. Still update backend `CORS_ORIGINS` if using web admin against Render API.

## Related

- [`ADMIN_APP_STAGING_APK_ARTIFACT.md`](./ADMIN_APP_STAGING_APK_ARTIFACT.md)
- [`ADMIN_APP_STAGING_END_TO_END_UAT.md`](./ADMIN_APP_STAGING_END_TO_END_UAT.md)
- Backend [`RENDER_STAGING_DEPLOYMENT.md`](../../transdoc-backend/docs/RENDER_STAGING_DEPLOYMENT.md)
