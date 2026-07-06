# Admin app notification status (HEAD)

Current reference: `47adc94`.

## Screen

- **Route:** `/notification-status`
- **Entry point:** linked from `/operations`

## Current UI state

The screen shows:

- Driver app notification foundation card (ready status)
- Production push provider status card (from existing push provider status API usage)
- Device token registration dependency card
- Notification events dependency card

## Push provider status details

Rendered as metadata, localized:

- Provider label (`none` / `fcm` / `apns` mapped to localized labels)
- Delivery enabled state
- Provider configured state
- Token storage mode
- Last failure code (if present)

## Privacy boundary

- No raw FCM token values for normal admins
- No secret/credential payload rendering
- Metadata-only status presentation

## Open dependencies

- Driver device token admin metadata endpoint (for platform visibility)
- Notification events list endpoint

Planned endpoint direction:

- device token admin visibility endpoint (platform-admin scope)
- `GET /platform-admin/notification-events`

## Related operational dependency context

Notification status remains part of the operations readiness picture together with:

- `GET /platform-admin/operational-metrics` (pending sync visibility)
- `PATCH /platform-admin/drivers/:id/status` (driver lifecycle action dependency)
