# ViaNexis Admin App — quality gates

Run these checks before every commit and before release builds.

## Admin app

```powershell
cd vianexis_admin_app
flutter clean
flutter pub get
flutter gen-l10n
flutter analyze
flutter test
```

Optional release readiness:

```powershell
dart run tool/admin_release_readiness_check.dart
```

## Backend (when API integration changes)

```powershell
cd transdoc-backend
npm run build
npm test
npm run test:e2e -- --runInBand
```

## Commit rules

- Do not commit after failing analyze or tests.
- Keep backend and admin app commits separate.
- Do not modify `transport_driver_app` from admin app work.

## CI

- Admin app: `.github/workflows/admin_app_ci.yml`
- Backend: `transdoc-backend/.github/workflows/backend-ci.yml` (includes PostgreSQL service + e2e)
