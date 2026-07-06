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
  String get brandAppName => 'ViaNexis Admin';

  @override
  String get brandControlCenterSubtitle => 'Operational control center';

  @override
  String get brandOperationalControlCenter => 'Operational Control Center';

  @override
  String get brandPlatformControlCenterBody =>
      'Platform control center for metadata-only administration, review queues, and audit visibility.';

  @override
  String get brandAdminOnlyAccess =>
      'Platform admin access only. Tenant driver and dispatcher accounts cannot sign in here.';

  @override
  String get brandMetadataOnlyPlatformView =>
      'Metadata-only platform view — no operational trip, document, or message content.';

  @override
  String get brandEnvironmentLabel => 'Environment';

  @override
  String get brandSecureAdminSession => 'Secure admin session';

  @override
  String get brandApiConnected => 'API connected';

  @override
  String get brandApiNotConfigured => 'API not configured';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navRegistrations => 'Registrations';

  @override
  String get navPublicIntakes => 'Public intakes';

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
  String get loginTitle => 'Sign in';

  @override
  String get loginSubtitle =>
      'Secure platform admin session for ViaNexis operations staff.';

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
      'Network error. Check your internet connection or staging API availability.';

  @override
  String get authServerError => 'Server error. Try again later.';

  @override
  String get authForbiddenRole =>
      'You do not have permission to access this interface.';

  @override
  String get authLoginServiceUnavailable =>
      'The sign-in service is not available in this environment.';

  @override
  String get authPasswordChangeInvalidCurrent =>
      'The current password is incorrect.';

  @override
  String get authPasswordChangeWeakPassword =>
      'The new password must be at least 16 characters.';

  @override
  String get authPasswordChangeUnchanged =>
      'The new password must differ from the current password.';

  @override
  String get settingsAccountSecuritySection => 'Account security';

  @override
  String get settingsChangePasswordAction => 'Change password';

  @override
  String get settingsChangePasswordTitle => 'Change account password';

  @override
  String get settingsChangePasswordBody =>
      'Update your platform account password. This is separate from the local device PIN.';

  @override
  String get settingsCurrentPasswordLabel => 'Current password';

  @override
  String get settingsNewPasswordLabel => 'New password';

  @override
  String get settingsConfirmPasswordLabel => 'Confirm new password';

  @override
  String get settingsPasswordChangeSuccess =>
      'Password updated. Sign in again with your new password.';

  @override
  String get settingsPasswordMinLengthValidation =>
      'Password must be at least 16 characters.';

  @override
  String get settingsPasswordMismatchValidation => 'Passwords do not match.';

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
  String get dashboardTitle => 'Control center';

  @override
  String get dashboardOperationalOverviewTitle => 'Operational overview';

  @override
  String get dashboardOperationalOverviewBody =>
      'Metadata-only control center snapshot across platform services and human review queues.';

  @override
  String get dashboardSystemStatusHealthy => 'Healthy';

  @override
  String get dashboardSystemStatusAttention => 'Needs attention';

  @override
  String get dashboardMetricSystemStatus => 'System status';

  @override
  String get dashboardMetricPendingRegistrations => 'Pending registrations';

  @override
  String get dashboardMetricCompaniesAttention => 'Companies needing attention';

  @override
  String get dashboardMetricBulkOnboardingReview =>
      'Bulk onboarding waiting review';

  @override
  String get dashboardMetricAiHighRisk => 'AI high-risk reviews';

  @override
  String get dashboardMetricSupportIssues => 'Open support issues';

  @override
  String get dashboardMetricAuditRisks => 'Failed / denied audit events';

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
  String get aiReviewLoadError => 'Could not load AI reviews.';

  @override
  String get aiReviewDetailError => 'Could not load AI review detail.';

  @override
  String get aiReviewListEmpty => 'No AI advisory reviews match your filters.';

  @override
  String get aiReviewSearchHint => 'Search by source, company, or summary';

  @override
  String get aiReviewMockDataBadge => 'Mock data';

  @override
  String get aiReviewOpenModule => 'Open AI reviews';

  @override
  String get aiReviewAdvisoryNotice =>
      'AI recommendations are advisory only. Human approval is required for all decisions.';

  @override
  String get aiReviewDashboardTitle => 'AI advisory reviews';

  @override
  String aiReviewDashboardTotal(String count) {
    return 'Total reviews: $count';
  }

  @override
  String aiReviewDashboardHighRisk(String count) {
    return 'High risk: $count';
  }

  @override
  String aiReviewDashboardNeedsHumanReview(String count) {
    return 'Needs human review: $count';
  }

  @override
  String get aiReviewFilterAll => 'All';

  @override
  String get aiReviewFilterHighRisk => 'High risk';

  @override
  String get aiReviewFilterRegistration => 'Registration';

  @override
  String get aiReviewFilterBulkOnboarding => 'Bulk onboarding';

  @override
  String get aiReviewFilterSystemHealth => 'System health';

  @override
  String get aiReviewFilterNeedsHumanReview => 'Needs human review';

  @override
  String get aiReviewSourceRegistration => 'Registration';

  @override
  String get aiReviewSourceBulkOnboarding => 'Bulk onboarding';

  @override
  String get aiReviewSourceSystemHealth => 'System health';

  @override
  String get aiReviewSourceSupportTicket => 'Support ticket';

  @override
  String get aiReviewSourceUnknown => 'Unknown source';

  @override
  String get aiReviewRiskLow => 'Low risk';

  @override
  String get aiReviewRiskMedium => 'Medium risk';

  @override
  String get aiReviewRiskHigh => 'High risk';

  @override
  String get aiReviewRiskUnknown => 'Unknown risk';

  @override
  String get aiReviewRecommendationReview => 'Review recommended';

  @override
  String get aiReviewRecommendationRequestInfo => 'Request info';

  @override
  String get aiReviewRecommendationApproveCandidate => 'Approve candidate';

  @override
  String get aiReviewRecommendationRejectCandidate => 'Reject candidate';

  @override
  String get aiReviewRecommendationEscalate => 'Escalate';

  @override
  String get aiReviewRecommendationCannotApproveYet => 'Cannot approve yet';

  @override
  String get aiReviewRecommendationUnknown => 'Unknown recommendation';

  @override
  String get aiReviewSectionSummary => 'Advisory summary';

  @override
  String get aiReviewSectionChecks => 'Checks and warnings';

  @override
  String get aiReviewFieldChecksPerformed => 'Checks performed';

  @override
  String get aiReviewFieldMissingInformation => 'Missing information';

  @override
  String get aiReviewFieldDuplicateWarnings => 'Duplicate warnings';

  @override
  String aiReviewFieldConfidenceScore(String score) {
    return 'Confidence score: $score';
  }

  @override
  String aiReviewUpdatedAt(String date) {
    return 'Updated $date';
  }

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
  String get errorSessionExpiredTitle => 'Session expired';

  @override
  String get authSessionExpired =>
      'Your session expired. Sign in again to continue.';

  @override
  String get errorPermissionDeniedTitle => 'Permission denied';

  @override
  String get errorPermissionDeniedBody =>
      'Your account does not have access to this module.';

  @override
  String get errorActionUnavailableTitle => 'Action unavailable';

  @override
  String get errorActionUnavailableBody =>
      'This action or resource is not available right now.';

  @override
  String get errorActionUnavailable =>
      'This action or resource is not available right now.';

  @override
  String get errorBackendNotConfiguredTitle => 'Backend not configured';

  @override
  String get errorNetworkTitle => 'Connection problem';

  @override
  String get offlineBannerMessage =>
      'You appear to be offline. Some actions may fail until connectivity returns.';

  @override
  String get backendNotConfiguredBanner =>
      'Live backend is not configured. Modules may use mock data.';

  @override
  String get confirmDialogCancel => 'Cancel';

  @override
  String get confirmDialogProceed => 'Confirm';

  @override
  String get logoutConfirmTitle => 'Log out?';

  @override
  String get logoutConfirmBody =>
      'You will need to sign in again to access the admin app.';

  @override
  String get accessDeniedBackToDashboard => 'Back to dashboard';

  @override
  String get navAiReviews => 'AI reviews';

  @override
  String get settingsAccountSection => 'Signed-in account';

  @override
  String get settingsEmailLabel => 'Email';

  @override
  String get settingsRoleLabel => 'Role';

  @override
  String get settingsApiBaseUrlLabel => 'API base URL';

  @override
  String get settingsEnvironmentLabel => 'Environment';

  @override
  String get settingsBackendNotConfiguredValue => 'Not configured';

  @override
  String get settingsSignOutSection => 'Session';

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
  String get settingsVersionLabel => 'Version';

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
  String get auditLogDateRangeLabel => 'Filter by date range';

  @override
  String auditLogDateRangeSelected(String from, String to) {
    return '$from – $to';
  }

  @override
  String get auditLogDateRangeClear => 'Clear dates';

  @override
  String get auditLogDateRangeComingSoon => 'Date range filter (coming soon)';

  @override
  String get auditLogExportCsv => 'Export metadata CSV';

  @override
  String get auditLogExportCopied => 'Audit log export copied to clipboard.';

  @override
  String get auditLogExportFailed => 'Could not export audit logs.';

  @override
  String get auditLogExportUnavailable => 'Audit log export is unavailable.';

  @override
  String get auditLogExportSafetyNotice =>
      'Exports include metadata only. No trip, document, or message content is included.';

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
  String get bulkOnboardingDryRunAction => 'Dry run';

  @override
  String get bulkOnboardingExecuteAction => 'Execute';

  @override
  String get bulkOnboardingExecuteDisabled => 'Execution unavailable';

  @override
  String get bulkOnboardingDryRunSuccess => 'Dry run completed.';

  @override
  String get bulkOnboardingExecuteSuccess =>
      'Execution started and audit logged.';

  @override
  String get bulkOnboardingProvisioningTitle => 'Provisioning';

  @override
  String bulkOnboardingProvisioningStatus(Object status) {
    return 'Provisioning status: $status';
  }

  @override
  String bulkOnboardingExecutePolicyDisabled(Object reason) {
    return 'Execution policy blocked: $reason';
  }

  @override
  String get bulkOnboardingExecuteDialogTitle => 'Execute provisioning';

  @override
  String get bulkOnboardingExecuteMetadataNotice =>
      'Metadata only is shown here. Tenant operational content is not exposed.';

  @override
  String get bulkOnboardingExecuteIrreversibleWarning =>
      'This action is irreversible and may provision real entities.';

  @override
  String bulkOnboardingExecuteRowWindow(Object count, Object maxRows) {
    return 'Rows to execute: $count / max $maxRows';
  }

  @override
  String get bulkOnboardingExecuteReasonLabel => 'Execution reason';

  @override
  String get bulkOnboardingExecuteReasonRequired =>
      'Execution reason is required.';

  @override
  String get bulkOnboardingExecuteConfirmRequired =>
      'You must confirm execution.';

  @override
  String get bulkOnboardingExecuteConfirmCheckbox =>
      'I understand this cannot be undone.';

  @override
  String get bulkOnboardingExecuteConfirmAction => 'Execute now';

  @override
  String get bulkOnboardingSummaryDryRunOk => 'Dry run ok';

  @override
  String get bulkOnboardingSummaryBlocked => 'Blocked';

  @override
  String get bulkOnboardingSummaryDuplicates => 'Duplicates';

  @override
  String get bulkOnboardingSummaryFailed => 'Failed';

  @override
  String get bulkOnboardingSummaryProvisioned => 'Provisioned';

  @override
  String get bulkOnboardingRowExecutionStatusesTitle =>
      'Row execution statuses';

  @override
  String get bulkOnboardingExecuteRejectedPolicy =>
      'Execution rejected by policy. Review row limits and job readiness.';

  @override
  String get bulkOnboardingExecuteRejectedValidation =>
      'Execution rejected by backend validation.';

  @override
  String get bulkOnboardingExecuteForbidden =>
      'You do not have permission to execute this job.';

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
  String get bulkOnboardingDownloadValidationReport =>
      'Download validation report CSV';

  @override
  String get bulkOnboardingValidationReportCopied =>
      'Validation report copied to clipboard.';

  @override
  String get bulkOnboardingValidationReportFailed =>
      'Could not download the validation report.';

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

  @override
  String get platformCompanyExchangeSettingsAction =>
      'Pallet / packaging settings';

  @override
  String get companyExchangeSettingsTitle => 'Company exchange settings';

  @override
  String get companyExchangeMockDataBadge => 'Mock data';

  @override
  String get companyExchangeSaved => 'Settings saved.';

  @override
  String get companyExchangeSaveFailed => 'Save failed.';

  @override
  String get companyExchangeLoadFailed => 'Failed to load settings.';

  @override
  String get companyExchangeBackendDependency =>
      'Backend exchange settings endpoint unavailable. Check API access and role.';

  @override
  String get companyExchangePrivacyNotice =>
      'Company feature flags and list metadata only. No trip, document, or message content.';

  @override
  String get companyExchangeMockNotice =>
      'Mock mode: save updates local preview data only. Production requires the backend API.';

  @override
  String get companyExchangePalletEnabled => 'Pallet exchange enabled';

  @override
  String get companyExchangePalletEnabledHint =>
      'Show pallet exchange card in the driver app.';

  @override
  String get companyExchangePackagingEnabled => 'Packaging exchange enabled';

  @override
  String get companyExchangePackagingEnabledHint =>
      'Show packaging exchange card in the driver app.';

  @override
  String get companyExchangeCustomItemsEnabled =>
      'Driver custom packaging items';

  @override
  String get companyExchangeCustomItemsEnabledHint =>
      'Allow drivers to add custom packaging items.';

  @override
  String get companyExchangeDefaultPalletTypes => 'Default pallet types';

  @override
  String get companyExchangeDefaultPackagingItems => 'Default packaging list';

  @override
  String get companyExchangeDefaultPackagingPlaceholder =>
      'List editing arrives in a later admin version. Read-only preview for now.';

  @override
  String get companyExchangeItemInactive => 'Inactive';

  @override
  String get companyExchangeSave => 'Save';

  @override
  String get navBilling => 'Billing';

  @override
  String get billingTitle => 'Billing';

  @override
  String get billingTabSubscriptions => 'Subscriptions';

  @override
  String get billingTabPricingIntakes => 'Pricing intakes';

  @override
  String get billingTabQuoteRequests => 'Quote requests';

  @override
  String get billingMockDataBadge => 'Mock data';

  @override
  String get billingMetadataBadge => 'Metadata only';

  @override
  String get billingLoadError => 'Could not load billing data.';

  @override
  String get billingDetailError => 'Could not load billing detail.';

  @override
  String get billingOpenModule => 'Open billing module';

  @override
  String get billingPrivacyNotice =>
      'Billing views show metadata and counts only. No payment processing or document access occurs here.';

  @override
  String get billingOverviewTitle => 'Billing overview';

  @override
  String billingOverviewActive(String count) {
    return 'Active: $count';
  }

  @override
  String billingOverviewTrial(String count) {
    return 'Trial: $count';
  }

  @override
  String billingOverviewPastDue(String count) {
    return 'Past due: $count';
  }

  @override
  String billingOverviewSuspended(String count) {
    return 'Suspended: $count';
  }

  @override
  String billingOverviewPricingNew(String count) {
    return 'New intakes: $count';
  }

  @override
  String billingOverviewQuotesPending(String count) {
    return 'Pending quotes: $count';
  }

  @override
  String billingOverviewLastUpdated(String date) {
    return 'Last updated: $date';
  }

  @override
  String get dashboardMetricBillingAttention => 'Billing attention';

  @override
  String get billingSubscriptionSearchHint => 'Search subscriptions';

  @override
  String get billingSubscriptionListEmpty =>
      'No subscriptions match your filters.';

  @override
  String get billingSubscriptionDetailTitle => 'Subscription detail';

  @override
  String get billingSubscriptionFilterAll => 'All';

  @override
  String get billingSubscriptionFilterActive => 'Active';

  @override
  String get billingSubscriptionFilterTrial => 'Trial';

  @override
  String get billingSubscriptionFilterPastDue => 'Past due';

  @override
  String get billingSubscriptionFilterSuspended => 'Suspended';

  @override
  String get billingSubscriptionFilterCancelled => 'Cancelled';

  @override
  String get billingSubscriptionStatusTrial => 'Trial';

  @override
  String get billingSubscriptionStatusActive => 'Active';

  @override
  String get billingSubscriptionStatusPastDue => 'Past due';

  @override
  String get billingSubscriptionStatusSuspended => 'Suspended';

  @override
  String get billingSubscriptionStatusCancelled => 'Cancelled';

  @override
  String get billingSubscriptionStatusCustomQuotePending =>
      'Custom quote pending';

  @override
  String get billingSubscriptionStatusUnknown => 'Unknown';

  @override
  String get billingPricingIntakeSearchHint => 'Search pricing intakes';

  @override
  String get billingPricingIntakeListEmpty =>
      'No pricing intakes match your filters.';

  @override
  String get billingPricingIntakeDetailTitle => 'Pricing intake detail';

  @override
  String get billingPricingIntakeNeedsReview => 'Needs human review';

  @override
  String get billingPricingIntakeFilterAll => 'All';

  @override
  String get billingPricingIntakeFilterNew => 'New';

  @override
  String get billingPricingIntakeFilterReviewing => 'Reviewing';

  @override
  String get billingPricingIntakeFilterQuoted => 'Quoted';

  @override
  String get billingPricingIntakeFilterAccepted => 'Accepted';

  @override
  String get billingPricingIntakeFilterRejected => 'Rejected';

  @override
  String get billingPricingIntakeStatusNew => 'New';

  @override
  String get billingPricingIntakeStatusReviewing => 'Reviewing';

  @override
  String get billingPricingIntakeStatusQuoted => 'Quoted';

  @override
  String get billingPricingIntakeStatusAccepted => 'Accepted';

  @override
  String get billingPricingIntakeStatusRejected => 'Rejected';

  @override
  String get billingPricingIntakeStatusUnknown => 'Unknown';

  @override
  String get billingQuoteRequestSearchHint => 'Search quote requests';

  @override
  String get billingQuoteRequestListEmpty =>
      'No quote requests match your filters.';

  @override
  String get billingQuoteRequestDetailTitle => 'Quote request detail';

  @override
  String get billingQuoteRequestFilterAll => 'All';

  @override
  String get billingQuoteRequestFilterSubmitted => 'Submitted';

  @override
  String get billingQuoteRequestFilterUnderReview => 'Under review';

  @override
  String get billingQuoteRequestFilterQuoted => 'Quoted';

  @override
  String get billingQuoteRequestFilterAccepted => 'Accepted';

  @override
  String get billingQuoteRequestFilterRejected => 'Rejected';

  @override
  String get billingQuoteRequestStatusDraft => 'Draft';

  @override
  String get billingQuoteRequestStatusSubmitted => 'Submitted';

  @override
  String get billingQuoteRequestStatusUnderReview => 'Under review';

  @override
  String get billingQuoteRequestStatusQuoted => 'Quoted';

  @override
  String get billingQuoteRequestStatusAccepted => 'Accepted';

  @override
  String get billingQuoteRequestStatusRejected => 'Rejected';

  @override
  String get billingQuoteRequestStatusUnknown => 'Unknown';

  @override
  String billingMetricSeats(String used, String included) {
    return 'Seats: $used/$included';
  }

  @override
  String billingMetricDriverApps(String used, String included) {
    return 'Driver apps: $used/$included';
  }

  @override
  String billingMetricFleetSize(String count) {
    return 'Fleet size: $count';
  }

  @override
  String billingMetricOfficeUsers(String count) {
    return 'Office users: $count';
  }

  @override
  String billingMetricDriverAppsRequested(String count) {
    return 'Driver apps requested: $count';
  }

  @override
  String billingFieldCompanyId(String id) {
    return 'Company #$id';
  }

  @override
  String get billingFieldPlan => 'Plan';

  @override
  String get billingFieldBillingCycle => 'Billing cycle';

  @override
  String get billingFieldCurrency => 'Currency';

  @override
  String get billingFieldPricingSource => 'Pricing source';

  @override
  String get billingFieldOperatingModel => 'Operating model';

  @override
  String get billingFieldAiAddOn => 'AI add-on';

  @override
  String get billingFieldStartedAt => 'Started at';

  @override
  String get billingFieldRenewsAt => 'Renews at';

  @override
  String get billingFieldCancelledAt => 'Cancelled at';

  @override
  String get billingFieldLastPaymentStatus => 'Last payment status';

  @override
  String get billingFieldContactEmail => 'Contact email';

  @override
  String get billingFieldCountry => 'Country';

  @override
  String get billingFieldCreatedAt => 'Created at';

  @override
  String get billingSectionPlan => 'Plan & billing';

  @override
  String get billingSectionUsage => 'Usage';

  @override
  String get billingSectionDates => 'Dates';

  @override
  String get billingSectionContact => 'Contact';

  @override
  String get billingSectionFleet => 'Fleet sizing';

  @override
  String get billingSectionModules => 'Requested modules';

  @override
  String get billingSectionAiFeatures => 'Requested AI features';

  @override
  String get billingYes => 'Yes';

  @override
  String get billingNo => 'No';

  @override
  String get billingNoneReported => 'None reported';

  @override
  String get billingChangeStatusAction => 'Change status';

  @override
  String get billingActionDialogTitle => 'Update billing status';

  @override
  String get billingActionAuditNotice =>
      'Status changes are audit logged. No payment processing occurs here.';

  @override
  String billingActionCurrentStatus(String status) {
    return 'Current status: $status';
  }

  @override
  String get billingActionStatusLabel => 'New status';

  @override
  String get billingActionStatusRequired => 'Select a status.';

  @override
  String get billingActionReasonLabel => 'Reason';

  @override
  String get billingActionReasonRequired =>
      'A reason is required for this status.';

  @override
  String get billingActionNoteLabel => 'Internal note (optional)';

  @override
  String get billingActionConfirm => 'Update status';

  @override
  String get billingActionSuccess => 'Billing status updated.';

  @override
  String get billingActionError => 'Could not update billing status.';

  @override
  String get billingActionUnavailable =>
      'Billing status change is unavailable.';

  @override
  String get navActionCenter => 'Action center';

  @override
  String get navSecurityCenter => 'Security center';

  @override
  String get navAdminUsers => 'Admin users';

  @override
  String get navReleaseCenter => 'Release center';

  @override
  String get adminUsersTitle => 'Admin users';

  @override
  String get adminUserDetailTitle => 'Admin user detail';

  @override
  String get adminUserLoadError => 'Could not load admin users.';

  @override
  String get adminUserDetailError => 'Could not load admin user detail.';

  @override
  String get adminUserMockDataBadge => 'Mock data';

  @override
  String get adminUserMetadataBadge => 'Metadata only';

  @override
  String get adminUserOpenModule => 'Open admin users';

  @override
  String get adminUserPrivacyNotice =>
      'Admin user views show metadata only. No passwords or credentials are exposed.';

  @override
  String get adminUserSearchHint => 'Search admin users';

  @override
  String get adminUserListEmpty => 'No admin users match your filters.';

  @override
  String get adminUserInviteAction => 'Invite admin user';

  @override
  String get adminUserInviteTitle => 'Invite platform admin';

  @override
  String get adminUserInviteNotice =>
      'Invites create a metadata-only platform admin record. Email delivery may be pending.';

  @override
  String get adminUserInviteNoteLabel => 'Internal note (optional)';

  @override
  String get adminUserInviteConfirm => 'Send invite';

  @override
  String get adminUserInviteSuccess => 'Admin user invited.';

  @override
  String get adminUserFilterAll => 'All';

  @override
  String get adminUserFilterActive => 'Active';

  @override
  String get adminUserFilterInvited => 'Invited';

  @override
  String get adminUserFilterSuspended => 'Suspended';

  @override
  String get adminUserFilterDisabled => 'Disabled';

  @override
  String get adminUserStatusActive => 'Active';

  @override
  String get adminUserStatusInvited => 'Invited';

  @override
  String get adminUserStatusSuspended => 'Suspended';

  @override
  String get adminUserStatusDisabled => 'Disabled';

  @override
  String get adminUserStatusUnknown => 'Unknown';

  @override
  String get adminUserRoleUnknown => 'Unknown role';

  @override
  String adminUserLastLogin(String date) {
    return 'Last login: $date';
  }

  @override
  String adminUserFailedLogins(String count) {
    return 'Failed logins: $count';
  }

  @override
  String get adminUserFieldName => 'Name';

  @override
  String get adminUserFieldEmail => 'Email';

  @override
  String get adminUserFieldRole => 'Role';

  @override
  String get adminUserFieldStatus => 'Status';

  @override
  String get adminUserFieldCreatedAt => 'Created';

  @override
  String get adminUserFieldLastLoginAt => 'Last login';

  @override
  String get adminUserFieldFailedLoginCount => 'Failed login count';

  @override
  String get adminUserChangeRoleAction => 'Change role';

  @override
  String get adminUserChangeStatusAction => 'Change status';

  @override
  String get adminUserRoleDialogTitle => 'Change admin role';

  @override
  String get adminUserStatusDialogTitle => 'Change admin status';

  @override
  String adminUserActionCurrentRole(String role) {
    return 'Current role: $role';
  }

  @override
  String adminUserActionCurrentStatus(String status) {
    return 'Current status: $status';
  }

  @override
  String get adminUserReasonLabel => 'Reason';

  @override
  String get adminUserReasonRequired => 'A reason is required.';

  @override
  String get adminUserNameRequired => 'Name must be at least 2 characters.';

  @override
  String get adminUserActionAuditNotice =>
      'Admin user changes are audit logged.';

  @override
  String get adminUserActionCancel => 'Cancel';

  @override
  String get adminUserRoleConfirm => 'Update role';

  @override
  String get adminUserStatusConfirm => 'Update status';

  @override
  String get adminUserRoleSuccess => 'Admin role updated.';

  @override
  String get adminUserStatusSuccess => 'Admin status updated.';

  @override
  String get adminUserActionError => 'Could not update admin user.';

  @override
  String get adminUserActionUnavailable =>
      'Admin user management requires super_admin.';

  @override
  String get securityCenterTitle => 'Security center';

  @override
  String get securityEventDetailTitle => 'Security event detail';

  @override
  String get securityLoadError => 'Could not load security data.';

  @override
  String get securityMockDataBadge => 'Mock data';

  @override
  String get securityOpenModule => 'Open security center';

  @override
  String get securityPrivacyNotice =>
      'Security views show metadata only. No message bodies or document content are shown.';

  @override
  String get securityOverviewTitle => 'Security overview';

  @override
  String securityOverviewFailedLogins(String count) {
    return 'Failed logins: $count';
  }

  @override
  String securityOverviewDeniedActions(String count) {
    return 'Denied actions: $count';
  }

  @override
  String securityOverviewActiveGrants(String count) {
    return 'Active support grants: $count';
  }

  @override
  String securityOverviewCriticalEvents(String count) {
    return 'Critical security events: $count';
  }

  @override
  String securityOverviewExpiringGrants(String count) {
    return 'Expiring grants: $count';
  }

  @override
  String securityOverviewHighRiskAi(String count) {
    return 'High-risk AI reviews: $count';
  }

  @override
  String securityOverviewSuspiciousBulk(String count) {
    return 'Suspicious bulk jobs: $count';
  }

  @override
  String get securityOverviewNoCritical => 'No critical events recorded';

  @override
  String securityOverviewLastCritical(String date) {
    return 'Last critical event: $date';
  }

  @override
  String get securityEventSearchHint => 'Search security events';

  @override
  String get securityEventListEmpty => 'No security events match your filters.';

  @override
  String get securityEventDetailError => 'Security event not found.';

  @override
  String securityEventCompanyLabel(String name) {
    return 'Company: $name';
  }

  @override
  String securityEventCreatedAt(String date) {
    return 'Created: $date';
  }

  @override
  String get securityEventFieldSourceType => 'Source type';

  @override
  String get securityEventFieldSourceId => 'Source ID';

  @override
  String get securityEventFieldActorEmail => 'Actor email';

  @override
  String get securityEventFieldActorRole => 'Actor role';

  @override
  String get securityEventFieldCompany => 'Company';

  @override
  String get securityEventFieldCorrelationId => 'Correlation ID';

  @override
  String get securityEventFieldCreatedAt => 'Created at';

  @override
  String get securityEventFilterAll => 'All';

  @override
  String get securityEventFilterFailedLogin => 'Failed logins';

  @override
  String get securityEventFilterPermissionDenied => 'Denied actions';

  @override
  String get securityEventFilterSupportAccess => 'Support access';

  @override
  String get securityEventFilterHighRiskAi => 'High-risk AI';

  @override
  String get securityEventFilterCriticalSystem => 'Critical system';

  @override
  String get securityEventFilterAdminRoleChange => 'Admin changes';

  @override
  String get securityEventFilterSuspiciousBulkOnboarding => 'Suspicious bulk';

  @override
  String get securityEventFilterCritical => 'Critical';

  @override
  String get securityEventFilterWarning => 'Warning';

  @override
  String get securityEventTypeFailedLogin => 'Failed login';

  @override
  String get securityEventTypePermissionDenied => 'Permission denied';

  @override
  String get securityEventTypeSupportAccess => 'Support access';

  @override
  String get securityEventTypeHighRiskAi => 'High-risk AI';

  @override
  String get securityEventTypeCriticalSystem => 'Critical system';

  @override
  String get securityEventTypeAdminRoleChange => 'Admin change';

  @override
  String get securityEventTypeSuspiciousBulkOnboarding => 'Suspicious bulk';

  @override
  String get securityEventTypeUnknown => 'Unknown';

  @override
  String get securityEventSeverityInfo => 'Info';

  @override
  String get securityEventSeverityWarning => 'Warning';

  @override
  String get securityEventSeverityCritical => 'Critical';

  @override
  String get securityEventSeverityUnknown => 'Unknown';

  @override
  String get actionCenterTitle => 'Action center';

  @override
  String get actionCenterLoadError => 'Could not load action center.';

  @override
  String get actionCenterMockDataBadge => 'Mock data';

  @override
  String get actionCenterOpenModule => 'Open action center';

  @override
  String get actionCenterPrivacyNotice =>
      'Action center items are metadata-only summaries. Open linked modules for details.';

  @override
  String get actionCenterReadOnlyNotice =>
      'Items reflect current system state. They clear when the underlying issue is resolved. Server dismiss is not available in this release.';

  @override
  String get actionCenterSearchHint => 'Search action items';

  @override
  String get actionCenterListEmpty => 'No action items match your filters.';

  @override
  String get actionCenterListEmptyDetail =>
      'When registrations, support tickets, public intakes, or health events need attention, they appear here automatically.';

  @override
  String get actionCenterNeedsAttentionTitle => 'Needs attention';

  @override
  String actionCenterNeedsAttentionOpen(String count) {
    return 'Open items: $count';
  }

  @override
  String actionCenterNeedsAttentionCritical(String count) {
    return 'Critical/urgent: $count';
  }

  @override
  String actionCenterNeedsAttentionTotal(String count) {
    return 'Total items: $count';
  }

  @override
  String actionCenterCompanyLabel(String name) {
    return 'Company: $name';
  }

  @override
  String actionCenterCreatedAt(String date) {
    return 'Created: $date';
  }

  @override
  String get actionCenterFilterAll => 'All';

  @override
  String get actionCenterFilterRegistration => 'Registrations';

  @override
  String get actionCenterFilterBulkOnboarding => 'Bulk onboarding';

  @override
  String get actionCenterFilterSupport => 'Support';

  @override
  String get actionCenterFilterSystemHealth => 'System health';

  @override
  String get actionCenterFilterSecurity => 'Security';

  @override
  String get actionCenterFilterBilling => 'Billing';

  @override
  String get actionCenterFilterAiReview => 'AI reviews';

  @override
  String get actionCenterFilterCritical => 'Critical/urgent';

  @override
  String get actionCenterFilterCustomerCommunication =>
      'Customer communications';

  @override
  String get actionCenterTypeRegistration => 'Registration';

  @override
  String get actionCenterTypeBulkOnboarding => 'Bulk onboarding';

  @override
  String get actionCenterTypeSupport => 'Support';

  @override
  String get actionCenterTypeSystemHealth => 'System health';

  @override
  String get actionCenterTypeSecurity => 'Security';

  @override
  String get actionCenterTypeBilling => 'Billing';

  @override
  String get actionCenterTypeAiReview => 'AI review';

  @override
  String get actionCenterTypeCompany => 'Company';

  @override
  String get actionCenterTypeCustomerCommunication => 'Customer communication';

  @override
  String get actionCenterTypeUnknown => 'Unknown';

  @override
  String get actionCenterPriorityLow => 'Low';

  @override
  String get actionCenterPriorityNormal => 'Normal';

  @override
  String get actionCenterPriorityHigh => 'High';

  @override
  String get actionCenterPriorityUrgent => 'Urgent';

  @override
  String get actionCenterPriorityCritical => 'Critical';

  @override
  String get actionCenterPriorityUnknown => 'Unknown';

  @override
  String get actionCenterStatusOpen => 'Open';

  @override
  String get actionCenterStatusAcknowledged => 'Acknowledged';

  @override
  String get actionCenterStatusDismissed => 'Dismissed';

  @override
  String get actionCenterStatusResolved => 'Resolved';

  @override
  String get actionCenterStatusUnknown => 'Unknown';

  @override
  String get releaseCenterTitle => 'Release center';

  @override
  String get releaseLoadError => 'Could not load release metadata.';

  @override
  String get releaseMockDataBadge => 'Mock data';

  @override
  String get releaseReadOnlyBadge => 'Read only';

  @override
  String get releasePrivacyNotice =>
      'Release views show deployment metadata only. No secrets or storage keys are exposed.';

  @override
  String get releaseTabOverview => 'Overview';

  @override
  String get releaseTabAppVersions => 'App versions';

  @override
  String get releaseTabEnvironment => 'Environment';

  @override
  String get releaseOverviewTitle => 'Release overview';

  @override
  String get releaseAppVersionsTitle => 'App versions';

  @override
  String get releaseEnvironmentTitle => 'Environment';

  @override
  String get releaseFieldBackendVersion => 'Backend version';

  @override
  String get releaseFieldEnvironment => 'Environment';

  @override
  String get releaseFieldNodeEnv => 'Node environment';

  @override
  String get releaseFieldMaintenanceMode => 'Maintenance mode';

  @override
  String get releaseFieldLatestAdminApp => 'Latest admin app';

  @override
  String get releaseFieldLatestDriverApp => 'Latest driver app';

  @override
  String get releaseFieldMinAdminApp => 'Minimum admin app';

  @override
  String get releaseFieldMinDriverApp => 'Minimum driver app';

  @override
  String releaseFieldLastDeployment(String date) {
    return 'Last deployment: $date';
  }

  @override
  String get releaseFieldMigrationStatus => 'Database migrations';

  @override
  String get releaseFieldDeploymentReady => 'Deployment ready';

  @override
  String get releaseFieldApiPublicName => 'Public API name';

  @override
  String get releaseActiveAdminVersions => 'Active admin app versions';

  @override
  String get releaseActiveDriverVersions => 'Active driver app versions';

  @override
  String get releaseDeploymentWarnings => 'Deployment warnings';

  @override
  String get releaseYes => 'Yes';

  @override
  String get releaseNo => 'No';

  @override
  String get releaseEmailDeliveryTitle => 'Email delivery';

  @override
  String get releaseEmailDeliveryProvider => 'Provider';

  @override
  String get releaseEmailDeliveryEnabled => 'Delivery enabled';

  @override
  String get releaseEmailDeliveryLastStatus => 'Last delivery status';

  @override
  String get releaseEmailDeliveryNotice =>
      'Email delivery status shows provider and metadata only. No SMTP passwords or message bodies are exposed.';

  @override
  String get releaseEmailDeliveryAllowlistEnabled =>
      'Staging allowlist enabled';

  @override
  String get releaseEmailDeliveryAllowlistDomains => 'Allowed domains (count)';

  @override
  String get releaseEmailDeliveryAllowlistRecipients =>
      'Allowed recipients (count)';

  @override
  String get releaseEmailDeliveryLastFailureCode => 'Last failure code';

  @override
  String get releaseEmailDeliveryStagingAllowlistMissing =>
      'Staging delivery enabled but allowlist is missing — external sends are blocked.';

  @override
  String get releaseEmailProviderNoop => 'No-op (disabled)';

  @override
  String get releaseEmailProviderSmtp => 'SMTP';

  @override
  String get releaseEmailProviderPlaceholder => 'Provider placeholder';

  @override
  String get releaseObservabilityTitle => 'Observability';

  @override
  String get releaseObservabilityLogLevel => 'Log level';

  @override
  String get releaseObservabilityMetricsEnabled => 'Metrics enabled';

  @override
  String get releaseObservabilitySentryConfigured => 'Sentry configured';

  @override
  String get releaseObservabilityOtelConfigured => 'OpenTelemetry configured';

  @override
  String get releaseObservabilityCorrelationId => 'Correlation ID enabled';

  @override
  String get releaseObservabilityNotice =>
      'Observability status shows configuration flags only. No DSN, endpoint URLs, or secrets are displayed.';

  @override
  String get settingsReleaseSection => 'Release & deployment';

  @override
  String get settingsReleaseCenterBody =>
      'View read-only release metadata, app versions, and environment status.';

  @override
  String get settingsOpenReleaseCenter => 'Open release center';

  @override
  String get appEnvLocal => 'Local';

  @override
  String get appEnvDev => 'Development';

  @override
  String get appEnvStaging => 'Staging';

  @override
  String get appEnvProduction => 'Production';

  @override
  String get appConfigEnvironmentLabel => 'Environment';

  @override
  String get appConfigApiStatusLabel => 'API';

  @override
  String get appConfigApiConfigured => 'Configured';

  @override
  String get appConfigApiNotConfigured => 'Not configured';

  @override
  String get appConfigMockFallbackActive => 'Mock fallback active';

  @override
  String get appConfigProductionMisconfigured =>
      'Production build requires API_BASE_URL. Mock fallback is disabled.';

  @override
  String get appConfigProductionLoginBlocked =>
      'Sign-in is disabled until API_BASE_URL is configured for production.';

  @override
  String loginStagingApiHost(String host) {
    return 'Staging API: $host';
  }

  @override
  String get backendMockFallbackBanner =>
      'Live backend is not configured. Modules use mock data for local UI development.';

  @override
  String get settingsApiHostLabel => 'API host';

  @override
  String get navNotifications => 'Notifications';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsPreferences => 'Preferences';

  @override
  String get notificationsMarkAllRead => 'Mark all read';

  @override
  String get notificationsEmpty => 'No notifications.';

  @override
  String get notificationsInAppOnlyTitle => 'In-app only notifications';

  @override
  String get notificationsInAppOnlyBody =>
      'Push channels are not enabled in this phase.';

  @override
  String get notificationsDetailTitle => 'Notification detail';

  @override
  String get notificationsNotFound => 'Notification not found.';

  @override
  String get notificationsPreferencesTitle => 'Notification preferences';

  @override
  String get notificationsSavePreferences => 'Save preferences';

  @override
  String get notificationsSaved => 'Preferences saved.';

  @override
  String get notificationsPrefSystemHealth => 'System health';

  @override
  String get notificationsPrefSecurity => 'Security';

  @override
  String get notificationsPrefSupport => 'Support';

  @override
  String get notificationsPrefBilling => 'Billing';

  @override
  String get notificationsPrefRelease => 'Release';

  @override
  String get notificationsPrefInAppOnlyHint =>
      'Only in-app notifications are available in this phase.';

  @override
  String get notificationsPrefValidationAtLeastOne =>
      'At least one channel must stay enabled.';

  @override
  String get notificationsPrefValidationInAppOnly =>
      'Only in-app notifications are supported in this phase.';

  @override
  String get notificationsInAppChip => 'In-app only';

  @override
  String get notificationsYes => 'Yes';

  @override
  String get notificationsNo => 'No';

  @override
  String get notificationsPushProviderTitle => 'Push provider status';

  @override
  String get notificationsPushStateInAppOnly => 'In-app only';

  @override
  String get notificationsPushStateExternalNotConfigured =>
      'External push not configured';

  @override
  String get notificationsPushStateConfigured => 'Push provider configured';

  @override
  String get notificationsPushProviderField => 'Provider';

  @override
  String get notificationsPushDeliveryEnabled => 'Delivery enabled';

  @override
  String get notificationsPushTokenStorage => 'Token storage mode';

  @override
  String get notificationsPushLastFailureCode => 'Last failure code';

  @override
  String get notificationsPushProviderNotice =>
      'Push provider status shows metadata only. No FCM, APNS, or credential values are displayed.';

  @override
  String get notificationsPushProviderNone => 'None (in-app only)';

  @override
  String get notificationsPushProviderFcm => 'FCM';

  @override
  String get notificationsPushProviderApns => 'APNS';

  @override
  String get settingsNotificationsSection => 'Notifications';

  @override
  String get settingsNotificationsBody =>
      'Manage in-app notification preferences.';

  @override
  String get settingsOpenNotificationPreferences =>
      'Open notification preferences';

  @override
  String get translationPanelTitle => 'Translation';

  @override
  String get translationProviderDisabled =>
      'Translation provider not configured';

  @override
  String get translationTargetLanguageLabel => 'Target language';

  @override
  String get translationRecipientLanguageLabel => 'Recipient language';

  @override
  String get translationTranslateAction => 'Translate';

  @override
  String get translationTranslating => 'Translating…';

  @override
  String get translationActionError => 'Translation failed';

  @override
  String get translationOriginalTitle => 'Original text';

  @override
  String get translationTranslatedTitle => 'Translated text';

  @override
  String translationLanguageLabel(String code) {
    return 'Language: $code';
  }

  @override
  String get translationMetadataOnlyNotice =>
      'Translated text is hidden in metadata-only view';

  @override
  String get translationBadgeMachine => 'Machine translation';

  @override
  String get translationBadgeNeedsReview => 'Needs review';

  @override
  String get translationBadgeStale => 'Stale translation';

  @override
  String get translationBadgeApproved => 'Approved';

  @override
  String get translationHumanConfirmationRequired =>
      'Human approval is required before sending translated text';

  @override
  String get translationReplyPreviewTitle => 'Reply translation preview';

  @override
  String get translationReplyPreviewNotice =>
      'Preview only. Original draft is preserved and nothing is sent automatically.';

  @override
  String get translationGeneratePreviewAction => 'Generate preview';

  @override
  String get translationNoAutoSendNotice =>
      'Approving marks the translation ready. Sending remains a separate explicit action.';

  @override
  String get translationDismissAction => 'Cancel';

  @override
  String get translationApproveForSendAction => 'Approve translation';

  @override
  String get translationApproving => 'Approving…';

  @override
  String get translationDraftReplyAction => 'Draft reply translation';

  @override
  String get translationReplyApprovedNotice =>
      'Translation approved. Copy or send through your normal support workflow.';

  @override
  String get customerCommunicationsTitle => 'Customer communications';

  @override
  String get customerCommunicationDetailTitle => 'Communication thread';

  @override
  String get customerCommunicationEvidencePackageTitle => 'Evidence package';

  @override
  String get customerCommunicationLoadError =>
      'Could not load customer communications.';

  @override
  String get customerCommunicationActionError =>
      'Customer communication action failed.';

  @override
  String get customerCommunicationMockDataBadge => 'Mock data';

  @override
  String get customerCommunicationOpenModule => 'Open customer communications';

  @override
  String get customerCommunicationPrivacyNotice =>
      'List views are metadata-first. Message bodies appear only on authorized detail access.';

  @override
  String get customerCommunicationDetailMetadataOnly =>
      'Message bodies are hidden for your role or this thread scope.';

  @override
  String get customerCommunicationSearchHint =>
      'Search by name, domain, or company';

  @override
  String get customerCommunicationListEmpty =>
      'No customer communication threads match your filters.';

  @override
  String get customerCommunicationDisputedBadge => 'Disputed';

  @override
  String get customerCommunicationBillingRelatedBadge => 'Billing related';

  @override
  String customerCommunicationThreadSubtitle(String domain, String companyId) {
    return '$domain · company $companyId';
  }

  @override
  String customerCommunicationUpdatedAt(String date) {
    return 'Updated: $date';
  }

  @override
  String get customerCommunicationFilterAll => 'All';

  @override
  String get customerCommunicationFilterOpen => 'Open';

  @override
  String get customerCommunicationFilterDisputed => 'Disputed';

  @override
  String get customerCommunicationFilterClosed => 'Closed';

  @override
  String get customerCommunicationFilterBillingRelated => 'Billing related';

  @override
  String get customerCommunicationStatusOpen => 'Open';

  @override
  String get customerCommunicationStatusClosed => 'Closed';

  @override
  String get customerCommunicationStatusArchived => 'Archived';

  @override
  String get customerCommunicationStatusDisputed => 'Disputed';

  @override
  String get customerCommunicationStatusUnknown => 'Unknown';

  @override
  String get customerCommunicationSourcePublicSite => 'Public site';

  @override
  String get customerCommunicationSourceEmail => 'Email';

  @override
  String get customerCommunicationSourceAdminApp => 'Admin app';

  @override
  String get customerCommunicationSourceAdminWeb => 'Admin web';

  @override
  String get customerCommunicationSourceImport => 'Import';

  @override
  String get customerCommunicationSourceSupport => 'Support';

  @override
  String get customerCommunicationSourceSystem => 'System';

  @override
  String get customerCommunicationSourceUnknown => 'Unknown';

  @override
  String get customerCommunicationDirectionInbound => 'Inbound';

  @override
  String get customerCommunicationDirectionOutbound => 'Outbound';

  @override
  String get customerCommunicationDirectionInternalNote => 'Internal note';

  @override
  String get customerCommunicationDirectionSystemEvent => 'System event';

  @override
  String get customerCommunicationDirectionUnknown => 'Unknown';

  @override
  String get customerCommunicationSenderCustomer => 'Customer';

  @override
  String get customerCommunicationSenderPlatformAdmin => 'Platform admin';

  @override
  String get customerCommunicationSenderCompanyAdmin => 'Company admin';

  @override
  String get customerCommunicationSenderSystem => 'System';

  @override
  String get customerCommunicationSenderUnknown => 'Unknown';

  @override
  String get customerCommunicationHumanReviewedBadge => 'Human reviewed';

  @override
  String customerCommunicationOriginalLabel(String language) {
    return 'Original ($language)';
  }

  @override
  String customerCommunicationTranslatedLabel(String language) {
    return 'Translated ($language)';
  }

  @override
  String get customerCommunicationMessageMetadataOnly =>
      'Message body hidden (metadata-only view).';

  @override
  String get customerCommunicationMessagesEmpty => 'No messages logged yet.';

  @override
  String get customerCommunicationTimelineTitle => 'Timeline';

  @override
  String get customerCommunicationAgreementsTitle => 'Agreement snapshots';

  @override
  String get customerCommunicationEvidencePackagesTitle => 'Evidence packages';

  @override
  String get customerCommunicationPackagesEmpty =>
      'No evidence packages generated yet.';

  @override
  String customerCommunicationAgreementPrice(
    String amount,
    String currency,
    String cycle,
  ) {
    return '$amount $currency · $cycle';
  }

  @override
  String customerCommunicationAgreementModules(String modules) {
    return 'Modules: $modules';
  }

  @override
  String customerCommunicationAgreementAcceptedAt(String date) {
    return 'Accepted: $date';
  }

  @override
  String get customerCommunicationPdfPendingNotice =>
      'PDF rendering pending; structured evidence package generated from audit records.';

  @override
  String get customerCommunicationPdfReadyNotice =>
      'PDF evidence package is ready to share from this device.';

  @override
  String get customerCommunicationPdfFailedNotice =>
      'PDF rendering failed. Structured summaryJson remains available from audit records.';

  @override
  String get customerCommunicationPdfSourceOfTruthNotice =>
      'Generated from ViaNexis audit records. Database audit records remain the source of truth; this PDF is a presentation export only.';

  @override
  String get customerCommunicationDownloadPdfAction => 'Download PDF';

  @override
  String customerCommunicationDownloadPdfSuccess(String bytes) {
    return 'PDF downloaded ($bytes bytes). Handle according to your privacy and retention policy.';
  }

  @override
  String get customerCommunicationDownloadPdfFailed =>
      'Could not download the evidence PDF.';

  @override
  String get customerCommunicationSharePdfAction => 'Share PDF';

  @override
  String get customerCommunicationSharePdfSuccess =>
      'PDF ready to share. Use your device share sheet to open or save the file.';

  @override
  String get customerCommunicationSharePdfFailed =>
      'Could not share the evidence PDF.';

  @override
  String get customerCommunicationSharePdfInvalid =>
      'The evidence PDF file is empty or invalid. Regenerate the package or try again.';

  @override
  String get customerCommunicationSharePdfUnavailable =>
      'Sharing is not available on this device. Try again or use another device.';

  @override
  String get customerCommunicationSharePdfNotReady =>
      'PDF is not ready yet. Wait for generation to finish or regenerate the package.';

  @override
  String customerCommunicationGeneratedBy(String userId) {
    return 'Generated by user ID: $userId';
  }

  @override
  String get customerCommunicationSendReplyTitle => 'Send customer reply';

  @override
  String get customerCommunicationSendReplyAction => 'Send reply';

  @override
  String get customerCommunicationSendReplyMessageLabel => 'Reply message';

  @override
  String get customerCommunicationSendReplySubjectLabel =>
      'Email subject (optional)';

  @override
  String get customerCommunicationUseTranslatedTextLabel =>
      'Use approved translated text';

  @override
  String get customerCommunicationHumanConfirmationLabel =>
      'I confirm this reply is ready to send';

  @override
  String get customerCommunicationHumanConfirmedBadge => 'Human confirmed';

  @override
  String get customerCommunicationTranslationApprovedBadge =>
      'Translation approved';

  @override
  String get customerCommunicationTranslatedReplyWarning =>
      'Translated replies are not sent automatically. Review and confirm before sending.';

  @override
  String get customerCommunicationDeliveryProviderDisabledNotice =>
      'Delivery provider disabled; reply will be logged but not externally sent.';

  @override
  String get customerCommunicationReplyLoggedSkippedNotice =>
      'Reply logged with skipped delivery (provider disabled).';

  @override
  String get customerCommunicationReplySentSuccess =>
      'Reply sent successfully.';

  @override
  String get customerCommunicationEvidenceDeliveryNotice =>
      'Evidence packages include outbound delivery status when available.';

  @override
  String get customerCommunicationDeliveryStatusDraft => 'Draft';

  @override
  String get customerCommunicationDeliveryStatusQueued => 'Queued';

  @override
  String get customerCommunicationDeliveryStatusSkipped => 'Skipped';

  @override
  String get customerCommunicationDeliveryStatusSent => 'Sent';

  @override
  String get customerCommunicationDeliveryStatusFailed => 'Failed';

  @override
  String get customerCommunicationDeliveryStatusCancelled => 'Cancelled';

  @override
  String get customerCommunicationDeliveryStatusUnknown => 'Unknown status';

  @override
  String get customerCommunicationDeliveryChannelEmail => 'Email';

  @override
  String get customerCommunicationDeliveryChannelPortal => 'Portal';

  @override
  String get customerCommunicationDeliveryChannelManual => 'Manual';

  @override
  String get customerCommunicationDeliveryChannelNone => 'None';

  @override
  String get customerCommunicationDeliveryChannelUnknown => 'Unknown channel';

  @override
  String get customerCommunicationDeliveryHistoryTitle => 'Delivery history';

  @override
  String get customerCommunicationDeliveryHistoryEmpty =>
      'No delivery attempts recorded yet.';

  @override
  String get customerCommunicationDeliveryFilterAll => 'All';

  @override
  String get customerCommunicationDeliveryFilterSkipped => 'Skipped';

  @override
  String get customerCommunicationDeliveryFilterFailed => 'Failed';

  @override
  String get customerCommunicationDeliveryFilterSent => 'Sent';

  @override
  String get customerCommunicationDeliveryFilterQueued => 'Queued';

  @override
  String get customerCommunicationResendTitle => 'Resend delivery';

  @override
  String get customerCommunicationResendAction => 'Resend';

  @override
  String get customerCommunicationResendAuditNotice =>
      'Resending creates a new audited delivery attempt.';

  @override
  String get customerCommunicationResendTranslationNotice =>
      'Translated replies require approved translation before sending.';

  @override
  String get customerCommunicationResendSuccess =>
      'Resend logged successfully.';

  @override
  String get customerCommunicationDeliveryMultipleAttempts =>
      'Multiple delivery attempts recorded — see delivery history.';

  @override
  String get customerCommunicationDeliveryResendAttempt =>
      'This attempt is a resend of a prior delivery.';

  @override
  String get customerCommunicationDeliveryTemplateLabel => 'Email template';

  @override
  String get customerCommunicationEvidenceRegenerationNotice =>
      'Evidence package may need regeneration after new delivery attempts.';

  @override
  String get customerCommunicationHumanConfirmRequired =>
      'Human confirmation is required.';

  @override
  String get customerCommunicationDeliveryEventQueued => 'Queued';

  @override
  String get customerCommunicationDeliveryEventSent => 'Sent';

  @override
  String get customerCommunicationDeliveryEventDelivered => 'Delivered';

  @override
  String get customerCommunicationDeliveryEventBounced => 'Bounced';

  @override
  String get customerCommunicationDeliveryEventComplained => 'Complained';

  @override
  String get customerCommunicationDeliveryEventOpened => 'Opened';

  @override
  String get customerCommunicationDeliveryEventClicked => 'Clicked';

  @override
  String get customerCommunicationDeliveryEventFailed => 'Failed';

  @override
  String get customerCommunicationDeliveryEventProviderStatus =>
      'Provider status';

  @override
  String get customerCommunicationDeliveryEventUnknown => 'Unknown event';

  @override
  String customerCommunicationPackageGeneratedAt(String date) {
    return 'Generated: $date';
  }

  @override
  String get customerCommunicationPackageTypeCommunicationEvidence =>
      'Communication evidence';

  @override
  String get customerCommunicationPackageTypeSubscriptionDispute =>
      'Subscription dispute';

  @override
  String get customerCommunicationPackageTypeRegistrationEvidence =>
      'Registration evidence';

  @override
  String get customerCommunicationPackageTypePricingEvidence =>
      'Pricing evidence';

  @override
  String get customerCommunicationPackageTypeUnknown => 'Unknown package type';

  @override
  String get customerCommunicationPackageStatusGenerated => 'Generated';

  @override
  String get customerCommunicationPackageStatusFailed => 'Failed';

  @override
  String get customerCommunicationPackageStatusUnknown => 'Unknown status';

  @override
  String get customerCommunicationGeneratePackageTitle =>
      'Generate evidence package';

  @override
  String get customerCommunicationGeneratePackageAction => 'Generate package';

  @override
  String get customerCommunicationMarkDisputedTitle => 'Mark thread disputed';

  @override
  String get customerCommunicationMarkDisputedAction => 'Mark disputed';

  @override
  String get customerCommunicationDisputedSectionTitle => 'Dispute';

  @override
  String get customerCommunicationReasonLabel => 'Reason (required)';

  @override
  String get customerCommunicationReasonRequired =>
      'Enter at least 5 characters.';

  @override
  String get customerCommunicationPackageTypeLabel => 'Package type';

  @override
  String get customerCommunicationExportAuditWarning =>
      'Export creates an audited evidence package from database records. Provide a reason for compliance.';

  @override
  String get customerCommunicationCancel => 'Cancel';

  @override
  String get customerCommunicationDisputeMarkedSuccess =>
      'Thread marked as disputed.';

  @override
  String get customerCommunicationPackageGeneratedSuccess =>
      'Evidence package generated.';

  @override
  String get customerCommunicationSummaryJsonTitle =>
      'Structured summary (authoritative audit export)';

  @override
  String customerCommunicationPackageReason(String reason) {
    return 'Reason: $reason';
  }

  @override
  String customerCommunicationFileHash(String hash) {
    return 'Integrity hash: $hash';
  }

  @override
  String get customerCommunicationPackageNotFound =>
      'Evidence package not found.';

  @override
  String get customerCommunicationSummaryTitle => 'Customer communications';

  @override
  String customerCommunicationSummaryDisputed(String count) {
    return 'Disputed: $count';
  }

  @override
  String customerCommunicationSummaryOpen(String count) {
    return 'Open: $count';
  }

  @override
  String customerCommunicationSummaryTotal(String count) {
    return 'Total: $count';
  }

  @override
  String get publicIntakesTitle => 'Public intakes';

  @override
  String get publicIntakeDashboardSubtitle =>
      'Review website leads and quote requests. Also available under More.';

  @override
  String get publicIntakeDashboardOpenAction => 'Open public intakes';

  @override
  String get publicIntakeModuleDescription =>
      'Website leads, demo and quote requests';

  @override
  String get publicIntakeNoLinkedThreadTitle =>
      'No customer communication thread yet';

  @override
  String get publicIntakeNoLinkedThreadBody =>
      'This intake is not linked to a customer communication thread. Review the intake details here; a thread may be created when backend workflow links it.';

  @override
  String get publicIntakeNoLinksTitle => 'No linked records';

  @override
  String get publicIntakeNoLinksBody =>
      'No communication thread, quote request, or pricing intake is linked to this submission yet.';

  @override
  String get publicIntakeDetailTitle => 'Public intake';

  @override
  String get publicIntakeSearchHint => 'Search company, domain, country…';

  @override
  String get publicIntakeListEmpty => 'No public intakes match your filters.';

  @override
  String get publicIntakeListError => 'Could not load public intakes.';

  @override
  String get publicIntakeDetailError => 'Could not load public intake detail.';

  @override
  String get publicIntakeMockDataBadge => 'Mock data';

  @override
  String get publicIntakeUnknownCustomer => 'Unknown contact';

  @override
  String publicIntakeCreatedAt(String date) {
    return 'Submitted: $date';
  }

  @override
  String get publicIntakeFilterAll => 'All';

  @override
  String get publicIntakeFilterNew => 'New';

  @override
  String get publicIntakeFilterReviewing => 'Reviewing';

  @override
  String get publicIntakeFilterQuoteDemo => 'Quote / demo';

  @override
  String get publicIntakeFilterContacted => 'Contacted / quoted';

  @override
  String get publicIntakeFilterClosed => 'Closed';

  @override
  String get publicIntakeTypeContact => 'Contact';

  @override
  String get publicIntakeTypeDemoRequest => 'Demo request';

  @override
  String get publicIntakeTypeQuoteRequest => 'Quote request';

  @override
  String get publicIntakeTypeRegistrationInterest => 'Registration interest';

  @override
  String get publicIntakeTypeSupportRequest => 'Support request';

  @override
  String get publicIntakeTypeUnknown => 'Unknown type';

  @override
  String get publicIntakeStatusNew => 'New';

  @override
  String get publicIntakeStatusReviewing => 'Reviewing';

  @override
  String get publicIntakeStatusContacted => 'Contacted';

  @override
  String get publicIntakeStatusQuoted => 'Quoted';

  @override
  String get publicIntakeStatusConverted => 'Converted';

  @override
  String get publicIntakeStatusRejected => 'Rejected';

  @override
  String get publicIntakeStatusClosed => 'Closed';

  @override
  String get publicIntakeStatusUnknown => 'Unknown status';

  @override
  String get publicIntakeSectionCustomer => 'Customer';

  @override
  String get publicIntakeSectionConsent => 'Consent';

  @override
  String get publicIntakeSectionMessage => 'Original message';

  @override
  String get publicIntakeSectionQuote => 'Quote details';

  @override
  String get publicIntakeSectionLinks => 'Related records';

  @override
  String get publicIntakeFieldCustomerName => 'Contact name';

  @override
  String get publicIntakeFieldEmailDomain => 'Email domain';

  @override
  String get publicIntakeFieldCompany => 'Company';

  @override
  String get publicIntakeFieldCountry => 'Country';

  @override
  String publicIntakeFieldOriginalLanguage(String lang) {
    return 'Original language: $lang';
  }

  @override
  String publicIntakeFieldFleetSize(String count) {
    return 'Fleet size: $count';
  }

  @override
  String publicIntakeFieldOfficeUsers(String count) {
    return 'Office users: $count';
  }

  @override
  String publicIntakeFieldDriverApps(String count) {
    return 'Driver apps: $count';
  }

  @override
  String get publicIntakeFieldModules => 'Requested modules';

  @override
  String get publicIntakeFieldAiFeatures => 'Requested AI features';

  @override
  String get publicIntakeFieldStatus => 'Status';

  @override
  String get publicIntakeFieldConsentVersion => 'Consent version';

  @override
  String get publicIntakeConsentPrivacy => 'Privacy consent';

  @override
  String get publicIntakeConsentTerms => 'Terms consent';

  @override
  String get publicIntakeConsentMarketing => 'Marketing consent';

  @override
  String get publicIntakeConsentYes => 'Yes';

  @override
  String get publicIntakeConsentNo => 'No';

  @override
  String get publicIntakeOpenThreadAction =>
      'Open customer communication thread';

  @override
  String get publicIntakeLinkedQuote => 'Linked quote request';

  @override
  String get publicIntakeLinkedPricing => 'Linked pricing intake';

  @override
  String get publicIntakeChangeStatusAction => 'Update status';

  @override
  String get publicIntakeStatusDialogTitle => 'Update intake status';

  @override
  String get publicIntakeReasonLabel => 'Reason';

  @override
  String get publicIntakeReasonRequired =>
      'Reason is required when closing or rejecting.';

  @override
  String get publicIntakeReasonMinLength => 'Enter at least 5 characters.';

  @override
  String get publicIntakeCancel => 'Cancel';

  @override
  String get publicIntakeStatusConfirm => 'Save status';

  @override
  String get publicIntakeStatusSuccess => 'Status updated.';

  @override
  String get publicIntakeStatusError => 'Could not update status.';

  @override
  String get publicIntakeEvidenceNotice =>
      'This public intake is logged from first contact and can be included in evidence packages.';

  @override
  String publicIntakeDashboardNew(String count) {
    return 'New public intakes: $count';
  }

  @override
  String publicIntakeDashboardHighPriority(String count) {
    return 'Quote/demo requests: $count';
  }

  @override
  String get actionCenterFilterPublicIntake => 'Public intakes';

  @override
  String get actionCenterTypePublicIntake => 'Public intake';

  @override
  String get navMore => 'More';

  @override
  String get modulesHubTitle => 'Modules';

  @override
  String get modulesHubBody => 'Additional admin modules and settings.';

  @override
  String get navReturnToDashboard => 'Return to dashboard';

  @override
  String get settingsLanguageSection => 'Language';

  @override
  String get settingsLanguageBody => 'Choose the admin app display language.';

  @override
  String get settingsLanguageHu => 'Hungarian';

  @override
  String get settingsLanguageEn => 'English';

  @override
  String get devicePinSectionTitle => 'Device PIN';

  @override
  String get devicePinSectionBody =>
      'Optional local PIN for this device. Does not replace backend sign-in.';

  @override
  String get devicePinSetAction => 'Set PIN';

  @override
  String get devicePinChangeAction => 'Change PIN';

  @override
  String get devicePinRemoveAction => 'Remove PIN';

  @override
  String get devicePinCurrentLabel => 'Current PIN';

  @override
  String get devicePinNewLabel => 'New PIN';

  @override
  String get devicePinConfirmLabel => 'Confirm PIN';

  @override
  String get devicePinSetSuccess => 'Device PIN saved.';

  @override
  String get devicePinChangeSuccess => 'Device PIN updated.';

  @override
  String get devicePinRemoveSuccess => 'Device PIN removed.';

  @override
  String get devicePinMismatch => 'PIN entries do not match.';

  @override
  String get devicePinInvalidLength => 'PIN must be 4–8 digits.';

  @override
  String get devicePinInvalidCurrent => 'Current PIN is incorrect.';

  @override
  String get devicePinNonNumeric => 'PIN must contain digits only.';

  @override
  String get navOperations => 'Operations overview';

  @override
  String get operationsTitle => 'Operations overview';

  @override
  String get operationsModuleDescription =>
      'Platform metrics, trips, drivers, and backend dependencies.';

  @override
  String get operationsOpenModule => 'Open operations overview';

  @override
  String get operationsMockBadge => 'Mock data';

  @override
  String get operationsLoadFailed => 'Failed to load operations overview.';

  @override
  String get operationsPrivacyNotice =>
      'Aggregated platform metadata only. No trip, document, or message content.';

  @override
  String get operationsPendingSyncTitle => 'Pending sync issues';

  @override
  String get operationsPendingSyncDependency =>
      'Platform-wide sync warning list is not wired yet.';

  @override
  String get operationsExchangeRecordsTitle => 'Pallet/packaging records';

  @override
  String get operationsExchangeRecordsDependency =>
      'Platform exchange record list endpoint is not available yet.';

  @override
  String get operationsCompanyCount => 'Companies (active/total)';

  @override
  String get operationsActiveDrivers => 'Active drivers (estimate)';

  @override
  String get operationsActiveTrips => 'Active trips';

  @override
  String get operationsCompletedTrips => 'Completed trips';

  @override
  String get operationsSupportAccess => 'Active support access';

  @override
  String get operationsPublicIntakes => 'Pending public intakes';

  @override
  String get operationsPendingRegistrations => 'Pending registrations';

  @override
  String get operationsPackagesGenerated => 'Generated packages';

  @override
  String get operationsModulesTitle => 'Operations modules';

  @override
  String get operationsLinkDriverAccess => 'Driver access';

  @override
  String get operationsLinkTrips => 'Trips overview';

  @override
  String get operationsLinkExchangeRecords => 'Exchange records';

  @override
  String get operationsLinkNotificationStatus => 'Notification status';

  @override
  String get operationsLinkSupportAccess => 'Support access';

  @override
  String get operationsLinkPublicIntakes => 'Public intakes';

  @override
  String get driverAccessTitle => 'Driver access';

  @override
  String get driverAccessMockBadge => 'Mock data';

  @override
  String get driverAccessLoadFailed => 'Failed to load driver list.';

  @override
  String get driverAccessPrivacyNotice =>
      'Metadata only: name, status, device label, session count. No tokens, PIN hash, or message content.';

  @override
  String get driverAccessBackendTitle => 'Backend dependency';

  @override
  String get driverAccessBackendMessage =>
      'Platform driver list endpoint is not available yet. Sample data appears in mock mode.';

  @override
  String get driverAccessDetailTitle => 'Driver details';

  @override
  String get driverAccessNotFound => 'Driver not found.';

  @override
  String get driverAccessFieldName => 'Name';

  @override
  String get driverAccessFieldCompany => 'Company';

  @override
  String get driverAccessRegistrationStatus => 'Registration status';

  @override
  String get driverAccessFieldDeviceLabel => 'Device label';

  @override
  String get driverAccessFieldActiveSessions => 'Active sessions';

  @override
  String get driverAccessFieldLastActivity => 'Last activity';

  @override
  String get driverAccessEnableDisableTitle => 'Enable/disable driver';

  @override
  String get driverAccessEnableDisableDependency =>
      'Driver status change endpoint is not available yet.';

  @override
  String get driverAccessStatusPending => 'Pending';

  @override
  String get driverAccessStatusActive => 'Active';

  @override
  String get driverAccessStatusDisabled => 'Disabled';

  @override
  String get driverAccessStatusInvited => 'Invited';

  @override
  String get tripsOverviewTitle => 'Trips overview';

  @override
  String get tripsOverviewMockBadge => 'Mock data';

  @override
  String get tripsOverviewLoadFailed => 'Failed to load trips overview.';

  @override
  String get tripsOverviewPrivacyNotice =>
      'Trip metadata only: reference, status, exchange indicators. No document or message content.';

  @override
  String get tripsOverviewActiveCount => 'Active trips';

  @override
  String get tripsOverviewCompletedCount => 'Completed trips';

  @override
  String get tripsOverviewParkedCount => 'Parked trips';

  @override
  String get tripsOverviewBackendTitle => 'Backend dependency';

  @override
  String get tripsOverviewBackendMessage =>
      'Platform trip list endpoint is not available yet. Summary counts come from the dashboard API.';

  @override
  String get tripsOverviewListTitle => 'Trips';

  @override
  String get tripsOverviewExchangeIndicator => 'Has exchange record';

  @override
  String get tripsOverviewExchangeAttention => 'Exchange attention';

  @override
  String get tripsOverviewPendingSync => 'Pending sync';

  @override
  String get tripsOverviewStatusActive => 'Active';

  @override
  String get tripsOverviewStatusCompleted => 'Completed';

  @override
  String get tripsOverviewStatusParked => 'Parked';

  @override
  String get tripsOverviewStatusPending => 'Pending';

  @override
  String get exchangeRecordsTitle => 'Exchange records';

  @override
  String get exchangeRecordsMockBadge => 'Mock data';

  @override
  String get exchangeRecordsLoadFailed => 'Failed to load exchange records.';

  @override
  String get exchangeRecordsPrivacyNotice =>
      'Record metadata only: item, quantities, status, timestamp. No attachment content or storage keys.';

  @override
  String get exchangeRecordsBackendTitle => 'Backend dependency';

  @override
  String get exchangeRecordsBackendMessage =>
      'Platform exchange record list endpoint is not available yet.';

  @override
  String get exchangeRecordsFilterAll => 'All';

  @override
  String get exchangeRecordsFilterDisputed => 'Disputed';

  @override
  String get exchangeRecordsFilterDamaged => 'Damaged';

  @override
  String get exchangeRecordsFilterMissing => 'Missing';

  @override
  String get exchangeRecordsListEmpty => 'No records match the filter.';

  @override
  String get exchangeRecordsFieldStatus => 'Status';

  @override
  String get exchangeRecordsFieldMissing => 'Missing';

  @override
  String get exchangeRecordsFieldDamaged => 'Damaged';

  @override
  String get exchangeRecordsStatusCompleted => 'Completed';

  @override
  String get exchangeRecordsStatusDisputed => 'Disputed';

  @override
  String get exchangeRecordsStatusDamaged => 'Damaged';

  @override
  String get exchangeRecordsStatusMissing => 'Missing';

  @override
  String get exchangeRecordsStatusUnknown => 'Unknown';

  @override
  String get notificationStatusTitle => 'Notification status';

  @override
  String get notificationStatusPrivacyNotice =>
      'Push infrastructure metadata only. No FCM/APNS tokens, secrets, or credentials.';

  @override
  String get notificationStatusLoadFailed =>
      'Failed to load notification status.';

  @override
  String get notificationStatusDriverFoundationTitle =>
      'Driver app notification foundation';

  @override
  String get notificationStatusDriverFoundationReady =>
      'Ready — in-app and push foundation implemented.';

  @override
  String get notificationStatusDeviceTokenTitle => 'Device token registration';

  @override
  String get notificationStatusDeviceTokenDependency =>
      'Driver device token registration endpoint is not available to admin yet.';

  @override
  String get notificationStatusEventsTitle => 'Recent notification events';

  @override
  String get notificationStatusEventsDependency =>
      'Platform notification event list endpoint is not available yet.';

  @override
  String get notificationStatusProductionPushConfigured =>
      'Production push backend configured';

  @override
  String get notificationStatusBackendDependency =>
      'Backend dependency — production push not fully wired.';

  @override
  String get companyExchangeItemSortOrder => 'Sort order';

  @override
  String get companyExchangePackagingCrudTitle => 'Packaging list editing';

  @override
  String get companyExchangePackagingCrudDependency =>
      'Default packaging item CRUD is not available yet. Read-only list for now.';

  @override
  String get companyExchangeManualPalletRecordTitle =>
      'Driver manual pallet record';

  @override
  String get companyExchangeManualPalletRecordDependency =>
      'Driver manual pallet record policy toggle endpoint is not available yet.';

  @override
  String get companyExchangeAddPackagingItem => 'Add packaging item';

  @override
  String get companyExchangeEditPackagingItem => 'Edit packaging item';

  @override
  String get companyExchangePackagingItemName => 'Packaging item name';

  @override
  String get companyExchangePackagingItemNameRequired =>
      'Enter the packaging item name.';

  @override
  String get companyExchangePackagingItemNotes => 'Notes';

  @override
  String get companyExchangePackagingItemSortOrder => 'Sort order';

  @override
  String get companyExchangeSavePackagingItem => 'Save';

  @override
  String get companyExchangePackagingItemSaved => 'Packaging list saved.';

  @override
  String get companyExchangePackagingItemSaveFailed =>
      'Could not save the packaging item.';

  @override
  String get companyExchangeDeactivatePackagingItem => 'Deactivate';

  @override
  String get companyExchangeReactivatePackagingItem => 'Reactivate';

  @override
  String get companyExchangePackagingItemEmpty =>
      'No packaging items have been configured for this company yet.';

  @override
  String get companyExchangeCancel => 'Cancel';
}
