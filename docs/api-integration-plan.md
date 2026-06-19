# API integration plan

## Backend

**Base URL:** configured via `--dart-define=API_BASE_URL=...` (see `lib/core/api/api_config.dart`)

**Backend project:** `../transdoc-backend`

## Authentication

| Method | Path | Purpose |
|--------|------|---------|
| POST | `/auth/login` | Platform staff sign in |
| POST | `/auth/refresh` | Refresh access token |
| POST | `/auth/logout` | End session |

**Client rules:**

- Store access and refresh tokens in `flutter_secure_storage` only
- Reject sessions whose role is not a platform admin role
- Auto-refresh on 401 via `dio` interceptor

## Platform roles

| Role | Backend enum | Primary surfaces |
|------|--------------|------------------|
| Super admin | `super_admin` | Full platform admin navigation |
| Support admin | `support_admin` | Support tickets, grants, health, audit |
| Onboarding reviewer | `onboarding_reviewer` | Registration applications, AI reviews |
| Billing admin | `billing_admin` | Pricing intakes, subscriptions |

Role groups are defined in backend `src/access/role-groups.ts`.

## Planned API modules

### Dashboard

| Method | Path | Screen |
|--------|------|--------|
| GET | `/platform-admin/dashboard` | `admin_dashboard_screen.dart` |

### Registrations (ECC)

| Method | Path | Screen |
|--------|------|--------|
| GET | `/platform-admin/registration-applications` | `registration_applications_screen.dart` |
| GET | `/platform-admin/registration-applications/:id` | `registration_application_detail_screen.dart` |
| PATCH | `/platform-admin/registration-applications/:id/approve` | detail actions |
| PATCH | `/platform-admin/registration-applications/:id/reject` | detail actions |
| PATCH | `/platform-admin/registration-applications/:id/request-info` | detail actions |

### Bulk onboarding (Phase 10)

| Method | Path | Screen |
|--------|------|--------|
| GET | `/platform-admin/bulk-onboarding/jobs` | `bulk_onboarding_jobs_screen.dart` |
| GET | `/platform-admin/bulk-onboarding/jobs/:id` | `bulk_onboarding_job_detail_screen.dart` |
| GET | `/platform-admin/bulk-onboarding/jobs/:id/rows` | `bulk_onboarding_rows_screen.dart` |
| POST | `/platform-admin/bulk-onboarding/jobs/:id/validate` | detail actions |
| PATCH | `/platform-admin/bulk-onboarding/jobs/:id/approve` | detail actions |
| PATCH | `/platform-admin/bulk-onboarding/jobs/:id/reject` | detail actions |
| PATCH | `/platform-admin/bulk-onboarding/jobs/:id/cancel` | detail actions |
| POST | `/platform-admin/bulk-onboarding/jobs/:id/process` | detail actions (requires `confirm=true`) |

Roles: list/detail read for `super_admin`, `onboarding_reviewer`, `support_admin`; write actions for `super_admin` + `onboarding_reviewer` only.

### Support

| Method | Path | Screen |
|--------|------|--------|
| GET | `/platform-admin/support-tickets` | `support_tickets_screen.dart` |
| GET | `/platform-admin/support-tickets/:id` | `support_ticket_detail_screen.dart` |
| PATCH | `/platform-admin/support-tickets/:id/acknowledge` | detail actions |
| PATCH | `/platform-admin/support-tickets/:id/close` | detail actions |
| GET | `/platform-admin/support-access-grants` | `support_access_grants_screen.dart` |
| GET | `/platform-admin/support-access-grants/:id` | `support_access_grant_detail_screen.dart` |
| PATCH | `/platform-admin/support-access-grants/:id/revoke` | grant detail |
| POST | `/platform-admin/support-access-grants` | grant creation (support admin) |

### System health and audit

| Method | Path | Screen |
|--------|------|--------|
| GET | `/platform-admin/system-health` | `system_health_screen.dart` |
| GET | `/platform-admin/system-health/events` | event list enrichment |
| GET | `/platform-admin/system-health/events/:id` | `system_health_event_detail_screen.dart` |
| PATCH | `/platform-admin/system-health/events/:id/acknowledge` | detail actions |
| POST | `/platform-admin/system-health/events/:id/escalate` | detail actions |
| POST | `/platform-admin/system-health/events/:id/create-support-ticket` | detail actions (when backend supports) |
| GET | `/platform-admin/audit-logs` | `audit_logs_screen.dart` |
| GET | `/platform-admin/audit-logs/:id` | `audit_log_detail_screen.dart` |
| GET | `/platform-admin/system-audit` | audit alias (list) |

### Companies and billing (later phases)

| Method | Path | Notes |
|--------|------|-------|
| GET | `/platform-admin/companies` | Company metadata list |
| GET | `/platform-admin/pricing-intakes` | Billing admin |
| GET | `/platform-admin/subscriptions` | Billing admin |

### Search (later phase)

| Method | Path | Notes |
|--------|------|-------|
| GET | `/search` | Context-aware metadata search |
| GET | `/search/operational-snapshot` | Structured snapshot |

## Implementation phases

| Phase | Scope |
|-------|-------|
| **Current** | App shell, theme, router, auth model, placeholder screens |
| **Next** | `dio` client + auth API + secure token restore |
| **Then** | Dashboard + registration queue |
| **Then** | Support, health, audit |
| **Phase 10** | Bulk onboarding jobs list/detail/rows, validation workflow, dashboard summary |
| **Then** | Search, billing, company detail |

## Error handling

Map backend error codes to localized messages. Never surface raw stack traces in UI.

## Testing

- Unit tests for mappers and role capability filtering
- Widget tests for scaffold responsiveness and auth redirect
- Integration tests against staging backend (future)
