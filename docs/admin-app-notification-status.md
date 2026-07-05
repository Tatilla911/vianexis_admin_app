# Admin app — notification / push status

## Screen

**Operations → Notification status** (`/notification-status`)

## What admin sees

| Item | Source | Live? |
|------|--------|-------|
| Driver app notification foundation | Static “ready” card | N/A (product status) |
| Push provider status | `GET /platform-admin/notifications/push-provider` (existing) | Yes |
| Device token registration | Dependency card | **Missing endpoint** |
| Recent notification events | Dependency card | **Missing endpoint** |

## Push provider card (existing)

Reuses `PushProviderStatusCard` from notification preferences:

- Provider label (none / FCM / APNS) — localized, not raw enum
- Delivery enabled flag
- Configured flag
- Token storage mode (`hash_only` metadata)
- Last failure code (if any)

**Not displayed:** raw FCM/APNS tokens, secrets, credential JSON.

## Production push dependency

If `configured: false` or `deliveryEnabled: false`, admin sees localized “not configured” / backend dependency messaging — not a fake “working” state.

## Planned backend (driver side)

```
POST /drivers/device-tokens
GET  /platform-admin/notification-events  (optional admin audit)
```

## Blockers

- Driver device token registration visibility for platform admins awaits backend listing/aggregate endpoint.
- Event history not wired; dependency card only.
