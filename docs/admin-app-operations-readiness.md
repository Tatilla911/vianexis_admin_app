# Admin app operations readiness

## Summary

This sprint adds an **Operations overview** hub and supporting screens so platform admins can monitor ViaNexis day-to-day operations without dispatch complexity.

## Ready (admin app)

| Area | Status |
|------|--------|
| Operations dashboard (`/operations`) | Live counts from `GET /platform-admin/dashboard` + module links |
| Driver access list/detail | Mock sample data; live shows backend dependency |
| Trips overview | Dashboard aggregate counts + mock trip list |
| Exchange records overview | Mock filters/list; live shows backend dependency |
| Notification status | Push provider card + driver foundation + dependency cards |
| Support access | Existing module (`/support/grants`) — metadata-only preserved |
| Public intakes | Existing module (`/public-intakes`) — linked from operations |
| Company exchange settings | Toggles + read-only lists + CRUD dependency banners |
| HU/EN localization | All new UI strings via l10n keys |
| Tests | `test/operations_readiness_test.dart` |

## Backend dependencies (not wired in live mode)

| Feature | Planned endpoint | Notes |
|---------|------------------|-------|
| Platform driver list | `GET /platform-admin/drivers` | Privacy-safe metadata only |
| Driver enable/disable | `PATCH /platform-admin/drivers/:id/status` | UI placeholder only |
| Platform trip list | `GET /platform-admin/trips` | Dashboard counts work today |
| Pending sync metrics | `GET /platform-admin/operational-metrics` | No fake counts |
| Platform exchange records | `GET /platform-admin/exchange-records` | Trip-scoped API exists for driver |
| Packaging item CRUD | `POST/PATCH/DELETE .../packaging-items` | Read-only list in admin |
| Manual pallet record policy | `PATCH .../exchange-settings` field | Not in current contract |
| Driver device tokens | `POST /drivers/device-tokens` | Admin visibility only |
| Notification events | `GET /platform-admin/notification-events` | Optional audit trail |

## Security / privacy boundary

- No FCM/APNS tokens, secrets, PIN hashes, document bodies, message content, or storage keys in new screens.
- Live repositories return empty lists + `listEndpointReady: false` rather than fabricated production data.
- Mock mode is clearly badged.

## Known blockers

1. Platform-level trip/driver/exchange list endpoints missing — operations visibility is partial in live mode.
2. Production push delivery depends on backend FCM/APNS configuration (admin sees status via existing push provider API).
3. Packaging default list editing awaits backend CRUD contract.

## Related docs

- [Company exchange settings](./admin-app-company-settings.md)
- [Support access](./admin-app-support-access.md)
- [Notification status](./admin-app-notification-status.md)
