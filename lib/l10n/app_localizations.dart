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
  /// **'Platform sign in'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with your ViaNexis platform account.'**
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
  /// **'This account is not authorized for the platform admin app.'**
  String get authForbiddenRole;

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
  /// **'Platform dashboard'**
  String get dashboardTitle;

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

  /// No description provided for @auditLogDateRangeComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Date range filter (coming soon)'**
  String get auditLogDateRangeComingSoon;

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
