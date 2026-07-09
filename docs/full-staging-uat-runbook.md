# Full staging UAT runbook (admin app)

Master runbook: [`transdoc-driver-app/docs/full-staging-uat-runbook.md`](../../transdoc-driver-app/docs/full-staging-uat-runbook.md)

## Admin-specific steps

### Build

```bash
flutter build apk --release \
  --dart-define=APP_ENV=staging \
  --dart-define=API_BASE_URL=https://vianexis-staging-api.onrender.com
```

### Pending driver registration approval

1. Login as `super_admin` or `onboarding_reviewer`.
2. **More → Driver access**.
3. Section **Pending driver registrations** (top).
4. **Approve** → `POST /platform-admin/driver-registration-requests/:id/approve`.
5. Verify driver appears in list below with **Active** status.

### Endpoints wired

| Action | Endpoint |
|--------|----------|
| List pending | `GET /platform-admin/driver-registration-requests?status=pending` |
| Approve | `POST /platform-admin/driver-registration-requests/:id/approve` |
| Reject | `POST /platform-admin/driver-registration-requests/:id/reject` |
| Active drivers | `GET /platform-admin/drivers` |
| Enable/disable | `PATCH /platform-admin/drivers/:id/status` |

### Staging deploy dependency

Pending list shows backend dependency card until staging API includes driver registration + platform-admin approval routes.
