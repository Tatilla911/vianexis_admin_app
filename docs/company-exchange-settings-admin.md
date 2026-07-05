# Company exchange settings — admin app

**Screen:** `lib/features/company_settings/presentation/company_exchange_settings_screen.dart`  
**Route:** `/companies/:id/exchange-settings`  
**Backend:** `GET/PATCH /companies/:companyId/exchange-settings`

## Features (foundation)

- Raklapcsere enabled/disabled toggle
- Göngyöleg enabled/disabled toggle
- Driver custom packaging items toggle
- Default pallet types — read-only chips
- Default packaging list — read-only placeholder (editor phase 2)

## Modes

| Mode | Behavior |
|------|----------|
| Live API configured | Calls backend; errors show backend dependency message |
| Mock fallback (dev) | Local mock data + badge; save updates mock only |

No silent mock in production when API is configured.

## Privacy

Metadata and feature flags only — no trip, document, or message content on this screen.

Cross-repo matrix: `transdoc-backend/docs/platform-integration-matrix.md`
