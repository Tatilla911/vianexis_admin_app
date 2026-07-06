# Admin app support access metadata boundary (HEAD)

Current reference: `47adc94`.

## Route and operations link

- **Primary screen:** `/support/grants`
- **Operations hub link:** available from `/operations` (support access module link)

## Access model

- Intended platform roles: `super_admin` and `support_admin` for support grant management views.
- Existing list/create/revoke flows remain on the current support grants module.

## Metadata-only policy (must remain)

Displayed metadata:

- Company
- Scope
- Status
- `createdAt`
- `expiresAt`
- `createdBy`

Must not be displayed:

- `documentContent`
- `messageBody`
- `storageKey`
- Any operational sensitive content payload

## Backend status

- Support grants backend integration already exists and is used by the current admin module.
- No extra backend code changes are required for the docs refresh.

## Notes

- This document reflects boundary enforcement and routing/linking state after operations readiness updates.
