# ViaNexis Admin App — operator runbook

## Access requirements

Platform roles only: `super_admin`, `support_admin`, `onboarding_reviewer`, `billing_admin`.

Tenant roles (driver, dispatcher, company_admin, etc.) cannot sign in.

## Starting a session

1. Install build with correct `APP_ENV` and `API_BASE_URL` (see [ADMIN_APP_ENVIRONMENTS.md](ADMIN_APP_ENVIRONMENTS.md)).
2. Sign in with platform staff credentials from the backend seed or your IdP-provisioned account.
3. Confirm environment badge on dashboard/settings matches expected profile.
4. Confirm **API connected** (not mock fallback) before production decisions.

## Metadata-only model

- Lists, summaries, and audit views show **metadata only**.
- No operational trip bodies, document content, or message bodies in platform admin views.
- AI recommendations are **advisory** — human approval required.

## Mock fallback policy

| Environment | API unset behavior |
|-------------|-------------------|
| local / dev | Mock data allowed; orange banner |
| staging / production | Live API required; sign-in blocked; error banner |

## Troubleshooting

### API not configured

- Symptom: red/orange banner, sign-in disabled in production.
- Fix: rebuild with `--dart-define=API_BASE_URL=https://...`.

### Backend unreachable

- Symptom: network errors, loading failures.
- Check: device network, VPN, backend health, CORS (web), TLS certificate.
- Verify backend URL in settings shows expected host only.

### Unauthorized / session expired

- Symptom: redirected to login or permission denied after idle period.
- Fix: sign in again; confirm role still valid on backend.

### Permission denied

- Symptom: **Permission denied** screen when opening a module.
- Expected: role does not include that destination (e.g. support_admin → Admin Users).
- Fix: use correct role or request access from super_admin.

### Localization missing

- Symptom: English fallback or raw key visible.
- Fix: run `flutter gen-l10n`; ensure both `app_en.arb` and `app_hu.arb` contain the key.

## Support escalation

Document: environment, role, approximate time, module, correlation/audit id if available. **Do not** paste operational tenant content into tickets.
