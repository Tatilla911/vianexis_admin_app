# Admin app company exchange settings (HEAD)

Current reference: `47adc94`.

## Screen and route

- **Route:** `/companies/:id/exchange-settings`
- **Context:** company-level exchange configuration for pallet and packaging behavior.

## Current behavior

### Pallet exchange

- Toggle: enabled/disabled (`palletExchangeEnabled`)
- Default pallet types are displayed as read-only chips
- Manual pallet record policy is still a backend dependency (not wired as a writable field)

### Packaging (göngyöleg)

- Toggle: enabled/disabled (`packagingExchangeEnabled`)
- Toggle: allow driver custom packaging items (`allowDriverCustomPackagingItems`)
- Default packaging list is shown with metadata (name, active state, sort order, notes)
- List source is merged from live endpoint: `GET /platform-admin/companies/:companyId/packaging-items` (`includeInactive=true`)

## Packaging CRUD UI (added in `47adc94`)

Supported actions in admin UI:

- Add packaging item
- Edit packaging item
- Deactivate packaging item
- Reactivate packaging item

Supported fields:

- Name
- Sort order
- Notes (optional)
- Active/inactive flag

Backend calls:

- `POST /platform-admin/companies/:companyId/packaging-items`
- `PATCH /platform-admin/companies/:companyId/packaging-items/:itemId`
- `DELETE /platform-admin/companies/:companyId/packaging-items/:itemId`

## Live and mock behavior

- **Live mode:** reads and mutates packaging items through platform-admin endpoints.
- **Mock mode:** local in-memory fallback remains available for development/testing and is explicitly badged in UI.

## Localization and layout

- New and existing UI labels are localized (HU/EN).
- Dialog and list layout are responsive and used in mobile-safe patterns (no forced horizontal overflow in current implementation).

## Dependencies still open

- Manual pallet record policy backend field (documented in UI as dependency):
  - planned direction: extend exchange settings contract (for example `allowDriverManualPalletRecord`)

## Privacy boundary

- Company settings view is metadata/configuration only.
- No trip document content, message body, storage key, or token secrets are displayed.
