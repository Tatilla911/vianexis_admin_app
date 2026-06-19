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
}
