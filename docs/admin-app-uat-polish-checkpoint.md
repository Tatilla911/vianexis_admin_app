# ViaNexis Admin App — UAT / staging polish checkpoint

**Document type:** Internal re-entry snapshot for staging operator readiness  
**Repository:** `vianexis_admin_app`  
**Checkpoint date:** 2026-06-25  
**Product context:** [`transdoc-backend/docs/product-development-checkpoint.md`](../../transdoc-backend/docs/product-development-checkpoint.md) — priority #1 is first staging UAT completion  
**Latest app commit:** `856d9e3` — admin password change + login error mapping  
**Prior UAT fixes:** `e2e19ab` — mobile nav, More hub, locale, device PIN, staging APK tooling

**Do not treat this file as UAT sign-off.**

---

## 1. Checks run (this checkpoint)

| Check | Command | Result |
|-------|---------|--------|
| Analyzer | `flutter analyze` | **No issues** |
| Unit/widget tests | `flutter test` | **317/317 passed** (post UAT polish) |
| Release readiness | `dart run tool/admin_release_readiness_check.dart` | **OK** |
| Staging build check | `dart run tool/admin_staging_build_check.dart` | **OK** |
| App smoke (static) | `dart run tool/admin_app_smoke_check.dart` | **OK** |

**Not run (requires device + staging API):** release APK install, live Render login, customer evidence PDF open on device, airplane-mode UX.

---

## 2. Git state

| Item | Status |
|------|--------|
| Branch | `main` @ `856d9e3` |
| Untracked | `artifacts/` — local APK/build output; **do not commit** unless documented release artifact workflow |
| Other repos | **Not modified** (`transdoc-backend`, `transport_driver_app` untouched in this phase) |

---

## 3. Existing UAT / status docs

| Document | Purpose |
|----------|---------|
| `ADMIN_APP_FIRST_STAGING_UAT_RUNBOOK.md` | Operator UAT on Render + release APK |
| `ADMIN_APP_INTERNAL_UAT_CHECKLIST.md` | Human acceptance checklist |
| `ADMIN_APP_STAGING_END_TO_END_UAT.md` | Broader E2E UAT |
| `CUSTOMER_COMMUNICATION_DELIVERY_UAT.md` | Reply noop + evidence PDF path |
| `ADMIN_APP_RENDER_STAGING_APK_RUNBOOK.md` | APK build with `API_BASE_URL` |
| `ADMIN_APP_RELEASE_CHECKLIST.md` | Pre-release gates |
| `QUALITY-GATES.md` | analyze + test before commit |
| `admin-app-current-status.md` | Module inventory (partially outdated — missing public intake / customer comms in table) |
| `ADMIN_APP_PRODUCTION_READINESS.md` | Known production gaps |

---

## 4. Current visible modules

### Mobile primary bottom nav (phone)

Dashboard · Action Center · Registrations · **Customer communications** · **More** (`admin_modules_hub_screen`)

### More hub (secondary)

Companies · Billing · Bulk onboarding · AI reviews · Support tickets · Support grants · **Public intakes** · System health · Security center · Audit logs · Notifications · Admin users · Release center · Settings

### Module maturity (operator-facing)

| Module | Route(s) | Staging notes |
|--------|----------|---------------|
| **Dashboard** | `/dashboard` | Summary cards; per-module error cards; mock badge when fallback active |
| **Action Center** | `/action-center` | Deep-links via `actionRouteHint`; **no dismiss/ack persist** (read-model) |
| **Registrations** | `/registrations` | Approve/reject flows; invite depends on backend email |
| **Companies** | `/companies` | Metadata summaries |
| **Support tickets** | `/support/tickets` | Acknowledge + close; grant create from ticket |
| **Support grants** | `/support/grants` | Revoke with reason dialog |
| **Customer communications** | `/customer-communications` | Reply, delivery history, evidence PDF — **see blockers** |
| **Public intakes** | `/public-intakes` | Status change, translation panel, link to comm thread when `linkedCustomerCommunicationThreadId` set |
| **Billing** | `/billing` | Plans, pricing intakes, quote requests — metadata/status only |
| **Settings** | `/settings` | Env badge, API host, language (HU default), **password change** |
| **System health** | `/system-health` | Acknowledge/escalate actions |
| **Release center** | `/release` | Email/push/observability readiness cards |
| **Notifications** | `/notifications` | In-app metadata list |
| **Audit logs** | `/audit-logs` | Metadata-only notices |

---

## 5. Known staging / UAT blockers

| # | Blocker | Severity | Status (post polish) |
|---|---------|----------|----------------------|
| 1 | **Evidence PDF clipboard copy** | **High** | **Fixed** — Share PDF via temp file + platform share sheet (`share_plus`) |
| 2 | **Staging backend not verified from dev machine** | **High** | **Open** — operator UAT on Render still required |
| 3 | **Public intakes discoverability** | **Medium** | **Improved** — dashboard quick action + More hub description |
| 4 | **Mock fallback if `API_BASE_URL` missing** | **Medium** | **Open** — release APK discipline |
| 5 | **Action Center dismiss persistence** | **Low** | **Clarified** — read-only notice; no server dismiss API |
| 6 | **No FCM/APNS push** | **Low** | Expected for staging |
| 7 | **`artifacts/` untracked locally** | **Low** | Local build output only |

---

## 5b. Implemented in UAT polish package (pending commit)

- Evidence PDF: `EvidencePdfShareService` + `EvidencePdfBytes` validation; button **Share PDF**
- Public intake: dashboard filled quick action; More hub module description; no-linked-thread / no-links cards
- Action Center: read-only aggregate notice; richer empty state
- Localization: HU + EN for all new strings
- Dependencies added: `path_provider`, `share_plus` (PDF share only)

---

## 6. Confusing UX areas

| Area | Issue |
|------|--------|
| **Evidence PDF** | ~~Button labeled download but clipboard~~ → **Share PDF** opens platform share sheet |
| **Public intakes vs communications** | Two related workflows; only communications on bottom nav; thread link on intake detail only when backend links thread |
| **Translation panel** | Provider-disabled state correct but easy to misread as broken feature |
| **Mock data badge** | Good safety signal — but operators must confirm **absent** on staging dashboard before UAT |
| **Settings vs Release center** | Readiness split across two screens — UAT asks to check both |

---

## 7. Missing / weak empty and error states

| Screen | Gap |
|--------|-----|
| Public intakes list | Has empty text when filtered list empty — OK |
| Customer communications | Has empty state — OK |
| Public intake links section | No explicit empty copy when **no** linked thread/quote/pricing — section still shows header only |
| Evidence package detail | Good not-found state when package id missing |
| Action Center snapshot error | Compact error text in summary strip only — could be easy to miss |
| Tablet wide layout | Rail navigation at `AppTheme.tabletBreakpoint` — limited dedicated tablet QA in tests |

---

## 8. Mobile / tablet layout risks

| Risk | Detail |
|------|--------|
| Phone bottom nav cap | Max 5 items — secondary modules crowded in More grid (2–3 columns) |
| Long HU strings | Module hub cards use `maxLines: 2` + ellipsis — verify on small phones |
| Dashboard density | Many async cards on one scroll — slow API makes page feel partial-loaded |
| Tablet | Side rail vs bottom nav switch — operator flows mostly tested on phone widths (`mobile_navigation_locale_test.dart`) |
| Dialogs on small screens | Support/public intake status dialogs — tested in widget tests; verify on physical device keyboard overlap |

---

## 9. API / staging config risks

| Risk | Mitigation |
|------|------------|
| Missing `API_BASE_URL` on staging APK | Use `prepare_staging_apk_artifact.dart` or documented `flutter build apk` defines |
| `APP_ENV=staging` without URL | Mock fallback **disabled** — app may show backend-not-configured |
| Wrong host / HTTP vs HTTPS | Settings shows host metadata only — no in-app URL editor (correct for security) |
| 401 session expiry | `ApiClient` unauthorized handler + login redirect — verify on device |
| Offline | `OfflineBanner` + connectivity provider — verify airplane-mode copy (UAT item) |
| Backend CORS / storage | **Backend** staging env must pass `check:staging-readiness` — not an app-only fix |

---

## 10. Recommended top 5 implementation tasks

| Priority | Task | Repo | Backend needed? |
|----------|------|------|----------------|
| **1** | **Real evidence PDF export on device** — save/open via platform share sheet or temp file + `open_file`/`share_plus`; update UAT copy | Admin app | No (uses existing download API) |
| **2** | **Staging UAT execution** — build release APK, run `ADMIN_APP_FIRST_STAGING_UAT_RUNBOOK.md`, file bugs from template | Admin + ops | Yes — Render deploy + smoke |
| **3** | **Public intake discoverability** — dashboard shortcut card and/or promote public intakes in primary nav vs docs alignment | Admin app | Optional (dashboard counts API) |
| **4** | **Public intake empty links state** — explicit “no linked thread yet” when `linkedCustomerCommunicationThreadId` null | Admin app | No |
| **5** | **Docs sync** — update `admin-app-current-status.md` + `ADMIN_APP_PRODUCTION_READINESS.md` module tables (public intake, customer comms); align UAT runbook with actual bottom nav | Admin docs | No |

### Lower priority (after UAT sign-off)

- Action Center dismiss/ack persistence (likely **backend** + app)
- Integration/widget tests against staging API (CI secret)
- FCM foundation
- Tablet-specific layout pass

---

## 11. Backend work required?

| For… | Backend changes? |
|------|------------------|
| Admin analyzer/tests/release checks | **No** |
| Evidence PDF download UX fix | **No** — bytes endpoint exists |
| Staging UAT | **Yes** — deploy, env, smoke, seed `super_admin` |
| Public intake → thread linking in UAT | **Maybe** — only if staging data lacks `linkedCustomerCommunicationThreadId` |
| Email delivery in staging | **Config only** — noop provider acceptable per UAT |
| Action Center dismiss | **Yes** — if persistence required |

**Summary:** Most **immediate polish is admin-app-only** except staging deployment and UAT data on the backend.

---

## 12. Verification commands (repeat before polish commits)

```powershell
cd vianexis_admin_app
flutter analyze
flutter test
dart run tool/admin_release_readiness_check.dart
dart run tool/admin_staging_build_check.dart
```

Staging APK (operator UAT only):

```powershell
dart run tool/prepare_staging_apk_artifact.dart --api-base-url=https://<RENDER_STAGING_API_HOST> --execute
```

---

## 13. Commit recommendation

**Not committed** — review this checkpoint first.

When approved, commit only `docs/admin-app-uat-polish-checkpoint.md` (and optional one-line pointer in `admin-app-current-status.md`).

Do **not** commit `artifacts/` unless following `ADMIN_APP_STAGING_APK_ARTIFACT.md` intentionally.

---

## 14. Maintenance

Update after: first staging UAT sign-off, evidence PDF UX fix, or primary-nav change. Record pass/fail and APK version in §1 table.
