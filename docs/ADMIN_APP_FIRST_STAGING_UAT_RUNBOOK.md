# Admin App — first staging UAT runbook

Use after Render backend deploy and APK build. Master checklist: `transdoc-backend/docs/FIRST_STAGING_UAT_MASTER_RUNBOOK.md`.

## Prerequisites

- [ ] Render API: `https://<RENDER_STAGING_API_HOST>`
- [ ] Backend smoke passed (`npm run smoke:platform-admin`)
- [ ] APK built per [`ADMIN_APP_RENDER_STAGING_APK_RUNBOOK.md`](./ADMIN_APP_RENDER_STAGING_APK_RUNBOOK.md)
- [ ] Staging super_admin credentials in secret store

## Install and environment

- [ ] **Use release/profile APK for operator UAT** — `flutter run` shows a DEBUG banner; staging sign-off must use:
  ```bash
  flutter build apk --release \
    --dart-define=APP_ENV=staging \
    --dart-define=API_BASE_URL=https://vianexis-staging-api.onrender.com
  ```
  Or: `dart run tool/prepare_staging_apk_artifact.dart --api-base-url=https://vianexis-staging-api.onrender.com --execute`
- [ ] APK installed on test Android device
- [ ] Default app language is **Hungarian** (change in Settings → Language if needed)
- [ ] Staging badge visible
- [ ] Settings → API host matches Render hostname (metadata only)
- [ ] Mock fallback **not** active

## Login

- [ ] Login with staging super_admin succeeds
- [ ] Wrong password → localized error (no stack trace)

## Core navigation

- [ ] Bottom nav on phone shows **max 5 items** (Dashboard, Action Center, Registrations, Communications, More)
- [ ] Secondary modules reachable via **Továbbiak / More**
- [ ] **Public intakes** quick action on dashboard + tile under More (with description)
- [ ] Customer communications
- [ ] Billing overview
- [ ] Release Center
- [ ] Audit logs (metadata-only notice)
- [ ] Notifications

## Customer communication UAT

- [ ] Open thread linked from public intake (if available)
- [ ] Send reply — **noop** email provider; delivery skipped logged
- [ ] Generate evidence PDF
- [ ] **Share PDF** opens device share sheet (save/open with another app) — not clipboard copy

## Translation panel (provider disabled)

- [ ] Public intake detail shows provider disabled state
- [ ] No auto-send of translated replies

## Support operations UAT

- [ ] Open support ticket detail from list (live `GET /platform-admin/support-tickets/:id`)
- [ ] Acknowledge ticket — status moves to investigating (`in_progress` on backend)
- [ ] Close ticket — required note; status becomes closed
- [ ] Create support access grant from ticket detail (metadata-only scope)
- [ ] Open grant detail (live `GET /platform-admin/support-access-grants/:id`)
- [ ] Revoke grant with reason — grant remains visible as revoked
- [ ] Privacy notice visible; no document/message body fields in UI
- [ ] Roles: `support_admin` / `super_admin` only; others see permission denied

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
