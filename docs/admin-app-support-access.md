# Admin app — support access

## Status: existing module (unchanged boundary)

Support access grants remain in **Support → Access grants** (`/support/grants`).

Roles: `super_admin`, `support_admin` (per existing `AdminRole` gates).

## Metadata shown

- Company name / id
- Scope
- Status (active, expired, revoked, …)
- `createdAt`, `expiresAt`
- `createdBy` (admin reference)

Create/revoke flows remain where backend endpoints exist (existing implementation).

## Never shown

- Document content
- Message body
- Storage keys
- Operational sensitive payloads

## Operations hub link

The new **Operations overview** links to the existing support grants module; no duplicate grant UI was added.

## Backend

Existing platform-admin support grant endpoints (see backend platform-admin module). No admin-app changes required for list/create/revoke in this sprint.

## Blockers

None for metadata-only listing. Full operational impersonation tooling is out of scope.
