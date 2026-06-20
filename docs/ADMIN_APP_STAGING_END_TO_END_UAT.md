# ViaNexis Admin App — staging end-to-end UAT

Admin app portion of staging rehearsal. Backend master flow: `transdoc-backend/docs/STAGING_END_TO_END_REHEARSAL.md`.

## Prerequisites

- [ ] Staging API deployed and smoke tests PASS
- [ ] Staging `super_admin` bootstrapped
- [ ] Staging APK built with correct `API_BASE_URL`

## Build and install

1. [ ] `dart run tool/prepare_staging_apk_artifact.dart` (dry-run)
2. [ ] Build APK with staging dart-defines — see [`ADMIN_APP_RENDER_STAGING_BUILD.md`](./ADMIN_APP_RENDER_STAGING_BUILD.md) for Render
3. [ ] Rename to `ViaNexisAdmin-staging-v<version>.apk`
4. [ ] Install via secure channel — see [`ADMIN_APP_INTERNAL_DISTRIBUTION.md`](./ADMIN_APP_INTERNAL_DISTRIBUTION.md)

## Login and environment

5. [ ] Open app — **Staging** badge visible (EN/HU)
6. [ ] Settings shows API host (not secrets)
7. [ ] Login with staging super_admin

## Module verification

8. [ ] Dashboard
9. [ ] Action Center
10. [ ] Registrations / Companies / Billing
11. [ ] Notifications + push provider status (external push not configured OK)
12. [ ] Security Center
13. [ ] System Health / Audit logs
14. [ ] Release Center — email + observability readiness cards

## Failure paths

15. [ ] Airplane mode — safe error, no stack trace
16. [ ] Logout → login screen
17. [ ] Session expiry behavior (if tested)

## Bug reporting

18. [ ] Use [`ADMIN_APP_BUG_REPORT_TEMPLATE.md`](./ADMIN_APP_BUG_REPORT_TEMPLATE.md)
19. [ ] No JWT/passwords in reports

## Sign-off

| Tester | Date | Result | Notes |
|--------|------|--------|-------|
| | | | |

## After UAT

- Rotate shared staging password
- Remove APK from unsecured devices
