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
}
