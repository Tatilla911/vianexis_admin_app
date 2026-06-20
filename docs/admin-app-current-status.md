# ViaNexis Admin App — current status

Last updated: production advancement pack (Phases 29–32 + smoke docs).

## Repository

| Item | Status |
|------|--------|
| Branch | `main` |
| Latest commit | see `git log -1` |
| Remote | configure with `git remote add origin <URL>` if not set |
| Analyzer | `flutter analyze` — target: no issues |
| Tests | `flutter test` — 224+ |

## App identity

| Platform | Value |
|----------|--------|
| Display name | ViaNexis Admin |
| Android `applicationId` | `hu.vianexis.vianexis_admin_app` |
| iOS bundle id | `hu.vianexis.vianexisAdminApp` |
| Version | `1.0.0+1` (`pubspec.yaml`) |

## Environment configuration

- `APP_ENV`: `local` \| `dev` \| `staging` \| `production`
- `API_BASE_URL`: required for staging/production builds
- Mock fallback: local/dev only by default

## CI

- `.github/workflows/admin_app_ci.yml` — analyze + test on push/PR

## Added in latest advancement

- Brand asset set generated and tracked:
  - `assets/branding/*`
  - `assets/backgrounds/admin_background.png`
  - `assets/icons/app_icon.png`
- Notification center foundation (in-app metadata-only)
- Bulk onboarding dry-run/execute control UX with policy-aware safety dialogs
- Smoke test runbook: `docs/ADMIN_APP_SMOKE_TESTS.md`

## Next recommended phases

1. Production/staging backend deployment with stable API URLs
2. GitHub remote + push admin app repository
3. Native icon/splash generation tooling (`flutter_launcher_icons`, `flutter_native_splash`)
4. Push provider integration (FCM/APNS) with secure token storage strategy
5. CI hardening (integration tests against staging API)
6. App Store / internal distribution (TestFlight, Play internal track)
7. Native app icon and splash generation
