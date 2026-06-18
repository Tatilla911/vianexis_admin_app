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

API connection will use `--dart-define` values (see `lib/app/app_environment.dart`). Backend integration is not wired in the current foundation phase.

## Documentation

- [Architecture](docs/architecture.md)
- [API integration plan](docs/api-integration-plan.md)
- [Privacy and security](docs/privacy-and-security.md)

## Quality checks

```bash
flutter analyze
flutter test
```
