# Admin app company exchange settings (HEAD)

## Screen and route

- **Route:** `/companies/:id/exchange-settings`

## Current behavior

### Pallet exchange

- Toggle: `palletExchangeEnabled`
- Default pallet types: read-only chips
- Toggle: `allowDriverManualPalletRecords` (live via exchange settings PATCH)

### Packaging

- Toggle: `packagingExchangeEnabled`
- Toggle: `allowDriverCustomPackagingItems`
- Default packaging list merged from `GET /platform-admin/companies/:companyId/packaging-items`
- CRUD: add, edit, deactivate, reactivate via platform-admin packaging endpoints

## Backend calls

- `GET/PATCH /companies/:companyId/exchange-settings`
- `GET/POST/PATCH/DELETE /platform-admin/companies/:companyId/packaging-items`

## Privacy boundary

Configuration metadata only — no trip document or message content.
