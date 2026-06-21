# ViaNexis Admin App — internal UAT checklist

Human acceptance testing for the first internal staging APK. Test on a **non-production** staging backend only.

## Setup

- [ ] Staging API deployed and healthy (`/health`, `/health/ready`)
- [ ] `super_admin` bootstrapped (`npm run seed:platform-admin` on backend)
- [ ] APK built with `APP_ENV=staging` and correct `API_BASE_URL`
- [ ] APK installed on test device
- [ ] Tester assigned staging credentials via secure channel

## Install and login

- [ ] APK installs without errors
- [ ] App opens to login screen
- [ ] Environment badge shows **Staging** (EN/HU)
- [ ] Login with staging `super_admin` succeeds
- [ ] No mock-data badge on dashboard (live API mode)

## Core modules (super_admin)

- [ ] Dashboard cards load
- [ ] Action Center loads
- [ ] Registrations list and detail open
- [ ] Companies list and detail open
- [ ] Billing overview opens
- [ ] Admin Users opens
- [ ] Security Center opens
- [ ] Notifications list opens
- [ ] System Health opens
- [ ] Audit logs open
- [ ] Release Center opens

## Customer communications evidence PDF

- [ ] Customer Communications module opens
- [ ] Generate evidence package requires reason (≥5 chars)
- [ ] PDF ready status shown after generation (`pdfReady` / download path)
- [ ] Download PDF button visible when ready; pending/failed states shown otherwise
- [ ] File hash displayed; structured summaryJson still visible
- [ ] “Generated from ViaNexis audit records” notice visible before download

## Readiness status cards (Release Center / Settings)

- [ ] Email delivery status — provider noop, delivery disabled, metadata-only notice
- [ ] Observability status — no DSN/endpoint values shown
- [ ] Push provider status (notification preferences) — external push not configured

## Failure handling

- [ ] Airplane mode / API unavailable shows safe error (no stack traces)
- [ ] Invalid credentials show generic error (no password in UI)
- [ ] Session expiry redirects to login
- [ ] Logout returns to login screen

## Privacy

- [ ] No raw JWT or API secrets visible in UI
- [ ] Metadata-only notices visible where applicable
- [ ] No tenant trip/document bodies exposed

## Screenshots to capture

1. Login with staging badge
2. Dashboard overview
3. Release Center readiness cards
4. Settings — environment + API host summary
5. One error state (API unavailable)

## Sign-off

| Tester | Date | Pass/Fail | Notes |
|--------|------|-----------|-------|
| | | | |

File bugs using [`ADMIN_APP_BUG_REPORT_TEMPLATE.md`](./ADMIN_APP_BUG_REPORT_TEMPLATE.md).
