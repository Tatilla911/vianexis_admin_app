# Architecture

## Purpose

`vianexis_admin_app` is a standalone Flutter client for ViaNexis platform administrators. It provides mobile and tablet access to platform control workflows without mixing tenant operational tools into the driver app.

## Boundaries

```text
vianexis_admin_app          transport_driver_app
        |                            |
        |  /platform-admin/*         |  /trips, /documents, driver flows
        v                            v
              transdoc-backend (shared API)
```

| Client | Users | Data scope |
|--------|-------|------------|
| **Admin app (this project)** | Platform staff | Metadata, registration, support metadata, health, audit |
| **Driver app** | Drivers | Trips, documents, field workflows |
| **Portal web** | Company admins, dispatchers | Tenant operational workspace |

## Layering

```text
lib/
  app/           Application shell: theme, router, environment
  core/          Shared infrastructure: API, auth, widgets, models
  features/      Feature screens grouped by domain
  l10n/          Localization ARB files
```

### App layer

- `vianexis_admin_app.dart` — `MaterialApp.router`, theme, localization delegates
- `app_router.dart` — `go_router` routes, auth redirects, shell navigation
- `app_theme.dart` — ViaNexis admin visual system (`#0D1B2A` background)
- `app_environment.dart` — build profile and dart-define keys

### Core layer

- **API** — `dio` client, config, exceptions, secure token storage (foundation only in phase 1)
- **Auth** — platform role model, session state, repository abstraction
- **Widgets** — responsive admin scaffold, loading/error views, status badges
- **Models** — shared DTO helpers (`PagedResult`, `AdminActionResult`)

### Features layer

Each feature owns its screens. Business logic will live in feature-specific providers as API integration is added.

## Navigation

- **Phone (< 600 logical px):** bottom navigation bar
- **Tablet (≥ 600 logical px):** navigation rail

Navigation items are filtered by platform role capabilities.

## State management

`flutter_riverpod` providers expose:

- Auth session (`AdminAuthState`)
- Router (`GoRouter` with auth redirect)
- Future feature repositories

## Localization

All user-visible strings use `AppLocalizations` from `flutter gen-l10n`. ARB files live in `lib/l10n/`.

## Future integration points

1. Auth — `POST /auth/login`, refresh, logout
2. Platform admin — `/platform-admin/*`
3. Search — `/search`, `/search/operational-snapshot`

See [api-integration-plan.md](api-integration-plan.md).
