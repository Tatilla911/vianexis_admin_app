# Admin App — first staging UAT runbook

Use after Render backend deploy and APK build. Master checklist: `transdoc-backend/docs/FIRST_STAGING_UAT_MASTER_RUNBOOK.md`.

## Prerequisites

- [ ] Render API: `https://<RENDER_STAGING_API_HOST>`
- [ ] Backend smoke passed (`npm run smoke:platform-admin`)
- [ ] APK built per [`ADMIN_APP_RENDER_STAGING_APK_RUNBOOK.md`](./ADMIN_APP_RENDER_STAGING_APK_RUNBOOK.md)
- [ ] Staging super_admin credentials in secret store

## Install and environment

- [ ] APK installed on test Android device
- [ ] Staging badge visible (EN/HU)
- [ ] Settings → API host matches Render hostname (metadata only)
- [ ] Mock fallback **not** active

## Login

- [ ] Login with staging super_admin succeeds
- [ ] Wrong password → localized error (no stack trace)

## Core navigation

- [ ] Dashboard
- [ ] Action Center
- [ ] Public intakes (list + detail)
- [ ] Customer communications
- [ ] Billing overview
- [ ] Release Center
- [ ] Audit logs (metadata-only notice)
- [ ] Notifications

## Customer communication UAT

- [ ] Open thread linked from public intake (if available)
- [ ] Send reply — **noop** email provider; delivery skipped logged
- [ ] Generate evidence PDF
- [ ] Download PDF opens successfully

## Translation panel (provider disabled)

- [ ] Public intake detail shows provider disabled state
- [ ] No auto-send of translated replies

## Release / observability

- [ ] Release Center shows email noop, push none
- [ ] No production URLs in UI

## Failure paths

- [ ] Airplane mode → safe unreachable message
- [ ] Session expiry handled gracefully (if tested)

## Bug reporting

Use [`ADMIN_APP_BUG_REPORT_TEMPLATE.md`](./ADMIN_APP_BUG_REPORT_TEMPLATE.md). Include Render hostname only — **no** JWT or passwords.

## Sign-off

| Tester | Device | APK version | Date | Pass/Fail |
|--------|--------|-------------|------|-----------|
| | | | | |

**Approved:** ☐ Yes ☐ No — Reviewer: ______________ Date: __________
