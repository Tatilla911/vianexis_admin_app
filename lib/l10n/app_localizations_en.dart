// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'ViaNexis Admin';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navRegistrations => 'Registrations';

  @override
  String get navBulkOnboarding => 'Bulk onboarding';

  @override
  String get navSupport => 'Support';

  @override
  String get navSystemHealth => 'System health';

  @override
  String get navAuditLogs => 'Audit logs';

  @override
  String get navSettings => 'Settings';

  @override
  String get loginTitle => 'Platform sign in';

  @override
  String get loginSubtitle => 'Sign in with your ViaNexis platform account.';

  @override
  String get authEmail => 'Email';

  @override
  String get authPassword => 'Password';

  @override
  String get authSignIn => 'Sign in';

  @override
  String get authSigningIn => 'Signing in…';

  @override
  String get authLogout => 'Log out';

  @override
  String get authInvalidCredentials => 'Invalid email or password.';

  @override
  String get authNetworkError =>
      'Network error. Check your connection and try again.';

  @override
  String get authServerError => 'Server error. Try again later.';

  @override
  String get authForbiddenRole =>
      'This account is not authorized for the platform admin app.';

  @override
  String get authBackendNotConfigured =>
      'Backend connection is not configured yet.';

  @override
  String get authRequiredField => 'This field is required.';

  @override
  String get authShowPassword => 'Show password';

  @override
  String get authHidePassword => 'Hide password';

  @override
  String get loginEmailLabel => 'Email';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginSignInButton => 'Sign in';

  @override
  String get loginBackendNotConfigured =>
      'Backend connection is not configured yet.';

  @override
  String get dashboardTitle => 'Platform dashboard';

  @override
  String get dashboardPlaceholderBody =>
      'Operational summaries and platform metrics will appear here.';

  @override
  String get registrationsTitle => 'Registration applications';

  @override
  String get registrationsPlaceholderBody =>
      'Pending company onboarding applications will appear here.';

  @override
  String get registrationDetailTitle => 'Registration application';

  @override
  String get registrationDetailPlaceholderBody =>
      'Application metadata and review actions will appear here.';

  @override
  String get aiReviewsTitle => 'AI review summaries';

  @override
  String get aiReviewsPlaceholderBody =>
      'AI-assisted review recommendations will appear here.';

  @override
  String get supportTicketsTitle => 'Support tickets';

  @override
  String get supportTicketsPlaceholderBody =>
      'Support ticket metadata will appear here.';

  @override
  String get supportGrantsTitle => 'Support access grants';

  @override
  String get supportGrantsPlaceholderBody =>
      'Scoped support grant metadata will appear here.';

  @override
  String get systemHealthTitle => 'System health';

  @override
  String get systemHealthPlaceholderBody =>
      'Platform health diagnostics will appear here.';

  @override
  String get auditLogsTitle => 'Audit logs';

  @override
  String get auditLogsPlaceholderBody =>
      'Sanitized platform audit metadata will appear here.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsPlaceholderBody =>
      'Account and application preferences will appear here.';

  @override
  String get privacyMetadataOnlyBadge => 'Metadata only';

  @override
  String get privacyNoOperationalContent =>
      'Operational trip, document, and message content is not shown in this app.';

  @override
  String get roleSuperAdmin => 'Super admin';

  @override
  String get roleSupportAdmin => 'Support admin';

  @override
  String get roleOnboardingReviewer => 'Onboarding reviewer';

  @override
  String get roleBillingAdmin => 'Billing admin';

  @override
  String get errorGenericTitle => 'Something went wrong';

  @override
  String get errorGenericBody => 'An unexpected error occurred. Try again.';

  @override
  String get errorRetryButton => 'Retry';

  @override
  String get loadingLabel => 'Loading';

  @override
  String get statusHealthy => 'Healthy';

  @override
  String get statusDegraded => 'Degraded';

  @override
  String get statusUnknown => 'Unknown';

  @override
  String get settingsSignOut => 'Sign out';

  @override
  String settingsAppVersion(String version) {
    return 'Version $version';
  }

  @override
  String get validationEmailRequired => 'Email is required.';

  @override
  String get validationPasswordRequired => 'Password is required.';

  @override
  String get registrationFilterAll => 'All';

  @override
  String get registrationFilterPending => 'Pending';

  @override
  String get registrationFilterNeedsInfo => 'Needs info';

  @override
  String get registrationFilterAiReviewed => 'AI reviewed';

  @override
  String get registrationFilterApproved => 'Approved';

  @override
  String get registrationFilterRejected => 'Rejected';

  @override
  String get registrationFilterHighRisk => 'High risk';

  @override
  String get registrationStatusPending => 'Pending';

  @override
  String get registrationStatusNeedsInfo => 'Needs info';

  @override
  String get registrationStatusApproved => 'Approved';

  @override
  String get registrationStatusRejected => 'Rejected';

  @override
  String get registrationStatusCancelled => 'Cancelled';

  @override
  String get registrationStatusUnknown => 'Unknown';

  @override
  String get registrationRiskLow => 'Low risk';

  @override
  String get registrationRiskMedium => 'Medium risk';

  @override
  String get registrationRiskHigh => 'High risk';

  @override
  String get registrationRiskUnknown => 'Unknown risk';

  @override
  String get registrationTypeCompany => 'Company';

  @override
  String get registrationTypeUser => 'User';

  @override
  String get registrationTypeBulkOnboarding => 'Bulk onboarding';

  @override
  String get registrationSearchHint => 'Search company, VAT, country, or email';

  @override
  String get registrationListEmpty =>
      'No registration applications match your filters.';

  @override
  String get registrationListError =>
      'Could not load registration applications.';

  @override
  String get registrationDetailError =>
      'Could not load registration application details.';

  @override
  String get registrationMockDataBadge => 'Mock data';

  @override
  String registrationSubmittedAt(String date) {
    return 'Submitted $date';
  }

  @override
  String get registrationSectionCompany => 'Company';

  @override
  String get registrationSectionContact => 'Contact';

  @override
  String get registrationSectionStatus => 'Status';

  @override
  String get registrationSectionAiReview => 'AI review';

  @override
  String get registrationSectionDocuments => 'Documents';

  @override
  String get registrationFieldCompanyName => 'Company name';

  @override
  String get registrationFieldCountry => 'Country';

  @override
  String get registrationFieldVatNumber => 'VAT / tax number';

  @override
  String get registrationFieldRegistrationNumber => 'Registration number';

  @override
  String get registrationFieldContactName => 'Contact name';

  @override
  String get registrationFieldContactEmail => 'Contact email';

  @override
  String get registrationFieldSubmittedAt => 'Submitted';

  @override
  String get registrationFieldReviewedAt => 'Reviewed';

  @override
  String get registrationFieldReviewedBy => 'Reviewed by';

  @override
  String get registrationFieldAiRecommendation => 'AI recommendation';

  @override
  String get registrationFieldAiSummary => 'AI summary';

  @override
  String get registrationFieldMissingInformation => 'Missing information';

  @override
  String get registrationFieldDuplicateWarnings => 'Duplicate warnings';

  @override
  String get registrationFieldRiskFlags => 'Risk flags';

  @override
  String get registrationNoneReported => 'None reported';

  @override
  String get registrationDocumentsMetadataOnly =>
      'Document metadata only — file contents are not shown.';

  @override
  String get registrationDocumentsEmpty =>
      'No uploaded document metadata reported.';

  @override
  String get registrationActionApprove => 'Approve';

  @override
  String get registrationActionReject => 'Reject';

  @override
  String get registrationActionRequestInfo => 'Request information';

  @override
  String get registrationDecisionApproveTitle => 'Approve registration';

  @override
  String get registrationDecisionRejectTitle => 'Reject registration';

  @override
  String get registrationDecisionRequestInfoTitle => 'Request more information';

  @override
  String get registrationDecisionApproveBody =>
      'Confirm approval of this onboarding application.';

  @override
  String get registrationDecisionAuditNotice =>
      'This action will be recorded in the platform audit log.';

  @override
  String get registrationDecisionNotesLabel => 'Review notes';

  @override
  String get registrationDecisionNotesRequired =>
      'Enter at least 3 characters.';

  @override
  String get registrationDecisionCancel => 'Cancel';

  @override
  String get registrationDecisionApproveConfirm => 'Approve';

  @override
  String get registrationDecisionRejectConfirm => 'Reject';

  @override
  String get registrationDecisionRequestInfoConfirm => 'Send request';

  @override
  String get registrationDecisionSuccess => 'Registration decision saved.';

  @override
  String get registrationDecisionError =>
      'Could not save registration decision.';

  @override
  String get systemHealthLoadError => 'Could not load system health data.';

  @override
  String get systemHealthActionUnavailable =>
      'This action is not available on the connected backend yet.';

  @override
  String get systemHealthMockDataBadge => 'Mock data';

  @override
  String get systemHealthServicesTitle => 'Service status';

  @override
  String get systemHealthEventsTitle => 'Health events';

  @override
  String get systemHealthEventsEmpty => 'No health events match your filters.';

  @override
  String get systemHealthEventDetailTitle => 'Health event';

  @override
  String systemHealthEventStartedAt(String date) {
    return 'Started $date';
  }

  @override
  String get systemHealthOpenModule => 'Open system health';

  @override
  String systemHealthOverallStatusLabel(String status) {
    return 'Overall status: $status';
  }

  @override
  String systemHealthLastUpdated(String date) {
    return 'Last updated $date';
  }

  @override
  String get systemHealthMetricHealthyServices => 'Healthy services';

  @override
  String get systemHealthMetricWarningServices => 'Warning services';

  @override
  String get systemHealthMetricCriticalServices => 'Critical services';

  @override
  String get systemHealthMetricCriticalEvents => 'Critical events';

  @override
  String get systemHealthMetricWarningEvents => 'Warning events';

  @override
  String get systemHealthMetricFailedJobs => 'Failed jobs';

  @override
  String get systemHealthSeverityInfo => 'Info';

  @override
  String get systemHealthSeverityWarning => 'Warning';

  @override
  String get systemHealthSeverityCritical => 'Critical';

  @override
  String get systemHealthSeverityUnknown => 'Unknown';

  @override
  String get systemHealthOverallHealthy => 'Healthy';

  @override
  String get systemHealthOverallDegraded => 'Degraded';

  @override
  String get systemHealthOverallCritical => 'Critical';

  @override
  String get systemHealthOverallUnknown => 'Unknown';

  @override
  String get systemHealthFilterAll => 'All';

  @override
  String get systemHealthFilterCritical => 'Critical';

  @override
  String get systemHealthFilterWarning => 'Warning';

  @override
  String get systemHealthFilterOpen => 'Open';

  @override
  String get systemHealthFilterAcknowledged => 'Acknowledged';

  @override
  String get systemHealthFilterResolved => 'Resolved';

  @override
  String get systemHealthFilterTenantImpacting => 'Tenant impacting';

  @override
  String get systemHealthEventStatusOpen => 'Open';

  @override
  String get systemHealthEventStatusAcknowledged => 'Acknowledged';

  @override
  String get systemHealthEventStatusInvestigating => 'Investigating';

  @override
  String get systemHealthEventStatusResolved => 'Resolved';

  @override
  String get systemHealthEventStatusUnknown => 'Unknown';

  @override
  String get systemHealthImpactNone => 'No tenant impact';

  @override
  String get systemHealthImpactSingleTenant => 'Single tenant';

  @override
  String get systemHealthImpactMultipleTenants => 'Multiple tenants';

  @override
  String get systemHealthImpactPlatformWide => 'Platform wide';

  @override
  String get systemHealthImpactUnknown => 'Unknown impact';

  @override
  String get systemHealthServiceBackendApi => 'Backend API';

  @override
  String get systemHealthServiceDatabase => 'Database';

  @override
  String get systemHealthServiceDocumentStorage => 'Document storage';

  @override
  String get systemHealthServiceBackgroundWorkers => 'Background workers';

  @override
  String get systemHealthServiceAiOcrWorkers => 'AI / OCR workers';

  @override
  String get systemHealthServiceTranslationService => 'Translation service';

  @override
  String get systemHealthServiceEmailService => 'Email service';

  @override
  String get systemHealthServicePushNotificationService =>
      'Push notification service';

  @override
  String get systemHealthServiceQueueSystem => 'Queue system';

  @override
  String get systemHealthServiceAuthService => 'Auth service';

  @override
  String get systemHealthAiDiagnosticTitle => 'AI diagnostic summary';

  @override
  String get systemHealthAiAdvisoryOnly =>
      'Advisory only — not an automatic repair instruction.';

  @override
  String get systemHealthRecommendedAction => 'Recommended action';

  @override
  String get systemHealthActionAcknowledgeTitle => 'Acknowledge event';

  @override
  String get systemHealthActionEscalateTitle => 'Escalate event';

  @override
  String get systemHealthActionAuditNotice =>
      'This action will be recorded in the platform audit log.';

  @override
  String get systemHealthActionNoAutoRepair =>
      'No automatic production repair will be performed.';

  @override
  String get systemHealthActionNoteLabel => 'Escalation note';

  @override
  String get systemHealthActionNoteRequired => 'Enter at least 3 characters.';

  @override
  String get systemHealthActionAcknowledgeBody =>
      'Confirm acknowledgement of this health event.';

  @override
  String get systemHealthActionCancel => 'Cancel';

  @override
  String get systemHealthActionAcknowledgeConfirm => 'Acknowledge';

  @override
  String get systemHealthActionEscalateConfirm => 'Escalate';

  @override
  String get systemHealthActionAcknowledge => 'Acknowledge';

  @override
  String get systemHealthActionEscalate => 'Escalate to support';

  @override
  String get systemHealthActionSuccess => 'Health action saved.';

  @override
  String get systemHealthActionError => 'Could not save health action.';

  @override
  String get systemHealthCreateTicketDisabled =>
      'Create support ticket (coming soon)';

  @override
  String get systemHealthPrivacyNotice =>
      'Metadata only — no tenant operational trip, document, or message content is shown.';

  @override
  String get systemHealthFieldServiceName => 'Service';

  @override
  String get systemHealthFieldTenantImpact => 'Tenant impact';

  @override
  String get systemHealthFieldAffectedCompany => 'Affected company';

  @override
  String get systemHealthFieldStartedAt => 'Started';

  @override
  String get systemHealthFieldLastSeenAt => 'Last seen';

  @override
  String get systemHealthFieldResolvedAt => 'Resolved';

  @override
  String get systemHealthFieldFailedJobs => 'Failed jobs';

  @override
  String get systemHealthFieldCorrelationId => 'Correlation ID';

  @override
  String get systemHealthCreateTicket => 'Create support ticket';

  @override
  String get supportLoadError => 'Could not load support data.';

  @override
  String get supportActionUnavailable =>
      'This support action is not available on the connected backend yet.';

  @override
  String get supportActionError => 'Could not save support action.';

  @override
  String get supportActionSuccess => 'Support action saved.';

  @override
  String get supportMockDataBadge => 'Mock data';

  @override
  String get supportOpenModule => 'Open support module';

  @override
  String get supportPrivacyNotice =>
      'Metadata only — no tenant operational trip, document, or message content is shown by default.';

  @override
  String get supportActionAuditNotice =>
      'This action will be recorded in the platform audit log.';

  @override
  String get supportActionNoteLabel => 'Note';

  @override
  String get supportActionNoteRequired => 'Enter at least 3 characters.';

  @override
  String get supportActionCancel => 'Cancel';

  @override
  String get supportTicketSearchHint =>
      'Search company, title, or requester email';

  @override
  String get supportTicketListEmpty => 'No support tickets match your filters.';

  @override
  String supportTicketLastActivity(String date) {
    return 'Last activity $date';
  }

  @override
  String get supportTicketDetailTitle => 'Support ticket';

  @override
  String get supportGrantDetailTitle => 'Support access grant';

  @override
  String get supportGrantSearchHint => 'Search company, scope id, or requester';

  @override
  String get supportGrantListEmpty =>
      'No support access grants match your filters.';

  @override
  String supportGrantScopeIdLabel(String id) {
    return 'Scope ID: $id';
  }

  @override
  String supportGrantExpiresAt(String date) {
    return 'Expires $date';
  }

  @override
  String get supportSummaryTitle => 'Support overview';

  @override
  String get supportSummaryOpenTickets => 'Open tickets';

  @override
  String get supportSummaryUrgentCritical => 'Urgent / critical';

  @override
  String get supportSummaryActiveGrants => 'Active grants';

  @override
  String supportSummaryLastUpdated(String date) {
    return 'Last updated $date';
  }

  @override
  String get supportTicketCreateSuccess => 'Support ticket created.';

  @override
  String get supportTicketFilterAll => 'All';

  @override
  String get supportTicketFilterOpen => 'Open';

  @override
  String get supportTicketFilterUrgent => 'Urgent';

  @override
  String get supportTicketFilterCritical => 'Critical';

  @override
  String get supportTicketFilterSystemHealth => 'System health';

  @override
  String get supportTicketFilterWaitingForCustomer => 'Waiting for customer';

  @override
  String get supportTicketFilterResolved => 'Resolved';

  @override
  String get supportGrantFilterAll => 'All';

  @override
  String get supportGrantFilterPending => 'Pending';

  @override
  String get supportGrantFilterActive => 'Active';

  @override
  String get supportGrantFilterExpired => 'Expired';

  @override
  String get supportGrantFilterRevoked => 'Revoked';

  @override
  String get supportTicketStatusOpen => 'Open';

  @override
  String get supportTicketStatusAcknowledged => 'Acknowledged';

  @override
  String get supportTicketStatusInvestigating => 'Investigating';

  @override
  String get supportTicketStatusWaitingForCustomer => 'Waiting for customer';

  @override
  String get supportTicketStatusResolved => 'Resolved';

  @override
  String get supportTicketStatusClosed => 'Closed';

  @override
  String get supportTicketStatusUnknown => 'Unknown';

  @override
  String get supportTicketPriorityLow => 'Low';

  @override
  String get supportTicketPriorityNormal => 'Normal';

  @override
  String get supportTicketPriorityHigh => 'High';

  @override
  String get supportTicketPriorityUrgent => 'Urgent';

  @override
  String get supportTicketPriorityCritical => 'Critical';

  @override
  String get supportTicketPriorityUnknown => 'Unknown';

  @override
  String get supportTicketCategoryRegistration => 'Registration';

  @override
  String get supportTicketCategorySystemHealth => 'System health';

  @override
  String get supportTicketCategoryUploadIssue => 'Upload issue';

  @override
  String get supportTicketCategoryBilling => 'Billing';

  @override
  String get supportTicketCategoryAccess => 'Access';

  @override
  String get supportTicketCategoryIntegration => 'Integration';

  @override
  String get supportTicketCategoryOther => 'Other';

  @override
  String get supportTicketCategoryUnknown => 'Unknown';

  @override
  String get supportGrantStatusPending => 'Pending';

  @override
  String get supportGrantStatusActive => 'Active';

  @override
  String get supportGrantStatusExpired => 'Expired';

  @override
  String get supportGrantStatusRevoked => 'Revoked';

  @override
  String get supportGrantStatusDenied => 'Denied';

  @override
  String get supportGrantStatusUnknown => 'Unknown';

  @override
  String get supportScopeCompanyMetadata => 'Company metadata';

  @override
  String get supportScopeSpecificTrip => 'Specific trip';

  @override
  String get supportScopeSpecificDocumentIssue => 'Specific document issue';

  @override
  String get supportScopeUploadQueueIssue => 'Upload queue issue';

  @override
  String get supportScopeSystemHealthIssue => 'System health issue';

  @override
  String get supportScopeIntegrationIssue => 'Integration issue';

  @override
  String get supportScopeBillingIssue => 'Billing issue';

  @override
  String get supportScopeUnknown => 'Unknown scope';

  @override
  String get supportGrantWarningTitle => 'Scoped support access';

  @override
  String get supportGrantWarningBody =>
      'Grants are temporary, scoped, and audit logged. No broad unlimited tenant access.';

  @override
  String get supportGrantAuditNotice =>
      'This grants temporary scoped support access and will be audit logged.';

  @override
  String get supportGrantCreateTitle => 'Create support access grant';

  @override
  String get supportGrantCreateWarning =>
      'This grants temporary scoped support access and will be audit logged.';

  @override
  String get supportGrantCreateConfirm => 'Create grant';

  @override
  String get supportGrantCreateSuccess => 'Support access grant created.';

  @override
  String supportGrantCompanyLabel(String name) {
    return 'Company: $name';
  }

  @override
  String get supportGrantScopeTypeLabel => 'Scope type';

  @override
  String get supportGrantScopeIdFieldLabel => 'Scope ID';

  @override
  String get supportGrantScopeIdRequired =>
      'Scope ID is required for this scope type.';

  @override
  String get supportGrantReasonLabel => 'Reason';

  @override
  String get supportGrantReasonRequired => 'Enter at least 3 characters.';

  @override
  String get supportGrantExpiryRequired =>
      'Choose a valid expiry within 24 hours.';

  @override
  String get supportGrantBroadAccessRejected =>
      'Broad or document access is not allowed.';

  @override
  String get supportGrantExpiryLabel => 'Expiry';

  @override
  String get supportGrantExpiryTwoHours => '2 hours';

  @override
  String get supportGrantExpiryTwentyFourHours => '24 hours';

  @override
  String get supportGrantRevokeTitle => 'Revoke support access grant';

  @override
  String get supportGrantRevokeNoteLabel => 'Revocation reason';

  @override
  String get supportGrantRevokeConfirm => 'Revoke grant';

  @override
  String get supportGrantRevokeSuccess => 'Support access grant revoked.';

  @override
  String get supportGrantActionRevoke => 'Revoke grant';

  @override
  String get supportGrantFieldCompany => 'Company';

  @override
  String get supportGrantFieldScopeId => 'Scope ID';

  @override
  String get supportGrantFieldReason => 'Reason';

  @override
  String get supportGrantFieldAllowedCategories => 'Allowed data categories';

  @override
  String get supportGrantFieldExcludesDocuments =>
      'Excludes sensitive documents';

  @override
  String get supportGrantFieldCreatedAt => 'Created';

  @override
  String get supportGrantFieldExpiresAt => 'Expires';

  @override
  String get supportGrantFieldRevokedAt => 'Revoked';

  @override
  String get supportGrantFieldApprovedBy => 'Approved by';

  @override
  String get supportGrantFieldAuditLogId => 'Audit log ID';

  @override
  String get supportGrantYes => 'Yes';

  @override
  String get supportGrantNo => 'No';

  @override
  String get supportTicketFieldCompany => 'Company';

  @override
  String get supportTicketFieldRequester => 'Requester';

  @override
  String get supportTicketFieldCategory => 'Category';

  @override
  String get supportTicketFieldSummary => 'Summary';

  @override
  String get supportTicketFieldCreatedAt => 'Created';

  @override
  String get supportTicketFieldUpdatedAt => 'Updated';

  @override
  String get supportTicketFieldLastActivity => 'Last activity';

  @override
  String get supportTicketFieldLinkedHealthEvent => 'Linked health event';

  @override
  String get supportTicketFieldSupportGrant => 'Support access grant';

  @override
  String get supportTicketActionAcknowledge => 'Acknowledge';

  @override
  String get supportTicketActionClose => 'Close ticket';

  @override
  String get supportTicketActionCreateGrant => 'Create support access grant';

  @override
  String get supportTicketActionAcknowledgeTitle => 'Acknowledge ticket';

  @override
  String get supportTicketActionCloseTitle => 'Close ticket';

  @override
  String get supportTicketActionAcknowledgeBody =>
      'Confirm acknowledgement of this support ticket.';

  @override
  String get supportTicketActionAcknowledgeConfirm => 'Acknowledge';

  @override
  String get supportTicketActionCloseConfirm => 'Close';

  @override
  String get auditLogLoadError => 'Could not load audit logs.';

  @override
  String get auditLogMockDataBadge => 'Mock data';

  @override
  String get auditLogOpenModule => 'Open audit logs';

  @override
  String get auditLogSearchHint =>
      'Search actor email, company, target id, or correlation id';

  @override
  String get auditLogListEmpty => 'No audit logs match your filters.';

  @override
  String get auditLogDateRangeComingSoon => 'Date range filter (coming soon)';

  @override
  String auditLogTimestampLabel(String date) {
    return '$date';
  }

  @override
  String get auditLogDetailTitle => 'Audit log entry';

  @override
  String get auditLogPrivacyNotice =>
      'Metadata only — no tenant operational trip, document, or message content is shown.';

  @override
  String get auditLogExportDisabled => 'Export audit log (coming soon)';

  @override
  String get auditLogSummaryTitle => 'Recent audit activity';

  @override
  String get auditLogSummaryLastCritical => 'Last critical event';

  @override
  String get auditLogSummaryNoCritical => 'No critical events';

  @override
  String get auditLogSummaryFailedDenied => 'Failed / denied';

  @override
  String get auditLogSummaryRecentActions => 'Recent platform actions';

  @override
  String auditLogSummaryLastUpdated(String date) {
    return 'Last updated $date';
  }

  @override
  String get auditLogFilterAll => 'All';

  @override
  String get auditLogFilterCritical => 'Critical';

  @override
  String get auditLogFilterWarning => 'Warning';

  @override
  String get auditLogFilterFailures => 'Failures';

  @override
  String get auditLogFilterDenied => 'Denied';

  @override
  String get auditLogFilterRegistration => 'Registration';

  @override
  String get auditLogFilterSupportAccess => 'Support access';

  @override
  String get auditLogFilterSystemHealth => 'System health';

  @override
  String get auditLogFilterSecurity => 'Security';

  @override
  String get auditLogResultSuccess => 'Success';

  @override
  String get auditLogResultFailure => 'Failure';

  @override
  String get auditLogResultDenied => 'Denied';

  @override
  String get auditLogResultPartial => 'Partial';

  @override
  String get auditLogResultUnknown => 'Unknown';

  @override
  String get auditLogSeverityInfo => 'Info';

  @override
  String get auditLogSeverityWarning => 'Warning';

  @override
  String get auditLogSeverityCritical => 'Critical';

  @override
  String get auditLogSeverityUnknown => 'Unknown';

  @override
  String get auditLogActionLogin => 'Login';

  @override
  String get auditLogActionLogout => 'Logout';

  @override
  String get auditLogActionLoginFailed => 'Login failed';

  @override
  String get auditLogActionRegistrationApproved => 'Registration approved';

  @override
  String get auditLogActionRegistrationRejected => 'Registration rejected';

  @override
  String get auditLogActionRegistrationInfoRequested =>
      'Registration info requested';

  @override
  String get auditLogActionSupportTicketAcknowledged =>
      'Support ticket acknowledged';

  @override
  String get auditLogActionSupportTicketClosed => 'Support ticket closed';

  @override
  String get auditLogActionSupportAccessGranted => 'Support access granted';

  @override
  String get auditLogActionSupportAccessRevoked => 'Support access revoked';

  @override
  String get auditLogActionSystemHealthAcknowledged =>
      'System health acknowledged';

  @override
  String get auditLogActionSystemHealthEscalated => 'System health escalated';

  @override
  String get auditLogActionBillingUpdated => 'Billing updated';

  @override
  String get auditLogActionRoleChanged => 'Role changed';

  @override
  String get auditLogActionPermissionDenied => 'Permission denied';

  @override
  String get auditLogActionExportRequested => 'Export requested';

  @override
  String get auditLogActionApiKeyCreated => 'API key created';

  @override
  String get auditLogActionApiKeyRevoked => 'API key revoked';

  @override
  String get auditLogActionUnknown => 'Unknown action';

  @override
  String get auditLogFieldTimestamp => 'Timestamp';

  @override
  String get auditLogFieldActor => 'Actor';

  @override
  String get auditLogFieldActorRole => 'Actor role';

  @override
  String get auditLogFieldTargetType => 'Target type';

  @override
  String get auditLogFieldTargetId => 'Target ID';

  @override
  String get auditLogFieldCompany => 'Company';

  @override
  String get auditLogFieldTenantId => 'Tenant ID';

  @override
  String get auditLogFieldReason => 'Reason';

  @override
  String get auditLogFieldNote => 'Note';

  @override
  String get auditLogFieldIpAddress => 'IP address';

  @override
  String get auditLogFieldDeviceLabel => 'Device';

  @override
  String get auditLogFieldCorrelationId => 'Correlation ID';

  @override
  String get auditLogFieldRegistrationApplicationId =>
      'Registration application ID';

  @override
  String get auditLogFieldSupportAccessGrantId => 'Support access grant ID';

  @override
  String get auditLogFieldSystemHealthEventId => 'System health event ID';

  @override
  String get auditLogDetailLoaded => 'Audit log detail loaded.';

  @override
  String get supportTicketAcknowledgedSuccess => 'Ticket acknowledged.';

  @override
  String get supportTicketClosedSuccess => 'Ticket closed.';

  @override
  String get supportGrantRevokedSuccess => 'Grant revoked.';

  @override
  String get systemHealthEventAcknowledgedSuccess =>
      'System health event acknowledged.';

  @override
  String get systemHealthEventEscalatedSuccess =>
      'System health event escalated.';

  @override
  String get backendActionUnavailable =>
      'Action not available on this backend yet.';

  @override
  String get bulkOnboardingTitle => 'Bulk onboarding';

  @override
  String get bulkOnboardingDetailTitle => 'Bulk onboarding job';

  @override
  String get bulkOnboardingRowsTitle => 'Import rows';

  @override
  String get bulkOnboardingMockDataBadge => 'Mock data';

  @override
  String get bulkOnboardingSearchHint => 'Search by company, file, or job ID';

  @override
  String get bulkOnboardingListEmpty =>
      'No bulk onboarding jobs match your filters.';

  @override
  String get bulkOnboardingListError => 'Could not load bulk onboarding jobs.';

  @override
  String get bulkOnboardingDetailError => 'Could not load bulk onboarding job.';

  @override
  String get bulkOnboardingRowsError => 'Could not load import rows.';

  @override
  String get bulkOnboardingRowsEmpty => 'No rows match this filter.';

  @override
  String get bulkOnboardingPrivacyNotice =>
      'Metadata only. Tenant operational trip, document, and message content is never shown here.';

  @override
  String get bulkOnboardingOpenModule => 'Open bulk onboarding';

  @override
  String get bulkOnboardingOpenRows => 'View rows';

  @override
  String get bulkOnboardingNoSourceFile => 'No source file name';

  @override
  String get bulkOnboardingFieldSourceFile => 'Source file';

  @override
  String get bulkOnboardingDashboardTitle => 'Bulk onboarding';

  @override
  String get bulkOnboardingDashboardWaitingReview => 'Waiting for review';

  @override
  String get bulkOnboardingDashboardHighRisk => 'High-risk jobs';

  @override
  String get bulkOnboardingDashboardInvalidRows => 'Invalid rows';

  @override
  String get bulkOnboardingDashboardProcessing => 'Processing jobs';

  @override
  String get bulkOnboardingFilterAll => 'All';

  @override
  String get bulkOnboardingFilterReadyForReview => 'Ready for review';

  @override
  String get bulkOnboardingFilterValidationFailed => 'Validation failed';

  @override
  String get bulkOnboardingFilterProcessing => 'Processing';

  @override
  String get bulkOnboardingFilterCompleted => 'Completed';

  @override
  String get bulkOnboardingFilterRejected => 'Rejected';

  @override
  String get bulkOnboardingFilterHighRisk => 'High risk';

  @override
  String get bulkOnboardingStatusDraft => 'Draft';

  @override
  String get bulkOnboardingStatusUploaded => 'Uploaded';

  @override
  String get bulkOnboardingStatusValidating => 'Validating';

  @override
  String get bulkOnboardingStatusValidationFailed => 'Validation failed';

  @override
  String get bulkOnboardingStatusReadyForReview => 'Ready for review';

  @override
  String get bulkOnboardingStatusApprovedForProcessing =>
      'Approved for processing';

  @override
  String get bulkOnboardingStatusProcessing => 'Processing';

  @override
  String get bulkOnboardingStatusPartiallyCompleted => 'Partially completed';

  @override
  String get bulkOnboardingStatusCompleted => 'Completed';

  @override
  String get bulkOnboardingStatusRejected => 'Rejected';

  @override
  String get bulkOnboardingStatusCancelled => 'Cancelled';

  @override
  String get bulkOnboardingStatusUnknown => 'Unknown';

  @override
  String get bulkOnboardingRowStatusPending => 'Pending';

  @override
  String get bulkOnboardingRowStatusValid => 'Valid';

  @override
  String get bulkOnboardingRowStatusWarning => 'Warning';

  @override
  String get bulkOnboardingRowStatusInvalid => 'Invalid';

  @override
  String get bulkOnboardingRowStatusDuplicate => 'Duplicate';

  @override
  String get bulkOnboardingRowStatusApproved => 'Approved';

  @override
  String get bulkOnboardingRowStatusSkipped => 'Skipped';

  @override
  String get bulkOnboardingRowStatusProcessed => 'Processed';

  @override
  String get bulkOnboardingRowStatusFailed => 'Failed';

  @override
  String get bulkOnboardingRowStatusUnknown => 'Unknown';

  @override
  String get bulkOnboardingTypeCompanyUsers => 'Company users';

  @override
  String get bulkOnboardingTypeDrivers => 'Drivers';

  @override
  String get bulkOnboardingTypeVehicles => 'Vehicles';

  @override
  String get bulkOnboardingTypeTrailers => 'Trailers';

  @override
  String get bulkOnboardingTypeMixedCompanyImport => 'Mixed company import';

  @override
  String get bulkOnboardingTypeUnknown => 'Unknown type';

  @override
  String get bulkOnboardingRiskLow => 'Low risk';

  @override
  String get bulkOnboardingRiskMedium => 'Medium risk';

  @override
  String get bulkOnboardingRiskHigh => 'High risk';

  @override
  String get bulkOnboardingRiskUnknown => 'Unknown risk';

  @override
  String bulkOnboardingMetricTotalRows(String count) {
    return 'Total rows: $count';
  }

  @override
  String bulkOnboardingMetricValidRows(String count) {
    return 'Valid: $count';
  }

  @override
  String bulkOnboardingMetricWarningRows(String count) {
    return 'Warnings: $count';
  }

  @override
  String bulkOnboardingMetricInvalidRows(String count) {
    return 'Invalid: $count';
  }

  @override
  String bulkOnboardingMetricDuplicateRows(String count) {
    return 'Duplicates: $count';
  }

  @override
  String get bulkOnboardingValidationSummaryTitle => 'Validation summary';

  @override
  String get bulkOnboardingValidationErrors => 'Validation errors';

  @override
  String bulkOnboardingDuplicateReason(String reason) {
    return 'Duplicate: $reason';
  }

  @override
  String get bulkOnboardingAiReviewTitle => 'AI review (advisory)';

  @override
  String get bulkOnboardingAiAdvisoryNotice =>
      'Recommendations are advisory only. Human approval is required.';

  @override
  String bulkOnboardingRecommendedAction(String action) {
    return 'Recommended action: $action';
  }

  @override
  String get bulkOnboardingRowFilterAll => 'All rows';

  @override
  String get bulkOnboardingRowFilterInvalid => 'Invalid';

  @override
  String get bulkOnboardingRowFilterWarning => 'Warnings';

  @override
  String get bulkOnboardingRowFilterDuplicate => 'Duplicates';

  @override
  String get bulkOnboardingActionValidate => 'Validate';

  @override
  String get bulkOnboardingActionApprove => 'Approve';

  @override
  String get bulkOnboardingActionReject => 'Reject';

  @override
  String get bulkOnboardingActionCancel => 'Cancel';

  @override
  String get bulkOnboardingActionProcess => 'Process';

  @override
  String get bulkOnboardingProcessDisabled => 'Processing unavailable';

  @override
  String get bulkOnboardingProcessUnavailable =>
      'Processing is not available for this job.';

  @override
  String get bulkOnboardingActionUnavailable =>
      'This action is unavailable right now.';

  @override
  String get bulkOnboardingActionSuccess => 'Action recorded and audit logged.';

  @override
  String get bulkOnboardingActionAuditNotice =>
      'This action is audit logged and may affect tenant onboarding.';

  @override
  String get bulkOnboardingActionNoteLabel => 'Reason / note';

  @override
  String get bulkOnboardingActionOptionalNoteLabel => 'Optional note';

  @override
  String get bulkOnboardingActionNoteRequired => 'A reason is required.';

  @override
  String get bulkOnboardingActionConfirmRequired =>
      'Explicit confirmation is required.';

  @override
  String get bulkOnboardingActionExplicitConfirm =>
      'I confirm this sensitive processing action.';

  @override
  String get bulkOnboardingActionDismiss => 'Dismiss';

  @override
  String get bulkOnboardingActionValidateTitle => 'Validate import';

  @override
  String get bulkOnboardingActionApproveTitle => 'Approve for processing';

  @override
  String get bulkOnboardingActionRejectTitle => 'Reject import job';

  @override
  String get bulkOnboardingActionCancelTitle => 'Cancel import job';

  @override
  String get bulkOnboardingActionProcessTitle => 'Process approved import';

  @override
  String get bulkOnboardingActionValidateConfirm => 'Run validation';

  @override
  String get bulkOnboardingActionApproveConfirm => 'Approve';

  @override
  String get bulkOnboardingActionRejectConfirm => 'Reject';

  @override
  String get bulkOnboardingActionCancelConfirm => 'Cancel job';

  @override
  String get bulkOnboardingActionProcessConfirm => 'Start processing';

  @override
  String get bulkOnboardingUploadCsv => 'Upload CSV';

  @override
  String get bulkOnboardingChooseFile => 'Choose file';

  @override
  String bulkOnboardingSelectedFile(String name) {
    return 'Selected file: $name';
  }

  @override
  String bulkOnboardingFileSize(String size) {
    return 'File size: $size';
  }

  @override
  String get bulkOnboardingUploadPreviewTitle => 'Upload preview';

  @override
  String get bulkOnboardingImportTemplate => 'Import template';

  @override
  String get bulkOnboardingDownloadTemplate => 'Download template';

  @override
  String get bulkOnboardingTemplateCopied => 'Template copied to clipboard.';

  @override
  String get bulkOnboardingCsvOnlyNotice =>
      'CSV only in this phase. Excel import coming later.';

  @override
  String get bulkOnboardingExcelComingLater =>
      'Excel import coming later. Please upload CSV for now.';

  @override
  String get bulkOnboardingNoRealProvisioningNotice =>
      'No users, vehicles, trailers, or invitations are created by this upload.';

  @override
  String get bulkOnboardingHumanApprovalNotice =>
      'Human approval is required before future processing.';

  @override
  String get bulkOnboardingValidationCompleted => 'Validation completed.';

  @override
  String get bulkOnboardingRowsParsed => 'Rows parsed.';

  @override
  String get bulkOnboardingUploadSuccessful => 'Upload successful.';

  @override
  String get bulkOnboardingUploadFailed => 'Upload failed.';

  @override
  String get bulkOnboardingUnsupportedFileType => 'Unsupported file type.';

  @override
  String get bulkOnboardingTooManyRows => 'Too many rows in file.';

  @override
  String get bulkOnboardingEmptyFile => 'The selected file is empty.';

  @override
  String get bulkOnboardingFileRequired => 'A CSV file is required.';

  @override
  String get bulkOnboardingUploadTypeRequired => 'Import type is required.';

  @override
  String get bulkOnboardingUploadTypeLabel => 'Import type';

  @override
  String get bulkOnboardingUploadCompanyIdLabel =>
      'Company ID (optional until approval)';

  @override
  String get bulkOnboardingUploadCompanyNameLabel => 'Company name';

  @override
  String get bulkOnboardingUploadNoteLabel => 'Admin note (optional)';

  @override
  String get bulkOnboardingUploadProgress => 'Uploading…';

  @override
  String get bulkOnboardingUploadForbidden =>
      'You do not have permission to upload imports.';

  @override
  String get bulkOnboardingMockUploadBadge => 'Mock upload preview';

  @override
  String get bulkOnboardingRowsSearchHint => 'Search rows';

  @override
  String get bulkOnboardingRowFilterValid => 'Valid';

  @override
  String get bulkOnboardingRowFilterProcessed => 'Processed';

  @override
  String get bulkOnboardingRowFilterFailed => 'Failed';

  @override
  String get bulkOnboardingRowFilterSkipped => 'Skipped';

  @override
  String get bulkOnboardingRowDetailTitle => 'Import row';

  @override
  String get bulkOnboardingRowDetailError =>
      'Could not load import row details.';

  @override
  String get bulkOnboardingRowOriginalValuesTitle => 'Original imported values';

  @override
  String get bulkOnboardingRowCorrectedValuesTitle => 'Corrected values';

  @override
  String bulkOnboardingRowLastValidatedAt(String date) {
    return 'Last validated: $date';
  }

  @override
  String bulkOnboardingJobLastValidatedAt(String date) {
    return 'Job last validated: $date';
  }

  @override
  String get bulkOnboardingRowCorrectionTitle => 'Correct import row';

  @override
  String get bulkOnboardingRowCorrectionNotice =>
      'Update invalid fields. Original imported values are preserved for audit.';

  @override
  String get bulkOnboardingRowCorrectionNoteLabel =>
      'Correction note (optional)';

  @override
  String get bulkOnboardingRowCorrectionConfirm => 'Save correction';

  @override
  String get bulkOnboardingRowCorrectionAction => 'Correct row';

  @override
  String get bulkOnboardingRowCorrectionFieldRequired =>
      'Provide at least one corrected field.';

  @override
  String get bulkOnboardingRowFieldName => 'Name';

  @override
  String get bulkOnboardingRowFieldEmail => 'Email';

  @override
  String get bulkOnboardingRowFieldPhone => 'Phone';

  @override
  String get bulkOnboardingRowFieldCountry => 'Country';

  @override
  String get bulkOnboardingRowFieldRole => 'Role';

  @override
  String get bulkOnboardingRowFieldVehiclePlate => 'Vehicle plate';

  @override
  String get bulkOnboardingRowFieldTrailerPlate => 'Trailer plate';

  @override
  String get bulkOnboardingRowSkipTitle => 'Skip import row';

  @override
  String get bulkOnboardingRowSkipNotice =>
      'Skipped rows are excluded from validation counts and processing.';

  @override
  String get bulkOnboardingRowSkipReasonLabel => 'Skip reason';

  @override
  String get bulkOnboardingRowSkipReasonRequired =>
      'A skip reason is required.';

  @override
  String get bulkOnboardingRowSkipConfirm => 'Skip row';

  @override
  String get bulkOnboardingRowSkipAction => 'Skip row';

  @override
  String get bulkOnboardingRowRevalidateAction => 'Revalidate row';

  @override
  String get bulkOnboardingJobRevalidateAction => 'Revalidate job';

  @override
  String get bulkOnboardingJobRevalidateSuccess =>
      'Job revalidation completed.';

  @override
  String get bulkOnboardingRowActionAuditNotice =>
      'This action is audit logged. No accounts or assets are created.';

  @override
  String get bulkOnboardingRowActionSuccess => 'Row updated successfully.';

  @override
  String get bulkOnboardingRowActionUnavailable => 'Row action is unavailable.';

  @override
  String bulkOnboardingMetricSkippedRows(String count) {
    return 'Skipped: $count';
  }

  @override
  String get bulkOnboardingValidationWarnings => 'Validation warnings';

  @override
  String get navCompanies => 'Companies';

  @override
  String get platformCompaniesTitle => 'Companies';

  @override
  String get platformCompanyDetailTitle => 'Company detail';

  @override
  String get platformCompanySearchHint => 'Search by name, VAT, or country';

  @override
  String get platformCompanyListEmpty => 'No companies match your filters.';

  @override
  String get platformCompanyListError => 'Could not load companies.';

  @override
  String get platformCompanyDetailError => 'Could not load company detail.';

  @override
  String get platformCompanySummaryError => 'Could not load company summary.';

  @override
  String get platformCompanyMockDataBadge => 'Mock company data';

  @override
  String get platformCompanyMetadataBadge => 'Metadata only';

  @override
  String get platformCompanyOpenModule => 'Open companies';

  @override
  String get platformCompanyPrivacyNotice =>
      'Metadata-only tenant view. No trips, documents, or messages are shown.';

  @override
  String get platformCompanyDashboardTitle => 'Company overview';

  @override
  String platformCompanyDashboardActive(String count) {
    return 'Active: $count';
  }

  @override
  String platformCompanyDashboardPendingReview(String count) {
    return 'Pending review: $count';
  }

  @override
  String platformCompanyDashboardSuspended(String count) {
    return 'Suspended: $count';
  }

  @override
  String platformCompanyDashboardOpenSupport(String count) {
    return 'Open support issues: $count';
  }

  @override
  String platformCompanyDashboardPendingOnboarding(String count) {
    return 'Pending onboarding: $count';
  }

  @override
  String get platformCompanyFilterAll => 'All';

  @override
  String get platformCompanyFilterActive => 'Active';

  @override
  String get platformCompanyFilterPendingReview => 'Pending review';

  @override
  String get platformCompanyFilterSuspended => 'Suspended';

  @override
  String get platformCompanyFilterDisabled => 'Disabled';

  @override
  String get platformCompanyStatusActive => 'Active';

  @override
  String get platformCompanyStatusPendingReview => 'Pending review';

  @override
  String get platformCompanyStatusSuspended => 'Suspended';

  @override
  String get platformCompanyStatusDisabled => 'Disabled';

  @override
  String get platformCompanyStatusArchived => 'Archived';

  @override
  String get platformCompanyStatusUnknown => 'Unknown';

  @override
  String platformCompanyMetricActiveUsers(String count) {
    return 'Active users: $count';
  }

  @override
  String platformCompanyMetricDrivers(String count) {
    return 'Drivers: $count';
  }

  @override
  String platformCompanyMetricVehicles(String count) {
    return 'Vehicles: $count';
  }

  @override
  String platformCompanyMetricTrailers(String count) {
    return 'Trailers: $count';
  }

  @override
  String platformCompanyMetricOpenSupport(String count) {
    return 'Open support: $count';
  }

  @override
  String platformCompanyMetricActiveGrants(String count) {
    return 'Active grants: $count';
  }

  @override
  String platformCompanyMetricTotalUsers(String count) {
    return 'Total users: $count';
  }

  @override
  String platformCompanyMetricPendingRegistrations(String count) {
    return 'Pending registrations: $count';
  }

  @override
  String platformCompanyMetricPendingBulkJobs(String count) {
    return 'Pending bulk jobs: $count';
  }

  @override
  String get platformCompanySectionMetadata => 'Company metadata';

  @override
  String get platformCompanySectionUsers => 'Users summary';

  @override
  String get platformCompanySectionSupport => 'Support & fleet summary';

  @override
  String get platformCompanySectionOnboarding => 'Onboarding summary';

  @override
  String get platformCompanyFieldCountry => 'Country';

  @override
  String get platformCompanyFieldVat => 'VAT number';

  @override
  String get platformCompanyFieldRegistrationNumber => 'Registration number';

  @override
  String get platformCompanyFieldPlan => 'Plan';

  @override
  String get platformCompanyFieldSubscriptionStatus => 'Subscription status';

  @override
  String get platformCompanyFieldLastAdminActivity => 'Last admin activity';

  @override
  String get platformCompanyChangeStatusAction => 'Change status';

  @override
  String get platformCompanyStatusDialogTitle => 'Change company status';

  @override
  String get platformCompanyStatusDialogNotice =>
      'Restrictive statuses require a reason. This action is audit logged.';

  @override
  String get platformCompanyStatusFieldLabel => 'New status';

  @override
  String get platformCompanyStatusReasonLabel => 'Reason';

  @override
  String get platformCompanyStatusReasonRequired =>
      'A reason is required for this status.';

  @override
  String get platformCompanyStatusAuditNotice =>
      'Status changes are audit logged. No billing or provisioning occurs here.';

  @override
  String get platformCompanyStatusDismiss => 'Cancel';

  @override
  String get platformCompanyStatusConfirm => 'Update status';

  @override
  String get platformCompanyStatusSuccess => 'Company status updated.';

  @override
  String get platformCompanyStatusUnavailable =>
      'Company status change is unavailable.';
}
