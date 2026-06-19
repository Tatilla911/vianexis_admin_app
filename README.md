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

```bash
cd vianexis_admin_app
flutter pub get
flutter run
```

## Build configuration

API connection uses `--dart-define=API_BASE_URL=...` (see `lib/core/api/api_config.dart`). When no base URL is configured, repositories fall back to mock data for local UI development.

## Phase 9 status (platform admin parity)

Live integration is wired for:

- Support ticket detail / acknowledge / close
- Support access grant detail / revoke
- System health events list / detail / acknowledge / escalate / create support ticket
- Audit log detail (list + detail; cached fallback on older backends for 404 detail only)

Capability detection: missing action endpoints return localized **“Action not available on this backend yet.”** without breaking screens.

## Documentation

- [Architecture](docs/architecture.md)
- [API integration plan](docs/api-integration-plan.md)
- [Privacy and security](docs/privacy-and-security.md)

## Quality checks

```bash
flutter analyze
flutter test
```
