# ViaNexis Admin App — production readiness

## Summary (2026-07-05 platform checkpoint)

| Gate | Result |
|------|--------|
| `flutter analyze lib` | **PASS** — 0 issues |
| `flutter test` | **334/334 PASS** |
| Release readiness script | **OK** |
| Git tree | **Clean** at `d8a533b` |

**Exchange settings admin:** Company exchange toggles (pallet, packaging, driver custom items) — foundation at `d8a533b`. Default packaging list editor phase 2.

**Blockers:** No app store pipeline; staging URL at build time; push notifications not started.

See backend repo `transdoc-backend/docs/platform-integration-matrix.md` (cross-repo matrix).

## Configuration

- Central config: `lib/app/app_config.dart`, `lib/app/app_environment.dart`
- Build defines: `APP_ENV`, `API_BASE_URL`, optional `ALLOW_MOCK_FALLBACK`
- See [ADMIN_APP_ENVIRONMENTS.md](ADMIN_APP_ENVIRONMENTS.md)

## Implemented modules

| Module | Route | Roles (summary) |
|--------|-------|-----------------|
| Dashboard | `/dashboard` | All platform roles |
| Action Center | `/action-center` | All (filtered) |
| Registrations | `/registrations` | super_admin, onboarding_reviewer |
| Companies | `/companies` | Most platform roles |
| Billing | `/billing` | super_admin, billing_admin; support read-only |
| Bulk onboarding | `/bulk-onboarding` | super_admin, onboarding_reviewer |
| AI reviews | `/ai-reviews` | super_admin, onboarding_reviewer, support |
| Support | `/support/*` | super_admin, support_admin |
| System health | `/system-health` | super_admin, support |
| Audit logs | `/audit-logs` | super_admin, support |
| Admin users | `/admin-users` | super_admin |
| Security Center | `/security` | super_admin, support |
| Release Center | `/release` | super_admin, support read-only |
| Settings | `/settings` | All platform roles |

## Quality gates

See [QUALITY-GATES.md](QUALITY-GATES.md) and `.github/workflows/admin_app_ci.yml`.

## Known production gaps

1. Backend staging/production deployment URLs must be supplied at build time — no hardcoded production URL in app.
2. Platform admin invite email delivery pending on backend.
3. No push notification foundation.
4. No app store / internal distribution pipeline in repo.
5. App icon/splash native generation pending (assets documented).
6. Action Center dismiss/acknowledge not persisted (read-model only).
7. No real payment processor integration (billing is metadata/status only).
8. No real bulk provisioning execution from admin app.

## Related docs

- [ADMIN_APP_RUNBOOK.md](ADMIN_APP_RUNBOOK.md)
- [ADMIN_APP_RELEASE_CHECKLIST.md](ADMIN_APP_RELEASE_CHECKLIST.md)
- [admin-app-current-status.md](admin-app-current-status.md)
- [privacy-and-security.md](privacy-and-security.md)
