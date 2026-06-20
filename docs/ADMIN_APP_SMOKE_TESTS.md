# ViaNexis Admin App — smoke tests

Run against a non-production environment first.

## Authentication and session

- [ ] Login with `super_admin`
- [ ] Session restores after app restart
- [ ] Logout returns to login screen
- [ ] Session expiry path redirects safely to login

## Core modules

- [ ] Environment badge is visible and correct
- [ ] Dashboard cards load
- [ ] Action Center loads
- [ ] Registrations list/detail open
- [ ] Companies list/detail open
- [ ] Billing overview opens
- [ ] Admin Users opens (super_admin)
- [ ] Security Center opens
- [ ] Notifications list opens
- [ ] Support tickets open
- [ ] System health opens
- [ ] Audit logs open
- [ ] Release Center opens

## Bulk onboarding controls

- [ ] Approved job shows dry-run action
- [ ] Execute action requires reason + confirmation
- [ ] Policy-disabled state is shown when backend blocks execute
- [ ] Row-level execution status badges render

## Failure handling

- [ ] API unavailable shows safe error messaging
- [ ] Production without `API_BASE_URL` shows configuration warning
- [ ] No raw token/API secrets are shown in UI
