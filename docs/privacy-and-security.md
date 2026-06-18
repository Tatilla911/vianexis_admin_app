# Privacy and security

## Data scope

The admin app is designed for **platform metadata only**. By default it must not display:

- Trip operational content
- Document bodies or downloads
- Message or chat content
- Private uploaded files

These remain in tenant-scoped systems and require explicit support access grants for deeper troubleshooting.

## Backend alignment

The backend enforces privacy at the API layer:

- `platform-admin` controllers return aggregates and metadata
- Audit responses are sanitized (`platform-admin-privacy.util.ts`)
- Operational content requires an active company support grant

The client must mirror this at the UI layer — never assume an endpoint will stay metadata-only without checking contract docs.

## Token storage

| Data | Storage | Notes |
|------|---------|-------|
| Access token | `flutter_secure_storage` | Short-lived JWT |
| Refresh token | `flutter_secure_storage` | Opaque refresh token |
| User preferences | `shared_preferences` | Non-sensitive only |

Never store tokens in plain `SharedPreferences`.

## Session rules

1. Only platform admin roles may use this app
2. Sign out clears secure storage
3. Failed refresh forces re-authentication
4. No persistent "remember me" bypass of role checks

## UI privacy patterns

- Show **Metadata only** badge on summary screens (`privacyMetadataOnlyBadge`)
- Display privacy notice on dashboard (`privacyNoOperationalContent`)
- Do not cache operational content locally
- Redact email/phone in list views where backend returns partial metadata

## Network

- HTTPS only in staging and production
- Certificate pinning: evaluate for production hardening (future)
- Log requests without tokens or PII in release builds

## Device posture

- Support biometric lock (future phase)
- Auto-lock on background (future phase)
- Screenshot restrictions: evaluate for sensitive screens (future)

## Audit

Platform admin actions on the backend are audited. When write actions are added (approve registration, create support grant), the client should display confirmation dialogs and surface audit-friendly action labels.

## Release checklist

- [ ] API base URL set via dart-define (no hardcoded production secrets)
- [ ] Secure storage verified on Android and iOS
- [ ] Role gate tested for all four platform roles
- [ ] No operational content widgets ship without grant context
- [ ] Localization covers all privacy-related strings
