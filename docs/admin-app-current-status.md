# ViaNexis Admin App — current status

Last updated: production readiness pack (Phases 25–28).

## Repository

| Item | Status |
|------|--------|
| Branch | `main` |
| Latest commit | see `git log -1` |
| Remote | configure with `git remote add origin <URL>` if not set |
| Analyzer | `flutter analyze` — target: no issues |
| Tests | `flutter test` — 216+ |

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

## Next recommended phases

1. Production/staging backend deployment with stable API URLs
2. GitHub remote + push admin app repository
3. Real notification/push foundation
4. Controlled bulk provisioning behind feature flag (backend)
5. CI hardening (integration tests against staging API)
6. App Store / internal distribution (TestFlight, Play internal track)
7. Native app icon and splash generation
