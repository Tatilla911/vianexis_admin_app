# ViaNexis Admin App

Mobile and tablet client for ViaNexis platform administrators.

## Scope

This app is for **platform staff** (`super_admin`, `support_admin`, `onboarding_reviewer`, `billing_admin`). It connects to `transdoc-backend` platform admin APIs and shows **metadata only** by default.

It is **not** the driver app and **not** the tenant dispatcher portal.

## Related projects

| Project | Path | Role |
|---------|------|------|
| Backend API | `../transdoc-backend` | NestJS / PostgreSQL |
| Driver app | `../transport_driver_app` | Field driver client (separate) |
| Portal web | `../transdoc-backend/portal-web` | Tenant web portal (separate) |

## Stack

- Flutter (Android + iOS)
- `dio` — HTTP client
- `go_router` — navigation
- `flutter_riverpod` — state management
- `flutter_secure_storage` — token storage
- `flutter gen-l10n` — localization (EN + HU)

## Getting started

```powershell
cd vianexis_admin_app
flutter pub get
flutter gen-l10n
flutter run --dart-define=APP_ENV=local --dart-define=API_BASE_URL=http://10.0.2.2:3000
```

When `API_BASE_URL` is not set, **local** and **dev** profiles may use mock data for UI development. Staging and production require a configured API URL.

## Build configuration

| Define | Default | Description |
|--------|---------|-------------|
| `APP_ENV` | `local` | `local`, `dev`, `staging`, or `production` |
| `API_BASE_URL` | empty | Backend base URL (required for staging/production) |
| `ALLOW_MOCK_FALLBACK` | false | Debug override only |

See [docs/ADMIN_APP_ENVIRONMENTS.md](docs/ADMIN_APP_ENVIRONMENTS.md) for full examples.

### Debug / local

```powershell
flutter run --dart-define=APP_ENV=local --dart-define=API_BASE_URL=http://10.0.2.2:3000
```

### Staging release APK

```powershell
flutter build apk --release --dart-define=APP_ENV=staging --dart-define=API_BASE_URL=<STAGING_API_URL>
```

### Production release APK

```powershell
flutter build apk --release --dart-define=APP_ENV=production --dart-define=API_BASE_URL=<PRODUCTION_API_URL>
```

### iOS production (when signing configured)

```powershell
flutter build ipa --release --dart-define=APP_ENV=production --dart-define=API_BASE_URL=<PRODUCTION_API_URL>
```

## App identity

| Item | Value |
|------|--------|
| Android label | ViaNexis Admin |
| iOS display name | ViaNexis Admin |
| Android applicationId | `hu.vianexis.vianexis_admin_app` |
| iOS bundle id | `hu.vianexis.vianexisAdminApp` |
| Version | `1.0.0+1` |

## Phase 9 status (platform admin parity)

Live integration is wired for:

- Support ticket detail / acknowledge / close
- Support access grant detail / revoke
- System health events list / detail / acknowledge / escalate / create support ticket
- Audit log detail (list + detail; cached fallback on older backends for 404 detail only)

Capability detection: missing action endpoints return localized **“Action not available on this backend yet.”** without breaking screens.

## Phase 10 status (bulk onboarding control center)

Live integration is wired for:

- Bulk onboarding jobs list / detail / rows (`GET /platform-admin/bulk-onboarding/jobs...`)
- Validate / approve / reject / cancel / process actions (decision roles only)
- Dashboard summary card (waiting review, high risk, invalid rows, processing)
- Mock fallback module when `API_BASE_URL` is not configured

Navigation visibility: `super_admin`, `onboarding_reviewer` only.

## Phase 11 status (CSV upload + import preview)

- `POST /platform-admin/bulk-onboarding/jobs/upload` (multipart CSV, auto-validation)
- `GET /platform-admin/bulk-onboarding/templates/:type.csv`
- Row list supports `status` + `search` query params
- Admin route: `/bulk-onboarding/upload` (upload screen with file picker, template copy, safety notices)
- Mock upload preview when API is unconfigured (badge shown)
- Excel/XLSX rejected with localized “coming later” message

Upload is visible only for `super_admin` and `onboarding_reviewer`.

## Documentation

- [Production readiness](docs/ADMIN_APP_PRODUCTION_READINESS.md)
- [Environments](docs/ADMIN_APP_ENVIRONMENTS.md)
- [Operator runbook](docs/ADMIN_APP_RUNBOOK.md)
- [Release checklist](docs/ADMIN_APP_RELEASE_CHECKLIST.md)
- [Quality gates](docs/QUALITY-GATES.md)
- [Current status](docs/admin-app-current-status.md)
- [Architecture](docs/architecture.md)
- [API integration plan](docs/api-integration-plan.md)
- [Privacy and security](docs/privacy-and-security.md)
- [Brand and visual system](docs/brand-and-visual-system.md)

## Quality checks

```powershell
flutter clean
flutter pub get
flutter gen-l10n
flutter analyze
flutter test
dart run tool/admin_release_readiness_check.dart
dart run tool/admin_app_smoke_check.dart
dart run tool/admin_staging_build_check.dart
```

## Staging APK build

First internal staging build — see [ADMIN_APP_STAGING_BUILD.md](docs/ADMIN_APP_STAGING_BUILD.md):

```powershell
flutter build apk --release `
  --dart-define=APP_ENV=staging `
  --dart-define=API_BASE_URL=https://api-staging.example.com
```

Replace the URL with your staging API hostname. Do not commit real URLs or signing files.

Artifact tool:

```powershell
$env:STAGING_APK_API_BASE_URL="https://api-staging.example.com"
dart run tool/prepare_staging_apk_artifact.dart
```

## Release readiness

Run `dart run tool/admin_release_readiness_check.dart` before release builds. See [ADMIN_APP_RELEASE_CHECKLIST.md](docs/ADMIN_APP_RELEASE_CHECKLIST.md).
