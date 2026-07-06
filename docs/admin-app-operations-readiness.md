# Admin app operations readiness (HEAD)

Current reference: post-`844fad4` wiring to backend `8c7bfb5` operational dependencies.

## Scope

Operational hub and modules for platform admin visibility with privacy-safe metadata only.

## Operations dashboard

- **Route:** `/operations`
- **Dashboard source:** `GET /platform-admin/dashboard`
- **Operational metrics source:** `GET /platform-admin/operational-metrics` (live)
- **Cards:** companies, drivers, trips, support grants, public intakes, registrations, packages
- **Live operational metrics section:** exchange record aggregates (total/disputed/missing)
- **Pending sync:** shows dependency card when `pendingSync.sourceUnavailable=true`

## Live endpoint wiring

- `GET /platform-admin/drivers`
- `GET /platform-admin/trips`
- `GET /platform-admin/exchange-records`
- `GET /platform-admin/operational-metrics`
- `GET /platform-admin/companies/:companyId/packaging-items` (+ CRUD)
- `PATCH /platform-admin/drivers/:id/status` (live mode enable/disable)
- `GET /platform-admin/drivers/:id/device-notification-status` (metadata; may be `sourceUnavailable`)
- `GET /platform-admin/notification-events` (metadata; may be `sourceUnavailable`)
- `GET /platform-admin/notifications/provider-status`

## Module state

| Module | Route | Status |
|---|---|---|
| Operations dashboard | `/operations` | Ready (live metrics + dependency for pending sync) |
| Company exchange settings | `/companies/:id/exchange-settings` | Ready (toggles + packaging CRUD + manual pallet policy) |
| Driver access | `/driver-access` | Ready (list live; status change live in live mode) |
| Trips overview | `/trips-overview` | Ready (list live) |
| Exchange records | `/exchange-records` | Ready (list + filters live) |
| Notification status | `/notification-status` | Conditional (provider live; events/token metadata partial) |
| Support access | `/support/grants` | Ready (metadata-only) |
| Public intake | `/public-intakes` | Ready |

## Open dependencies (truthful)

- Pending sync count reliable source (`pendingSync.sourceUnavailable`)
- Driver device token admin metadata foundation (`sourceUnavailable` until driver token store exists)
- Notification events persistence (`sourceUnavailable` until event store exists)
- Production FCM/APNS infra configuration (separate from API contract)

## Security boundary

No raw FCM/APNS tokens, PIN hashes, document content, message bodies, or storage keys in operations modules.
