# Admin app notification status (HEAD)

## Screen

- **Route:** `/notification-status`
- **Entry:** linked from `/operations`

## Current UI

- Driver app notification foundation card (ready)
- Production push provider status (`GET /platform-admin/notifications/provider-status`)
- Driver device token admin metadata dependency card (per-driver endpoint exists; platform-wide store may be `sourceUnavailable`)
- Notification events section wired to `GET /platform-admin/notification-events` (shows `sourceUnavailable` or empty list truthfully)

## Privacy boundary

No raw FCM tokens, secrets, or provider credential payloads.

## Remaining dependency

- Production push delivery infra (FCM/APNS credentials)
- Notification event persistence store
- Driver device token registration foundation for platform-wide visibility
