# ViaNexis Admin App — Render staging UAT

Admin app UAT after Render backend deploy. Master checklist: `transdoc-backend/docs/RENDER_STAGING_UAT_MASTER_CHECKLIST.md`.

## Prerequisites

- [ ] Render API URL: `https://<RENDER_STAGING_API_HOST>`
- [ ] APK built per [`ADMIN_APP_RENDER_STAGING_BUILD.md`](./ADMIN_APP_RENDER_STAGING_BUILD.md)
- [ ] Staging super_admin credentials in secret store (not in repo)

## Install and environment

- [ ] APK installed via secure channel
- [ ] Staging badge visible (EN/HU)
- [ ] Settings shows Render API host (metadata only)
- [ ] Mock fallback **not** active

## Login

- [ ] Login succeeds with staging super_admin
- [ ] Wrong password shows localized error (no stack trace)

## Core modules

- [ ] Dashboard
- [ ] Action Center
- [ ] Notifications list
- [ ] Billing overview
- [ ] Security Center
- [ ] Audit logs (metadata only)
- [ ] Release Center — staging label + email/push/observability cards

## Backend integration

- [ ] Data loads from live Render API (not mock)
- [ ] Logout clears session
- [ ] Re-login works

## Failure paths

- [ ] Airplane mode — safe unreachable message
- [ ] Session expiry handled gracefully (if tested)

## Bug reporting

- [ ] Use [`ADMIN_APP_BUG_REPORT_TEMPLATE.md`](./ADMIN_APP_BUG_REPORT_TEMPLATE.md)
- [ ] Include Render hostname; **no** JWT/passwords

## Sign-off

| Tester | Device | Date | Pass/Fail | Notes |
|--------|--------|------|-----------|-------|
| | | | | |

**Approved:** ☐ Yes ☐ No — Reviewer: ______________ Date: __________
