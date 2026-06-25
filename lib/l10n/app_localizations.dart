import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hu.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hu'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'ViaNexis Admin'**
  String get appTitle;

  /// No description provided for @brandAppName.
  ///
  /// In en, this message translates to:
  /// **'ViaNexis Admin'**
  String get brandAppName;

  /// No description provided for @brandControlCenterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Operational control center'**
  String get brandControlCenterSubtitle;

  /// No description provided for @brandOperationalControlCenter.
  ///
  /// In en, this message translates to:
  /// **'Operational Control Center'**
  String get brandOperationalControlCenter;

  /// No description provided for @brandPlatformControlCenterBody.
  ///
  /// In en, this message translates to:
  /// **'Platform control center for metadata-only administration, review queues, and audit visibility.'**
  String get brandPlatformControlCenterBody;

  /// No description provided for @brandAdminOnlyAccess.
  ///
  /// In en, this message translates to:
  /// **'Platform admin access only. Tenant driver and dispatcher accounts cannot sign in here.'**
  String get brandAdminOnlyAccess;

  /// No description provided for @brandMetadataOnlyPlatformView.
  ///
  /// In en, this message translates to:
  /// **'Metadata-only platform view — no operational trip, document, or message content.'**
  String get brandMetadataOnlyPlatformView;

  /// No description provided for @brandEnvironmentLabel.
  ///
  /// In en, this message translates to:
  /// **'Environment'**
  String get brandEnvironmentLabel;

  /// No description provided for @brandSecureAdminSession.
  ///
  /// In en, this message translates to:
  /// **'Secure admin session'**
  String get brandSecureAdminSession;

  /// No description provided for @brandApiConnected.
  ///
  /// In en, this message translates to:
  /// **'API connected'**
  String get brandApiConnected;

  /// No description provided for @brandApiNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'API not configured'**
  String get brandApiNotConfigured;

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navRegistrations.
  ///
  /// In en, this message translates to:
  /// **'Registrations'**
  String get navRegistrations;

  /// No description provided for @navPublicIntakes.
  ///
  /// In en, this message translates to:
  /// **'Public intakes'**
  String get navPublicIntakes;

  /// No description provided for @navBulkOnboarding.
  ///
  /// In en, this message translates to:
  /// **'Bulk onboarding'**
  String get navBulkOnboarding;

  /// No description provided for @navSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get navSupport;

  /// No description provided for @navSystemHealth.
  ///
  /// In en, this message translates to:
  /// **'System health'**
  String get navSystemHealth;

  /// No description provided for @navAuditLogs.
  ///
  /// In en, this message translates to:
  /// **'Audit logs'**
  String get navAuditLogs;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Secure platform admin session for ViaNexis operations staff.'**
  String get loginSubtitle;

  /// No description provided for @authEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmail;

  /// No description provided for @authPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPassword;

  /// No description provided for @authSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get authSignIn;

  /// No description provided for @authSigningIn.
  ///
  /// In en, this message translates to:
  /// **'Signing in…'**
  String get authSigningIn;

  /// No description provided for @authLogout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get authLogout;

  /// No description provided for @authInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password.'**
  String get authInvalidCredentials;

  /// No description provided for @authNetworkError.
  ///
  /// In en, this message translates to:
  /// **'Network error. Check your connection and try again.'**
  String get authNetworkError;

  /// No description provided for @authServerError.
  ///
  /// In en, this message translates to:
  /// **'Server error. Try again later.'**
  String get authServerError;

  /// No description provided for @authForbiddenRole.
  ///
  /// In en, this message translates to:
  /// **'This account cannot sign in to the admin app.'**
  String get authForbiddenRole;

  /// No description provided for @authPasswordChangeInvalidCurrent.
  ///
  /// In en, this message translates to:
  /// **'The current password is incorrect.'**
  String get authPasswordChangeInvalidCurrent;

  /// No description provided for @authPasswordChangeWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'The new password must be at least 16 characters.'**
  String get authPasswordChangeWeakPassword;

  /// No description provided for @authPasswordChangeUnchanged.
  ///
  /// In en, this message translates to:
  /// **'The new password must differ from the current password.'**
  String get authPasswordChangeUnchanged;

  /// No description provided for @settingsAccountSecuritySection.
  ///
  /// In en, this message translates to:
  /// **'Account security'**
  String get settingsAccountSecuritySection;

  /// No description provided for @settingsChangePasswordAction.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get settingsChangePasswordAction;

  /// No description provided for @settingsChangePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Change account password'**
  String get settingsChangePasswordTitle;

  /// No description provided for @settingsChangePasswordBody.
  ///
  /// In en, this message translates to:
  /// **'Update your platform account password. This is separate from the local device PIN.'**
  String get settingsChangePasswordBody;

  /// No description provided for @settingsCurrentPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get settingsCurrentPasswordLabel;

  /// No description provided for @settingsNewPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get settingsNewPasswordLabel;

  /// No description provided for @settingsConfirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get settingsConfirmPasswordLabel;

  /// No description provided for @settingsPasswordChangeSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password updated. Sign in again with your new password.'**
  String get settingsPasswordChangeSuccess;

  /// No description provided for @settingsPasswordMinLengthValidation.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 16 characters.'**
  String get settingsPasswordMinLengthValidation;

  /// No description provided for @settingsPasswordMismatchValidation.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get settingsPasswordMismatchValidation;

  /// No description provided for @authBackendNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Backend connection is not configured yet.'**
  String get authBackendNotConfigured;

  /// No description provided for @authRequiredField.
  ///
  /// In en, this message translates to:
  /// **'This field is required.'**
  String get authRequiredField;

  /// No description provided for @authShowPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get authShowPassword;

  /// No description provided for @authHidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get authHidePassword;

  /// No description provided for @loginEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get loginEmailLabel;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPasswordLabel;

  /// No description provided for @loginSignInButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginSignInButton;

  /// No description provided for @loginBackendNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Backend connection is not configured yet.'**
  String get loginBackendNotConfigured;

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Control center'**
  String get dashboardTitle;

  /// No description provided for @dashboardOperationalOverviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Operational overview'**
  String get dashboardOperationalOverviewTitle;

  /// No description provided for @dashboardOperationalOverviewBody.
  ///
  /// In en, this message translates to:
  /// **'Metadata-only control center snapshot across platform services and human review queues.'**
  String get dashboardOperationalOverviewBody;

  /// No description provided for @dashboardSystemStatusHealthy.
  ///
  /// In en, this message translates to:
  /// **'Healthy'**
  String get dashboardSystemStatusHealthy;

  /// No description provided for @dashboardSystemStatusAttention.
  ///
  /// In en, this message translates to:
  /// **'Needs attention'**
  String get dashboardSystemStatusAttention;

  /// No description provided for @dashboardMetricSystemStatus.
  ///
  /// In en, this message translates to:
  /// **'System status'**
  String get dashboardMetricSystemStatus;

  /// No description provided for @dashboardMetricPendingRegistrations.
  ///
  /// In en, this message translates to:
  /// **'Pending registrations'**
  String get dashboardMetricPendingRegistrations;

  /// No description provided for @dashboardMetricCompaniesAttention.
  ///
  /// In en, this message translates to:
  /// **'Companies needing attention'**
  String get dashboardMetricCompaniesAttention;

  /// No description provided for @dashboardMetricBulkOnboardingReview.
  ///
  /// In en, this message translates to:
  /// **'Bulk onboarding waiting review'**
  String get dashboardMetricBulkOnboardingReview;

  /// No description provided for @dashboardMetricAiHighRisk.
  ///
  /// In en, this message translates to:
  /// **'AI high-risk reviews'**
  String get dashboardMetricAiHighRisk;

  /// No description provided for @dashboardMetricSupportIssues.
  ///
  /// In en, this message translates to:
  /// **'Open support issues'**
  String get dashboardMetricSupportIssues;

  /// No description provided for @dashboardMetricAuditRisks.
  ///
  /// In en, this message translates to:
  /// **'Failed / denied audit events'**
  String get dashboardMetricAuditRisks;

  /// No description provided for @dashboardPlaceholderBody.
  ///
  /// In en, this message translates to:
  /// **'Operational summaries and platform metrics will appear here.'**
  String get dashboardPlaceholderBody;

  /// No description provided for @registrationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Registration applications'**
  String get registrationsTitle;

  /// No description provided for @registrationsPlaceholderBody.
  ///
  /// In en, this message translates to:
  /// **'Pending company onboarding applications will appear here.'**
  String get registrationsPlaceholderBody;

  /// No description provided for @registrationDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Registration application'**
  String get registrationDetailTitle;

  /// No description provided for @registrationDetailPlaceholderBody.
  ///
  /// In en, this message translates to:
  /// **'Application metadata and review actions will appear here.'**
  String get registrationDetailPlaceholderBody;

  /// No description provided for @aiReviewsTitle.
  ///
  /// In en, this message translates to:
  /// **'AI review summaries'**
  String get aiReviewsTitle;

  /// No description provided for @aiReviewsPlaceholderBody.
  ///
  /// In en, this message translates to:
  /// **'AI-assisted review recommendations will appear here.'**
  String get aiReviewsPlaceholderBody;

  /// No description provided for @aiReviewLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load AI reviews.'**
  String get aiReviewLoadError;

  /// No description provided for @aiReviewDetailError.
  ///
  /// In en, this message translates to:
  /// **'Could not load AI review detail.'**
  String get aiReviewDetailError;

  /// No description provided for @aiReviewListEmpty.
  ///
  /// In en, this message translates to:
  /// **'No AI advisory reviews match your filters.'**
  String get aiReviewListEmpty;

  /// No description provided for @aiReviewSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by source, company, or summary'**
  String get aiReviewSearchHint;

  /// No description provided for @aiReviewMockDataBadge.
  ///
  /// In en, this message translates to:
  /// **'Mock data'**
  String get aiReviewMockDataBadge;

  /// No description provided for @aiReviewOpenModule.
  ///
  /// In en, this message translates to:
  /// **'Open AI reviews'**
  String get aiReviewOpenModule;

  /// No description provided for @aiReviewAdvisoryNotice.
  ///
  /// In en, this message translates to:
  /// **'AI recommendations are advisory only. Human approval is required for all decisions.'**
  String get aiReviewAdvisoryNotice;

  /// No description provided for @aiReviewDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'AI advisory reviews'**
  String get aiReviewDashboardTitle;

  /// No description provided for @aiReviewDashboardTotal.
  ///
  /// In en, this message translates to:
  /// **'Total reviews: {count}'**
  String aiReviewDashboardTotal(String count);

  /// No description provided for @aiReviewDashboardHighRisk.
  ///
  /// In en, this message translates to:
  /// **'High risk: {count}'**
  String aiReviewDashboardHighRisk(String count);

  /// No description provided for @aiReviewDashboardNeedsHumanReview.
  ///
  /// In en, this message translates to:
  /// **'Needs human review: {count}'**
  String aiReviewDashboardNeedsHumanReview(String count);

  /// No description provided for @aiReviewFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get aiReviewFilterAll;

  /// No description provided for @aiReviewFilterHighRisk.
  ///
  /// In en, this message translates to:
  /// **'High risk'**
  String get aiReviewFilterHighRisk;

  /// No description provided for @aiReviewFilterRegistration.
  ///
  /// In en, this message translates to:
  /// **'Registration'**
  String get aiReviewFilterRegistration;

  /// No description provided for @aiReviewFilterBulkOnboarding.
  ///
  /// In en, this message translates to:
  /// **'Bulk onboarding'**
  String get aiReviewFilterBulkOnboarding;

  /// No description provided for @aiReviewFilterSystemHealth.
  ///
  /// In en, this message translates to:
  /// **'System health'**
  String get aiReviewFilterSystemHealth;

  /// No description provided for @aiReviewFilterNeedsHumanReview.
  ///
  /// In en, this message translates to:
  /// **'Needs human review'**
  String get aiReviewFilterNeedsHumanReview;

  /// No description provided for @aiReviewSourceRegistration.
  ///
  /// In en, this message translates to:
  /// **'Registration'**
  String get aiReviewSourceRegistration;

  /// No description provided for @aiReviewSourceBulkOnboarding.
  ///
  /// In en, this message translates to:
  /// **'Bulk onboarding'**
  String get aiReviewSourceBulkOnboarding;

  /// No description provided for @aiReviewSourceSystemHealth.
  ///
  /// In en, this message translates to:
  /// **'System health'**
  String get aiReviewSourceSystemHealth;

  /// No description provided for @aiReviewSourceSupportTicket.
  ///
  /// In en, this message translates to:
  /// **'Support ticket'**
  String get aiReviewSourceSupportTicket;

  /// No description provided for @aiReviewSourceUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown source'**
  String get aiReviewSourceUnknown;

  /// No description provided for @aiReviewRiskLow.
  ///
  /// In en, this message translates to:
  /// **'Low risk'**
  String get aiReviewRiskLow;

  /// No description provided for @aiReviewRiskMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium risk'**
  String get aiReviewRiskMedium;

  /// No description provided for @aiReviewRiskHigh.
  ///
  /// In en, this message translates to:
  /// **'High risk'**
  String get aiReviewRiskHigh;

  /// No description provided for @aiReviewRiskUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown risk'**
  String get aiReviewRiskUnknown;

  /// No description provided for @aiReviewRecommendationReview.
  ///
  /// In en, this message translates to:
  /// **'Review recommended'**
  String get aiReviewRecommendationReview;

  /// No description provided for @aiReviewRecommendationRequestInfo.
  ///
  /// In en, this message translates to:
  /// **'Request info'**
  String get aiReviewRecommendationRequestInfo;

  /// No description provided for @aiReviewRecommendationApproveCandidate.
  ///
  /// In en, this message translates to:
  /// **'Approve candidate'**
  String get aiReviewRecommendationApproveCandidate;

  /// No description provided for @aiReviewRecommendationRejectCandidate.
  ///
  /// In en, this message translates to:
  /// **'Reject candidate'**
  String get aiReviewRecommendationRejectCandidate;

  /// No description provided for @aiReviewRecommendationEscalate.
  ///
  /// In en, this message translates to:
  /// **'Escalate'**
  String get aiReviewRecommendationEscalate;

  /// No description provided for @aiReviewRecommendationCannotApproveYet.
  ///
  /// In en, this message translates to:
  /// **'Cannot approve yet'**
  String get aiReviewRecommendationCannotApproveYet;

  /// No description provided for @aiReviewRecommendationUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown recommendation'**
  String get aiReviewRecommendationUnknown;

  /// No description provided for @aiReviewSectionSummary.
  ///
  /// In en, this message translates to:
  /// **'Advisory summary'**
  String get aiReviewSectionSummary;

  /// No description provided for @aiReviewSectionChecks.
  ///
  /// In en, this message translates to:
  /// **'Checks and warnings'**
  String get aiReviewSectionChecks;

  /// No description provided for @aiReviewFieldChecksPerformed.
  ///
  /// In en, this message translates to:
  /// **'Checks performed'**
  String get aiReviewFieldChecksPerformed;

  /// No description provided for @aiReviewFieldMissingInformation.
  ///
  /// In en, this message translates to:
  /// **'Missing information'**
  String get aiReviewFieldMissingInformation;

  /// No description provided for @aiReviewFieldDuplicateWarnings.
  ///
  /// In en, this message translates to:
  /// **'Duplicate warnings'**
  String get aiReviewFieldDuplicateWarnings;

  /// No description provided for @aiReviewFieldConfidenceScore.
  ///
  /// In en, this message translates to:
  /// **'Confidence score: {score}'**
  String aiReviewFieldConfidenceScore(String score);

  /// No description provided for @aiReviewUpdatedAt.
  ///
  /// In en, this message translates to:
  /// **'Updated {date}'**
  String aiReviewUpdatedAt(String date);

  /// No description provided for @supportTicketsTitle.
  ///
  /// In en, this message translates to:
  /// **'Support tickets'**
  String get supportTicketsTitle;

  /// No description provided for @supportTicketsPlaceholderBody.
  ///
  /// In en, this message translates to:
  /// **'Support ticket metadata will appear here.'**
  String get supportTicketsPlaceholderBody;

  /// No description provided for @supportGrantsTitle.
  ///
  /// In en, this message translates to:
  /// **'Support access grants'**
  String get supportGrantsTitle;

  /// No description provided for @supportGrantsPlaceholderBody.
  ///
  /// In en, this message translates to:
  /// **'Scoped support grant metadata will appear here.'**
  String get supportGrantsPlaceholderBody;

  /// No description provided for @systemHealthTitle.
  ///
  /// In en, this message translates to:
  /// **'System health'**
  String get systemHealthTitle;

  /// No description provided for @systemHealthPlaceholderBody.
  ///
  /// In en, this message translates to:
  /// **'Platform health diagnostics will appear here.'**
  String get systemHealthPlaceholderBody;

  /// No description provided for @auditLogsTitle.
  ///
  /// In en, this message translates to:
  /// **'Audit logs'**
  String get auditLogsTitle;

  /// No description provided for @auditLogsPlaceholderBody.
  ///
  /// In en, this message translates to:
  /// **'Sanitized platform audit metadata will appear here.'**
  String get auditLogsPlaceholderBody;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsPlaceholderBody.
  ///
  /// In en, this message translates to:
  /// **'Account and application preferences will appear here.'**
  String get settingsPlaceholderBody;

  /// No description provided for @privacyMetadataOnlyBadge.
  ///
  /// In en, this message translates to:
  /// **'Metadata only'**
  String get privacyMetadataOnlyBadge;

  /// No description provided for @privacyNoOperationalContent.
  ///
  /// In en, this message translates to:
  /// **'Operational trip, document, and message content is not shown in this app.'**
  String get privacyNoOperationalContent;

  /// No description provided for @roleSuperAdmin.
  ///
  /// In en, this message translates to:
  /// **'Super admin'**
  String get roleSuperAdmin;

  /// No description provided for @roleSupportAdmin.
  ///
  /// In en, this message translates to:
  /// **'Support admin'**
  String get roleSupportAdmin;

  /// No description provided for @roleOnboardingReviewer.
  ///
  /// In en, this message translates to:
  /// **'Onboarding reviewer'**
  String get roleOnboardingReviewer;

  /// No description provided for @roleBillingAdmin.
  ///
  /// In en, this message translates to:
  /// **'Billing admin'**
  String get roleBillingAdmin;

  /// No description provided for @errorGenericTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorGenericTitle;

  /// No description provided for @errorGenericBody.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Try again.'**
  String get errorGenericBody;

  /// No description provided for @errorRetryButton.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get errorRetryButton;

  /// No description provided for @errorSessionExpiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Session expired'**
  String get errorSessionExpiredTitle;

  /// No description provided for @authSessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Your session expired. Sign in again to continue.'**
  String get authSessionExpired;

  /// No description provided for @errorPermissionDeniedTitle.
  ///
  /// In en, this message translates to:
  /// **'Permission denied'**
  String get errorPermissionDeniedTitle;

  /// No description provided for @errorPermissionDeniedBody.
  ///
  /// In en, this message translates to:
  /// **'Your account does not have access to this module.'**
  String get errorPermissionDeniedBody;

  /// No description provided for @errorActionUnavailableTitle.
  ///
  /// In en, this message translates to:
  /// **'Action unavailable'**
  String get errorActionUnavailableTitle;

  /// No description provided for @errorActionUnavailableBody.
  ///
  /// In en, this message translates to:
  /// **'This action or resource is not available right now.'**
  String get errorActionUnavailableBody;

  /// No description provided for @errorActionUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This action or resource is not available right now.'**
  String get errorActionUnavailable;

  /// No description provided for @errorBackendNotConfiguredTitle.
  ///
  /// In en, this message translates to:
  /// **'Backend not configured'**
  String get errorBackendNotConfiguredTitle;

  /// No description provided for @errorNetworkTitle.
  ///
  /// In en, this message translates to:
  /// **'Connection problem'**
  String get errorNetworkTitle;

  /// No description provided for @offlineBannerMessage.
  ///
  /// In en, this message translates to:
  /// **'You appear to be offline. Some actions may fail until connectivity returns.'**
  String get offlineBannerMessage;

  /// No description provided for @backendNotConfiguredBanner.
  ///
  /// In en, this message translates to:
  /// **'Live backend is not configured. Modules may use mock data.'**
  String get backendNotConfiguredBanner;

  /// No description provided for @confirmDialogCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get confirmDialogCancel;

  /// No description provided for @confirmDialogProceed.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmDialogProceed;

  /// No description provided for @logoutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Log out?'**
  String get logoutConfirmTitle;

  /// No description provided for @logoutConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'You will need to sign in again to access the admin app.'**
  String get logoutConfirmBody;

  /// No description provided for @accessDeniedBackToDashboard.
  ///
  /// In en, this message translates to:
  /// **'Back to dashboard'**
  String get accessDeniedBackToDashboard;

  /// No description provided for @navAiReviews.
  ///
  /// In en, this message translates to:
  /// **'AI reviews'**
  String get navAiReviews;

  /// No description provided for @settingsAccountSection.
  ///
  /// In en, this message translates to:
  /// **'Signed-in account'**
  String get settingsAccountSection;

  /// No description provided for @settingsEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get settingsEmailLabel;

  /// No description provided for @settingsRoleLabel.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get settingsRoleLabel;

  /// No description provided for @settingsApiBaseUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'API base URL'**
  String get settingsApiBaseUrlLabel;

  /// No description provided for @settingsEnvironmentLabel.
  ///
  /// In en, this message translates to:
  /// **'Environment'**
  String get settingsEnvironmentLabel;

  /// No description provided for @settingsBackendNotConfiguredValue.
  ///
  /// In en, this message translates to:
  /// **'Not configured'**
  String get settingsBackendNotConfiguredValue;

  /// No description provided for @settingsSignOutSection.
  ///
  /// In en, this message translates to:
  /// **'Session'**
  String get settingsSignOutSection;

  /// No description provided for @loadingLabel.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loadingLabel;

  /// No description provided for @statusHealthy.
  ///
  /// In en, this message translates to:
  /// **'Healthy'**
  String get statusHealthy;

  /// No description provided for @statusDegraded.
  ///
  /// In en, this message translates to:
  /// **'Degraded'**
  String get statusDegraded;

  /// No description provided for @statusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get statusUnknown;

  /// No description provided for @settingsSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get settingsSignOut;

  /// No description provided for @settingsAppVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String settingsAppVersion(String version);

  /// No description provided for @settingsVersionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settingsVersionLabel;

  /// No description provided for @validationEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required.'**
  String get validationEmailRequired;

  /// No description provided for @validationPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required.'**
  String get validationPasswordRequired;

  /// No description provided for @registrationFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get registrationFilterAll;

  /// No description provided for @registrationFilterPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get registrationFilterPending;

  /// No description provided for @registrationFilterNeedsInfo.
  ///
  /// In en, this message translates to:
  /// **'Needs info'**
  String get registrationFilterNeedsInfo;

  /// No description provided for @registrationFilterAiReviewed.
  ///
  /// In en, this message translates to:
  /// **'AI reviewed'**
  String get registrationFilterAiReviewed;

  /// No description provided for @registrationFilterApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get registrationFilterApproved;

  /// No description provided for @registrationFilterRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get registrationFilterRejected;

  /// No description provided for @registrationFilterHighRisk.
  ///
  /// In en, this message translates to:
  /// **'High risk'**
  String get registrationFilterHighRisk;

  /// No description provided for @registrationStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get registrationStatusPending;

  /// No description provided for @registrationStatusNeedsInfo.
  ///
  /// In en, this message translates to:
  /// **'Needs info'**
  String get registrationStatusNeedsInfo;

  /// No description provided for @registrationStatusApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get registrationStatusApproved;

  /// No description provided for @registrationStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get registrationStatusRejected;

  /// No description provided for @registrationStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get registrationStatusCancelled;

  /// No description provided for @registrationStatusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get registrationStatusUnknown;

  /// No description provided for @registrationRiskLow.
  ///
  /// In en, this message translates to:
  /// **'Low risk'**
  String get registrationRiskLow;

  /// No description provided for @registrationRiskMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium risk'**
  String get registrationRiskMedium;

  /// No description provided for @registrationRiskHigh.
  ///
  /// In en, this message translates to:
  /// **'High risk'**
  String get registrationRiskHigh;

  /// No description provided for @registrationRiskUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown risk'**
  String get registrationRiskUnknown;

  /// No description provided for @registrationTypeCompany.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get registrationTypeCompany;

  /// No description provided for @registrationTypeUser.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get registrationTypeUser;

  /// No description provided for @registrationTypeBulkOnboarding.
  ///
  /// In en, this message translates to:
  /// **'Bulk onboarding'**
  String get registrationTypeBulkOnboarding;

  /// No description provided for @registrationSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search company, VAT, country, or email'**
  String get registrationSearchHint;

  /// No description provided for @registrationListEmpty.
  ///
  /// In en, this message translates to:
  /// **'No registration applications match your filters.'**
  String get registrationListEmpty;

  /// No description provided for @registrationListError.
  ///
  /// In en, this message translates to:
  /// **'Could not load registration applications.'**
  String get registrationListError;

  /// No description provided for @registrationDetailError.
  ///
  /// In en, this message translates to:
  /// **'Could not load registration application details.'**
  String get registrationDetailError;

  /// No description provided for @registrationMockDataBadge.
  ///
  /// In en, this message translates to:
  /// **'Mock data'**
  String get registrationMockDataBadge;

  /// No description provided for @registrationSubmittedAt.
  ///
  /// In en, this message translates to:
  /// **'Submitted {date}'**
  String registrationSubmittedAt(String date);

  /// No description provided for @registrationSectionCompany.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get registrationSectionCompany;

  /// No description provided for @registrationSectionContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get registrationSectionContact;

  /// No description provided for @registrationSectionStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get registrationSectionStatus;

  /// No description provided for @registrationSectionAiReview.
  ///
  /// In en, this message translates to:
  /// **'AI review'**
  String get registrationSectionAiReview;

  /// No description provided for @registrationSectionDocuments.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get registrationSectionDocuments;

  /// No description provided for @registrationFieldCompanyName.
  ///
  /// In en, this message translates to:
  /// **'Company name'**
  String get registrationFieldCompanyName;

  /// No description provided for @registrationFieldCountry.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get registrationFieldCountry;

  /// No description provided for @registrationFieldVatNumber.
  ///
  /// In en, this message translates to:
  /// **'VAT / tax number'**
  String get registrationFieldVatNumber;

  /// No description provided for @registrationFieldRegistrationNumber.
  ///
  /// In en, this message translates to:
  /// **'Registration number'**
  String get registrationFieldRegistrationNumber;

  /// No description provided for @registrationFieldContactName.
  ///
  /// In en, this message translates to:
  /// **'Contact name'**
  String get registrationFieldContactName;

  /// No description provided for @registrationFieldContactEmail.
  ///
  /// In en, this message translates to:
  /// **'Contact email'**
  String get registrationFieldContactEmail;

  /// No description provided for @registrationFieldSubmittedAt.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get registrationFieldSubmittedAt;

  /// No description provided for @registrationFieldReviewedAt.
  ///
  /// In en, this message translates to:
  /// **'Reviewed'**
  String get registrationFieldReviewedAt;

  /// No description provided for @registrationFieldReviewedBy.
  ///
  /// In en, this message translates to:
  /// **'Reviewed by'**
  String get registrationFieldReviewedBy;

  /// No description provided for @registrationFieldAiRecommendation.
  ///
  /// In en, this message translates to:
  /// **'AI recommendation'**
  String get registrationFieldAiRecommendation;

  /// No description provided for @registrationFieldAiSummary.
  ///
  /// In en, this message translates to:
  /// **'AI summary'**
  String get registrationFieldAiSummary;

  /// No description provided for @registrationFieldMissingInformation.
  ///
  /// In en, this message translates to:
  /// **'Missing information'**
  String get registrationFieldMissingInformation;

  /// No description provided for @registrationFieldDuplicateWarnings.
  ///
  /// In en, this message translates to:
  /// **'Duplicate warnings'**
  String get registrationFieldDuplicateWarnings;

  /// No description provided for @registrationFieldRiskFlags.
  ///
  /// In en, this message translates to:
  /// **'Risk flags'**
  String get registrationFieldRiskFlags;

  /// No description provided for @registrationNoneReported.
  ///
  /// In en, this message translates to:
  /// **'None reported'**
  String get registrationNoneReported;

  /// No description provided for @registrationDocumentsMetadataOnly.
  ///
  /// In en, this message translates to:
  /// **'Document metadata only — file contents are not shown.'**
  String get registrationDocumentsMetadataOnly;

  /// No description provided for @registrationDocumentsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No uploaded document metadata reported.'**
  String get registrationDocumentsEmpty;

  /// No description provided for @registrationActionApprove.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get registrationActionApprove;

  /// No description provided for @registrationActionReject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get registrationActionReject;

  /// No description provided for @registrationActionRequestInfo.
  ///
  /// In en, this message translates to:
  /// **'Request information'**
  String get registrationActionRequestInfo;

  /// No description provided for @registrationDecisionApproveTitle.
  ///
  /// In en, this message translates to:
  /// **'Approve registration'**
  String get registrationDecisionApproveTitle;

  /// No description provided for @registrationDecisionRejectTitle.
  ///
  /// In en, this message translates to:
  /// **'Reject registration'**
  String get registrationDecisionRejectTitle;

  /// No description provided for @registrationDecisionRequestInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Request more information'**
  String get registrationDecisionRequestInfoTitle;

  /// No description provided for @registrationDecisionApproveBody.
  ///
  /// In en, this message translates to:
  /// **'Confirm approval of this onboarding application.'**
  String get registrationDecisionApproveBody;

  /// No description provided for @registrationDecisionAuditNotice.
  ///
  /// In en, this message translates to:
  /// **'This action will be recorded in the platform audit log.'**
  String get registrationDecisionAuditNotice;

  /// No description provided for @registrationDecisionNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Review notes'**
  String get registrationDecisionNotesLabel;

  /// No description provided for @registrationDecisionNotesRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter at least 3 characters.'**
  String get registrationDecisionNotesRequired;

  /// No description provided for @registrationDecisionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get registrationDecisionCancel;

  /// No description provided for @registrationDecisionApproveConfirm.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get registrationDecisionApproveConfirm;

  /// No description provided for @registrationDecisionRejectConfirm.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get registrationDecisionRejectConfirm;

  /// No description provided for @registrationDecisionRequestInfoConfirm.
  ///
  /// In en, this message translates to:
  /// **'Send request'**
  String get registrationDecisionRequestInfoConfirm;

  /// No description provided for @registrationDecisionSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration decision saved.'**
  String get registrationDecisionSuccess;

  /// No description provided for @registrationDecisionError.
  ///
  /// In en, this message translates to:
  /// **'Could not save registration decision.'**
  String get registrationDecisionError;

  /// No description provided for @systemHealthLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load system health data.'**
  String get systemHealthLoadError;

  /// No description provided for @systemHealthActionUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This action is not available on the connected backend yet.'**
  String get systemHealthActionUnavailable;

  /// No description provided for @systemHealthMockDataBadge.
  ///
  /// In en, this message translates to:
  /// **'Mock data'**
  String get systemHealthMockDataBadge;

  /// No description provided for @systemHealthServicesTitle.
  ///
  /// In en, this message translates to:
  /// **'Service status'**
  String get systemHealthServicesTitle;

  /// No description provided for @systemHealthEventsTitle.
  ///
  /// In en, this message translates to:
  /// **'Health events'**
  String get systemHealthEventsTitle;

  /// No description provided for @systemHealthEventsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No health events match your filters.'**
  String get systemHealthEventsEmpty;

  /// No description provided for @systemHealthEventDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Health event'**
  String get systemHealthEventDetailTitle;

  /// No description provided for @systemHealthEventStartedAt.
  ///
  /// In en, this message translates to:
  /// **'Started {date}'**
  String systemHealthEventStartedAt(String date);

  /// No description provided for @systemHealthOpenModule.
  ///
  /// In en, this message translates to:
  /// **'Open system health'**
  String get systemHealthOpenModule;

  /// No description provided for @systemHealthOverallStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Overall status: {status}'**
  String systemHealthOverallStatusLabel(String status);

  /// No description provided for @systemHealthLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated {date}'**
  String systemHealthLastUpdated(String date);

  /// No description provided for @systemHealthMetricHealthyServices.
  ///
  /// In en, this message translates to:
  /// **'Healthy services'**
  String get systemHealthMetricHealthyServices;

  /// No description provided for @systemHealthMetricWarningServices.
  ///
  /// In en, this message translates to:
  /// **'Warning services'**
  String get systemHealthMetricWarningServices;

  /// No description provided for @systemHealthMetricCriticalServices.
  ///
  /// In en, this message translates to:
  /// **'Critical services'**
  String get systemHealthMetricCriticalServices;

  /// No description provided for @systemHealthMetricCriticalEvents.
  ///
  /// In en, this message translates to:
  /// **'Critical events'**
  String get systemHealthMetricCriticalEvents;

  /// No description provided for @systemHealthMetricWarningEvents.
  ///
  /// In en, this message translates to:
  /// **'Warning events'**
  String get systemHealthMetricWarningEvents;

  /// No description provided for @systemHealthMetricFailedJobs.
  ///
  /// In en, this message translates to:
  /// **'Failed jobs'**
  String get systemHealthMetricFailedJobs;

  /// No description provided for @systemHealthSeverityInfo.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get systemHealthSeverityInfo;

  /// No description provided for @systemHealthSeverityWarning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get systemHealthSeverityWarning;

  /// No description provided for @systemHealthSeverityCritical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get systemHealthSeverityCritical;

  /// No description provided for @systemHealthSeverityUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get systemHealthSeverityUnknown;

  /// No description provided for @systemHealthOverallHealthy.
  ///
  /// In en, this message translates to:
  /// **'Healthy'**
  String get systemHealthOverallHealthy;

  /// No description provided for @systemHealthOverallDegraded.
  ///
  /// In en, this message translates to:
  /// **'Degraded'**
  String get systemHealthOverallDegraded;

  /// No description provided for @systemHealthOverallCritical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get systemHealthOverallCritical;

  /// No description provided for @systemHealthOverallUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get systemHealthOverallUnknown;

  /// No description provided for @systemHealthFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get systemHealthFilterAll;

  /// No description provided for @systemHealthFilterCritical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get systemHealthFilterCritical;

  /// No description provided for @systemHealthFilterWarning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get systemHealthFilterWarning;

  /// No description provided for @systemHealthFilterOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get systemHealthFilterOpen;

  /// No description provided for @systemHealthFilterAcknowledged.
  ///
  /// In en, this message translates to:
  /// **'Acknowledged'**
  String get systemHealthFilterAcknowledged;

  /// No description provided for @systemHealthFilterResolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get systemHealthFilterResolved;

  /// No description provided for @systemHealthFilterTenantImpacting.
  ///
  /// In en, this message translates to:
  /// **'Tenant impacting'**
  String get systemHealthFilterTenantImpacting;

  /// No description provided for @systemHealthEventStatusOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get systemHealthEventStatusOpen;

  /// No description provided for @systemHealthEventStatusAcknowledged.
  ///
  /// In en, this message translates to:
  /// **'Acknowledged'**
  String get systemHealthEventStatusAcknowledged;

  /// No description provided for @systemHealthEventStatusInvestigating.
  ///
  /// In en, this message translates to:
  /// **'Investigating'**
  String get systemHealthEventStatusInvestigating;

  /// No description provided for @systemHealthEventStatusResolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get systemHealthEventStatusResolved;

  /// No description provided for @systemHealthEventStatusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get systemHealthEventStatusUnknown;

  /// No description provided for @systemHealthImpactNone.
  ///
  /// In en, this message translates to:
  /// **'No tenant impact'**
  String get systemHealthImpactNone;

  /// No description provided for @systemHealthImpactSingleTenant.
  ///
  /// In en, this message translates to:
  /// **'Single tenant'**
  String get systemHealthImpactSingleTenant;

  /// No description provided for @systemHealthImpactMultipleTenants.
  ///
  /// In en, this message translates to:
  /// **'Multiple tenants'**
  String get systemHealthImpactMultipleTenants;

  /// No description provided for @systemHealthImpactPlatformWide.
  ///
  /// In en, this message translates to:
  /// **'Platform wide'**
  String get systemHealthImpactPlatformWide;

  /// No description provided for @systemHealthImpactUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown impact'**
  String get systemHealthImpactUnknown;

  /// No description provided for @systemHealthServiceBackendApi.
  ///
  /// In en, this message translates to:
  /// **'Backend API'**
  String get systemHealthServiceBackendApi;

  /// No description provided for @systemHealthServiceDatabase.
  ///
  /// In en, this message translates to:
  /// **'Database'**
  String get systemHealthServiceDatabase;

  /// No description provided for @systemHealthServiceDocumentStorage.
  ///
  /// In en, this message translates to:
  /// **'Document storage'**
  String get systemHealthServiceDocumentStorage;

  /// No description provided for @systemHealthServiceBackgroundWorkers.
  ///
  /// In en, this message translates to:
  /// **'Background workers'**
  String get systemHealthServiceBackgroundWorkers;

  /// No description provided for @systemHealthServiceAiOcrWorkers.
  ///
  /// In en, this message translates to:
  /// **'AI / OCR workers'**
  String get systemHealthServiceAiOcrWorkers;

  /// No description provided for @systemHealthServiceTranslationService.
  ///
  /// In en, this message translates to:
  /// **'Translation service'**
  String get systemHealthServiceTranslationService;

  /// No description provided for @systemHealthServiceEmailService.
  ///
  /// In en, this message translates to:
  /// **'Email service'**
  String get systemHealthServiceEmailService;

  /// No description provided for @systemHealthServicePushNotificationService.
  ///
  /// In en, this message translates to:
  /// **'Push notification service'**
  String get systemHealthServicePushNotificationService;

  /// No description provided for @systemHealthServiceQueueSystem.
  ///
  /// In en, this message translates to:
  /// **'Queue system'**
  String get systemHealthServiceQueueSystem;

  /// No description provided for @systemHealthServiceAuthService.
  ///
  /// In en, this message translates to:
  /// **'Auth service'**
  String get systemHealthServiceAuthService;

  /// No description provided for @systemHealthAiDiagnosticTitle.
  ///
  /// In en, this message translates to:
  /// **'AI diagnostic summary'**
  String get systemHealthAiDiagnosticTitle;

  /// No description provided for @systemHealthAiAdvisoryOnly.
  ///
  /// In en, this message translates to:
  /// **'Advisory only — not an automatic repair instruction.'**
  String get systemHealthAiAdvisoryOnly;

  /// No description provided for @systemHealthRecommendedAction.
  ///
  /// In en, this message translates to:
  /// **'Recommended action'**
  String get systemHealthRecommendedAction;

  /// No description provided for @systemHealthActionAcknowledgeTitle.
  ///
  /// In en, this message translates to:
  /// **'Acknowledge event'**
  String get systemHealthActionAcknowledgeTitle;

  /// No description provided for @systemHealthActionEscalateTitle.
  ///
  /// In en, this message translates to:
  /// **'Escalate event'**
  String get systemHealthActionEscalateTitle;

  /// No description provided for @systemHealthActionAuditNotice.
  ///
  /// In en, this message translates to:
  /// **'This action will be recorded in the platform audit log.'**
  String get systemHealthActionAuditNotice;

  /// No description provided for @systemHealthActionNoAutoRepair.
  ///
  /// In en, this message translates to:
  /// **'No automatic production repair will be performed.'**
  String get systemHealthActionNoAutoRepair;

  /// No description provided for @systemHealthActionNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Escalation note'**
  String get systemHealthActionNoteLabel;

  /// No description provided for @systemHealthActionNoteRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter at least 3 characters.'**
  String get systemHealthActionNoteRequired;

  /// No description provided for @systemHealthActionAcknowledgeBody.
  ///
  /// In en, this message translates to:
  /// **'Confirm acknowledgement of this health event.'**
  String get systemHealthActionAcknowledgeBody;

  /// No description provided for @systemHealthActionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get systemHealthActionCancel;

  /// No description provided for @systemHealthActionAcknowledgeConfirm.
  ///
  /// In en, this message translates to:
  /// **'Acknowledge'**
  String get systemHealthActionAcknowledgeConfirm;

  /// No description provided for @systemHealthActionEscalateConfirm.
  ///
  /// In en, this message translates to:
  /// **'Escalate'**
  String get systemHealthActionEscalateConfirm;

  /// No description provided for @systemHealthActionAcknowledge.
  ///
  /// In en, this message translates to:
  /// **'Acknowledge'**
  String get systemHealthActionAcknowledge;

  /// No description provided for @systemHealthActionEscalate.
  ///
  /// In en, this message translates to:
  /// **'Escalate to support'**
  String get systemHealthActionEscalate;

  /// No description provided for @systemHealthActionSuccess.
  ///
  /// In en, this message translates to:
  /// **'Health action saved.'**
  String get systemHealthActionSuccess;

  /// No description provided for @systemHealthActionError.
  ///
  /// In en, this message translates to:
  /// **'Could not save health action.'**
  String get systemHealthActionError;

  /// No description provided for @systemHealthCreateTicketDisabled.
  ///
  /// In en, this message translates to:
  /// **'Create support ticket (coming soon)'**
  String get systemHealthCreateTicketDisabled;

  /// No description provided for @systemHealthPrivacyNotice.
  ///
  /// In en, this message translates to:
  /// **'Metadata only — no tenant operational trip, document, or message content is shown.'**
  String get systemHealthPrivacyNotice;

  /// No description provided for @systemHealthFieldServiceName.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get systemHealthFieldServiceName;

  /// No description provided for @systemHealthFieldTenantImpact.
  ///
  /// In en, this message translates to:
  /// **'Tenant impact'**
  String get systemHealthFieldTenantImpact;

  /// No description provided for @systemHealthFieldAffectedCompany.
  ///
  /// In en, this message translates to:
  /// **'Affected company'**
  String get systemHealthFieldAffectedCompany;

  /// No description provided for @systemHealthFieldStartedAt.
  ///
  /// In en, this message translates to:
  /// **'Started'**
  String get systemHealthFieldStartedAt;

  /// No description provided for @systemHealthFieldLastSeenAt.
  ///
  /// In en, this message translates to:
  /// **'Last seen'**
  String get systemHealthFieldLastSeenAt;

  /// No description provided for @systemHealthFieldResolvedAt.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get systemHealthFieldResolvedAt;

  /// No description provided for @systemHealthFieldFailedJobs.
  ///
  /// In en, this message translates to:
  /// **'Failed jobs'**
  String get systemHealthFieldFailedJobs;

  /// No description provided for @systemHealthFieldCorrelationId.
  ///
  /// In en, this message translates to:
  /// **'Correlation ID'**
  String get systemHealthFieldCorrelationId;

  /// No description provided for @systemHealthCreateTicket.
  ///
  /// In en, this message translates to:
  /// **'Create support ticket'**
  String get systemHealthCreateTicket;

  /// No description provided for @supportLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load support data.'**
  String get supportLoadError;

  /// No description provided for @supportActionUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This support action is not available on the connected backend yet.'**
  String get supportActionUnavailable;

  /// No description provided for @supportActionError.
  ///
  /// In en, this message translates to:
  /// **'Could not save support action.'**
  String get supportActionError;

  /// No description provided for @supportActionSuccess.
  ///
  /// In en, this message translates to:
  /// **'Support action saved.'**
  String get supportActionSuccess;

  /// No description provided for @supportMockDataBadge.
  ///
  /// In en, this message translates to:
  /// **'Mock data'**
  String get supportMockDataBadge;

  /// No description provided for @supportOpenModule.
  ///
  /// In en, this message translates to:
  /// **'Open support module'**
  String get supportOpenModule;

  /// No description provided for @supportPrivacyNotice.
  ///
  /// In en, this message translates to:
  /// **'Metadata only — no tenant operational trip, document, or message content is shown by default.'**
  String get supportPrivacyNotice;

  /// No description provided for @supportActionAuditNotice.
  ///
  /// In en, this message translates to:
  /// **'This action will be recorded in the platform audit log.'**
  String get supportActionAuditNotice;

  /// No description provided for @supportActionNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get supportActionNoteLabel;

  /// No description provided for @supportActionNoteRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter at least 3 characters.'**
  String get supportActionNoteRequired;

  /// No description provided for @supportActionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get supportActionCancel;

  /// No description provided for @supportTicketSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search company, title, or requester email'**
  String get supportTicketSearchHint;

  /// No description provided for @supportTicketListEmpty.
  ///
  /// In en, this message translates to:
  /// **'No support tickets match your filters.'**
  String get supportTicketListEmpty;

  /// No description provided for @supportTicketLastActivity.
  ///
  /// In en, this message translates to:
  /// **'Last activity {date}'**
  String supportTicketLastActivity(String date);

  /// No description provided for @supportTicketDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Support ticket'**
  String get supportTicketDetailTitle;

  /// No description provided for @supportGrantDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Support access grant'**
  String get supportGrantDetailTitle;

  /// No description provided for @supportGrantSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search company, scope id, or requester'**
  String get supportGrantSearchHint;

  /// No description provided for @supportGrantListEmpty.
  ///
  /// In en, this message translates to:
  /// **'No support access grants match your filters.'**
  String get supportGrantListEmpty;

  /// No description provided for @supportGrantScopeIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Scope ID: {id}'**
  String supportGrantScopeIdLabel(String id);

  /// No description provided for @supportGrantExpiresAt.
  ///
  /// In en, this message translates to:
  /// **'Expires {date}'**
  String supportGrantExpiresAt(String date);

  /// No description provided for @supportSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Support overview'**
  String get supportSummaryTitle;

  /// No description provided for @supportSummaryOpenTickets.
  ///
  /// In en, this message translates to:
  /// **'Open tickets'**
  String get supportSummaryOpenTickets;

  /// No description provided for @supportSummaryUrgentCritical.
  ///
  /// In en, this message translates to:
  /// **'Urgent / critical'**
  String get supportSummaryUrgentCritical;

  /// No description provided for @supportSummaryActiveGrants.
  ///
  /// In en, this message translates to:
  /// **'Active grants'**
  String get supportSummaryActiveGrants;

  /// No description provided for @supportSummaryLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated {date}'**
  String supportSummaryLastUpdated(String date);

  /// No description provided for @supportTicketCreateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Support ticket created.'**
  String get supportTicketCreateSuccess;

  /// No description provided for @supportTicketFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get supportTicketFilterAll;

  /// No description provided for @supportTicketFilterOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get supportTicketFilterOpen;

  /// No description provided for @supportTicketFilterUrgent.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get supportTicketFilterUrgent;

  /// No description provided for @supportTicketFilterCritical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get supportTicketFilterCritical;

  /// No description provided for @supportTicketFilterSystemHealth.
  ///
  /// In en, this message translates to:
  /// **'System health'**
  String get supportTicketFilterSystemHealth;

  /// No description provided for @supportTicketFilterWaitingForCustomer.
  ///
  /// In en, this message translates to:
  /// **'Waiting for customer'**
  String get supportTicketFilterWaitingForCustomer;

  /// No description provided for @supportTicketFilterResolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get supportTicketFilterResolved;

  /// No description provided for @supportGrantFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get supportGrantFilterAll;

  /// No description provided for @supportGrantFilterPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get supportGrantFilterPending;

  /// No description provided for @supportGrantFilterActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get supportGrantFilterActive;

  /// No description provided for @supportGrantFilterExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get supportGrantFilterExpired;

  /// No description provided for @supportGrantFilterRevoked.
  ///
  /// In en, this message translates to:
  /// **'Revoked'**
  String get supportGrantFilterRevoked;

  /// No description provided for @supportTicketStatusOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get supportTicketStatusOpen;

  /// No description provided for @supportTicketStatusAcknowledged.
  ///
  /// In en, this message translates to:
  /// **'Acknowledged'**
  String get supportTicketStatusAcknowledged;

  /// No description provided for @supportTicketStatusInvestigating.
  ///
  /// In en, this message translates to:
  /// **'Investigating'**
  String get supportTicketStatusInvestigating;

  /// No description provided for @supportTicketStatusWaitingForCustomer.
  ///
  /// In en, this message translates to:
  /// **'Waiting for customer'**
  String get supportTicketStatusWaitingForCustomer;

  /// No description provided for @supportTicketStatusResolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get supportTicketStatusResolved;

  /// No description provided for @supportTicketStatusClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get supportTicketStatusClosed;

  /// No description provided for @supportTicketStatusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get supportTicketStatusUnknown;

  /// No description provided for @supportTicketPriorityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get supportTicketPriorityLow;

  /// No description provided for @supportTicketPriorityNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get supportTicketPriorityNormal;

  /// No description provided for @supportTicketPriorityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get supportTicketPriorityHigh;

  /// No description provided for @supportTicketPriorityUrgent.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get supportTicketPriorityUrgent;

  /// No description provided for @supportTicketPriorityCritical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get supportTicketPriorityCritical;

  /// No description provided for @supportTicketPriorityUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get supportTicketPriorityUnknown;

  /// No description provided for @supportTicketCategoryRegistration.
  ///
  /// In en, this message translates to:
  /// **'Registration'**
  String get supportTicketCategoryRegistration;

  /// No description provided for @supportTicketCategorySystemHealth.
  ///
  /// In en, this message translates to:
  /// **'System health'**
  String get supportTicketCategorySystemHealth;

  /// No description provided for @supportTicketCategoryUploadIssue.
  ///
  /// In en, this message translates to:
  /// **'Upload issue'**
  String get supportTicketCategoryUploadIssue;

  /// No description provided for @supportTicketCategoryBilling.
  ///
  /// In en, this message translates to:
  /// **'Billing'**
  String get supportTicketCategoryBilling;

  /// No description provided for @supportTicketCategoryAccess.
  ///
  /// In en, this message translates to:
  /// **'Access'**
  String get supportTicketCategoryAccess;

  /// No description provided for @supportTicketCategoryIntegration.
  ///
  /// In en, this message translates to:
  /// **'Integration'**
  String get supportTicketCategoryIntegration;

  /// No description provided for @supportTicketCategoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get supportTicketCategoryOther;

  /// No description provided for @supportTicketCategoryUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get supportTicketCategoryUnknown;

  /// No description provided for @supportGrantStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get supportGrantStatusPending;

  /// No description provided for @supportGrantStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get supportGrantStatusActive;

  /// No description provided for @supportGrantStatusExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get supportGrantStatusExpired;

  /// No description provided for @supportGrantStatusRevoked.
  ///
  /// In en, this message translates to:
  /// **'Revoked'**
  String get supportGrantStatusRevoked;

  /// No description provided for @supportGrantStatusDenied.
  ///
  /// In en, this message translates to:
  /// **'Denied'**
  String get supportGrantStatusDenied;

  /// No description provided for @supportGrantStatusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get supportGrantStatusUnknown;

  /// No description provided for @supportScopeCompanyMetadata.
  ///
  /// In en, this message translates to:
  /// **'Company metadata'**
  String get supportScopeCompanyMetadata;

  /// No description provided for @supportScopeSpecificTrip.
  ///
  /// In en, this message translates to:
  /// **'Specific trip'**
  String get supportScopeSpecificTrip;

  /// No description provided for @supportScopeSpecificDocumentIssue.
  ///
  /// In en, this message translates to:
  /// **'Specific document issue'**
  String get supportScopeSpecificDocumentIssue;

  /// No description provided for @supportScopeUploadQueueIssue.
  ///
  /// In en, this message translates to:
  /// **'Upload queue issue'**
  String get supportScopeUploadQueueIssue;

  /// No description provided for @supportScopeSystemHealthIssue.
  ///
  /// In en, this message translates to:
  /// **'System health issue'**
  String get supportScopeSystemHealthIssue;

  /// No description provided for @supportScopeIntegrationIssue.
  ///
  /// In en, this message translates to:
  /// **'Integration issue'**
  String get supportScopeIntegrationIssue;

  /// No description provided for @supportScopeBillingIssue.
  ///
  /// In en, this message translates to:
  /// **'Billing issue'**
  String get supportScopeBillingIssue;

  /// No description provided for @supportScopeUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown scope'**
  String get supportScopeUnknown;

  /// No description provided for @supportGrantWarningTitle.
  ///
  /// In en, this message translates to:
  /// **'Scoped support access'**
  String get supportGrantWarningTitle;

  /// No description provided for @supportGrantWarningBody.
  ///
  /// In en, this message translates to:
  /// **'Grants are temporary, scoped, and audit logged. No broad unlimited tenant access.'**
  String get supportGrantWarningBody;

  /// No description provided for @supportGrantAuditNotice.
  ///
  /// In en, this message translates to:
  /// **'This grants temporary scoped support access and will be audit logged.'**
  String get supportGrantAuditNotice;

  /// No description provided for @supportGrantCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Create support access grant'**
  String get supportGrantCreateTitle;

  /// No description provided for @supportGrantCreateWarning.
  ///
  /// In en, this message translates to:
  /// **'This grants temporary scoped support access and will be audit logged.'**
  String get supportGrantCreateWarning;

  /// No description provided for @supportGrantCreateConfirm.
  ///
  /// In en, this message translates to:
  /// **'Create grant'**
  String get supportGrantCreateConfirm;

  /// No description provided for @supportGrantCreateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Support access grant created.'**
  String get supportGrantCreateSuccess;

  /// No description provided for @supportGrantCompanyLabel.
  ///
  /// In en, this message translates to:
  /// **'Company: {name}'**
  String supportGrantCompanyLabel(String name);

  /// No description provided for @supportGrantScopeTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Scope type'**
  String get supportGrantScopeTypeLabel;

  /// No description provided for @supportGrantScopeIdFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Scope ID'**
  String get supportGrantScopeIdFieldLabel;

  /// No description provided for @supportGrantScopeIdRequired.
  ///
  /// In en, this message translates to:
  /// **'Scope ID is required for this scope type.'**
  String get supportGrantScopeIdRequired;

  /// No description provided for @supportGrantReasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get supportGrantReasonLabel;

  /// No description provided for @supportGrantReasonRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter at least 3 characters.'**
  String get supportGrantReasonRequired;

  /// No description provided for @supportGrantExpiryRequired.
  ///
  /// In en, this message translates to:
  /// **'Choose a valid expiry within 24 hours.'**
  String get supportGrantExpiryRequired;

  /// No description provided for @supportGrantBroadAccessRejected.
  ///
  /// In en, this message translates to:
  /// **'Broad or document access is not allowed.'**
  String get supportGrantBroadAccessRejected;

  /// No description provided for @supportGrantExpiryLabel.
  ///
  /// In en, this message translates to:
  /// **'Expiry'**
  String get supportGrantExpiryLabel;

  /// No description provided for @supportGrantExpiryTwoHours.
  ///
  /// In en, this message translates to:
  /// **'2 hours'**
  String get supportGrantExpiryTwoHours;

  /// No description provided for @supportGrantExpiryTwentyFourHours.
  ///
  /// In en, this message translates to:
  /// **'24 hours'**
  String get supportGrantExpiryTwentyFourHours;

  /// No description provided for @supportGrantRevokeTitle.
  ///
  /// In en, this message translates to:
  /// **'Revoke support access grant'**
  String get supportGrantRevokeTitle;

  /// No description provided for @supportGrantRevokeNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Revocation reason'**
  String get supportGrantRevokeNoteLabel;

  /// No description provided for @supportGrantRevokeConfirm.
  ///
  /// In en, this message translates to:
  /// **'Revoke grant'**
  String get supportGrantRevokeConfirm;

  /// No description provided for @supportGrantRevokeSuccess.
  ///
  /// In en, this message translates to:
  /// **'Support access grant revoked.'**
  String get supportGrantRevokeSuccess;

  /// No description provided for @supportGrantActionRevoke.
  ///
  /// In en, this message translates to:
  /// **'Revoke grant'**
  String get supportGrantActionRevoke;

  /// No description provided for @supportGrantFieldCompany.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get supportGrantFieldCompany;

  /// No description provided for @supportGrantFieldScopeId.
  ///
  /// In en, this message translates to:
  /// **'Scope ID'**
  String get supportGrantFieldScopeId;

  /// No description provided for @supportGrantFieldReason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get supportGrantFieldReason;

  /// No description provided for @supportGrantFieldAllowedCategories.
  ///
  /// In en, this message translates to:
  /// **'Allowed data categories'**
  String get supportGrantFieldAllowedCategories;

  /// No description provided for @supportGrantFieldExcludesDocuments.
  ///
  /// In en, this message translates to:
  /// **'Excludes sensitive documents'**
  String get supportGrantFieldExcludesDocuments;

  /// No description provided for @supportGrantFieldCreatedAt.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get supportGrantFieldCreatedAt;

  /// No description provided for @supportGrantFieldExpiresAt.
  ///
  /// In en, this message translates to:
  /// **'Expires'**
  String get supportGrantFieldExpiresAt;

  /// No description provided for @supportGrantFieldRevokedAt.
  ///
  /// In en, this message translates to:
  /// **'Revoked'**
  String get supportGrantFieldRevokedAt;

  /// No description provided for @supportGrantFieldApprovedBy.
  ///
  /// In en, this message translates to:
  /// **'Approved by'**
  String get supportGrantFieldApprovedBy;

  /// No description provided for @supportGrantFieldAuditLogId.
  ///
  /// In en, this message translates to:
  /// **'Audit log ID'**
  String get supportGrantFieldAuditLogId;

  /// No description provided for @supportGrantYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get supportGrantYes;

  /// No description provided for @supportGrantNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get supportGrantNo;

  /// No description provided for @supportTicketFieldCompany.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get supportTicketFieldCompany;

  /// No description provided for @supportTicketFieldRequester.
  ///
  /// In en, this message translates to:
  /// **'Requester'**
  String get supportTicketFieldRequester;

  /// No description provided for @supportTicketFieldCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get supportTicketFieldCategory;

  /// No description provided for @supportTicketFieldSummary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get supportTicketFieldSummary;

  /// No description provided for @supportTicketFieldCreatedAt.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get supportTicketFieldCreatedAt;

  /// No description provided for @supportTicketFieldUpdatedAt.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get supportTicketFieldUpdatedAt;

  /// No description provided for @supportTicketFieldLastActivity.
  ///
  /// In en, this message translates to:
  /// **'Last activity'**
  String get supportTicketFieldLastActivity;

  /// No description provided for @supportTicketFieldLinkedHealthEvent.
  ///
  /// In en, this message translates to:
  /// **'Linked health event'**
  String get supportTicketFieldLinkedHealthEvent;

  /// No description provided for @supportTicketFieldSupportGrant.
  ///
  /// In en, this message translates to:
  /// **'Support access grant'**
  String get supportTicketFieldSupportGrant;

  /// No description provided for @supportTicketActionAcknowledge.
  ///
  /// In en, this message translates to:
  /// **'Acknowledge'**
  String get supportTicketActionAcknowledge;

  /// No description provided for @supportTicketActionClose.
  ///
  /// In en, this message translates to:
  /// **'Close ticket'**
  String get supportTicketActionClose;

  /// No description provided for @supportTicketActionCreateGrant.
  ///
  /// In en, this message translates to:
  /// **'Create support access grant'**
  String get supportTicketActionCreateGrant;

  /// No description provided for @supportTicketActionAcknowledgeTitle.
  ///
  /// In en, this message translates to:
  /// **'Acknowledge ticket'**
  String get supportTicketActionAcknowledgeTitle;

  /// No description provided for @supportTicketActionCloseTitle.
  ///
  /// In en, this message translates to:
  /// **'Close ticket'**
  String get supportTicketActionCloseTitle;

  /// No description provided for @supportTicketActionAcknowledgeBody.
  ///
  /// In en, this message translates to:
  /// **'Confirm acknowledgement of this support ticket.'**
  String get supportTicketActionAcknowledgeBody;

  /// No description provided for @supportTicketActionAcknowledgeConfirm.
  ///
  /// In en, this message translates to:
  /// **'Acknowledge'**
  String get supportTicketActionAcknowledgeConfirm;

  /// No description provided for @supportTicketActionCloseConfirm.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get supportTicketActionCloseConfirm;

  /// No description provided for @auditLogLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load audit logs.'**
  String get auditLogLoadError;

  /// No description provided for @auditLogMockDataBadge.
  ///
  /// In en, this message translates to:
  /// **'Mock data'**
  String get auditLogMockDataBadge;

  /// No description provided for @auditLogOpenModule.
  ///
  /// In en, this message translates to:
  /// **'Open audit logs'**
  String get auditLogOpenModule;

  /// No description provided for @auditLogSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search actor email, company, target id, or correlation id'**
  String get auditLogSearchHint;

  /// No description provided for @auditLogListEmpty.
  ///
  /// In en, this message translates to:
  /// **'No audit logs match your filters.'**
  String get auditLogListEmpty;

  /// No description provided for @auditLogDateRangeLabel.
  ///
  /// In en, this message translates to:
  /// **'Filter by date range'**
  String get auditLogDateRangeLabel;

  /// No description provided for @auditLogDateRangeSelected.
  ///
  /// In en, this message translates to:
  /// **'{from} – {to}'**
  String auditLogDateRangeSelected(String from, String to);

  /// No description provided for @auditLogDateRangeClear.
  ///
  /// In en, this message translates to:
  /// **'Clear dates'**
  String get auditLogDateRangeClear;

  /// No description provided for @auditLogDateRangeComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Date range filter (coming soon)'**
  String get auditLogDateRangeComingSoon;

  /// No description provided for @auditLogExportCsv.
  ///
  /// In en, this message translates to:
  /// **'Export metadata CSV'**
  String get auditLogExportCsv;

  /// No description provided for @auditLogExportCopied.
  ///
  /// In en, this message translates to:
  /// **'Audit log export copied to clipboard.'**
  String get auditLogExportCopied;

  /// No description provided for @auditLogExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not export audit logs.'**
  String get auditLogExportFailed;

  /// No description provided for @auditLogExportUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Audit log export is unavailable.'**
  String get auditLogExportUnavailable;

  /// No description provided for @auditLogExportSafetyNotice.
  ///
  /// In en, this message translates to:
  /// **'Exports include metadata only. No trip, document, or message content is included.'**
  String get auditLogExportSafetyNotice;

  /// No description provided for @auditLogTimestampLabel.
  ///
  /// In en, this message translates to:
  /// **'{date}'**
  String auditLogTimestampLabel(String date);

  /// No description provided for @auditLogDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Audit log entry'**
  String get auditLogDetailTitle;

  /// No description provided for @auditLogPrivacyNotice.
  ///
  /// In en, this message translates to:
  /// **'Metadata only — no tenant operational trip, document, or message content is shown.'**
  String get auditLogPrivacyNotice;

  /// No description provided for @auditLogExportDisabled.
  ///
  /// In en, this message translates to:
  /// **'Export audit log (coming soon)'**
  String get auditLogExportDisabled;

  /// No description provided for @auditLogSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent audit activity'**
  String get auditLogSummaryTitle;

  /// No description provided for @auditLogSummaryLastCritical.
  ///
  /// In en, this message translates to:
  /// **'Last critical event'**
  String get auditLogSummaryLastCritical;

  /// No description provided for @auditLogSummaryNoCritical.
  ///
  /// In en, this message translates to:
  /// **'No critical events'**
  String get auditLogSummaryNoCritical;

  /// No description provided for @auditLogSummaryFailedDenied.
  ///
  /// In en, this message translates to:
  /// **'Failed / denied'**
  String get auditLogSummaryFailedDenied;

  /// No description provided for @auditLogSummaryRecentActions.
  ///
  /// In en, this message translates to:
  /// **'Recent platform actions'**
  String get auditLogSummaryRecentActions;

  /// No description provided for @auditLogSummaryLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated {date}'**
  String auditLogSummaryLastUpdated(String date);

  /// No description provided for @auditLogFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get auditLogFilterAll;

  /// No description provided for @auditLogFilterCritical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get auditLogFilterCritical;

  /// No description provided for @auditLogFilterWarning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get auditLogFilterWarning;

  /// No description provided for @auditLogFilterFailures.
  ///
  /// In en, this message translates to:
  /// **'Failures'**
  String get auditLogFilterFailures;

  /// No description provided for @auditLogFilterDenied.
  ///
  /// In en, this message translates to:
  /// **'Denied'**
  String get auditLogFilterDenied;

  /// No description provided for @auditLogFilterRegistration.
  ///
  /// In en, this message translates to:
  /// **'Registration'**
  String get auditLogFilterRegistration;

  /// No description provided for @auditLogFilterSupportAccess.
  ///
  /// In en, this message translates to:
  /// **'Support access'**
  String get auditLogFilterSupportAccess;

  /// No description provided for @auditLogFilterSystemHealth.
  ///
  /// In en, this message translates to:
  /// **'System health'**
  String get auditLogFilterSystemHealth;

  /// No description provided for @auditLogFilterSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get auditLogFilterSecurity;

  /// No description provided for @auditLogResultSuccess.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get auditLogResultSuccess;

  /// No description provided for @auditLogResultFailure.
  ///
  /// In en, this message translates to:
  /// **'Failure'**
  String get auditLogResultFailure;

  /// No description provided for @auditLogResultDenied.
  ///
  /// In en, this message translates to:
  /// **'Denied'**
  String get auditLogResultDenied;

  /// No description provided for @auditLogResultPartial.
  ///
  /// In en, this message translates to:
  /// **'Partial'**
  String get auditLogResultPartial;

  /// No description provided for @auditLogResultUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get auditLogResultUnknown;

  /// No description provided for @auditLogSeverityInfo.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get auditLogSeverityInfo;

  /// No description provided for @auditLogSeverityWarning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get auditLogSeverityWarning;

  /// No description provided for @auditLogSeverityCritical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get auditLogSeverityCritical;

  /// No description provided for @auditLogSeverityUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get auditLogSeverityUnknown;

  /// No description provided for @auditLogActionLogin.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get auditLogActionLogin;

  /// No description provided for @auditLogActionLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get auditLogActionLogout;

  /// No description provided for @auditLogActionLoginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get auditLogActionLoginFailed;

  /// No description provided for @auditLogActionRegistrationApproved.
  ///
  /// In en, this message translates to:
  /// **'Registration approved'**
  String get auditLogActionRegistrationApproved;

  /// No description provided for @auditLogActionRegistrationRejected.
  ///
  /// In en, this message translates to:
  /// **'Registration rejected'**
  String get auditLogActionRegistrationRejected;

  /// No description provided for @auditLogActionRegistrationInfoRequested.
  ///
  /// In en, this message translates to:
  /// **'Registration info requested'**
  String get auditLogActionRegistrationInfoRequested;

  /// No description provided for @auditLogActionSupportTicketAcknowledged.
  ///
  /// In en, this message translates to:
  /// **'Support ticket acknowledged'**
  String get auditLogActionSupportTicketAcknowledged;

  /// No description provided for @auditLogActionSupportTicketClosed.
  ///
  /// In en, this message translates to:
  /// **'Support ticket closed'**
  String get auditLogActionSupportTicketClosed;

  /// No description provided for @auditLogActionSupportAccessGranted.
  ///
  /// In en, this message translates to:
  /// **'Support access granted'**
  String get auditLogActionSupportAccessGranted;

  /// No description provided for @auditLogActionSupportAccessRevoked.
  ///
  /// In en, this message translates to:
  /// **'Support access revoked'**
  String get auditLogActionSupportAccessRevoked;

  /// No description provided for @auditLogActionSystemHealthAcknowledged.
  ///
  /// In en, this message translates to:
  /// **'System health acknowledged'**
  String get auditLogActionSystemHealthAcknowledged;

  /// No description provided for @auditLogActionSystemHealthEscalated.
  ///
  /// In en, this message translates to:
  /// **'System health escalated'**
  String get auditLogActionSystemHealthEscalated;

  /// No description provided for @auditLogActionBillingUpdated.
  ///
  /// In en, this message translates to:
  /// **'Billing updated'**
  String get auditLogActionBillingUpdated;

  /// No description provided for @auditLogActionRoleChanged.
  ///
  /// In en, this message translates to:
  /// **'Role changed'**
  String get auditLogActionRoleChanged;

  /// No description provided for @auditLogActionPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Permission denied'**
  String get auditLogActionPermissionDenied;

  /// No description provided for @auditLogActionExportRequested.
  ///
  /// In en, this message translates to:
  /// **'Export requested'**
  String get auditLogActionExportRequested;

  /// No description provided for @auditLogActionApiKeyCreated.
  ///
  /// In en, this message translates to:
  /// **'API key created'**
  String get auditLogActionApiKeyCreated;

  /// No description provided for @auditLogActionApiKeyRevoked.
  ///
  /// In en, this message translates to:
  /// **'API key revoked'**
  String get auditLogActionApiKeyRevoked;

  /// No description provided for @auditLogActionUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown action'**
  String get auditLogActionUnknown;

  /// No description provided for @auditLogFieldTimestamp.
  ///
  /// In en, this message translates to:
  /// **'Timestamp'**
  String get auditLogFieldTimestamp;

  /// No description provided for @auditLogFieldActor.
  ///
  /// In en, this message translates to:
  /// **'Actor'**
  String get auditLogFieldActor;

  /// No description provided for @auditLogFieldActorRole.
  ///
  /// In en, this message translates to:
  /// **'Actor role'**
  String get auditLogFieldActorRole;

  /// No description provided for @auditLogFieldTargetType.
  ///
  /// In en, this message translates to:
  /// **'Target type'**
  String get auditLogFieldTargetType;

  /// No description provided for @auditLogFieldTargetId.
  ///
  /// In en, this message translates to:
  /// **'Target ID'**
  String get auditLogFieldTargetId;

  /// No description provided for @auditLogFieldCompany.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get auditLogFieldCompany;

  /// No description provided for @auditLogFieldTenantId.
  ///
  /// In en, this message translates to:
  /// **'Tenant ID'**
  String get auditLogFieldTenantId;

  /// No description provided for @auditLogFieldReason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get auditLogFieldReason;

  /// No description provided for @auditLogFieldNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get auditLogFieldNote;

  /// No description provided for @auditLogFieldIpAddress.
  ///
  /// In en, this message translates to:
  /// **'IP address'**
  String get auditLogFieldIpAddress;

  /// No description provided for @auditLogFieldDeviceLabel.
  ///
  /// In en, this message translates to:
  /// **'Device'**
  String get auditLogFieldDeviceLabel;

  /// No description provided for @auditLogFieldCorrelationId.
  ///
  /// In en, this message translates to:
  /// **'Correlation ID'**
  String get auditLogFieldCorrelationId;

  /// No description provided for @auditLogFieldRegistrationApplicationId.
  ///
  /// In en, this message translates to:
  /// **'Registration application ID'**
  String get auditLogFieldRegistrationApplicationId;

  /// No description provided for @auditLogFieldSupportAccessGrantId.
  ///
  /// In en, this message translates to:
  /// **'Support access grant ID'**
  String get auditLogFieldSupportAccessGrantId;

  /// No description provided for @auditLogFieldSystemHealthEventId.
  ///
  /// In en, this message translates to:
  /// **'System health event ID'**
  String get auditLogFieldSystemHealthEventId;

  /// No description provided for @auditLogDetailLoaded.
  ///
  /// In en, this message translates to:
  /// **'Audit log detail loaded.'**
  String get auditLogDetailLoaded;

  /// No description provided for @supportTicketAcknowledgedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Ticket acknowledged.'**
  String get supportTicketAcknowledgedSuccess;

  /// No description provided for @supportTicketClosedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Ticket closed.'**
  String get supportTicketClosedSuccess;

  /// No description provided for @supportGrantRevokedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Grant revoked.'**
  String get supportGrantRevokedSuccess;

  /// No description provided for @systemHealthEventAcknowledgedSuccess.
  ///
  /// In en, this message translates to:
  /// **'System health event acknowledged.'**
  String get systemHealthEventAcknowledgedSuccess;

  /// No description provided for @systemHealthEventEscalatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'System health event escalated.'**
  String get systemHealthEventEscalatedSuccess;

  /// No description provided for @backendActionUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Action not available on this backend yet.'**
  String get backendActionUnavailable;

  /// No description provided for @bulkOnboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Bulk onboarding'**
  String get bulkOnboardingTitle;

  /// No description provided for @bulkOnboardingDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Bulk onboarding job'**
  String get bulkOnboardingDetailTitle;

  /// No description provided for @bulkOnboardingRowsTitle.
  ///
  /// In en, this message translates to:
  /// **'Import rows'**
  String get bulkOnboardingRowsTitle;

  /// No description provided for @bulkOnboardingMockDataBadge.
  ///
  /// In en, this message translates to:
  /// **'Mock data'**
  String get bulkOnboardingMockDataBadge;

  /// No description provided for @bulkOnboardingSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by company, file, or job ID'**
  String get bulkOnboardingSearchHint;

  /// No description provided for @bulkOnboardingListEmpty.
  ///
  /// In en, this message translates to:
  /// **'No bulk onboarding jobs match your filters.'**
  String get bulkOnboardingListEmpty;

  /// No description provided for @bulkOnboardingListError.
  ///
  /// In en, this message translates to:
  /// **'Could not load bulk onboarding jobs.'**
  String get bulkOnboardingListError;

  /// No description provided for @bulkOnboardingDetailError.
  ///
  /// In en, this message translates to:
  /// **'Could not load bulk onboarding job.'**
  String get bulkOnboardingDetailError;

  /// No description provided for @bulkOnboardingRowsError.
  ///
  /// In en, this message translates to:
  /// **'Could not load import rows.'**
  String get bulkOnboardingRowsError;

  /// No description provided for @bulkOnboardingRowsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No rows match this filter.'**
  String get bulkOnboardingRowsEmpty;

  /// No description provided for @bulkOnboardingPrivacyNotice.
  ///
  /// In en, this message translates to:
  /// **'Metadata only. Tenant operational trip, document, and message content is never shown here.'**
  String get bulkOnboardingPrivacyNotice;

  /// No description provided for @bulkOnboardingOpenModule.
  ///
  /// In en, this message translates to:
  /// **'Open bulk onboarding'**
  String get bulkOnboardingOpenModule;

  /// No description provided for @bulkOnboardingOpenRows.
  ///
  /// In en, this message translates to:
  /// **'View rows'**
  String get bulkOnboardingOpenRows;

  /// No description provided for @bulkOnboardingNoSourceFile.
  ///
  /// In en, this message translates to:
  /// **'No source file name'**
  String get bulkOnboardingNoSourceFile;

  /// No description provided for @bulkOnboardingFieldSourceFile.
  ///
  /// In en, this message translates to:
  /// **'Source file'**
  String get bulkOnboardingFieldSourceFile;

  /// No description provided for @bulkOnboardingDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Bulk onboarding'**
  String get bulkOnboardingDashboardTitle;

  /// No description provided for @bulkOnboardingDashboardWaitingReview.
  ///
  /// In en, this message translates to:
  /// **'Waiting for review'**
  String get bulkOnboardingDashboardWaitingReview;

  /// No description provided for @bulkOnboardingDashboardHighRisk.
  ///
  /// In en, this message translates to:
  /// **'High-risk jobs'**
  String get bulkOnboardingDashboardHighRisk;

  /// No description provided for @bulkOnboardingDashboardInvalidRows.
  ///
  /// In en, this message translates to:
  /// **'Invalid rows'**
  String get bulkOnboardingDashboardInvalidRows;

  /// No description provided for @bulkOnboardingDashboardProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing jobs'**
  String get bulkOnboardingDashboardProcessing;

  /// No description provided for @bulkOnboardingFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get bulkOnboardingFilterAll;

  /// No description provided for @bulkOnboardingFilterReadyForReview.
  ///
  /// In en, this message translates to:
  /// **'Ready for review'**
  String get bulkOnboardingFilterReadyForReview;

  /// No description provided for @bulkOnboardingFilterValidationFailed.
  ///
  /// In en, this message translates to:
  /// **'Validation failed'**
  String get bulkOnboardingFilterValidationFailed;

  /// No description provided for @bulkOnboardingFilterProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get bulkOnboardingFilterProcessing;

  /// No description provided for @bulkOnboardingFilterCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get bulkOnboardingFilterCompleted;

  /// No description provided for @bulkOnboardingFilterRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get bulkOnboardingFilterRejected;

  /// No description provided for @bulkOnboardingFilterHighRisk.
  ///
  /// In en, this message translates to:
  /// **'High risk'**
  String get bulkOnboardingFilterHighRisk;

  /// No description provided for @bulkOnboardingStatusDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get bulkOnboardingStatusDraft;

  /// No description provided for @bulkOnboardingStatusUploaded.
  ///
  /// In en, this message translates to:
  /// **'Uploaded'**
  String get bulkOnboardingStatusUploaded;

  /// No description provided for @bulkOnboardingStatusValidating.
  ///
  /// In en, this message translates to:
  /// **'Validating'**
  String get bulkOnboardingStatusValidating;

  /// No description provided for @bulkOnboardingStatusValidationFailed.
  ///
  /// In en, this message translates to:
  /// **'Validation failed'**
  String get bulkOnboardingStatusValidationFailed;

  /// No description provided for @bulkOnboardingStatusReadyForReview.
  ///
  /// In en, this message translates to:
  /// **'Ready for review'**
  String get bulkOnboardingStatusReadyForReview;

  /// No description provided for @bulkOnboardingStatusApprovedForProcessing.
  ///
  /// In en, this message translates to:
  /// **'Approved for processing'**
  String get bulkOnboardingStatusApprovedForProcessing;

  /// No description provided for @bulkOnboardingStatusProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get bulkOnboardingStatusProcessing;

  /// No description provided for @bulkOnboardingStatusPartiallyCompleted.
  ///
  /// In en, this message translates to:
  /// **'Partially completed'**
  String get bulkOnboardingStatusPartiallyCompleted;

  /// No description provided for @bulkOnboardingStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get bulkOnboardingStatusCompleted;

  /// No description provided for @bulkOnboardingStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get bulkOnboardingStatusRejected;

  /// No description provided for @bulkOnboardingStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get bulkOnboardingStatusCancelled;

  /// No description provided for @bulkOnboardingStatusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get bulkOnboardingStatusUnknown;

  /// No description provided for @bulkOnboardingRowStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get bulkOnboardingRowStatusPending;

  /// No description provided for @bulkOnboardingRowStatusValid.
  ///
  /// In en, this message translates to:
  /// **'Valid'**
  String get bulkOnboardingRowStatusValid;

  /// No description provided for @bulkOnboardingRowStatusWarning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get bulkOnboardingRowStatusWarning;

  /// No description provided for @bulkOnboardingRowStatusInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid'**
  String get bulkOnboardingRowStatusInvalid;

  /// No description provided for @bulkOnboardingRowStatusDuplicate.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get bulkOnboardingRowStatusDuplicate;

  /// No description provided for @bulkOnboardingRowStatusApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get bulkOnboardingRowStatusApproved;

  /// No description provided for @bulkOnboardingRowStatusSkipped.
  ///
  /// In en, this message translates to:
  /// **'Skipped'**
  String get bulkOnboardingRowStatusSkipped;

  /// No description provided for @bulkOnboardingRowStatusProcessed.
  ///
  /// In en, this message translates to:
  /// **'Processed'**
  String get bulkOnboardingRowStatusProcessed;

  /// No description provided for @bulkOnboardingRowStatusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get bulkOnboardingRowStatusFailed;

  /// No description provided for @bulkOnboardingRowStatusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get bulkOnboardingRowStatusUnknown;

  /// No description provided for @bulkOnboardingTypeCompanyUsers.
  ///
  /// In en, this message translates to:
  /// **'Company users'**
  String get bulkOnboardingTypeCompanyUsers;

  /// No description provided for @bulkOnboardingTypeDrivers.
  ///
  /// In en, this message translates to:
  /// **'Drivers'**
  String get bulkOnboardingTypeDrivers;

  /// No description provided for @bulkOnboardingTypeVehicles.
  ///
  /// In en, this message translates to:
  /// **'Vehicles'**
  String get bulkOnboardingTypeVehicles;

  /// No description provided for @bulkOnboardingTypeTrailers.
  ///
  /// In en, this message translates to:
  /// **'Trailers'**
  String get bulkOnboardingTypeTrailers;

  /// No description provided for @bulkOnboardingTypeMixedCompanyImport.
  ///
  /// In en, this message translates to:
  /// **'Mixed company import'**
  String get bulkOnboardingTypeMixedCompanyImport;

  /// No description provided for @bulkOnboardingTypeUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown type'**
  String get bulkOnboardingTypeUnknown;

  /// No description provided for @bulkOnboardingRiskLow.
  ///
  /// In en, this message translates to:
  /// **'Low risk'**
  String get bulkOnboardingRiskLow;

  /// No description provided for @bulkOnboardingRiskMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium risk'**
  String get bulkOnboardingRiskMedium;

  /// No description provided for @bulkOnboardingRiskHigh.
  ///
  /// In en, this message translates to:
  /// **'High risk'**
  String get bulkOnboardingRiskHigh;

  /// No description provided for @bulkOnboardingRiskUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown risk'**
  String get bulkOnboardingRiskUnknown;

  /// No description provided for @bulkOnboardingMetricTotalRows.
  ///
  /// In en, this message translates to:
  /// **'Total rows: {count}'**
  String bulkOnboardingMetricTotalRows(String count);

  /// No description provided for @bulkOnboardingMetricValidRows.
  ///
  /// In en, this message translates to:
  /// **'Valid: {count}'**
  String bulkOnboardingMetricValidRows(String count);

  /// No description provided for @bulkOnboardingMetricWarningRows.
  ///
  /// In en, this message translates to:
  /// **'Warnings: {count}'**
  String bulkOnboardingMetricWarningRows(String count);

  /// No description provided for @bulkOnboardingMetricInvalidRows.
  ///
  /// In en, this message translates to:
  /// **'Invalid: {count}'**
  String bulkOnboardingMetricInvalidRows(String count);

  /// No description provided for @bulkOnboardingMetricDuplicateRows.
  ///
  /// In en, this message translates to:
  /// **'Duplicates: {count}'**
  String bulkOnboardingMetricDuplicateRows(String count);

  /// No description provided for @bulkOnboardingValidationSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Validation summary'**
  String get bulkOnboardingValidationSummaryTitle;

  /// No description provided for @bulkOnboardingValidationErrors.
  ///
  /// In en, this message translates to:
  /// **'Validation errors'**
  String get bulkOnboardingValidationErrors;

  /// No description provided for @bulkOnboardingDuplicateReason.
  ///
  /// In en, this message translates to:
  /// **'Duplicate: {reason}'**
  String bulkOnboardingDuplicateReason(String reason);

  /// No description provided for @bulkOnboardingAiReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'AI review (advisory)'**
  String get bulkOnboardingAiReviewTitle;

  /// No description provided for @bulkOnboardingAiAdvisoryNotice.
  ///
  /// In en, this message translates to:
  /// **'Recommendations are advisory only. Human approval is required.'**
  String get bulkOnboardingAiAdvisoryNotice;

  /// No description provided for @bulkOnboardingRecommendedAction.
  ///
  /// In en, this message translates to:
  /// **'Recommended action: {action}'**
  String bulkOnboardingRecommendedAction(String action);

  /// No description provided for @bulkOnboardingRowFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All rows'**
  String get bulkOnboardingRowFilterAll;

  /// No description provided for @bulkOnboardingRowFilterInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid'**
  String get bulkOnboardingRowFilterInvalid;

  /// No description provided for @bulkOnboardingRowFilterWarning.
  ///
  /// In en, this message translates to:
  /// **'Warnings'**
  String get bulkOnboardingRowFilterWarning;

  /// No description provided for @bulkOnboardingRowFilterDuplicate.
  ///
  /// In en, this message translates to:
  /// **'Duplicates'**
  String get bulkOnboardingRowFilterDuplicate;

  /// No description provided for @bulkOnboardingActionValidate.
  ///
  /// In en, this message translates to:
  /// **'Validate'**
  String get bulkOnboardingActionValidate;

  /// No description provided for @bulkOnboardingActionApprove.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get bulkOnboardingActionApprove;

  /// No description provided for @bulkOnboardingActionReject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get bulkOnboardingActionReject;

  /// No description provided for @bulkOnboardingActionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get bulkOnboardingActionCancel;

  /// No description provided for @bulkOnboardingActionProcess.
  ///
  /// In en, this message translates to:
  /// **'Process'**
  String get bulkOnboardingActionProcess;

  /// No description provided for @bulkOnboardingProcessDisabled.
  ///
  /// In en, this message translates to:
  /// **'Processing unavailable'**
  String get bulkOnboardingProcessDisabled;

  /// No description provided for @bulkOnboardingProcessUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Processing is not available for this job.'**
  String get bulkOnboardingProcessUnavailable;

  /// No description provided for @bulkOnboardingActionUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This action is unavailable right now.'**
  String get bulkOnboardingActionUnavailable;

  /// No description provided for @bulkOnboardingActionSuccess.
  ///
  /// In en, this message translates to:
  /// **'Action recorded and audit logged.'**
  String get bulkOnboardingActionSuccess;

  /// No description provided for @bulkOnboardingActionAuditNotice.
  ///
  /// In en, this message translates to:
  /// **'This action is audit logged and may affect tenant onboarding.'**
  String get bulkOnboardingActionAuditNotice;

  /// No description provided for @bulkOnboardingActionNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Reason / note'**
  String get bulkOnboardingActionNoteLabel;

  /// No description provided for @bulkOnboardingActionOptionalNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Optional note'**
  String get bulkOnboardingActionOptionalNoteLabel;

  /// No description provided for @bulkOnboardingActionNoteRequired.
  ///
  /// In en, this message translates to:
  /// **'A reason is required.'**
  String get bulkOnboardingActionNoteRequired;

  /// No description provided for @bulkOnboardingActionConfirmRequired.
  ///
  /// In en, this message translates to:
  /// **'Explicit confirmation is required.'**
  String get bulkOnboardingActionConfirmRequired;

  /// No description provided for @bulkOnboardingActionExplicitConfirm.
  ///
  /// In en, this message translates to:
  /// **'I confirm this sensitive processing action.'**
  String get bulkOnboardingActionExplicitConfirm;

  /// No description provided for @bulkOnboardingActionDismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get bulkOnboardingActionDismiss;

  /// No description provided for @bulkOnboardingActionValidateTitle.
  ///
  /// In en, this message translates to:
  /// **'Validate import'**
  String get bulkOnboardingActionValidateTitle;

  /// No description provided for @bulkOnboardingActionApproveTitle.
  ///
  /// In en, this message translates to:
  /// **'Approve for processing'**
  String get bulkOnboardingActionApproveTitle;

  /// No description provided for @bulkOnboardingActionRejectTitle.
  ///
  /// In en, this message translates to:
  /// **'Reject import job'**
  String get bulkOnboardingActionRejectTitle;

  /// No description provided for @bulkOnboardingActionCancelTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel import job'**
  String get bulkOnboardingActionCancelTitle;

  /// No description provided for @bulkOnboardingActionProcessTitle.
  ///
  /// In en, this message translates to:
  /// **'Process approved import'**
  String get bulkOnboardingActionProcessTitle;

  /// No description provided for @bulkOnboardingActionValidateConfirm.
  ///
  /// In en, this message translates to:
  /// **'Run validation'**
  String get bulkOnboardingActionValidateConfirm;

  /// No description provided for @bulkOnboardingActionApproveConfirm.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get bulkOnboardingActionApproveConfirm;

  /// No description provided for @bulkOnboardingActionRejectConfirm.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get bulkOnboardingActionRejectConfirm;

  /// No description provided for @bulkOnboardingActionCancelConfirm.
  ///
  /// In en, this message translates to:
  /// **'Cancel job'**
  String get bulkOnboardingActionCancelConfirm;

  /// No description provided for @bulkOnboardingActionProcessConfirm.
  ///
  /// In en, this message translates to:
  /// **'Start processing'**
  String get bulkOnboardingActionProcessConfirm;

  /// No description provided for @bulkOnboardingDryRunAction.
  ///
  /// In en, this message translates to:
  /// **'Dry run'**
  String get bulkOnboardingDryRunAction;

  /// No description provided for @bulkOnboardingExecuteAction.
  ///
  /// In en, this message translates to:
  /// **'Execute'**
  String get bulkOnboardingExecuteAction;

  /// No description provided for @bulkOnboardingExecuteDisabled.
  ///
  /// In en, this message translates to:
  /// **'Execution unavailable'**
  String get bulkOnboardingExecuteDisabled;

  /// No description provided for @bulkOnboardingDryRunSuccess.
  ///
  /// In en, this message translates to:
  /// **'Dry run completed.'**
  String get bulkOnboardingDryRunSuccess;

  /// No description provided for @bulkOnboardingExecuteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Execution started and audit logged.'**
  String get bulkOnboardingExecuteSuccess;

  /// No description provided for @bulkOnboardingProvisioningTitle.
  ///
  /// In en, this message translates to:
  /// **'Provisioning'**
  String get bulkOnboardingProvisioningTitle;

  /// No description provided for @bulkOnboardingProvisioningStatus.
  ///
  /// In en, this message translates to:
  /// **'Provisioning status: {status}'**
  String bulkOnboardingProvisioningStatus(Object status);

  /// No description provided for @bulkOnboardingExecutePolicyDisabled.
  ///
  /// In en, this message translates to:
  /// **'Execution policy blocked: {reason}'**
  String bulkOnboardingExecutePolicyDisabled(Object reason);

  /// No description provided for @bulkOnboardingExecuteDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Execute provisioning'**
  String get bulkOnboardingExecuteDialogTitle;

  /// No description provided for @bulkOnboardingExecuteMetadataNotice.
  ///
  /// In en, this message translates to:
  /// **'Metadata only is shown here. Tenant operational content is not exposed.'**
  String get bulkOnboardingExecuteMetadataNotice;

  /// No description provided for @bulkOnboardingExecuteIrreversibleWarning.
  ///
  /// In en, this message translates to:
  /// **'This action is irreversible and may provision real entities.'**
  String get bulkOnboardingExecuteIrreversibleWarning;

  /// No description provided for @bulkOnboardingExecuteRowWindow.
  ///
  /// In en, this message translates to:
  /// **'Rows to execute: {count} / max {maxRows}'**
  String bulkOnboardingExecuteRowWindow(Object count, Object maxRows);

  /// No description provided for @bulkOnboardingExecuteReasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Execution reason'**
  String get bulkOnboardingExecuteReasonLabel;

  /// No description provided for @bulkOnboardingExecuteReasonRequired.
  ///
  /// In en, this message translates to:
  /// **'Execution reason is required.'**
  String get bulkOnboardingExecuteReasonRequired;

  /// No description provided for @bulkOnboardingExecuteConfirmRequired.
  ///
  /// In en, this message translates to:
  /// **'You must confirm execution.'**
  String get bulkOnboardingExecuteConfirmRequired;

  /// No description provided for @bulkOnboardingExecuteConfirmCheckbox.
  ///
  /// In en, this message translates to:
  /// **'I understand this cannot be undone.'**
  String get bulkOnboardingExecuteConfirmCheckbox;

  /// No description provided for @bulkOnboardingExecuteConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Execute now'**
  String get bulkOnboardingExecuteConfirmAction;

  /// No description provided for @bulkOnboardingSummaryDryRunOk.
  ///
  /// In en, this message translates to:
  /// **'Dry run ok'**
  String get bulkOnboardingSummaryDryRunOk;

  /// No description provided for @bulkOnboardingSummaryBlocked.
  ///
  /// In en, this message translates to:
  /// **'Blocked'**
  String get bulkOnboardingSummaryBlocked;

  /// No description provided for @bulkOnboardingSummaryDuplicates.
  ///
  /// In en, this message translates to:
  /// **'Duplicates'**
  String get bulkOnboardingSummaryDuplicates;

  /// No description provided for @bulkOnboardingSummaryFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get bulkOnboardingSummaryFailed;

  /// No description provided for @bulkOnboardingSummaryProvisioned.
  ///
  /// In en, this message translates to:
  /// **'Provisioned'**
  String get bulkOnboardingSummaryProvisioned;

  /// No description provided for @bulkOnboardingRowExecutionStatusesTitle.
  ///
  /// In en, this message translates to:
  /// **'Row execution statuses'**
  String get bulkOnboardingRowExecutionStatusesTitle;

  /// No description provided for @bulkOnboardingExecuteRejectedPolicy.
  ///
  /// In en, this message translates to:
  /// **'Execution rejected by policy. Review row limits and job readiness.'**
  String get bulkOnboardingExecuteRejectedPolicy;

  /// No description provided for @bulkOnboardingExecuteRejectedValidation.
  ///
  /// In en, this message translates to:
  /// **'Execution rejected by backend validation.'**
  String get bulkOnboardingExecuteRejectedValidation;

  /// No description provided for @bulkOnboardingExecuteForbidden.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to execute this job.'**
  String get bulkOnboardingExecuteForbidden;

  /// No description provided for @bulkOnboardingUploadCsv.
  ///
  /// In en, this message translates to:
  /// **'Upload CSV'**
  String get bulkOnboardingUploadCsv;

  /// No description provided for @bulkOnboardingChooseFile.
  ///
  /// In en, this message translates to:
  /// **'Choose file'**
  String get bulkOnboardingChooseFile;

  /// No description provided for @bulkOnboardingSelectedFile.
  ///
  /// In en, this message translates to:
  /// **'Selected file: {name}'**
  String bulkOnboardingSelectedFile(String name);

  /// No description provided for @bulkOnboardingFileSize.
  ///
  /// In en, this message translates to:
  /// **'File size: {size}'**
  String bulkOnboardingFileSize(String size);

  /// No description provided for @bulkOnboardingUploadPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Upload preview'**
  String get bulkOnboardingUploadPreviewTitle;

  /// No description provided for @bulkOnboardingImportTemplate.
  ///
  /// In en, this message translates to:
  /// **'Import template'**
  String get bulkOnboardingImportTemplate;

  /// No description provided for @bulkOnboardingDownloadTemplate.
  ///
  /// In en, this message translates to:
  /// **'Download template'**
  String get bulkOnboardingDownloadTemplate;

  /// No description provided for @bulkOnboardingTemplateCopied.
  ///
  /// In en, this message translates to:
  /// **'Template copied to clipboard.'**
  String get bulkOnboardingTemplateCopied;

  /// No description provided for @bulkOnboardingDownloadValidationReport.
  ///
  /// In en, this message translates to:
  /// **'Download validation report CSV'**
  String get bulkOnboardingDownloadValidationReport;

  /// No description provided for @bulkOnboardingValidationReportCopied.
  ///
  /// In en, this message translates to:
  /// **'Validation report copied to clipboard.'**
  String get bulkOnboardingValidationReportCopied;

  /// No description provided for @bulkOnboardingValidationReportFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not download the validation report.'**
  String get bulkOnboardingValidationReportFailed;

  /// No description provided for @bulkOnboardingCsvOnlyNotice.
  ///
  /// In en, this message translates to:
  /// **'CSV only in this phase. Excel import coming later.'**
  String get bulkOnboardingCsvOnlyNotice;

  /// No description provided for @bulkOnboardingExcelComingLater.
  ///
  /// In en, this message translates to:
  /// **'Excel import coming later. Please upload CSV for now.'**
  String get bulkOnboardingExcelComingLater;

  /// No description provided for @bulkOnboardingNoRealProvisioningNotice.
  ///
  /// In en, this message translates to:
  /// **'No users, vehicles, trailers, or invitations are created by this upload.'**
  String get bulkOnboardingNoRealProvisioningNotice;

  /// No description provided for @bulkOnboardingHumanApprovalNotice.
  ///
  /// In en, this message translates to:
  /// **'Human approval is required before future processing.'**
  String get bulkOnboardingHumanApprovalNotice;

  /// No description provided for @bulkOnboardingValidationCompleted.
  ///
  /// In en, this message translates to:
  /// **'Validation completed.'**
  String get bulkOnboardingValidationCompleted;

  /// No description provided for @bulkOnboardingRowsParsed.
  ///
  /// In en, this message translates to:
  /// **'Rows parsed.'**
  String get bulkOnboardingRowsParsed;

  /// No description provided for @bulkOnboardingUploadSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Upload successful.'**
  String get bulkOnboardingUploadSuccessful;

  /// No description provided for @bulkOnboardingUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Upload failed.'**
  String get bulkOnboardingUploadFailed;

  /// No description provided for @bulkOnboardingUnsupportedFileType.
  ///
  /// In en, this message translates to:
  /// **'Unsupported file type.'**
  String get bulkOnboardingUnsupportedFileType;

  /// No description provided for @bulkOnboardingTooManyRows.
  ///
  /// In en, this message translates to:
  /// **'Too many rows in file.'**
  String get bulkOnboardingTooManyRows;

  /// No description provided for @bulkOnboardingEmptyFile.
  ///
  /// In en, this message translates to:
  /// **'The selected file is empty.'**
  String get bulkOnboardingEmptyFile;

  /// No description provided for @bulkOnboardingFileRequired.
  ///
  /// In en, this message translates to:
  /// **'A CSV file is required.'**
  String get bulkOnboardingFileRequired;

  /// No description provided for @bulkOnboardingUploadTypeRequired.
  ///
  /// In en, this message translates to:
  /// **'Import type is required.'**
  String get bulkOnboardingUploadTypeRequired;

  /// No description provided for @bulkOnboardingUploadTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Import type'**
  String get bulkOnboardingUploadTypeLabel;

  /// No description provided for @bulkOnboardingUploadCompanyIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Company ID (optional until approval)'**
  String get bulkOnboardingUploadCompanyIdLabel;

  /// No description provided for @bulkOnboardingUploadCompanyNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Company name'**
  String get bulkOnboardingUploadCompanyNameLabel;

  /// No description provided for @bulkOnboardingUploadNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Admin note (optional)'**
  String get bulkOnboardingUploadNoteLabel;

  /// No description provided for @bulkOnboardingUploadProgress.
  ///
  /// In en, this message translates to:
  /// **'Uploading…'**
  String get bulkOnboardingUploadProgress;

  /// No description provided for @bulkOnboardingUploadForbidden.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to upload imports.'**
  String get bulkOnboardingUploadForbidden;

  /// No description provided for @bulkOnboardingMockUploadBadge.
  ///
  /// In en, this message translates to:
  /// **'Mock upload preview'**
  String get bulkOnboardingMockUploadBadge;

  /// No description provided for @bulkOnboardingRowsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search rows'**
  String get bulkOnboardingRowsSearchHint;

  /// No description provided for @bulkOnboardingRowFilterValid.
  ///
  /// In en, this message translates to:
  /// **'Valid'**
  String get bulkOnboardingRowFilterValid;

  /// No description provided for @bulkOnboardingRowFilterProcessed.
  ///
  /// In en, this message translates to:
  /// **'Processed'**
  String get bulkOnboardingRowFilterProcessed;

  /// No description provided for @bulkOnboardingRowFilterFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get bulkOnboardingRowFilterFailed;

  /// No description provided for @bulkOnboardingRowFilterSkipped.
  ///
  /// In en, this message translates to:
  /// **'Skipped'**
  String get bulkOnboardingRowFilterSkipped;

  /// No description provided for @bulkOnboardingRowDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Import row'**
  String get bulkOnboardingRowDetailTitle;

  /// No description provided for @bulkOnboardingRowDetailError.
  ///
  /// In en, this message translates to:
  /// **'Could not load import row details.'**
  String get bulkOnboardingRowDetailError;

  /// No description provided for @bulkOnboardingRowOriginalValuesTitle.
  ///
  /// In en, this message translates to:
  /// **'Original imported values'**
  String get bulkOnboardingRowOriginalValuesTitle;

  /// No description provided for @bulkOnboardingRowCorrectedValuesTitle.
  ///
  /// In en, this message translates to:
  /// **'Corrected values'**
  String get bulkOnboardingRowCorrectedValuesTitle;

  /// No description provided for @bulkOnboardingRowLastValidatedAt.
  ///
  /// In en, this message translates to:
  /// **'Last validated: {date}'**
  String bulkOnboardingRowLastValidatedAt(String date);

  /// No description provided for @bulkOnboardingJobLastValidatedAt.
  ///
  /// In en, this message translates to:
  /// **'Job last validated: {date}'**
  String bulkOnboardingJobLastValidatedAt(String date);

  /// No description provided for @bulkOnboardingRowCorrectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Correct import row'**
  String get bulkOnboardingRowCorrectionTitle;

  /// No description provided for @bulkOnboardingRowCorrectionNotice.
  ///
  /// In en, this message translates to:
  /// **'Update invalid fields. Original imported values are preserved for audit.'**
  String get bulkOnboardingRowCorrectionNotice;

  /// No description provided for @bulkOnboardingRowCorrectionNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Correction note (optional)'**
  String get bulkOnboardingRowCorrectionNoteLabel;

  /// No description provided for @bulkOnboardingRowCorrectionConfirm.
  ///
  /// In en, this message translates to:
  /// **'Save correction'**
  String get bulkOnboardingRowCorrectionConfirm;

  /// No description provided for @bulkOnboardingRowCorrectionAction.
  ///
  /// In en, this message translates to:
  /// **'Correct row'**
  String get bulkOnboardingRowCorrectionAction;

  /// No description provided for @bulkOnboardingRowCorrectionFieldRequired.
  ///
  /// In en, this message translates to:
  /// **'Provide at least one corrected field.'**
  String get bulkOnboardingRowCorrectionFieldRequired;

  /// No description provided for @bulkOnboardingRowFieldName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get bulkOnboardingRowFieldName;

  /// No description provided for @bulkOnboardingRowFieldEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get bulkOnboardingRowFieldEmail;

  /// No description provided for @bulkOnboardingRowFieldPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get bulkOnboardingRowFieldPhone;

  /// No description provided for @bulkOnboardingRowFieldCountry.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get bulkOnboardingRowFieldCountry;

  /// No description provided for @bulkOnboardingRowFieldRole.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get bulkOnboardingRowFieldRole;

  /// No description provided for @bulkOnboardingRowFieldVehiclePlate.
  ///
  /// In en, this message translates to:
  /// **'Vehicle plate'**
  String get bulkOnboardingRowFieldVehiclePlate;

  /// No description provided for @bulkOnboardingRowFieldTrailerPlate.
  ///
  /// In en, this message translates to:
  /// **'Trailer plate'**
  String get bulkOnboardingRowFieldTrailerPlate;

  /// No description provided for @bulkOnboardingRowSkipTitle.
  ///
  /// In en, this message translates to:
  /// **'Skip import row'**
  String get bulkOnboardingRowSkipTitle;

  /// No description provided for @bulkOnboardingRowSkipNotice.
  ///
  /// In en, this message translates to:
  /// **'Skipped rows are excluded from validation counts and processing.'**
  String get bulkOnboardingRowSkipNotice;

  /// No description provided for @bulkOnboardingRowSkipReasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Skip reason'**
  String get bulkOnboardingRowSkipReasonLabel;

  /// No description provided for @bulkOnboardingRowSkipReasonRequired.
  ///
  /// In en, this message translates to:
  /// **'A skip reason is required.'**
  String get bulkOnboardingRowSkipReasonRequired;

  /// No description provided for @bulkOnboardingRowSkipConfirm.
  ///
  /// In en, this message translates to:
  /// **'Skip row'**
  String get bulkOnboardingRowSkipConfirm;

  /// No description provided for @bulkOnboardingRowSkipAction.
  ///
  /// In en, this message translates to:
  /// **'Skip row'**
  String get bulkOnboardingRowSkipAction;

  /// No description provided for @bulkOnboardingRowRevalidateAction.
  ///
  /// In en, this message translates to:
  /// **'Revalidate row'**
  String get bulkOnboardingRowRevalidateAction;

  /// No description provided for @bulkOnboardingJobRevalidateAction.
  ///
  /// In en, this message translates to:
  /// **'Revalidate job'**
  String get bulkOnboardingJobRevalidateAction;

  /// No description provided for @bulkOnboardingJobRevalidateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Job revalidation completed.'**
  String get bulkOnboardingJobRevalidateSuccess;

  /// No description provided for @bulkOnboardingRowActionAuditNotice.
  ///
  /// In en, this message translates to:
  /// **'This action is audit logged. No accounts or assets are created.'**
  String get bulkOnboardingRowActionAuditNotice;

  /// No description provided for @bulkOnboardingRowActionSuccess.
  ///
  /// In en, this message translates to:
  /// **'Row updated successfully.'**
  String get bulkOnboardingRowActionSuccess;

  /// No description provided for @bulkOnboardingRowActionUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Row action is unavailable.'**
  String get bulkOnboardingRowActionUnavailable;

  /// No description provided for @bulkOnboardingMetricSkippedRows.
  ///
  /// In en, this message translates to:
  /// **'Skipped: {count}'**
  String bulkOnboardingMetricSkippedRows(String count);

  /// No description provided for @bulkOnboardingValidationWarnings.
  ///
  /// In en, this message translates to:
  /// **'Validation warnings'**
  String get bulkOnboardingValidationWarnings;

  /// No description provided for @navCompanies.
  ///
  /// In en, this message translates to:
  /// **'Companies'**
  String get navCompanies;

  /// No description provided for @platformCompaniesTitle.
  ///
  /// In en, this message translates to:
  /// **'Companies'**
  String get platformCompaniesTitle;

  /// No description provided for @platformCompanyDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Company detail'**
  String get platformCompanyDetailTitle;

  /// No description provided for @platformCompanySearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name, VAT, or country'**
  String get platformCompanySearchHint;

  /// No description provided for @platformCompanyListEmpty.
  ///
  /// In en, this message translates to:
  /// **'No companies match your filters.'**
  String get platformCompanyListEmpty;

  /// No description provided for @platformCompanyListError.
  ///
  /// In en, this message translates to:
  /// **'Could not load companies.'**
  String get platformCompanyListError;

  /// No description provided for @platformCompanyDetailError.
  ///
  /// In en, this message translates to:
  /// **'Could not load company detail.'**
  String get platformCompanyDetailError;

  /// No description provided for @platformCompanySummaryError.
  ///
  /// In en, this message translates to:
  /// **'Could not load company summary.'**
  String get platformCompanySummaryError;

  /// No description provided for @platformCompanyMockDataBadge.
  ///
  /// In en, this message translates to:
  /// **'Mock company data'**
  String get platformCompanyMockDataBadge;

  /// No description provided for @platformCompanyMetadataBadge.
  ///
  /// In en, this message translates to:
  /// **'Metadata only'**
  String get platformCompanyMetadataBadge;

  /// No description provided for @platformCompanyOpenModule.
  ///
  /// In en, this message translates to:
  /// **'Open companies'**
  String get platformCompanyOpenModule;

  /// No description provided for @platformCompanyPrivacyNotice.
  ///
  /// In en, this message translates to:
  /// **'Metadata-only tenant view. No trips, documents, or messages are shown.'**
  String get platformCompanyPrivacyNotice;

  /// No description provided for @platformCompanyDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Company overview'**
  String get platformCompanyDashboardTitle;

  /// No description provided for @platformCompanyDashboardActive.
  ///
  /// In en, this message translates to:
  /// **'Active: {count}'**
  String platformCompanyDashboardActive(String count);

  /// No description provided for @platformCompanyDashboardPendingReview.
  ///
  /// In en, this message translates to:
  /// **'Pending review: {count}'**
  String platformCompanyDashboardPendingReview(String count);

  /// No description provided for @platformCompanyDashboardSuspended.
  ///
  /// In en, this message translates to:
  /// **'Suspended: {count}'**
  String platformCompanyDashboardSuspended(String count);

  /// No description provided for @platformCompanyDashboardOpenSupport.
  ///
  /// In en, this message translates to:
  /// **'Open support issues: {count}'**
  String platformCompanyDashboardOpenSupport(String count);

  /// No description provided for @platformCompanyDashboardPendingOnboarding.
  ///
  /// In en, this message translates to:
  /// **'Pending onboarding: {count}'**
  String platformCompanyDashboardPendingOnboarding(String count);

  /// No description provided for @platformCompanyFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get platformCompanyFilterAll;

  /// No description provided for @platformCompanyFilterActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get platformCompanyFilterActive;

  /// No description provided for @platformCompanyFilterPendingReview.
  ///
  /// In en, this message translates to:
  /// **'Pending review'**
  String get platformCompanyFilterPendingReview;

  /// No description provided for @platformCompanyFilterSuspended.
  ///
  /// In en, this message translates to:
  /// **'Suspended'**
  String get platformCompanyFilterSuspended;

  /// No description provided for @platformCompanyFilterDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get platformCompanyFilterDisabled;

  /// No description provided for @platformCompanyStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get platformCompanyStatusActive;

  /// No description provided for @platformCompanyStatusPendingReview.
  ///
  /// In en, this message translates to:
  /// **'Pending review'**
  String get platformCompanyStatusPendingReview;

  /// No description provided for @platformCompanyStatusSuspended.
  ///
  /// In en, this message translates to:
  /// **'Suspended'**
  String get platformCompanyStatusSuspended;

  /// No description provided for @platformCompanyStatusDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get platformCompanyStatusDisabled;

  /// No description provided for @platformCompanyStatusArchived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get platformCompanyStatusArchived;

  /// No description provided for @platformCompanyStatusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get platformCompanyStatusUnknown;

  /// No description provided for @platformCompanyMetricActiveUsers.
  ///
  /// In en, this message translates to:
  /// **'Active users: {count}'**
  String platformCompanyMetricActiveUsers(String count);

  /// No description provided for @platformCompanyMetricDrivers.
  ///
  /// In en, this message translates to:
  /// **'Drivers: {count}'**
  String platformCompanyMetricDrivers(String count);

  /// No description provided for @platformCompanyMetricVehicles.
  ///
  /// In en, this message translates to:
  /// **'Vehicles: {count}'**
  String platformCompanyMetricVehicles(String count);

  /// No description provided for @platformCompanyMetricTrailers.
  ///
  /// In en, this message translates to:
  /// **'Trailers: {count}'**
  String platformCompanyMetricTrailers(String count);

  /// No description provided for @platformCompanyMetricOpenSupport.
  ///
  /// In en, this message translates to:
  /// **'Open support: {count}'**
  String platformCompanyMetricOpenSupport(String count);

  /// No description provided for @platformCompanyMetricActiveGrants.
  ///
  /// In en, this message translates to:
  /// **'Active grants: {count}'**
  String platformCompanyMetricActiveGrants(String count);

  /// No description provided for @platformCompanyMetricTotalUsers.
  ///
  /// In en, this message translates to:
  /// **'Total users: {count}'**
  String platformCompanyMetricTotalUsers(String count);

  /// No description provided for @platformCompanyMetricPendingRegistrations.
  ///
  /// In en, this message translates to:
  /// **'Pending registrations: {count}'**
  String platformCompanyMetricPendingRegistrations(String count);

  /// No description provided for @platformCompanyMetricPendingBulkJobs.
  ///
  /// In en, this message translates to:
  /// **'Pending bulk jobs: {count}'**
  String platformCompanyMetricPendingBulkJobs(String count);

  /// No description provided for @platformCompanySectionMetadata.
  ///
  /// In en, this message translates to:
  /// **'Company metadata'**
  String get platformCompanySectionMetadata;

  /// No description provided for @platformCompanySectionUsers.
  ///
  /// In en, this message translates to:
  /// **'Users summary'**
  String get platformCompanySectionUsers;

  /// No description provided for @platformCompanySectionSupport.
  ///
  /// In en, this message translates to:
  /// **'Support & fleet summary'**
  String get platformCompanySectionSupport;

  /// No description provided for @platformCompanySectionOnboarding.
  ///
  /// In en, this message translates to:
  /// **'Onboarding summary'**
  String get platformCompanySectionOnboarding;

  /// No description provided for @platformCompanyFieldCountry.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get platformCompanyFieldCountry;

  /// No description provided for @platformCompanyFieldVat.
  ///
  /// In en, this message translates to:
  /// **'VAT number'**
  String get platformCompanyFieldVat;

  /// No description provided for @platformCompanyFieldRegistrationNumber.
  ///
  /// In en, this message translates to:
  /// **'Registration number'**
  String get platformCompanyFieldRegistrationNumber;

  /// No description provided for @platformCompanyFieldPlan.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get platformCompanyFieldPlan;

  /// No description provided for @platformCompanyFieldSubscriptionStatus.
  ///
  /// In en, this message translates to:
  /// **'Subscription status'**
  String get platformCompanyFieldSubscriptionStatus;

  /// No description provided for @platformCompanyFieldLastAdminActivity.
  ///
  /// In en, this message translates to:
  /// **'Last admin activity'**
  String get platformCompanyFieldLastAdminActivity;

  /// No description provided for @platformCompanyChangeStatusAction.
  ///
  /// In en, this message translates to:
  /// **'Change status'**
  String get platformCompanyChangeStatusAction;

  /// No description provided for @platformCompanyStatusDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Change company status'**
  String get platformCompanyStatusDialogTitle;

  /// No description provided for @platformCompanyStatusDialogNotice.
  ///
  /// In en, this message translates to:
  /// **'Restrictive statuses require a reason. This action is audit logged.'**
  String get platformCompanyStatusDialogNotice;

  /// No description provided for @platformCompanyStatusFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'New status'**
  String get platformCompanyStatusFieldLabel;

  /// No description provided for @platformCompanyStatusReasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get platformCompanyStatusReasonLabel;

  /// No description provided for @platformCompanyStatusReasonRequired.
  ///
  /// In en, this message translates to:
  /// **'A reason is required for this status.'**
  String get platformCompanyStatusReasonRequired;

  /// No description provided for @platformCompanyStatusAuditNotice.
  ///
  /// In en, this message translates to:
  /// **'Status changes are audit logged. No billing or provisioning occurs here.'**
  String get platformCompanyStatusAuditNotice;

  /// No description provided for @platformCompanyStatusDismiss.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get platformCompanyStatusDismiss;

  /// No description provided for @platformCompanyStatusConfirm.
  ///
  /// In en, this message translates to:
  /// **'Update status'**
  String get platformCompanyStatusConfirm;

  /// No description provided for @platformCompanyStatusSuccess.
  ///
  /// In en, this message translates to:
  /// **'Company status updated.'**
  String get platformCompanyStatusSuccess;

  /// No description provided for @platformCompanyStatusUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Company status change is unavailable.'**
  String get platformCompanyStatusUnavailable;

  /// No description provided for @navBilling.
  ///
  /// In en, this message translates to:
  /// **'Billing'**
  String get navBilling;

  /// No description provided for @billingTitle.
  ///
  /// In en, this message translates to:
  /// **'Billing'**
  String get billingTitle;

  /// No description provided for @billingTabSubscriptions.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get billingTabSubscriptions;

  /// No description provided for @billingTabPricingIntakes.
  ///
  /// In en, this message translates to:
  /// **'Pricing intakes'**
  String get billingTabPricingIntakes;

  /// No description provided for @billingTabQuoteRequests.
  ///
  /// In en, this message translates to:
  /// **'Quote requests'**
  String get billingTabQuoteRequests;

  /// No description provided for @billingMockDataBadge.
  ///
  /// In en, this message translates to:
  /// **'Mock data'**
  String get billingMockDataBadge;

  /// No description provided for @billingMetadataBadge.
  ///
  /// In en, this message translates to:
  /// **'Metadata only'**
  String get billingMetadataBadge;

  /// No description provided for @billingLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load billing data.'**
  String get billingLoadError;

  /// No description provided for @billingDetailError.
  ///
  /// In en, this message translates to:
  /// **'Could not load billing detail.'**
  String get billingDetailError;

  /// No description provided for @billingOpenModule.
  ///
  /// In en, this message translates to:
  /// **'Open billing module'**
  String get billingOpenModule;

  /// No description provided for @billingPrivacyNotice.
  ///
  /// In en, this message translates to:
  /// **'Billing views show metadata and counts only. No payment processing or document access occurs here.'**
  String get billingPrivacyNotice;

  /// No description provided for @billingOverviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Billing overview'**
  String get billingOverviewTitle;

  /// No description provided for @billingOverviewActive.
  ///
  /// In en, this message translates to:
  /// **'Active: {count}'**
  String billingOverviewActive(String count);

  /// No description provided for @billingOverviewTrial.
  ///
  /// In en, this message translates to:
  /// **'Trial: {count}'**
  String billingOverviewTrial(String count);

  /// No description provided for @billingOverviewPastDue.
  ///
  /// In en, this message translates to:
  /// **'Past due: {count}'**
  String billingOverviewPastDue(String count);

  /// No description provided for @billingOverviewSuspended.
  ///
  /// In en, this message translates to:
  /// **'Suspended: {count}'**
  String billingOverviewSuspended(String count);

  /// No description provided for @billingOverviewPricingNew.
  ///
  /// In en, this message translates to:
  /// **'New intakes: {count}'**
  String billingOverviewPricingNew(String count);

  /// No description provided for @billingOverviewQuotesPending.
  ///
  /// In en, this message translates to:
  /// **'Pending quotes: {count}'**
  String billingOverviewQuotesPending(String count);

  /// No description provided for @billingOverviewLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated: {date}'**
  String billingOverviewLastUpdated(String date);

  /// No description provided for @dashboardMetricBillingAttention.
  ///
  /// In en, this message translates to:
  /// **'Billing attention'**
  String get dashboardMetricBillingAttention;

  /// No description provided for @billingSubscriptionSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search subscriptions'**
  String get billingSubscriptionSearchHint;

  /// No description provided for @billingSubscriptionListEmpty.
  ///
  /// In en, this message translates to:
  /// **'No subscriptions match your filters.'**
  String get billingSubscriptionListEmpty;

  /// No description provided for @billingSubscriptionDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Subscription detail'**
  String get billingSubscriptionDetailTitle;

  /// No description provided for @billingSubscriptionFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get billingSubscriptionFilterAll;

  /// No description provided for @billingSubscriptionFilterActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get billingSubscriptionFilterActive;

  /// No description provided for @billingSubscriptionFilterTrial.
  ///
  /// In en, this message translates to:
  /// **'Trial'**
  String get billingSubscriptionFilterTrial;

  /// No description provided for @billingSubscriptionFilterPastDue.
  ///
  /// In en, this message translates to:
  /// **'Past due'**
  String get billingSubscriptionFilterPastDue;

  /// No description provided for @billingSubscriptionFilterSuspended.
  ///
  /// In en, this message translates to:
  /// **'Suspended'**
  String get billingSubscriptionFilterSuspended;

  /// No description provided for @billingSubscriptionFilterCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get billingSubscriptionFilterCancelled;

  /// No description provided for @billingSubscriptionStatusTrial.
  ///
  /// In en, this message translates to:
  /// **'Trial'**
  String get billingSubscriptionStatusTrial;

  /// No description provided for @billingSubscriptionStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get billingSubscriptionStatusActive;

  /// No description provided for @billingSubscriptionStatusPastDue.
  ///
  /// In en, this message translates to:
  /// **'Past due'**
  String get billingSubscriptionStatusPastDue;

  /// No description provided for @billingSubscriptionStatusSuspended.
  ///
  /// In en, this message translates to:
  /// **'Suspended'**
  String get billingSubscriptionStatusSuspended;

  /// No description provided for @billingSubscriptionStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get billingSubscriptionStatusCancelled;

  /// No description provided for @billingSubscriptionStatusCustomQuotePending.
  ///
  /// In en, this message translates to:
  /// **'Custom quote pending'**
  String get billingSubscriptionStatusCustomQuotePending;

  /// No description provided for @billingSubscriptionStatusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get billingSubscriptionStatusUnknown;

  /// No description provided for @billingPricingIntakeSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search pricing intakes'**
  String get billingPricingIntakeSearchHint;

  /// No description provided for @billingPricingIntakeListEmpty.
  ///
  /// In en, this message translates to:
  /// **'No pricing intakes match your filters.'**
  String get billingPricingIntakeListEmpty;

  /// No description provided for @billingPricingIntakeDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Pricing intake detail'**
  String get billingPricingIntakeDetailTitle;

  /// No description provided for @billingPricingIntakeNeedsReview.
  ///
  /// In en, this message translates to:
  /// **'Needs human review'**
  String get billingPricingIntakeNeedsReview;

  /// No description provided for @billingPricingIntakeFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get billingPricingIntakeFilterAll;

  /// No description provided for @billingPricingIntakeFilterNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get billingPricingIntakeFilterNew;

  /// No description provided for @billingPricingIntakeFilterReviewing.
  ///
  /// In en, this message translates to:
  /// **'Reviewing'**
  String get billingPricingIntakeFilterReviewing;

  /// No description provided for @billingPricingIntakeFilterQuoted.
  ///
  /// In en, this message translates to:
  /// **'Quoted'**
  String get billingPricingIntakeFilterQuoted;

  /// No description provided for @billingPricingIntakeFilterAccepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get billingPricingIntakeFilterAccepted;

  /// No description provided for @billingPricingIntakeFilterRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get billingPricingIntakeFilterRejected;

  /// No description provided for @billingPricingIntakeStatusNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get billingPricingIntakeStatusNew;

  /// No description provided for @billingPricingIntakeStatusReviewing.
  ///
  /// In en, this message translates to:
  /// **'Reviewing'**
  String get billingPricingIntakeStatusReviewing;

  /// No description provided for @billingPricingIntakeStatusQuoted.
  ///
  /// In en, this message translates to:
  /// **'Quoted'**
  String get billingPricingIntakeStatusQuoted;

  /// No description provided for @billingPricingIntakeStatusAccepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get billingPricingIntakeStatusAccepted;

  /// No description provided for @billingPricingIntakeStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get billingPricingIntakeStatusRejected;

  /// No description provided for @billingPricingIntakeStatusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get billingPricingIntakeStatusUnknown;

  /// No description provided for @billingQuoteRequestSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search quote requests'**
  String get billingQuoteRequestSearchHint;

  /// No description provided for @billingQuoteRequestListEmpty.
  ///
  /// In en, this message translates to:
  /// **'No quote requests match your filters.'**
  String get billingQuoteRequestListEmpty;

  /// No description provided for @billingQuoteRequestDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Quote request detail'**
  String get billingQuoteRequestDetailTitle;

  /// No description provided for @billingQuoteRequestFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get billingQuoteRequestFilterAll;

  /// No description provided for @billingQuoteRequestFilterSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get billingQuoteRequestFilterSubmitted;

  /// No description provided for @billingQuoteRequestFilterUnderReview.
  ///
  /// In en, this message translates to:
  /// **'Under review'**
  String get billingQuoteRequestFilterUnderReview;

  /// No description provided for @billingQuoteRequestFilterQuoted.
  ///
  /// In en, this message translates to:
  /// **'Quoted'**
  String get billingQuoteRequestFilterQuoted;

  /// No description provided for @billingQuoteRequestFilterAccepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get billingQuoteRequestFilterAccepted;

  /// No description provided for @billingQuoteRequestFilterRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get billingQuoteRequestFilterRejected;

  /// No description provided for @billingQuoteRequestStatusDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get billingQuoteRequestStatusDraft;

  /// No description provided for @billingQuoteRequestStatusSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get billingQuoteRequestStatusSubmitted;

  /// No description provided for @billingQuoteRequestStatusUnderReview.
  ///
  /// In en, this message translates to:
  /// **'Under review'**
  String get billingQuoteRequestStatusUnderReview;

  /// No description provided for @billingQuoteRequestStatusQuoted.
  ///
  /// In en, this message translates to:
  /// **'Quoted'**
  String get billingQuoteRequestStatusQuoted;

  /// No description provided for @billingQuoteRequestStatusAccepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get billingQuoteRequestStatusAccepted;

  /// No description provided for @billingQuoteRequestStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get billingQuoteRequestStatusRejected;

  /// No description provided for @billingQuoteRequestStatusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get billingQuoteRequestStatusUnknown;

  /// No description provided for @billingMetricSeats.
  ///
  /// In en, this message translates to:
  /// **'Seats: {used}/{included}'**
  String billingMetricSeats(String used, String included);

  /// No description provided for @billingMetricDriverApps.
  ///
  /// In en, this message translates to:
  /// **'Driver apps: {used}/{included}'**
  String billingMetricDriverApps(String used, String included);

  /// No description provided for @billingMetricFleetSize.
  ///
  /// In en, this message translates to:
  /// **'Fleet size: {count}'**
  String billingMetricFleetSize(String count);

  /// No description provided for @billingMetricOfficeUsers.
  ///
  /// In en, this message translates to:
  /// **'Office users: {count}'**
  String billingMetricOfficeUsers(String count);

  /// No description provided for @billingMetricDriverAppsRequested.
  ///
  /// In en, this message translates to:
  /// **'Driver apps requested: {count}'**
  String billingMetricDriverAppsRequested(String count);

  /// No description provided for @billingFieldCompanyId.
  ///
  /// In en, this message translates to:
  /// **'Company #{id}'**
  String billingFieldCompanyId(String id);

  /// No description provided for @billingFieldPlan.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get billingFieldPlan;

  /// No description provided for @billingFieldBillingCycle.
  ///
  /// In en, this message translates to:
  /// **'Billing cycle'**
  String get billingFieldBillingCycle;

  /// No description provided for @billingFieldCurrency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get billingFieldCurrency;

  /// No description provided for @billingFieldPricingSource.
  ///
  /// In en, this message translates to:
  /// **'Pricing source'**
  String get billingFieldPricingSource;

  /// No description provided for @billingFieldOperatingModel.
  ///
  /// In en, this message translates to:
  /// **'Operating model'**
  String get billingFieldOperatingModel;

  /// No description provided for @billingFieldAiAddOn.
  ///
  /// In en, this message translates to:
  /// **'AI add-on'**
  String get billingFieldAiAddOn;

  /// No description provided for @billingFieldStartedAt.
  ///
  /// In en, this message translates to:
  /// **'Started at'**
  String get billingFieldStartedAt;

  /// No description provided for @billingFieldRenewsAt.
  ///
  /// In en, this message translates to:
  /// **'Renews at'**
  String get billingFieldRenewsAt;

  /// No description provided for @billingFieldCancelledAt.
  ///
  /// In en, this message translates to:
  /// **'Cancelled at'**
  String get billingFieldCancelledAt;

  /// No description provided for @billingFieldLastPaymentStatus.
  ///
  /// In en, this message translates to:
  /// **'Last payment status'**
  String get billingFieldLastPaymentStatus;

  /// No description provided for @billingFieldContactEmail.
  ///
  /// In en, this message translates to:
  /// **'Contact email'**
  String get billingFieldContactEmail;

  /// No description provided for @billingFieldCountry.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get billingFieldCountry;

  /// No description provided for @billingFieldCreatedAt.
  ///
  /// In en, this message translates to:
  /// **'Created at'**
  String get billingFieldCreatedAt;

  /// No description provided for @billingSectionPlan.
  ///
  /// In en, this message translates to:
  /// **'Plan & billing'**
  String get billingSectionPlan;

  /// No description provided for @billingSectionUsage.
  ///
  /// In en, this message translates to:
  /// **'Usage'**
  String get billingSectionUsage;

  /// No description provided for @billingSectionDates.
  ///
  /// In en, this message translates to:
  /// **'Dates'**
  String get billingSectionDates;

  /// No description provided for @billingSectionContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get billingSectionContact;

  /// No description provided for @billingSectionFleet.
  ///
  /// In en, this message translates to:
  /// **'Fleet sizing'**
  String get billingSectionFleet;

  /// No description provided for @billingSectionModules.
  ///
  /// In en, this message translates to:
  /// **'Requested modules'**
  String get billingSectionModules;

  /// No description provided for @billingSectionAiFeatures.
  ///
  /// In en, this message translates to:
  /// **'Requested AI features'**
  String get billingSectionAiFeatures;

  /// No description provided for @billingYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get billingYes;

  /// No description provided for @billingNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get billingNo;

  /// No description provided for @billingNoneReported.
  ///
  /// In en, this message translates to:
  /// **'None reported'**
  String get billingNoneReported;

  /// No description provided for @billingChangeStatusAction.
  ///
  /// In en, this message translates to:
  /// **'Change status'**
  String get billingChangeStatusAction;

  /// No description provided for @billingActionDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Update billing status'**
  String get billingActionDialogTitle;

  /// No description provided for @billingActionAuditNotice.
  ///
  /// In en, this message translates to:
  /// **'Status changes are audit logged. No payment processing occurs here.'**
  String get billingActionAuditNotice;

  /// No description provided for @billingActionCurrentStatus.
  ///
  /// In en, this message translates to:
  /// **'Current status: {status}'**
  String billingActionCurrentStatus(String status);

  /// No description provided for @billingActionStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'New status'**
  String get billingActionStatusLabel;

  /// No description provided for @billingActionStatusRequired.
  ///
  /// In en, this message translates to:
  /// **'Select a status.'**
  String get billingActionStatusRequired;

  /// No description provided for @billingActionReasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get billingActionReasonLabel;

  /// No description provided for @billingActionReasonRequired.
  ///
  /// In en, this message translates to:
  /// **'A reason is required for this status.'**
  String get billingActionReasonRequired;

  /// No description provided for @billingActionNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Internal note (optional)'**
  String get billingActionNoteLabel;

  /// No description provided for @billingActionConfirm.
  ///
  /// In en, this message translates to:
  /// **'Update status'**
  String get billingActionConfirm;

  /// No description provided for @billingActionSuccess.
  ///
  /// In en, this message translates to:
  /// **'Billing status updated.'**
  String get billingActionSuccess;

  /// No description provided for @billingActionError.
  ///
  /// In en, this message translates to:
  /// **'Could not update billing status.'**
  String get billingActionError;

  /// No description provided for @billingActionUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Billing status change is unavailable.'**
  String get billingActionUnavailable;

  /// No description provided for @navActionCenter.
  ///
  /// In en, this message translates to:
  /// **'Action center'**
  String get navActionCenter;

  /// No description provided for @navSecurityCenter.
  ///
  /// In en, this message translates to:
  /// **'Security center'**
  String get navSecurityCenter;

  /// No description provided for @navAdminUsers.
  ///
  /// In en, this message translates to:
  /// **'Admin users'**
  String get navAdminUsers;

  /// No description provided for @navReleaseCenter.
  ///
  /// In en, this message translates to:
  /// **'Release center'**
  String get navReleaseCenter;

  /// No description provided for @adminUsersTitle.
  ///
  /// In en, this message translates to:
  /// **'Admin users'**
  String get adminUsersTitle;

  /// No description provided for @adminUserDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Admin user detail'**
  String get adminUserDetailTitle;

  /// No description provided for @adminUserLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load admin users.'**
  String get adminUserLoadError;

  /// No description provided for @adminUserDetailError.
  ///
  /// In en, this message translates to:
  /// **'Could not load admin user detail.'**
  String get adminUserDetailError;

  /// No description provided for @adminUserMockDataBadge.
  ///
  /// In en, this message translates to:
  /// **'Mock data'**
  String get adminUserMockDataBadge;

  /// No description provided for @adminUserMetadataBadge.
  ///
  /// In en, this message translates to:
  /// **'Metadata only'**
  String get adminUserMetadataBadge;

  /// No description provided for @adminUserOpenModule.
  ///
  /// In en, this message translates to:
  /// **'Open admin users'**
  String get adminUserOpenModule;

  /// No description provided for @adminUserPrivacyNotice.
  ///
  /// In en, this message translates to:
  /// **'Admin user views show metadata only. No passwords or credentials are exposed.'**
  String get adminUserPrivacyNotice;

  /// No description provided for @adminUserSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search admin users'**
  String get adminUserSearchHint;

  /// No description provided for @adminUserListEmpty.
  ///
  /// In en, this message translates to:
  /// **'No admin users match your filters.'**
  String get adminUserListEmpty;

  /// No description provided for @adminUserInviteAction.
  ///
  /// In en, this message translates to:
  /// **'Invite admin user'**
  String get adminUserInviteAction;

  /// No description provided for @adminUserInviteTitle.
  ///
  /// In en, this message translates to:
  /// **'Invite platform admin'**
  String get adminUserInviteTitle;

  /// No description provided for @adminUserInviteNotice.
  ///
  /// In en, this message translates to:
  /// **'Invites create a metadata-only platform admin record. Email delivery may be pending.'**
  String get adminUserInviteNotice;

  /// No description provided for @adminUserInviteNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Internal note (optional)'**
  String get adminUserInviteNoteLabel;

  /// No description provided for @adminUserInviteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Send invite'**
  String get adminUserInviteConfirm;

  /// No description provided for @adminUserInviteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Admin user invited.'**
  String get adminUserInviteSuccess;

  /// No description provided for @adminUserFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get adminUserFilterAll;

  /// No description provided for @adminUserFilterActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get adminUserFilterActive;

  /// No description provided for @adminUserFilterInvited.
  ///
  /// In en, this message translates to:
  /// **'Invited'**
  String get adminUserFilterInvited;

  /// No description provided for @adminUserFilterSuspended.
  ///
  /// In en, this message translates to:
  /// **'Suspended'**
  String get adminUserFilterSuspended;

  /// No description provided for @adminUserFilterDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get adminUserFilterDisabled;

  /// No description provided for @adminUserStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get adminUserStatusActive;

  /// No description provided for @adminUserStatusInvited.
  ///
  /// In en, this message translates to:
  /// **'Invited'**
  String get adminUserStatusInvited;

  /// No description provided for @adminUserStatusSuspended.
  ///
  /// In en, this message translates to:
  /// **'Suspended'**
  String get adminUserStatusSuspended;

  /// No description provided for @adminUserStatusDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get adminUserStatusDisabled;

  /// No description provided for @adminUserStatusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get adminUserStatusUnknown;

  /// No description provided for @adminUserRoleUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown role'**
  String get adminUserRoleUnknown;

  /// No description provided for @adminUserLastLogin.
  ///
  /// In en, this message translates to:
  /// **'Last login: {date}'**
  String adminUserLastLogin(String date);

  /// No description provided for @adminUserFailedLogins.
  ///
  /// In en, this message translates to:
  /// **'Failed logins: {count}'**
  String adminUserFailedLogins(String count);

  /// No description provided for @adminUserFieldName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get adminUserFieldName;

  /// No description provided for @adminUserFieldEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get adminUserFieldEmail;

  /// No description provided for @adminUserFieldRole.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get adminUserFieldRole;

  /// No description provided for @adminUserFieldStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get adminUserFieldStatus;

  /// No description provided for @adminUserFieldCreatedAt.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get adminUserFieldCreatedAt;

  /// No description provided for @adminUserFieldLastLoginAt.
  ///
  /// In en, this message translates to:
  /// **'Last login'**
  String get adminUserFieldLastLoginAt;

  /// No description provided for @adminUserFieldFailedLoginCount.
  ///
  /// In en, this message translates to:
  /// **'Failed login count'**
  String get adminUserFieldFailedLoginCount;

  /// No description provided for @adminUserChangeRoleAction.
  ///
  /// In en, this message translates to:
  /// **'Change role'**
  String get adminUserChangeRoleAction;

  /// No description provided for @adminUserChangeStatusAction.
  ///
  /// In en, this message translates to:
  /// **'Change status'**
  String get adminUserChangeStatusAction;

  /// No description provided for @adminUserRoleDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Change admin role'**
  String get adminUserRoleDialogTitle;

  /// No description provided for @adminUserStatusDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Change admin status'**
  String get adminUserStatusDialogTitle;

  /// No description provided for @adminUserActionCurrentRole.
  ///
  /// In en, this message translates to:
  /// **'Current role: {role}'**
  String adminUserActionCurrentRole(String role);

  /// No description provided for @adminUserActionCurrentStatus.
  ///
  /// In en, this message translates to:
  /// **'Current status: {status}'**
  String adminUserActionCurrentStatus(String status);

  /// No description provided for @adminUserReasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get adminUserReasonLabel;

  /// No description provided for @adminUserReasonRequired.
  ///
  /// In en, this message translates to:
  /// **'A reason is required.'**
  String get adminUserReasonRequired;

  /// No description provided for @adminUserNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters.'**
  String get adminUserNameRequired;

  /// No description provided for @adminUserActionAuditNotice.
  ///
  /// In en, this message translates to:
  /// **'Admin user changes are audit logged.'**
  String get adminUserActionAuditNotice;

  /// No description provided for @adminUserActionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get adminUserActionCancel;

  /// No description provided for @adminUserRoleConfirm.
  ///
  /// In en, this message translates to:
  /// **'Update role'**
  String get adminUserRoleConfirm;

  /// No description provided for @adminUserStatusConfirm.
  ///
  /// In en, this message translates to:
  /// **'Update status'**
  String get adminUserStatusConfirm;

  /// No description provided for @adminUserRoleSuccess.
  ///
  /// In en, this message translates to:
  /// **'Admin role updated.'**
  String get adminUserRoleSuccess;

  /// No description provided for @adminUserStatusSuccess.
  ///
  /// In en, this message translates to:
  /// **'Admin status updated.'**
  String get adminUserStatusSuccess;

  /// No description provided for @adminUserActionError.
  ///
  /// In en, this message translates to:
  /// **'Could not update admin user.'**
  String get adminUserActionError;

  /// No description provided for @adminUserActionUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Admin user management requires super_admin.'**
  String get adminUserActionUnavailable;

  /// No description provided for @securityCenterTitle.
  ///
  /// In en, this message translates to:
  /// **'Security center'**
  String get securityCenterTitle;

  /// No description provided for @securityEventDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Security event detail'**
  String get securityEventDetailTitle;

  /// No description provided for @securityLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load security data.'**
  String get securityLoadError;

  /// No description provided for @securityMockDataBadge.
  ///
  /// In en, this message translates to:
  /// **'Mock data'**
  String get securityMockDataBadge;

  /// No description provided for @securityOpenModule.
  ///
  /// In en, this message translates to:
  /// **'Open security center'**
  String get securityOpenModule;

  /// No description provided for @securityPrivacyNotice.
  ///
  /// In en, this message translates to:
  /// **'Security views show metadata only. No message bodies or document content are shown.'**
  String get securityPrivacyNotice;

  /// No description provided for @securityOverviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Security overview'**
  String get securityOverviewTitle;

  /// No description provided for @securityOverviewFailedLogins.
  ///
  /// In en, this message translates to:
  /// **'Failed logins: {count}'**
  String securityOverviewFailedLogins(String count);

  /// No description provided for @securityOverviewDeniedActions.
  ///
  /// In en, this message translates to:
  /// **'Denied actions: {count}'**
  String securityOverviewDeniedActions(String count);

  /// No description provided for @securityOverviewActiveGrants.
  ///
  /// In en, this message translates to:
  /// **'Active support grants: {count}'**
  String securityOverviewActiveGrants(String count);

  /// No description provided for @securityOverviewCriticalEvents.
  ///
  /// In en, this message translates to:
  /// **'Critical security events: {count}'**
  String securityOverviewCriticalEvents(String count);

  /// No description provided for @securityOverviewExpiringGrants.
  ///
  /// In en, this message translates to:
  /// **'Expiring grants: {count}'**
  String securityOverviewExpiringGrants(String count);

  /// No description provided for @securityOverviewHighRiskAi.
  ///
  /// In en, this message translates to:
  /// **'High-risk AI reviews: {count}'**
  String securityOverviewHighRiskAi(String count);

  /// No description provided for @securityOverviewSuspiciousBulk.
  ///
  /// In en, this message translates to:
  /// **'Suspicious bulk jobs: {count}'**
  String securityOverviewSuspiciousBulk(String count);

  /// No description provided for @securityOverviewNoCritical.
  ///
  /// In en, this message translates to:
  /// **'No critical events recorded'**
  String get securityOverviewNoCritical;

  /// No description provided for @securityOverviewLastCritical.
  ///
  /// In en, this message translates to:
  /// **'Last critical event: {date}'**
  String securityOverviewLastCritical(String date);

  /// No description provided for @securityEventSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search security events'**
  String get securityEventSearchHint;

  /// No description provided for @securityEventListEmpty.
  ///
  /// In en, this message translates to:
  /// **'No security events match your filters.'**
  String get securityEventListEmpty;

  /// No description provided for @securityEventDetailError.
  ///
  /// In en, this message translates to:
  /// **'Security event not found.'**
  String get securityEventDetailError;

  /// No description provided for @securityEventCompanyLabel.
  ///
  /// In en, this message translates to:
  /// **'Company: {name}'**
  String securityEventCompanyLabel(String name);

  /// No description provided for @securityEventCreatedAt.
  ///
  /// In en, this message translates to:
  /// **'Created: {date}'**
  String securityEventCreatedAt(String date);

  /// No description provided for @securityEventFieldSourceType.
  ///
  /// In en, this message translates to:
  /// **'Source type'**
  String get securityEventFieldSourceType;

  /// No description provided for @securityEventFieldSourceId.
  ///
  /// In en, this message translates to:
  /// **'Source ID'**
  String get securityEventFieldSourceId;

  /// No description provided for @securityEventFieldActorEmail.
  ///
  /// In en, this message translates to:
  /// **'Actor email'**
  String get securityEventFieldActorEmail;

  /// No description provided for @securityEventFieldActorRole.
  ///
  /// In en, this message translates to:
  /// **'Actor role'**
  String get securityEventFieldActorRole;

  /// No description provided for @securityEventFieldCompany.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get securityEventFieldCompany;

  /// No description provided for @securityEventFieldCorrelationId.
  ///
  /// In en, this message translates to:
  /// **'Correlation ID'**
  String get securityEventFieldCorrelationId;

  /// No description provided for @securityEventFieldCreatedAt.
  ///
  /// In en, this message translates to:
  /// **'Created at'**
  String get securityEventFieldCreatedAt;

  /// No description provided for @securityEventFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get securityEventFilterAll;

  /// No description provided for @securityEventFilterFailedLogin.
  ///
  /// In en, this message translates to:
  /// **'Failed logins'**
  String get securityEventFilterFailedLogin;

  /// No description provided for @securityEventFilterPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Denied actions'**
  String get securityEventFilterPermissionDenied;

  /// No description provided for @securityEventFilterSupportAccess.
  ///
  /// In en, this message translates to:
  /// **'Support access'**
  String get securityEventFilterSupportAccess;

  /// No description provided for @securityEventFilterHighRiskAi.
  ///
  /// In en, this message translates to:
  /// **'High-risk AI'**
  String get securityEventFilterHighRiskAi;

  /// No description provided for @securityEventFilterCriticalSystem.
  ///
  /// In en, this message translates to:
  /// **'Critical system'**
  String get securityEventFilterCriticalSystem;

  /// No description provided for @securityEventFilterAdminRoleChange.
  ///
  /// In en, this message translates to:
  /// **'Admin changes'**
  String get securityEventFilterAdminRoleChange;

  /// No description provided for @securityEventFilterSuspiciousBulkOnboarding.
  ///
  /// In en, this message translates to:
  /// **'Suspicious bulk'**
  String get securityEventFilterSuspiciousBulkOnboarding;

  /// No description provided for @securityEventFilterCritical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get securityEventFilterCritical;

  /// No description provided for @securityEventFilterWarning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get securityEventFilterWarning;

  /// No description provided for @securityEventTypeFailedLogin.
  ///
  /// In en, this message translates to:
  /// **'Failed login'**
  String get securityEventTypeFailedLogin;

  /// No description provided for @securityEventTypePermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Permission denied'**
  String get securityEventTypePermissionDenied;

  /// No description provided for @securityEventTypeSupportAccess.
  ///
  /// In en, this message translates to:
  /// **'Support access'**
  String get securityEventTypeSupportAccess;

  /// No description provided for @securityEventTypeHighRiskAi.
  ///
  /// In en, this message translates to:
  /// **'High-risk AI'**
  String get securityEventTypeHighRiskAi;

  /// No description provided for @securityEventTypeCriticalSystem.
  ///
  /// In en, this message translates to:
  /// **'Critical system'**
  String get securityEventTypeCriticalSystem;

  /// No description provided for @securityEventTypeAdminRoleChange.
  ///
  /// In en, this message translates to:
  /// **'Admin change'**
  String get securityEventTypeAdminRoleChange;

  /// No description provided for @securityEventTypeSuspiciousBulkOnboarding.
  ///
  /// In en, this message translates to:
  /// **'Suspicious bulk'**
  String get securityEventTypeSuspiciousBulkOnboarding;

  /// No description provided for @securityEventTypeUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get securityEventTypeUnknown;

  /// No description provided for @securityEventSeverityInfo.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get securityEventSeverityInfo;

  /// No description provided for @securityEventSeverityWarning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get securityEventSeverityWarning;

  /// No description provided for @securityEventSeverityCritical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get securityEventSeverityCritical;

  /// No description provided for @securityEventSeverityUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get securityEventSeverityUnknown;

  /// No description provided for @actionCenterTitle.
  ///
  /// In en, this message translates to:
  /// **'Action center'**
  String get actionCenterTitle;

  /// No description provided for @actionCenterLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load action center.'**
  String get actionCenterLoadError;

  /// No description provided for @actionCenterMockDataBadge.
  ///
  /// In en, this message translates to:
  /// **'Mock data'**
  String get actionCenterMockDataBadge;

  /// No description provided for @actionCenterOpenModule.
  ///
  /// In en, this message translates to:
  /// **'Open action center'**
  String get actionCenterOpenModule;

  /// No description provided for @actionCenterPrivacyNotice.
  ///
  /// In en, this message translates to:
  /// **'Action center items are metadata-only summaries. Open linked modules for details.'**
  String get actionCenterPrivacyNotice;

  /// No description provided for @actionCenterReadOnlyNotice.
  ///
  /// In en, this message translates to:
  /// **'Items reflect current system state. They clear when the underlying issue is resolved. Server dismiss is not available in this release.'**
  String get actionCenterReadOnlyNotice;

  /// No description provided for @actionCenterSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search action items'**
  String get actionCenterSearchHint;

  /// No description provided for @actionCenterListEmpty.
  ///
  /// In en, this message translates to:
  /// **'No action items match your filters.'**
  String get actionCenterListEmpty;

  /// No description provided for @actionCenterListEmptyDetail.
  ///
  /// In en, this message translates to:
  /// **'When registrations, support tickets, public intakes, or health events need attention, they appear here automatically.'**
  String get actionCenterListEmptyDetail;

  /// No description provided for @actionCenterNeedsAttentionTitle.
  ///
  /// In en, this message translates to:
  /// **'Needs attention'**
  String get actionCenterNeedsAttentionTitle;

  /// No description provided for @actionCenterNeedsAttentionOpen.
  ///
  /// In en, this message translates to:
  /// **'Open items: {count}'**
  String actionCenterNeedsAttentionOpen(String count);

  /// No description provided for @actionCenterNeedsAttentionCritical.
  ///
  /// In en, this message translates to:
  /// **'Critical/urgent: {count}'**
  String actionCenterNeedsAttentionCritical(String count);

  /// No description provided for @actionCenterNeedsAttentionTotal.
  ///
  /// In en, this message translates to:
  /// **'Total items: {count}'**
  String actionCenterNeedsAttentionTotal(String count);

  /// No description provided for @actionCenterCompanyLabel.
  ///
  /// In en, this message translates to:
  /// **'Company: {name}'**
  String actionCenterCompanyLabel(String name);

  /// No description provided for @actionCenterCreatedAt.
  ///
  /// In en, this message translates to:
  /// **'Created: {date}'**
  String actionCenterCreatedAt(String date);

  /// No description provided for @actionCenterFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get actionCenterFilterAll;

  /// No description provided for @actionCenterFilterRegistration.
  ///
  /// In en, this message translates to:
  /// **'Registrations'**
  String get actionCenterFilterRegistration;

  /// No description provided for @actionCenterFilterBulkOnboarding.
  ///
  /// In en, this message translates to:
  /// **'Bulk onboarding'**
  String get actionCenterFilterBulkOnboarding;

  /// No description provided for @actionCenterFilterSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get actionCenterFilterSupport;

  /// No description provided for @actionCenterFilterSystemHealth.
  ///
  /// In en, this message translates to:
  /// **'System health'**
  String get actionCenterFilterSystemHealth;

  /// No description provided for @actionCenterFilterSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get actionCenterFilterSecurity;

  /// No description provided for @actionCenterFilterBilling.
  ///
  /// In en, this message translates to:
  /// **'Billing'**
  String get actionCenterFilterBilling;

  /// No description provided for @actionCenterFilterAiReview.
  ///
  /// In en, this message translates to:
  /// **'AI reviews'**
  String get actionCenterFilterAiReview;

  /// No description provided for @actionCenterFilterCritical.
  ///
  /// In en, this message translates to:
  /// **'Critical/urgent'**
  String get actionCenterFilterCritical;

  /// No description provided for @actionCenterFilterCustomerCommunication.
  ///
  /// In en, this message translates to:
  /// **'Customer communications'**
  String get actionCenterFilterCustomerCommunication;

  /// No description provided for @actionCenterTypeRegistration.
  ///
  /// In en, this message translates to:
  /// **'Registration'**
  String get actionCenterTypeRegistration;

  /// No description provided for @actionCenterTypeBulkOnboarding.
  ///
  /// In en, this message translates to:
  /// **'Bulk onboarding'**
  String get actionCenterTypeBulkOnboarding;

  /// No description provided for @actionCenterTypeSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get actionCenterTypeSupport;

  /// No description provided for @actionCenterTypeSystemHealth.
  ///
  /// In en, this message translates to:
  /// **'System health'**
  String get actionCenterTypeSystemHealth;

  /// No description provided for @actionCenterTypeSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get actionCenterTypeSecurity;

  /// No description provided for @actionCenterTypeBilling.
  ///
  /// In en, this message translates to:
  /// **'Billing'**
  String get actionCenterTypeBilling;

  /// No description provided for @actionCenterTypeAiReview.
  ///
  /// In en, this message translates to:
  /// **'AI review'**
  String get actionCenterTypeAiReview;

  /// No description provided for @actionCenterTypeCompany.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get actionCenterTypeCompany;

  /// No description provided for @actionCenterTypeCustomerCommunication.
  ///
  /// In en, this message translates to:
  /// **'Customer communication'**
  String get actionCenterTypeCustomerCommunication;

  /// No description provided for @actionCenterTypeUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get actionCenterTypeUnknown;

  /// No description provided for @actionCenterPriorityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get actionCenterPriorityLow;

  /// No description provided for @actionCenterPriorityNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get actionCenterPriorityNormal;

  /// No description provided for @actionCenterPriorityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get actionCenterPriorityHigh;

  /// No description provided for @actionCenterPriorityUrgent.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get actionCenterPriorityUrgent;

  /// No description provided for @actionCenterPriorityCritical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get actionCenterPriorityCritical;

  /// No description provided for @actionCenterPriorityUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get actionCenterPriorityUnknown;

  /// No description provided for @actionCenterStatusOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get actionCenterStatusOpen;

  /// No description provided for @actionCenterStatusAcknowledged.
  ///
  /// In en, this message translates to:
  /// **'Acknowledged'**
  String get actionCenterStatusAcknowledged;

  /// No description provided for @actionCenterStatusDismissed.
  ///
  /// In en, this message translates to:
  /// **'Dismissed'**
  String get actionCenterStatusDismissed;

  /// No description provided for @actionCenterStatusResolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get actionCenterStatusResolved;

  /// No description provided for @actionCenterStatusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get actionCenterStatusUnknown;

  /// No description provided for @releaseCenterTitle.
  ///
  /// In en, this message translates to:
  /// **'Release center'**
  String get releaseCenterTitle;

  /// No description provided for @releaseLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load release metadata.'**
  String get releaseLoadError;

  /// No description provided for @releaseMockDataBadge.
  ///
  /// In en, this message translates to:
  /// **'Mock data'**
  String get releaseMockDataBadge;

  /// No description provided for @releaseReadOnlyBadge.
  ///
  /// In en, this message translates to:
  /// **'Read only'**
  String get releaseReadOnlyBadge;

  /// No description provided for @releasePrivacyNotice.
  ///
  /// In en, this message translates to:
  /// **'Release views show deployment metadata only. No secrets or storage keys are exposed.'**
  String get releasePrivacyNotice;

  /// No description provided for @releaseTabOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get releaseTabOverview;

  /// No description provided for @releaseTabAppVersions.
  ///
  /// In en, this message translates to:
  /// **'App versions'**
  String get releaseTabAppVersions;

  /// No description provided for @releaseTabEnvironment.
  ///
  /// In en, this message translates to:
  /// **'Environment'**
  String get releaseTabEnvironment;

  /// No description provided for @releaseOverviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Release overview'**
  String get releaseOverviewTitle;

  /// No description provided for @releaseAppVersionsTitle.
  ///
  /// In en, this message translates to:
  /// **'App versions'**
  String get releaseAppVersionsTitle;

  /// No description provided for @releaseEnvironmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Environment'**
  String get releaseEnvironmentTitle;

  /// No description provided for @releaseFieldBackendVersion.
  ///
  /// In en, this message translates to:
  /// **'Backend version'**
  String get releaseFieldBackendVersion;

  /// No description provided for @releaseFieldEnvironment.
  ///
  /// In en, this message translates to:
  /// **'Environment'**
  String get releaseFieldEnvironment;

  /// No description provided for @releaseFieldNodeEnv.
  ///
  /// In en, this message translates to:
  /// **'Node environment'**
  String get releaseFieldNodeEnv;

  /// No description provided for @releaseFieldMaintenanceMode.
  ///
  /// In en, this message translates to:
  /// **'Maintenance mode'**
  String get releaseFieldMaintenanceMode;

  /// No description provided for @releaseFieldLatestAdminApp.
  ///
  /// In en, this message translates to:
  /// **'Latest admin app'**
  String get releaseFieldLatestAdminApp;

  /// No description provided for @releaseFieldLatestDriverApp.
  ///
  /// In en, this message translates to:
  /// **'Latest driver app'**
  String get releaseFieldLatestDriverApp;

  /// No description provided for @releaseFieldMinAdminApp.
  ///
  /// In en, this message translates to:
  /// **'Minimum admin app'**
  String get releaseFieldMinAdminApp;

  /// No description provided for @releaseFieldMinDriverApp.
  ///
  /// In en, this message translates to:
  /// **'Minimum driver app'**
  String get releaseFieldMinDriverApp;

  /// No description provided for @releaseFieldLastDeployment.
  ///
  /// In en, this message translates to:
  /// **'Last deployment: {date}'**
  String releaseFieldLastDeployment(String date);

  /// No description provided for @releaseFieldMigrationStatus.
  ///
  /// In en, this message translates to:
  /// **'Database migrations'**
  String get releaseFieldMigrationStatus;

  /// No description provided for @releaseFieldDeploymentReady.
  ///
  /// In en, this message translates to:
  /// **'Deployment ready'**
  String get releaseFieldDeploymentReady;

  /// No description provided for @releaseFieldApiPublicName.
  ///
  /// In en, this message translates to:
  /// **'Public API name'**
  String get releaseFieldApiPublicName;

  /// No description provided for @releaseActiveAdminVersions.
  ///
  /// In en, this message translates to:
  /// **'Active admin app versions'**
  String get releaseActiveAdminVersions;

  /// No description provided for @releaseActiveDriverVersions.
  ///
  /// In en, this message translates to:
  /// **'Active driver app versions'**
  String get releaseActiveDriverVersions;

  /// No description provided for @releaseDeploymentWarnings.
  ///
  /// In en, this message translates to:
  /// **'Deployment warnings'**
  String get releaseDeploymentWarnings;

  /// No description provided for @releaseYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get releaseYes;

  /// No description provided for @releaseNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get releaseNo;

  /// No description provided for @releaseEmailDeliveryTitle.
  ///
  /// In en, this message translates to:
  /// **'Email delivery'**
  String get releaseEmailDeliveryTitle;

  /// No description provided for @releaseEmailDeliveryProvider.
  ///
  /// In en, this message translates to:
  /// **'Provider'**
  String get releaseEmailDeliveryProvider;

  /// No description provided for @releaseEmailDeliveryEnabled.
  ///
  /// In en, this message translates to:
  /// **'Delivery enabled'**
  String get releaseEmailDeliveryEnabled;

  /// No description provided for @releaseEmailDeliveryLastStatus.
  ///
  /// In en, this message translates to:
  /// **'Last delivery status'**
  String get releaseEmailDeliveryLastStatus;

  /// No description provided for @releaseEmailDeliveryNotice.
  ///
  /// In en, this message translates to:
  /// **'Email delivery status shows provider and metadata only. No SMTP passwords or message bodies are exposed.'**
  String get releaseEmailDeliveryNotice;

  /// No description provided for @releaseEmailDeliveryAllowlistEnabled.
  ///
  /// In en, this message translates to:
  /// **'Staging allowlist enabled'**
  String get releaseEmailDeliveryAllowlistEnabled;

  /// No description provided for @releaseEmailDeliveryAllowlistDomains.
  ///
  /// In en, this message translates to:
  /// **'Allowed domains (count)'**
  String get releaseEmailDeliveryAllowlistDomains;

  /// No description provided for @releaseEmailDeliveryAllowlistRecipients.
  ///
  /// In en, this message translates to:
  /// **'Allowed recipients (count)'**
  String get releaseEmailDeliveryAllowlistRecipients;

  /// No description provided for @releaseEmailDeliveryLastFailureCode.
  ///
  /// In en, this message translates to:
  /// **'Last failure code'**
  String get releaseEmailDeliveryLastFailureCode;

  /// No description provided for @releaseEmailDeliveryStagingAllowlistMissing.
  ///
  /// In en, this message translates to:
  /// **'Staging delivery enabled but allowlist is missing — external sends are blocked.'**
  String get releaseEmailDeliveryStagingAllowlistMissing;

  /// No description provided for @releaseEmailProviderNoop.
  ///
  /// In en, this message translates to:
  /// **'No-op (disabled)'**
  String get releaseEmailProviderNoop;

  /// No description provided for @releaseEmailProviderSmtp.
  ///
  /// In en, this message translates to:
  /// **'SMTP'**
  String get releaseEmailProviderSmtp;

  /// No description provided for @releaseEmailProviderPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Provider placeholder'**
  String get releaseEmailProviderPlaceholder;

  /// No description provided for @releaseObservabilityTitle.
  ///
  /// In en, this message translates to:
  /// **'Observability'**
  String get releaseObservabilityTitle;

  /// No description provided for @releaseObservabilityLogLevel.
  ///
  /// In en, this message translates to:
  /// **'Log level'**
  String get releaseObservabilityLogLevel;

  /// No description provided for @releaseObservabilityMetricsEnabled.
  ///
  /// In en, this message translates to:
  /// **'Metrics enabled'**
  String get releaseObservabilityMetricsEnabled;

  /// No description provided for @releaseObservabilitySentryConfigured.
  ///
  /// In en, this message translates to:
  /// **'Sentry configured'**
  String get releaseObservabilitySentryConfigured;

  /// No description provided for @releaseObservabilityOtelConfigured.
  ///
  /// In en, this message translates to:
  /// **'OpenTelemetry configured'**
  String get releaseObservabilityOtelConfigured;

  /// No description provided for @releaseObservabilityCorrelationId.
  ///
  /// In en, this message translates to:
  /// **'Correlation ID enabled'**
  String get releaseObservabilityCorrelationId;

  /// No description provided for @releaseObservabilityNotice.
  ///
  /// In en, this message translates to:
  /// **'Observability status shows configuration flags only. No DSN, endpoint URLs, or secrets are displayed.'**
  String get releaseObservabilityNotice;

  /// No description provided for @settingsReleaseSection.
  ///
  /// In en, this message translates to:
  /// **'Release & deployment'**
  String get settingsReleaseSection;

  /// No description provided for @settingsReleaseCenterBody.
  ///
  /// In en, this message translates to:
  /// **'View read-only release metadata, app versions, and environment status.'**
  String get settingsReleaseCenterBody;

  /// No description provided for @settingsOpenReleaseCenter.
  ///
  /// In en, this message translates to:
  /// **'Open release center'**
  String get settingsOpenReleaseCenter;

  /// No description provided for @appEnvLocal.
  ///
  /// In en, this message translates to:
  /// **'Local'**
  String get appEnvLocal;

  /// No description provided for @appEnvDev.
  ///
  /// In en, this message translates to:
  /// **'Development'**
  String get appEnvDev;

  /// No description provided for @appEnvStaging.
  ///
  /// In en, this message translates to:
  /// **'Staging'**
  String get appEnvStaging;

  /// No description provided for @appEnvProduction.
  ///
  /// In en, this message translates to:
  /// **'Production'**
  String get appEnvProduction;

  /// No description provided for @appConfigEnvironmentLabel.
  ///
  /// In en, this message translates to:
  /// **'Environment'**
  String get appConfigEnvironmentLabel;

  /// No description provided for @appConfigApiStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'API'**
  String get appConfigApiStatusLabel;

  /// No description provided for @appConfigApiConfigured.
  ///
  /// In en, this message translates to:
  /// **'Configured'**
  String get appConfigApiConfigured;

  /// No description provided for @appConfigApiNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Not configured'**
  String get appConfigApiNotConfigured;

  /// No description provided for @appConfigMockFallbackActive.
  ///
  /// In en, this message translates to:
  /// **'Mock fallback active'**
  String get appConfigMockFallbackActive;

  /// No description provided for @appConfigProductionMisconfigured.
  ///
  /// In en, this message translates to:
  /// **'Production build requires API_BASE_URL. Mock fallback is disabled.'**
  String get appConfigProductionMisconfigured;

  /// No description provided for @appConfigProductionLoginBlocked.
  ///
  /// In en, this message translates to:
  /// **'Sign-in is disabled until API_BASE_URL is configured for production.'**
  String get appConfigProductionLoginBlocked;

  /// No description provided for @backendMockFallbackBanner.
  ///
  /// In en, this message translates to:
  /// **'Live backend is not configured. Modules use mock data for local UI development.'**
  String get backendMockFallbackBanner;

  /// No description provided for @settingsApiHostLabel.
  ///
  /// In en, this message translates to:
  /// **'API host'**
  String get settingsApiHostLabel;

  /// No description provided for @navNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get navNotifications;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @notificationsPreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get notificationsPreferences;

  /// No description provided for @notificationsMarkAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get notificationsMarkAllRead;

  /// No description provided for @notificationsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No notifications.'**
  String get notificationsEmpty;

  /// No description provided for @notificationsInAppOnlyTitle.
  ///
  /// In en, this message translates to:
  /// **'In-app only notifications'**
  String get notificationsInAppOnlyTitle;

  /// No description provided for @notificationsInAppOnlyBody.
  ///
  /// In en, this message translates to:
  /// **'Push channels are not enabled in this phase.'**
  String get notificationsInAppOnlyBody;

  /// No description provided for @notificationsDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification detail'**
  String get notificationsDetailTitle;

  /// No description provided for @notificationsNotFound.
  ///
  /// In en, this message translates to:
  /// **'Notification not found.'**
  String get notificationsNotFound;

  /// No description provided for @notificationsPreferencesTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification preferences'**
  String get notificationsPreferencesTitle;

  /// No description provided for @notificationsSavePreferences.
  ///
  /// In en, this message translates to:
  /// **'Save preferences'**
  String get notificationsSavePreferences;

  /// No description provided for @notificationsSaved.
  ///
  /// In en, this message translates to:
  /// **'Preferences saved.'**
  String get notificationsSaved;

  /// No description provided for @notificationsPrefSystemHealth.
  ///
  /// In en, this message translates to:
  /// **'System health'**
  String get notificationsPrefSystemHealth;

  /// No description provided for @notificationsPrefSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get notificationsPrefSecurity;

  /// No description provided for @notificationsPrefSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get notificationsPrefSupport;

  /// No description provided for @notificationsPrefBilling.
  ///
  /// In en, this message translates to:
  /// **'Billing'**
  String get notificationsPrefBilling;

  /// No description provided for @notificationsPrefRelease.
  ///
  /// In en, this message translates to:
  /// **'Release'**
  String get notificationsPrefRelease;

  /// No description provided for @notificationsPrefInAppOnlyHint.
  ///
  /// In en, this message translates to:
  /// **'Only in-app notifications are available in this phase.'**
  String get notificationsPrefInAppOnlyHint;

  /// No description provided for @notificationsPrefValidationAtLeastOne.
  ///
  /// In en, this message translates to:
  /// **'At least one channel must stay enabled.'**
  String get notificationsPrefValidationAtLeastOne;

  /// No description provided for @notificationsPrefValidationInAppOnly.
  ///
  /// In en, this message translates to:
  /// **'Only in-app notifications are supported in this phase.'**
  String get notificationsPrefValidationInAppOnly;

  /// No description provided for @notificationsInAppChip.
  ///
  /// In en, this message translates to:
  /// **'In-app only'**
  String get notificationsInAppChip;

  /// No description provided for @notificationsYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get notificationsYes;

  /// No description provided for @notificationsNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get notificationsNo;

  /// No description provided for @notificationsPushProviderTitle.
  ///
  /// In en, this message translates to:
  /// **'Push provider status'**
  String get notificationsPushProviderTitle;

  /// No description provided for @notificationsPushStateInAppOnly.
  ///
  /// In en, this message translates to:
  /// **'In-app only'**
  String get notificationsPushStateInAppOnly;

  /// No description provided for @notificationsPushStateExternalNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'External push not configured'**
  String get notificationsPushStateExternalNotConfigured;

  /// No description provided for @notificationsPushStateConfigured.
  ///
  /// In en, this message translates to:
  /// **'Push provider configured'**
  String get notificationsPushStateConfigured;

  /// No description provided for @notificationsPushProviderField.
  ///
  /// In en, this message translates to:
  /// **'Provider'**
  String get notificationsPushProviderField;

  /// No description provided for @notificationsPushDeliveryEnabled.
  ///
  /// In en, this message translates to:
  /// **'Delivery enabled'**
  String get notificationsPushDeliveryEnabled;

  /// No description provided for @notificationsPushTokenStorage.
  ///
  /// In en, this message translates to:
  /// **'Token storage mode'**
  String get notificationsPushTokenStorage;

  /// No description provided for @notificationsPushLastFailureCode.
  ///
  /// In en, this message translates to:
  /// **'Last failure code'**
  String get notificationsPushLastFailureCode;

  /// No description provided for @notificationsPushProviderNotice.
  ///
  /// In en, this message translates to:
  /// **'Push provider status shows metadata only. No FCM, APNS, or credential values are displayed.'**
  String get notificationsPushProviderNotice;

  /// No description provided for @notificationsPushProviderNone.
  ///
  /// In en, this message translates to:
  /// **'None (in-app only)'**
  String get notificationsPushProviderNone;

  /// No description provided for @notificationsPushProviderFcm.
  ///
  /// In en, this message translates to:
  /// **'FCM'**
  String get notificationsPushProviderFcm;

  /// No description provided for @notificationsPushProviderApns.
  ///
  /// In en, this message translates to:
  /// **'APNS'**
  String get notificationsPushProviderApns;

  /// No description provided for @settingsNotificationsSection.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotificationsSection;

  /// No description provided for @settingsNotificationsBody.
  ///
  /// In en, this message translates to:
  /// **'Manage in-app notification preferences.'**
  String get settingsNotificationsBody;

  /// No description provided for @settingsOpenNotificationPreferences.
  ///
  /// In en, this message translates to:
  /// **'Open notification preferences'**
  String get settingsOpenNotificationPreferences;

  /// No description provided for @translationPanelTitle.
  ///
  /// In en, this message translates to:
  /// **'Translation'**
  String get translationPanelTitle;

  /// No description provided for @translationProviderDisabled.
  ///
  /// In en, this message translates to:
  /// **'Translation provider not configured'**
  String get translationProviderDisabled;

  /// No description provided for @translationTargetLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'Target language'**
  String get translationTargetLanguageLabel;

  /// No description provided for @translationRecipientLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'Recipient language'**
  String get translationRecipientLanguageLabel;

  /// No description provided for @translationTranslateAction.
  ///
  /// In en, this message translates to:
  /// **'Translate'**
  String get translationTranslateAction;

  /// No description provided for @translationTranslating.
  ///
  /// In en, this message translates to:
  /// **'Translating…'**
  String get translationTranslating;

  /// No description provided for @translationActionError.
  ///
  /// In en, this message translates to:
  /// **'Translation failed'**
  String get translationActionError;

  /// No description provided for @translationOriginalTitle.
  ///
  /// In en, this message translates to:
  /// **'Original text'**
  String get translationOriginalTitle;

  /// No description provided for @translationTranslatedTitle.
  ///
  /// In en, this message translates to:
  /// **'Translated text'**
  String get translationTranslatedTitle;

  /// No description provided for @translationLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language: {code}'**
  String translationLanguageLabel(String code);

  /// No description provided for @translationMetadataOnlyNotice.
  ///
  /// In en, this message translates to:
  /// **'Translated text is hidden in metadata-only view'**
  String get translationMetadataOnlyNotice;

  /// No description provided for @translationBadgeMachine.
  ///
  /// In en, this message translates to:
  /// **'Machine translation'**
  String get translationBadgeMachine;

  /// No description provided for @translationBadgeNeedsReview.
  ///
  /// In en, this message translates to:
  /// **'Needs review'**
  String get translationBadgeNeedsReview;

  /// No description provided for @translationBadgeStale.
  ///
  /// In en, this message translates to:
  /// **'Stale translation'**
  String get translationBadgeStale;

  /// No description provided for @translationBadgeApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get translationBadgeApproved;

  /// No description provided for @translationHumanConfirmationRequired.
  ///
  /// In en, this message translates to:
  /// **'Human approval is required before sending translated text'**
  String get translationHumanConfirmationRequired;

  /// No description provided for @translationReplyPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Reply translation preview'**
  String get translationReplyPreviewTitle;

  /// No description provided for @translationReplyPreviewNotice.
  ///
  /// In en, this message translates to:
  /// **'Preview only. Original draft is preserved and nothing is sent automatically.'**
  String get translationReplyPreviewNotice;

  /// No description provided for @translationGeneratePreviewAction.
  ///
  /// In en, this message translates to:
  /// **'Generate preview'**
  String get translationGeneratePreviewAction;

  /// No description provided for @translationNoAutoSendNotice.
  ///
  /// In en, this message translates to:
  /// **'Approving marks the translation ready. Sending remains a separate explicit action.'**
  String get translationNoAutoSendNotice;

  /// No description provided for @translationDismissAction.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get translationDismissAction;

  /// No description provided for @translationApproveForSendAction.
  ///
  /// In en, this message translates to:
  /// **'Approve translation'**
  String get translationApproveForSendAction;

  /// No description provided for @translationApproving.
  ///
  /// In en, this message translates to:
  /// **'Approving…'**
  String get translationApproving;

  /// No description provided for @translationDraftReplyAction.
  ///
  /// In en, this message translates to:
  /// **'Draft reply translation'**
  String get translationDraftReplyAction;

  /// No description provided for @translationReplyApprovedNotice.
  ///
  /// In en, this message translates to:
  /// **'Translation approved. Copy or send through your normal support workflow.'**
  String get translationReplyApprovedNotice;

  /// No description provided for @customerCommunicationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Customer communications'**
  String get customerCommunicationsTitle;

  /// No description provided for @customerCommunicationDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Communication thread'**
  String get customerCommunicationDetailTitle;

  /// No description provided for @customerCommunicationEvidencePackageTitle.
  ///
  /// In en, this message translates to:
  /// **'Evidence package'**
  String get customerCommunicationEvidencePackageTitle;

  /// No description provided for @customerCommunicationLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load customer communications.'**
  String get customerCommunicationLoadError;

  /// No description provided for @customerCommunicationActionError.
  ///
  /// In en, this message translates to:
  /// **'Customer communication action failed.'**
  String get customerCommunicationActionError;

  /// No description provided for @customerCommunicationMockDataBadge.
  ///
  /// In en, this message translates to:
  /// **'Mock data'**
  String get customerCommunicationMockDataBadge;

  /// No description provided for @customerCommunicationOpenModule.
  ///
  /// In en, this message translates to:
  /// **'Open customer communications'**
  String get customerCommunicationOpenModule;

  /// No description provided for @customerCommunicationPrivacyNotice.
  ///
  /// In en, this message translates to:
  /// **'List views are metadata-first. Message bodies appear only on authorized detail access.'**
  String get customerCommunicationPrivacyNotice;

  /// No description provided for @customerCommunicationDetailMetadataOnly.
  ///
  /// In en, this message translates to:
  /// **'Message bodies are hidden for your role or this thread scope.'**
  String get customerCommunicationDetailMetadataOnly;

  /// No description provided for @customerCommunicationSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name, domain, or company'**
  String get customerCommunicationSearchHint;

  /// No description provided for @customerCommunicationListEmpty.
  ///
  /// In en, this message translates to:
  /// **'No customer communication threads match your filters.'**
  String get customerCommunicationListEmpty;

  /// No description provided for @customerCommunicationDisputedBadge.
  ///
  /// In en, this message translates to:
  /// **'Disputed'**
  String get customerCommunicationDisputedBadge;

  /// No description provided for @customerCommunicationBillingRelatedBadge.
  ///
  /// In en, this message translates to:
  /// **'Billing related'**
  String get customerCommunicationBillingRelatedBadge;

  /// No description provided for @customerCommunicationThreadSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{domain} · company {companyId}'**
  String customerCommunicationThreadSubtitle(String domain, String companyId);

  /// No description provided for @customerCommunicationUpdatedAt.
  ///
  /// In en, this message translates to:
  /// **'Updated: {date}'**
  String customerCommunicationUpdatedAt(String date);

  /// No description provided for @customerCommunicationFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get customerCommunicationFilterAll;

  /// No description provided for @customerCommunicationFilterOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get customerCommunicationFilterOpen;

  /// No description provided for @customerCommunicationFilterDisputed.
  ///
  /// In en, this message translates to:
  /// **'Disputed'**
  String get customerCommunicationFilterDisputed;

  /// No description provided for @customerCommunicationFilterClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get customerCommunicationFilterClosed;

  /// No description provided for @customerCommunicationFilterBillingRelated.
  ///
  /// In en, this message translates to:
  /// **'Billing related'**
  String get customerCommunicationFilterBillingRelated;

  /// No description provided for @customerCommunicationStatusOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get customerCommunicationStatusOpen;

  /// No description provided for @customerCommunicationStatusClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get customerCommunicationStatusClosed;

  /// No description provided for @customerCommunicationStatusArchived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get customerCommunicationStatusArchived;

  /// No description provided for @customerCommunicationStatusDisputed.
  ///
  /// In en, this message translates to:
  /// **'Disputed'**
  String get customerCommunicationStatusDisputed;

  /// No description provided for @customerCommunicationStatusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get customerCommunicationStatusUnknown;

  /// No description provided for @customerCommunicationSourcePublicSite.
  ///
  /// In en, this message translates to:
  /// **'Public site'**
  String get customerCommunicationSourcePublicSite;

  /// No description provided for @customerCommunicationSourceEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get customerCommunicationSourceEmail;

  /// No description provided for @customerCommunicationSourceAdminApp.
  ///
  /// In en, this message translates to:
  /// **'Admin app'**
  String get customerCommunicationSourceAdminApp;

  /// No description provided for @customerCommunicationSourceAdminWeb.
  ///
  /// In en, this message translates to:
  /// **'Admin web'**
  String get customerCommunicationSourceAdminWeb;

  /// No description provided for @customerCommunicationSourceImport.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get customerCommunicationSourceImport;

  /// No description provided for @customerCommunicationSourceSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get customerCommunicationSourceSupport;

  /// No description provided for @customerCommunicationSourceSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get customerCommunicationSourceSystem;

  /// No description provided for @customerCommunicationSourceUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get customerCommunicationSourceUnknown;

  /// No description provided for @customerCommunicationDirectionInbound.
  ///
  /// In en, this message translates to:
  /// **'Inbound'**
  String get customerCommunicationDirectionInbound;

  /// No description provided for @customerCommunicationDirectionOutbound.
  ///
  /// In en, this message translates to:
  /// **'Outbound'**
  String get customerCommunicationDirectionOutbound;

  /// No description provided for @customerCommunicationDirectionInternalNote.
  ///
  /// In en, this message translates to:
  /// **'Internal note'**
  String get customerCommunicationDirectionInternalNote;

  /// No description provided for @customerCommunicationDirectionSystemEvent.
  ///
  /// In en, this message translates to:
  /// **'System event'**
  String get customerCommunicationDirectionSystemEvent;

  /// No description provided for @customerCommunicationDirectionUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get customerCommunicationDirectionUnknown;

  /// No description provided for @customerCommunicationSenderCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customerCommunicationSenderCustomer;

  /// No description provided for @customerCommunicationSenderPlatformAdmin.
  ///
  /// In en, this message translates to:
  /// **'Platform admin'**
  String get customerCommunicationSenderPlatformAdmin;

  /// No description provided for @customerCommunicationSenderCompanyAdmin.
  ///
  /// In en, this message translates to:
  /// **'Company admin'**
  String get customerCommunicationSenderCompanyAdmin;

  /// No description provided for @customerCommunicationSenderSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get customerCommunicationSenderSystem;

  /// No description provided for @customerCommunicationSenderUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get customerCommunicationSenderUnknown;

  /// No description provided for @customerCommunicationHumanReviewedBadge.
  ///
  /// In en, this message translates to:
  /// **'Human reviewed'**
  String get customerCommunicationHumanReviewedBadge;

  /// No description provided for @customerCommunicationOriginalLabel.
  ///
  /// In en, this message translates to:
  /// **'Original ({language})'**
  String customerCommunicationOriginalLabel(String language);

  /// No description provided for @customerCommunicationTranslatedLabel.
  ///
  /// In en, this message translates to:
  /// **'Translated ({language})'**
  String customerCommunicationTranslatedLabel(String language);

  /// No description provided for @customerCommunicationMessageMetadataOnly.
  ///
  /// In en, this message translates to:
  /// **'Message body hidden (metadata-only view).'**
  String get customerCommunicationMessageMetadataOnly;

  /// No description provided for @customerCommunicationMessagesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No messages logged yet.'**
  String get customerCommunicationMessagesEmpty;

  /// No description provided for @customerCommunicationTimelineTitle.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get customerCommunicationTimelineTitle;

  /// No description provided for @customerCommunicationAgreementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Agreement snapshots'**
  String get customerCommunicationAgreementsTitle;

  /// No description provided for @customerCommunicationEvidencePackagesTitle.
  ///
  /// In en, this message translates to:
  /// **'Evidence packages'**
  String get customerCommunicationEvidencePackagesTitle;

  /// No description provided for @customerCommunicationPackagesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No evidence packages generated yet.'**
  String get customerCommunicationPackagesEmpty;

  /// No description provided for @customerCommunicationAgreementPrice.
  ///
  /// In en, this message translates to:
  /// **'{amount} {currency} · {cycle}'**
  String customerCommunicationAgreementPrice(
    String amount,
    String currency,
    String cycle,
  );

  /// No description provided for @customerCommunicationAgreementModules.
  ///
  /// In en, this message translates to:
  /// **'Modules: {modules}'**
  String customerCommunicationAgreementModules(String modules);

  /// No description provided for @customerCommunicationAgreementAcceptedAt.
  ///
  /// In en, this message translates to:
  /// **'Accepted: {date}'**
  String customerCommunicationAgreementAcceptedAt(String date);

  /// No description provided for @customerCommunicationPdfPendingNotice.
  ///
  /// In en, this message translates to:
  /// **'PDF rendering pending; structured evidence package generated from audit records.'**
  String get customerCommunicationPdfPendingNotice;

  /// No description provided for @customerCommunicationPdfReadyNotice.
  ///
  /// In en, this message translates to:
  /// **'PDF evidence package is ready to share from this device.'**
  String get customerCommunicationPdfReadyNotice;

  /// No description provided for @customerCommunicationPdfFailedNotice.
  ///
  /// In en, this message translates to:
  /// **'PDF rendering failed. Structured summaryJson remains available from audit records.'**
  String get customerCommunicationPdfFailedNotice;

  /// No description provided for @customerCommunicationPdfSourceOfTruthNotice.
  ///
  /// In en, this message translates to:
  /// **'Generated from ViaNexis audit records. Database audit records remain the source of truth; this PDF is a presentation export only.'**
  String get customerCommunicationPdfSourceOfTruthNotice;

  /// No description provided for @customerCommunicationDownloadPdfAction.
  ///
  /// In en, this message translates to:
  /// **'Download PDF'**
  String get customerCommunicationDownloadPdfAction;

  /// No description provided for @customerCommunicationDownloadPdfSuccess.
  ///
  /// In en, this message translates to:
  /// **'PDF downloaded ({bytes} bytes). Handle according to your privacy and retention policy.'**
  String customerCommunicationDownloadPdfSuccess(String bytes);

  /// No description provided for @customerCommunicationDownloadPdfFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not download the evidence PDF.'**
  String get customerCommunicationDownloadPdfFailed;

  /// No description provided for @customerCommunicationSharePdfAction.
  ///
  /// In en, this message translates to:
  /// **'Share PDF'**
  String get customerCommunicationSharePdfAction;

  /// No description provided for @customerCommunicationSharePdfSuccess.
  ///
  /// In en, this message translates to:
  /// **'PDF ready to share. Use your device share sheet to open or save the file.'**
  String get customerCommunicationSharePdfSuccess;

  /// No description provided for @customerCommunicationSharePdfFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not share the evidence PDF.'**
  String get customerCommunicationSharePdfFailed;

  /// No description provided for @customerCommunicationSharePdfInvalid.
  ///
  /// In en, this message translates to:
  /// **'The evidence PDF file is empty or invalid. Regenerate the package or try again.'**
  String get customerCommunicationSharePdfInvalid;

  /// No description provided for @customerCommunicationSharePdfUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Sharing is not available on this device. Try again or use another device.'**
  String get customerCommunicationSharePdfUnavailable;

  /// No description provided for @customerCommunicationSharePdfNotReady.
  ///
  /// In en, this message translates to:
  /// **'PDF is not ready yet. Wait for generation to finish or regenerate the package.'**
  String get customerCommunicationSharePdfNotReady;

  /// No description provided for @customerCommunicationGeneratedBy.
  ///
  /// In en, this message translates to:
  /// **'Generated by user ID: {userId}'**
  String customerCommunicationGeneratedBy(String userId);

  /// No description provided for @customerCommunicationSendReplyTitle.
  ///
  /// In en, this message translates to:
  /// **'Send customer reply'**
  String get customerCommunicationSendReplyTitle;

  /// No description provided for @customerCommunicationSendReplyAction.
  ///
  /// In en, this message translates to:
  /// **'Send reply'**
  String get customerCommunicationSendReplyAction;

  /// No description provided for @customerCommunicationSendReplyMessageLabel.
  ///
  /// In en, this message translates to:
  /// **'Reply message'**
  String get customerCommunicationSendReplyMessageLabel;

  /// No description provided for @customerCommunicationSendReplySubjectLabel.
  ///
  /// In en, this message translates to:
  /// **'Email subject (optional)'**
  String get customerCommunicationSendReplySubjectLabel;

  /// No description provided for @customerCommunicationUseTranslatedTextLabel.
  ///
  /// In en, this message translates to:
  /// **'Use approved translated text'**
  String get customerCommunicationUseTranslatedTextLabel;

  /// No description provided for @customerCommunicationHumanConfirmationLabel.
  ///
  /// In en, this message translates to:
  /// **'I confirm this reply is ready to send'**
  String get customerCommunicationHumanConfirmationLabel;

  /// No description provided for @customerCommunicationHumanConfirmedBadge.
  ///
  /// In en, this message translates to:
  /// **'Human confirmed'**
  String get customerCommunicationHumanConfirmedBadge;

  /// No description provided for @customerCommunicationTranslationApprovedBadge.
  ///
  /// In en, this message translates to:
  /// **'Translation approved'**
  String get customerCommunicationTranslationApprovedBadge;

  /// No description provided for @customerCommunicationTranslatedReplyWarning.
  ///
  /// In en, this message translates to:
  /// **'Translated replies are not sent automatically. Review and confirm before sending.'**
  String get customerCommunicationTranslatedReplyWarning;

  /// No description provided for @customerCommunicationDeliveryProviderDisabledNotice.
  ///
  /// In en, this message translates to:
  /// **'Delivery provider disabled; reply will be logged but not externally sent.'**
  String get customerCommunicationDeliveryProviderDisabledNotice;

  /// No description provided for @customerCommunicationReplyLoggedSkippedNotice.
  ///
  /// In en, this message translates to:
  /// **'Reply logged with skipped delivery (provider disabled).'**
  String get customerCommunicationReplyLoggedSkippedNotice;

  /// No description provided for @customerCommunicationReplySentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Reply sent successfully.'**
  String get customerCommunicationReplySentSuccess;

  /// No description provided for @customerCommunicationEvidenceDeliveryNotice.
  ///
  /// In en, this message translates to:
  /// **'Evidence packages include outbound delivery status when available.'**
  String get customerCommunicationEvidenceDeliveryNotice;

  /// No description provided for @customerCommunicationDeliveryStatusDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get customerCommunicationDeliveryStatusDraft;

  /// No description provided for @customerCommunicationDeliveryStatusQueued.
  ///
  /// In en, this message translates to:
  /// **'Queued'**
  String get customerCommunicationDeliveryStatusQueued;

  /// No description provided for @customerCommunicationDeliveryStatusSkipped.
  ///
  /// In en, this message translates to:
  /// **'Skipped'**
  String get customerCommunicationDeliveryStatusSkipped;

  /// No description provided for @customerCommunicationDeliveryStatusSent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get customerCommunicationDeliveryStatusSent;

  /// No description provided for @customerCommunicationDeliveryStatusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get customerCommunicationDeliveryStatusFailed;

  /// No description provided for @customerCommunicationDeliveryStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get customerCommunicationDeliveryStatusCancelled;

  /// No description provided for @customerCommunicationDeliveryStatusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown status'**
  String get customerCommunicationDeliveryStatusUnknown;

  /// No description provided for @customerCommunicationDeliveryChannelEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get customerCommunicationDeliveryChannelEmail;

  /// No description provided for @customerCommunicationDeliveryChannelPortal.
  ///
  /// In en, this message translates to:
  /// **'Portal'**
  String get customerCommunicationDeliveryChannelPortal;

  /// No description provided for @customerCommunicationDeliveryChannelManual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get customerCommunicationDeliveryChannelManual;

  /// No description provided for @customerCommunicationDeliveryChannelNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get customerCommunicationDeliveryChannelNone;

  /// No description provided for @customerCommunicationDeliveryChannelUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown channel'**
  String get customerCommunicationDeliveryChannelUnknown;

  /// No description provided for @customerCommunicationDeliveryHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Delivery history'**
  String get customerCommunicationDeliveryHistoryTitle;

  /// No description provided for @customerCommunicationDeliveryHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No delivery attempts recorded yet.'**
  String get customerCommunicationDeliveryHistoryEmpty;

  /// No description provided for @customerCommunicationDeliveryFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get customerCommunicationDeliveryFilterAll;

  /// No description provided for @customerCommunicationDeliveryFilterSkipped.
  ///
  /// In en, this message translates to:
  /// **'Skipped'**
  String get customerCommunicationDeliveryFilterSkipped;

  /// No description provided for @customerCommunicationDeliveryFilterFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get customerCommunicationDeliveryFilterFailed;

  /// No description provided for @customerCommunicationDeliveryFilterSent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get customerCommunicationDeliveryFilterSent;

  /// No description provided for @customerCommunicationDeliveryFilterQueued.
  ///
  /// In en, this message translates to:
  /// **'Queued'**
  String get customerCommunicationDeliveryFilterQueued;

  /// No description provided for @customerCommunicationResendTitle.
  ///
  /// In en, this message translates to:
  /// **'Resend delivery'**
  String get customerCommunicationResendTitle;

  /// No description provided for @customerCommunicationResendAction.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get customerCommunicationResendAction;

  /// No description provided for @customerCommunicationResendAuditNotice.
  ///
  /// In en, this message translates to:
  /// **'Resending creates a new audited delivery attempt.'**
  String get customerCommunicationResendAuditNotice;

  /// No description provided for @customerCommunicationResendTranslationNotice.
  ///
  /// In en, this message translates to:
  /// **'Translated replies require approved translation before sending.'**
  String get customerCommunicationResendTranslationNotice;

  /// No description provided for @customerCommunicationResendSuccess.
  ///
  /// In en, this message translates to:
  /// **'Resend logged successfully.'**
  String get customerCommunicationResendSuccess;

  /// No description provided for @customerCommunicationDeliveryMultipleAttempts.
  ///
  /// In en, this message translates to:
  /// **'Multiple delivery attempts recorded — see delivery history.'**
  String get customerCommunicationDeliveryMultipleAttempts;

  /// No description provided for @customerCommunicationDeliveryResendAttempt.
  ///
  /// In en, this message translates to:
  /// **'This attempt is a resend of a prior delivery.'**
  String get customerCommunicationDeliveryResendAttempt;

  /// No description provided for @customerCommunicationDeliveryTemplateLabel.
  ///
  /// In en, this message translates to:
  /// **'Email template'**
  String get customerCommunicationDeliveryTemplateLabel;

  /// No description provided for @customerCommunicationEvidenceRegenerationNotice.
  ///
  /// In en, this message translates to:
  /// **'Evidence package may need regeneration after new delivery attempts.'**
  String get customerCommunicationEvidenceRegenerationNotice;

  /// No description provided for @customerCommunicationHumanConfirmRequired.
  ///
  /// In en, this message translates to:
  /// **'Human confirmation is required.'**
  String get customerCommunicationHumanConfirmRequired;

  /// No description provided for @customerCommunicationDeliveryEventQueued.
  ///
  /// In en, this message translates to:
  /// **'Queued'**
  String get customerCommunicationDeliveryEventQueued;

  /// No description provided for @customerCommunicationDeliveryEventSent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get customerCommunicationDeliveryEventSent;

  /// No description provided for @customerCommunicationDeliveryEventDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get customerCommunicationDeliveryEventDelivered;

  /// No description provided for @customerCommunicationDeliveryEventBounced.
  ///
  /// In en, this message translates to:
  /// **'Bounced'**
  String get customerCommunicationDeliveryEventBounced;

  /// No description provided for @customerCommunicationDeliveryEventComplained.
  ///
  /// In en, this message translates to:
  /// **'Complained'**
  String get customerCommunicationDeliveryEventComplained;

  /// No description provided for @customerCommunicationDeliveryEventOpened.
  ///
  /// In en, this message translates to:
  /// **'Opened'**
  String get customerCommunicationDeliveryEventOpened;

  /// No description provided for @customerCommunicationDeliveryEventClicked.
  ///
  /// In en, this message translates to:
  /// **'Clicked'**
  String get customerCommunicationDeliveryEventClicked;

  /// No description provided for @customerCommunicationDeliveryEventFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get customerCommunicationDeliveryEventFailed;

  /// No description provided for @customerCommunicationDeliveryEventProviderStatus.
  ///
  /// In en, this message translates to:
  /// **'Provider status'**
  String get customerCommunicationDeliveryEventProviderStatus;

  /// No description provided for @customerCommunicationDeliveryEventUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown event'**
  String get customerCommunicationDeliveryEventUnknown;

  /// No description provided for @customerCommunicationPackageGeneratedAt.
  ///
  /// In en, this message translates to:
  /// **'Generated: {date}'**
  String customerCommunicationPackageGeneratedAt(String date);

  /// No description provided for @customerCommunicationPackageTypeCommunicationEvidence.
  ///
  /// In en, this message translates to:
  /// **'Communication evidence'**
  String get customerCommunicationPackageTypeCommunicationEvidence;

  /// No description provided for @customerCommunicationPackageTypeSubscriptionDispute.
  ///
  /// In en, this message translates to:
  /// **'Subscription dispute'**
  String get customerCommunicationPackageTypeSubscriptionDispute;

  /// No description provided for @customerCommunicationPackageTypeRegistrationEvidence.
  ///
  /// In en, this message translates to:
  /// **'Registration evidence'**
  String get customerCommunicationPackageTypeRegistrationEvidence;

  /// No description provided for @customerCommunicationPackageTypePricingEvidence.
  ///
  /// In en, this message translates to:
  /// **'Pricing evidence'**
  String get customerCommunicationPackageTypePricingEvidence;

  /// No description provided for @customerCommunicationPackageTypeUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown package type'**
  String get customerCommunicationPackageTypeUnknown;

  /// No description provided for @customerCommunicationPackageStatusGenerated.
  ///
  /// In en, this message translates to:
  /// **'Generated'**
  String get customerCommunicationPackageStatusGenerated;

  /// No description provided for @customerCommunicationPackageStatusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get customerCommunicationPackageStatusFailed;

  /// No description provided for @customerCommunicationPackageStatusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown status'**
  String get customerCommunicationPackageStatusUnknown;

  /// No description provided for @customerCommunicationGeneratePackageTitle.
  ///
  /// In en, this message translates to:
  /// **'Generate evidence package'**
  String get customerCommunicationGeneratePackageTitle;

  /// No description provided for @customerCommunicationGeneratePackageAction.
  ///
  /// In en, this message translates to:
  /// **'Generate package'**
  String get customerCommunicationGeneratePackageAction;

  /// No description provided for @customerCommunicationMarkDisputedTitle.
  ///
  /// In en, this message translates to:
  /// **'Mark thread disputed'**
  String get customerCommunicationMarkDisputedTitle;

  /// No description provided for @customerCommunicationMarkDisputedAction.
  ///
  /// In en, this message translates to:
  /// **'Mark disputed'**
  String get customerCommunicationMarkDisputedAction;

  /// No description provided for @customerCommunicationDisputedSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Dispute'**
  String get customerCommunicationDisputedSectionTitle;

  /// No description provided for @customerCommunicationReasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Reason (required)'**
  String get customerCommunicationReasonLabel;

  /// No description provided for @customerCommunicationReasonRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter at least 5 characters.'**
  String get customerCommunicationReasonRequired;

  /// No description provided for @customerCommunicationPackageTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Package type'**
  String get customerCommunicationPackageTypeLabel;

  /// No description provided for @customerCommunicationExportAuditWarning.
  ///
  /// In en, this message translates to:
  /// **'Export creates an audited evidence package from database records. Provide a reason for compliance.'**
  String get customerCommunicationExportAuditWarning;

  /// No description provided for @customerCommunicationCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get customerCommunicationCancel;

  /// No description provided for @customerCommunicationDisputeMarkedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Thread marked as disputed.'**
  String get customerCommunicationDisputeMarkedSuccess;

  /// No description provided for @customerCommunicationPackageGeneratedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Evidence package generated.'**
  String get customerCommunicationPackageGeneratedSuccess;

  /// No description provided for @customerCommunicationSummaryJsonTitle.
  ///
  /// In en, this message translates to:
  /// **'Structured summary (authoritative audit export)'**
  String get customerCommunicationSummaryJsonTitle;

  /// No description provided for @customerCommunicationPackageReason.
  ///
  /// In en, this message translates to:
  /// **'Reason: {reason}'**
  String customerCommunicationPackageReason(String reason);

  /// No description provided for @customerCommunicationFileHash.
  ///
  /// In en, this message translates to:
  /// **'Integrity hash: {hash}'**
  String customerCommunicationFileHash(String hash);

  /// No description provided for @customerCommunicationPackageNotFound.
  ///
  /// In en, this message translates to:
  /// **'Evidence package not found.'**
  String get customerCommunicationPackageNotFound;

  /// No description provided for @customerCommunicationSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Customer communications'**
  String get customerCommunicationSummaryTitle;

  /// No description provided for @customerCommunicationSummaryDisputed.
  ///
  /// In en, this message translates to:
  /// **'Disputed: {count}'**
  String customerCommunicationSummaryDisputed(String count);

  /// No description provided for @customerCommunicationSummaryOpen.
  ///
  /// In en, this message translates to:
  /// **'Open: {count}'**
  String customerCommunicationSummaryOpen(String count);

  /// No description provided for @customerCommunicationSummaryTotal.
  ///
  /// In en, this message translates to:
  /// **'Total: {count}'**
  String customerCommunicationSummaryTotal(String count);

  /// No description provided for @publicIntakesTitle.
  ///
  /// In en, this message translates to:
  /// **'Public intakes'**
  String get publicIntakesTitle;

  /// No description provided for @publicIntakeDashboardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Review website leads and quote requests. Also available under More.'**
  String get publicIntakeDashboardSubtitle;

  /// No description provided for @publicIntakeDashboardOpenAction.
  ///
  /// In en, this message translates to:
  /// **'Open public intakes'**
  String get publicIntakeDashboardOpenAction;

  /// No description provided for @publicIntakeModuleDescription.
  ///
  /// In en, this message translates to:
  /// **'Website leads, demo and quote requests'**
  String get publicIntakeModuleDescription;

  /// No description provided for @publicIntakeNoLinkedThreadTitle.
  ///
  /// In en, this message translates to:
  /// **'No customer communication thread yet'**
  String get publicIntakeNoLinkedThreadTitle;

  /// No description provided for @publicIntakeNoLinkedThreadBody.
  ///
  /// In en, this message translates to:
  /// **'This intake is not linked to a customer communication thread. Review the intake details here; a thread may be created when backend workflow links it.'**
  String get publicIntakeNoLinkedThreadBody;

  /// No description provided for @publicIntakeNoLinksTitle.
  ///
  /// In en, this message translates to:
  /// **'No linked records'**
  String get publicIntakeNoLinksTitle;

  /// No description provided for @publicIntakeNoLinksBody.
  ///
  /// In en, this message translates to:
  /// **'No communication thread, quote request, or pricing intake is linked to this submission yet.'**
  String get publicIntakeNoLinksBody;

  /// No description provided for @publicIntakeDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Public intake'**
  String get publicIntakeDetailTitle;

  /// No description provided for @publicIntakeSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search company, domain, country…'**
  String get publicIntakeSearchHint;

  /// No description provided for @publicIntakeListEmpty.
  ///
  /// In en, this message translates to:
  /// **'No public intakes match your filters.'**
  String get publicIntakeListEmpty;

  /// No description provided for @publicIntakeListError.
  ///
  /// In en, this message translates to:
  /// **'Could not load public intakes.'**
  String get publicIntakeListError;

  /// No description provided for @publicIntakeDetailError.
  ///
  /// In en, this message translates to:
  /// **'Could not load public intake detail.'**
  String get publicIntakeDetailError;

  /// No description provided for @publicIntakeMockDataBadge.
  ///
  /// In en, this message translates to:
  /// **'Mock data'**
  String get publicIntakeMockDataBadge;

  /// No description provided for @publicIntakeUnknownCustomer.
  ///
  /// In en, this message translates to:
  /// **'Unknown contact'**
  String get publicIntakeUnknownCustomer;

  /// No description provided for @publicIntakeCreatedAt.
  ///
  /// In en, this message translates to:
  /// **'Submitted: {date}'**
  String publicIntakeCreatedAt(String date);

  /// No description provided for @publicIntakeFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get publicIntakeFilterAll;

  /// No description provided for @publicIntakeFilterNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get publicIntakeFilterNew;

  /// No description provided for @publicIntakeFilterReviewing.
  ///
  /// In en, this message translates to:
  /// **'Reviewing'**
  String get publicIntakeFilterReviewing;

  /// No description provided for @publicIntakeFilterQuoteDemo.
  ///
  /// In en, this message translates to:
  /// **'Quote / demo'**
  String get publicIntakeFilterQuoteDemo;

  /// No description provided for @publicIntakeFilterContacted.
  ///
  /// In en, this message translates to:
  /// **'Contacted / quoted'**
  String get publicIntakeFilterContacted;

  /// No description provided for @publicIntakeFilterClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get publicIntakeFilterClosed;

  /// No description provided for @publicIntakeTypeContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get publicIntakeTypeContact;

  /// No description provided for @publicIntakeTypeDemoRequest.
  ///
  /// In en, this message translates to:
  /// **'Demo request'**
  String get publicIntakeTypeDemoRequest;

  /// No description provided for @publicIntakeTypeQuoteRequest.
  ///
  /// In en, this message translates to:
  /// **'Quote request'**
  String get publicIntakeTypeQuoteRequest;

  /// No description provided for @publicIntakeTypeRegistrationInterest.
  ///
  /// In en, this message translates to:
  /// **'Registration interest'**
  String get publicIntakeTypeRegistrationInterest;

  /// No description provided for @publicIntakeTypeSupportRequest.
  ///
  /// In en, this message translates to:
  /// **'Support request'**
  String get publicIntakeTypeSupportRequest;

  /// No description provided for @publicIntakeTypeUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown type'**
  String get publicIntakeTypeUnknown;

  /// No description provided for @publicIntakeStatusNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get publicIntakeStatusNew;

  /// No description provided for @publicIntakeStatusReviewing.
  ///
  /// In en, this message translates to:
  /// **'Reviewing'**
  String get publicIntakeStatusReviewing;

  /// No description provided for @publicIntakeStatusContacted.
  ///
  /// In en, this message translates to:
  /// **'Contacted'**
  String get publicIntakeStatusContacted;

  /// No description provided for @publicIntakeStatusQuoted.
  ///
  /// In en, this message translates to:
  /// **'Quoted'**
  String get publicIntakeStatusQuoted;

  /// No description provided for @publicIntakeStatusConverted.
  ///
  /// In en, this message translates to:
  /// **'Converted'**
  String get publicIntakeStatusConverted;

  /// No description provided for @publicIntakeStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get publicIntakeStatusRejected;

  /// No description provided for @publicIntakeStatusClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get publicIntakeStatusClosed;

  /// No description provided for @publicIntakeStatusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown status'**
  String get publicIntakeStatusUnknown;

  /// No description provided for @publicIntakeSectionCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get publicIntakeSectionCustomer;

  /// No description provided for @publicIntakeSectionConsent.
  ///
  /// In en, this message translates to:
  /// **'Consent'**
  String get publicIntakeSectionConsent;

  /// No description provided for @publicIntakeSectionMessage.
  ///
  /// In en, this message translates to:
  /// **'Original message'**
  String get publicIntakeSectionMessage;

  /// No description provided for @publicIntakeSectionQuote.
  ///
  /// In en, this message translates to:
  /// **'Quote details'**
  String get publicIntakeSectionQuote;

  /// No description provided for @publicIntakeSectionLinks.
  ///
  /// In en, this message translates to:
  /// **'Related records'**
  String get publicIntakeSectionLinks;

  /// No description provided for @publicIntakeFieldCustomerName.
  ///
  /// In en, this message translates to:
  /// **'Contact name'**
  String get publicIntakeFieldCustomerName;

  /// No description provided for @publicIntakeFieldEmailDomain.
  ///
  /// In en, this message translates to:
  /// **'Email domain'**
  String get publicIntakeFieldEmailDomain;

  /// No description provided for @publicIntakeFieldCompany.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get publicIntakeFieldCompany;

  /// No description provided for @publicIntakeFieldCountry.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get publicIntakeFieldCountry;

  /// No description provided for @publicIntakeFieldOriginalLanguage.
  ///
  /// In en, this message translates to:
  /// **'Original language: {lang}'**
  String publicIntakeFieldOriginalLanguage(String lang);

  /// No description provided for @publicIntakeFieldFleetSize.
  ///
  /// In en, this message translates to:
  /// **'Fleet size: {count}'**
  String publicIntakeFieldFleetSize(String count);

  /// No description provided for @publicIntakeFieldOfficeUsers.
  ///
  /// In en, this message translates to:
  /// **'Office users: {count}'**
  String publicIntakeFieldOfficeUsers(String count);

  /// No description provided for @publicIntakeFieldDriverApps.
  ///
  /// In en, this message translates to:
  /// **'Driver apps: {count}'**
  String publicIntakeFieldDriverApps(String count);

  /// No description provided for @publicIntakeFieldModules.
  ///
  /// In en, this message translates to:
  /// **'Requested modules'**
  String get publicIntakeFieldModules;

  /// No description provided for @publicIntakeFieldAiFeatures.
  ///
  /// In en, this message translates to:
  /// **'Requested AI features'**
  String get publicIntakeFieldAiFeatures;

  /// No description provided for @publicIntakeFieldStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get publicIntakeFieldStatus;

  /// No description provided for @publicIntakeFieldConsentVersion.
  ///
  /// In en, this message translates to:
  /// **'Consent version'**
  String get publicIntakeFieldConsentVersion;

  /// No description provided for @publicIntakeConsentPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy consent'**
  String get publicIntakeConsentPrivacy;

  /// No description provided for @publicIntakeConsentTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms consent'**
  String get publicIntakeConsentTerms;

  /// No description provided for @publicIntakeConsentMarketing.
  ///
  /// In en, this message translates to:
  /// **'Marketing consent'**
  String get publicIntakeConsentMarketing;

  /// No description provided for @publicIntakeConsentYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get publicIntakeConsentYes;

  /// No description provided for @publicIntakeConsentNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get publicIntakeConsentNo;

  /// No description provided for @publicIntakeOpenThreadAction.
  ///
  /// In en, this message translates to:
  /// **'Open customer communication thread'**
  String get publicIntakeOpenThreadAction;

  /// No description provided for @publicIntakeLinkedQuote.
  ///
  /// In en, this message translates to:
  /// **'Linked quote request'**
  String get publicIntakeLinkedQuote;

  /// No description provided for @publicIntakeLinkedPricing.
  ///
  /// In en, this message translates to:
  /// **'Linked pricing intake'**
  String get publicIntakeLinkedPricing;

  /// No description provided for @publicIntakeChangeStatusAction.
  ///
  /// In en, this message translates to:
  /// **'Update status'**
  String get publicIntakeChangeStatusAction;

  /// No description provided for @publicIntakeStatusDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Update intake status'**
  String get publicIntakeStatusDialogTitle;

  /// No description provided for @publicIntakeReasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get publicIntakeReasonLabel;

  /// No description provided for @publicIntakeReasonRequired.
  ///
  /// In en, this message translates to:
  /// **'Reason is required when closing or rejecting.'**
  String get publicIntakeReasonRequired;

  /// No description provided for @publicIntakeReasonMinLength.
  ///
  /// In en, this message translates to:
  /// **'Enter at least 5 characters.'**
  String get publicIntakeReasonMinLength;

  /// No description provided for @publicIntakeCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get publicIntakeCancel;

  /// No description provided for @publicIntakeStatusConfirm.
  ///
  /// In en, this message translates to:
  /// **'Save status'**
  String get publicIntakeStatusConfirm;

  /// No description provided for @publicIntakeStatusSuccess.
  ///
  /// In en, this message translates to:
  /// **'Status updated.'**
  String get publicIntakeStatusSuccess;

  /// No description provided for @publicIntakeStatusError.
  ///
  /// In en, this message translates to:
  /// **'Could not update status.'**
  String get publicIntakeStatusError;

  /// No description provided for @publicIntakeEvidenceNotice.
  ///
  /// In en, this message translates to:
  /// **'This public intake is logged from first contact and can be included in evidence packages.'**
  String get publicIntakeEvidenceNotice;

  /// No description provided for @publicIntakeDashboardNew.
  ///
  /// In en, this message translates to:
  /// **'New public intakes: {count}'**
  String publicIntakeDashboardNew(String count);

  /// No description provided for @publicIntakeDashboardHighPriority.
  ///
  /// In en, this message translates to:
  /// **'Quote/demo requests: {count}'**
  String publicIntakeDashboardHighPriority(String count);

  /// No description provided for @actionCenterFilterPublicIntake.
  ///
  /// In en, this message translates to:
  /// **'Public intakes'**
  String get actionCenterFilterPublicIntake;

  /// No description provided for @actionCenterTypePublicIntake.
  ///
  /// In en, this message translates to:
  /// **'Public intake'**
  String get actionCenterTypePublicIntake;

  /// No description provided for @navMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get navMore;

  /// No description provided for @modulesHubTitle.
  ///
  /// In en, this message translates to:
  /// **'Modules'**
  String get modulesHubTitle;

  /// No description provided for @modulesHubBody.
  ///
  /// In en, this message translates to:
  /// **'Additional admin modules and settings.'**
  String get modulesHubBody;

  /// No description provided for @navReturnToDashboard.
  ///
  /// In en, this message translates to:
  /// **'Return to dashboard'**
  String get navReturnToDashboard;

  /// No description provided for @settingsLanguageSection.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguageSection;

  /// No description provided for @settingsLanguageBody.
  ///
  /// In en, this message translates to:
  /// **'Choose the admin app display language.'**
  String get settingsLanguageBody;

  /// No description provided for @settingsLanguageHu.
  ///
  /// In en, this message translates to:
  /// **'Hungarian'**
  String get settingsLanguageHu;

  /// No description provided for @settingsLanguageEn.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEn;

  /// No description provided for @devicePinSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Device PIN'**
  String get devicePinSectionTitle;

  /// No description provided for @devicePinSectionBody.
  ///
  /// In en, this message translates to:
  /// **'Optional local PIN for this device. Does not replace backend sign-in.'**
  String get devicePinSectionBody;

  /// No description provided for @devicePinSetAction.
  ///
  /// In en, this message translates to:
  /// **'Set PIN'**
  String get devicePinSetAction;

  /// No description provided for @devicePinChangeAction.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get devicePinChangeAction;

  /// No description provided for @devicePinRemoveAction.
  ///
  /// In en, this message translates to:
  /// **'Remove PIN'**
  String get devicePinRemoveAction;

  /// No description provided for @devicePinCurrentLabel.
  ///
  /// In en, this message translates to:
  /// **'Current PIN'**
  String get devicePinCurrentLabel;

  /// No description provided for @devicePinNewLabel.
  ///
  /// In en, this message translates to:
  /// **'New PIN'**
  String get devicePinNewLabel;

  /// No description provided for @devicePinConfirmLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm PIN'**
  String get devicePinConfirmLabel;

  /// No description provided for @devicePinSetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Device PIN saved.'**
  String get devicePinSetSuccess;

  /// No description provided for @devicePinChangeSuccess.
  ///
  /// In en, this message translates to:
  /// **'Device PIN updated.'**
  String get devicePinChangeSuccess;

  /// No description provided for @devicePinRemoveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Device PIN removed.'**
  String get devicePinRemoveSuccess;

  /// No description provided for @devicePinMismatch.
  ///
  /// In en, this message translates to:
  /// **'PIN entries do not match.'**
  String get devicePinMismatch;

  /// No description provided for @devicePinInvalidLength.
  ///
  /// In en, this message translates to:
  /// **'PIN must be 4–8 digits.'**
  String get devicePinInvalidLength;

  /// No description provided for @devicePinInvalidCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current PIN is incorrect.'**
  String get devicePinInvalidCurrent;

  /// No description provided for @devicePinNonNumeric.
  ///
  /// In en, this message translates to:
  /// **'PIN must contain digits only.'**
  String get devicePinNonNumeric;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hu'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hu':
      return AppLocalizationsHu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
