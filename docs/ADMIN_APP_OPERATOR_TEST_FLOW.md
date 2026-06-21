# ViaNexis Admin App — operator test flow

Step-by-step flow for internal operators testing the staging admin APK.

## 1. Receive build

1. Obtain APK from secure internal channel — see [`ADMIN_APP_INTERNAL_DISTRIBUTION.md`](./ADMIN_APP_INTERNAL_DISTRIBUTION.md)
2. Confirm filename includes version/build (e.g. `1.0.0+1`)
3. Install on dedicated test device

## 2. Verify environment

1. Open app — confirm **Staging** badge on login
2. Open Settings (after login) — confirm API host matches expected staging hostname
3. Confirm no "mock data" indicator on dashboard

## 3. Authenticate

1. Enter staging `super_admin` email and password (from secure handover — not email/chat plaintext if policy forbids)
2. Confirm landing on dashboard
3. Optional: kill app and reopen — session should restore

## 4. Module walkthrough (~30 min)

Follow order in [`ADMIN_APP_INTERNAL_UAT_CHECKLIST.md`](./ADMIN_APP_INTERNAL_UAT_CHECKLIST.md):

1. Dashboard → Action Center
2. Registrations → open one item (metadata only)
3. Companies → open one item
4. Billing overview
5. Notifications → preferences → push provider status card
6. Security Center
7. System Health
8. Audit logs (metadata)
9. Release Center → email + observability cards
10. Customer Communications → open thread → **Send reply** (human confirmation required; note “Delivery provider disabled” warning when email noop) → verify outbound message shows **skipped** delivery badge → generate evidence package (reason required) → verify PDF ready + download mentions delivery status when present

## 5. Negative tests

1. Enable airplane mode → open dashboard → expect safe error + retry
2. Logout → confirm login screen
3. Optional: wait for token expiry or revoke session on backend → confirm redirect to login

## 6. Report results

- Pass: note in UAT sign-off table
- Fail: file bug with [`ADMIN_APP_BUG_REPORT_TEMPLATE.md`](./ADMIN_APP_BUG_REPORT_TEMPLATE.md)
- Include: device model, Android version, APK version, staging API host, steps, screenshot

## 7. After UAT

- Rotate staging super_admin password if shared during testing
- Remove APK from unsecured devices
- Do not use staging credentials in production
