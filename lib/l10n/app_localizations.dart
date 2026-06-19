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
