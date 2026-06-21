# Customer Communication Delivery UAT

Admin app + backend UAT for outbound customer/admin communication delivery (Phases 68–73).

## Prerequisites

- Staging API with Phase 68+ backend deployed
- Admin APK with delivery history + resend UX
- `super_admin` or `support_admin` credentials
- Defaults: `EMAIL_PROVIDER=noop`, `EMAIL_DELIVERY_ENABLED=false`

## UAT steps

1. Open Customer Communications → select thread
2. Send reply with human confirmation → verify **skipped** delivery badge (provider disabled)
3. Verify audit trail in backend (optional: platform audit logs)
4. Open **Delivery history** section → filter skipped/failed/sent
5. Resend without reason → blocked in dialog
6. Resend with reason + confirmation → new skipped delivery attempt, `resendOfDeliveryId` linked
7. Timeline shows latest delivery status; multiple attempts notice if >1
8. Generate evidence package → PDF/summary includes delivery metadata
9. Evidence detail shows regeneration notice after resend
10. Release Center → email delivery card shows noop/disabled + allowlist counts (not values)
11. Confirm no external email sent in noop mode
12. Document SMTP staging allowlist test separately per `transdoc-backend/docs/SMTP_STAGING_TEST_RUNBOOK.md`

## Sign-off

| Tester | Date | Result | Notes |
|--------|------|--------|-------|
| | | | |
