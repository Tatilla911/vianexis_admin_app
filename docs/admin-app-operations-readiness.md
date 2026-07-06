# Admin app operations readiness (HEAD)

Current reference: `47adc94` (includes `b6a2378` live endpoint wiring and packaging CRUD UI).

## Scope

This document tracks the current operational readiness of the admin app for company/admin workflows, with clear separation between live features and backend dependencies.

## Operations dashboard

- **Route:** `/operations`
- **Purpose:** operational hub for visibility across companies, drivers, trips, exchange, notifications, support, and public intake modules.
- **Data source:** `GET /platform-admin/dashboard` for aggregate metric cards.
- **Current cards:** companies (active/total), active drivers (estimate), active trips, completed trips, support grants, pending public intakes, pending registrations, generated packages.
- **Module links:** driver access, trips overview, exchange records, notification status, support grants, public intakes.
- **Dependency cards shown in UI:**
  - pending sync metrics: `GET /platform-admin/operational-metrics` (missing)
  - extra exchange operational metrics card remains dependency-oriented

## Live endpoint wiring (since `b6a2378`)

The admin app now uses these live platform-admin endpoints:

- `GET /platform-admin/drivers`
- `GET /platform-admin/trips`
- `GET /platform-admin/exchange-records`
- `GET /platform-admin/companies/:companyId/packaging-items`

Company exchange settings loading now merges default packaging items from the packaging-items endpoint into the exchange settings view model.

## Current module state

- **Company exchange settings:** live toggles + packaging list merge + CRUD UI (see dedicated doc).
- **Driver access:** live list endpoint wired (`/platform-admin/drivers`) with metadata-only rendering; enable/disable still dependency.
- **Trips overview:** live list endpoint wired (`/platform-admin/trips`) + dashboard aggregates.
- **Exchange records overview:** live list endpoint wired (`/platform-admin/exchange-records`) + metadata-safe filters.
- **Notification status:** push provider status is live via existing notification provider status API; token/admin events remain dependency.
- **Support access:** existing metadata-only support grants module linked from operations.
- **Public intake:** existing `/public-intakes` module linked from operations.

## Readiness matrix

| Modul | Admin UI | Backend endpoint | Live/mock/dependency | Státusz | Következő lépés |
|---|---|---|---|---|---|
| Operations dashboard | `/operations` cards + hub links | `GET /platform-admin/dashboard` | Live + dependency cards | Ready | Add pending sync operational metrics endpoint |
| Company exchange settings | `/companies/:id/exchange-settings` | `GET/PATCH /companies/:id/exchange-settings` + packaging merge endpoint | Live | Ready | Add manual pallet policy field in backend contract |
| Packaging item CRUD | Add/edit/deactivate/reactivate actions in exchange settings | `POST/PATCH/DELETE /platform-admin/companies/:id/packaging-items` | Live (+ mock fallback) | Ready | Optional server-side validation/error metadata improvements |
| Driver access | `/driver-access`, `/driver-access/:id` | `GET /platform-admin/drivers` | Live (+ dependency for status change) | Conditional | Add `PATCH /platform-admin/drivers/:id/status` |
| Trips overview | `/trips-overview` list + summaries | `GET /platform-admin/trips` | Live (+ dependency for pending sync metrics) | Conditional | Add `GET /platform-admin/operational-metrics` |
| Exchange records | `/exchange-records` | `GET /platform-admin/exchange-records` | Live | Ready | Add richer server-side filter params if needed |
| Notification status | `/notification-status` | Push provider status API (existing) | Live + dependencies | Conditional | Add admin token metadata endpoint + notification events endpoint |
| Support access | Existing support grants UI (`/support/grants`) | Existing platform-admin support grants endpoints | Live | Ready | Maintain metadata-only policy |
| Public intake | Existing UI (`/public-intakes`) + operations link | Existing public intake endpoints | Live | Ready | Continue status/source taxonomy hardening |

## Open backend dependencies

- `GET /platform-admin/operational-metrics`
- `PATCH /platform-admin/drivers/:id/status`
- Driver device token admin metadata endpoint
- Notification events list endpoint
- Manual pallet record policy backend field on exchange settings

## Security and privacy boundary

- No raw FCM/APNS token values in normal admin views.
- No PIN hash exposure.
- No raw document/message/storage payload content in operations modules.
- Metadata-only rendering remains enforced for support/public-intake operational views.
