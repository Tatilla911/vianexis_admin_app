# Admin app — company exchange settings

## Implemented

Screen: **Companies → company detail → Exchange settings** (`/companies/:id/exchange-settings`)

| Control | API field | Writable |
|---------|-----------|----------|
| Pallet exchange enabled | `palletExchangeEnabled` | Yes (`PATCH`) |
| Packaging exchange enabled | `packagingExchangeEnabled` | Yes |
| Driver custom packaging items | `allowDriverCustomPackagingItems` | Yes |
| Default pallet types | `defaultPalletTypes` | Read-only display |
| Default packaging items | `defaultPackagingItems` | Read-only display (name, active, sort order, notes) |

API: `GET/PATCH /companies/:companyId/exchange-settings`

## Backend dependencies

| Feature | Status |
|---------|--------|
| Add/edit/delete packaging items | **Not available** — dependency card shown |
| Reorder packaging items | **Not available** |
| Driver manual pallet record policy toggle | **Not available** — `allowDriverManualPalletRecord` not in current contract |

Planned endpoints (document only):

```
POST   /companies/:id/exchange-settings/packaging-items
PATCH  /companies/:id/exchange-settings/packaging-items/:itemId
DELETE /companies/:id/exchange-settings/packaging-items/:itemId
PATCH  /companies/:id/exchange-settings  { allowDriverManualPalletRecord: bool }
```

## Privacy

Settings screen shows company feature flags and list metadata only. No trip payloads, PDF content, or driver-entered free text from stops.

## Blockers

- Full göngyöleg default lista kezelés requires backend CRUD before admin can offer edit/delete/inactivate UI beyond read-only preview.
