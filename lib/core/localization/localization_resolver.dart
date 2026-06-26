import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../localization/localization_keys.dart';

String resolveLocalizationKey(BuildContext context, String key) {
  final l10n = AppLocalizations.of(context);
  return switch (key) {
    LocalizationKeys.authEmail => l10n.authEmail,
    LocalizationKeys.authPassword => l10n.authPassword,
    LocalizationKeys.authSignIn => l10n.authSignIn,
    LocalizationKeys.authSigningIn => l10n.authSigningIn,
    LocalizationKeys.authLogout => l10n.authLogout,
    LocalizationKeys.authInvalidCredentials => l10n.authInvalidCredentials,
    LocalizationKeys.authSessionExpired => l10n.authSessionExpired,
    LocalizationKeys.authNetworkError => l10n.authNetworkError,
    LocalizationKeys.authServerError => l10n.authServerError,
    LocalizationKeys.authForbiddenRole => l10n.authForbiddenRole,
    LocalizationKeys.authLoginServiceUnavailable => l10n.authLoginServiceUnavailable,
    LocalizationKeys.authBackendNotConfigured => l10n.authBackendNotConfigured,
    LocalizationKeys.errorActionUnavailable => l10n.errorActionUnavailable,
    LocalizationKeys.authRequiredField => l10n.authRequiredField,
    LocalizationKeys.authShowPassword => l10n.authShowPassword,
    LocalizationKeys.authHidePassword => l10n.authHidePassword,
    LocalizationKeys.authPasswordChangeInvalidCurrent =>
      l10n.authPasswordChangeInvalidCurrent,
    LocalizationKeys.authPasswordChangeWeakPassword =>
      l10n.authPasswordChangeWeakPassword,
    LocalizationKeys.authPasswordChangeUnchanged =>
      l10n.authPasswordChangeUnchanged,
    LocalizationKeys.settingsPasswordChangeSuccess =>
      l10n.settingsPasswordChangeSuccess,
    LocalizationKeys.settingsPasswordMinLengthValidation =>
      l10n.settingsPasswordMinLengthValidation,
    LocalizationKeys.settingsPasswordMismatchValidation =>
      l10n.settingsPasswordMismatchValidation,
    LocalizationKeys.errorGenericBody => l10n.errorGenericBody,
    LocalizationKeys.roleSuperAdmin => l10n.roleSuperAdmin,
    LocalizationKeys.roleSupportAdmin => l10n.roleSupportAdmin,
    LocalizationKeys.roleOnboardingReviewer => l10n.roleOnboardingReviewer,
    LocalizationKeys.roleBillingAdmin => l10n.roleBillingAdmin,
    LocalizationKeys.systemHealthLoadError => l10n.systemHealthLoadError,
    LocalizationKeys.systemHealthActionUnavailable =>
      l10n.systemHealthActionUnavailable,
    LocalizationKeys.supportLoadError => l10n.supportLoadError,
    LocalizationKeys.supportActionUnavailable => l10n.supportActionUnavailable,
    LocalizationKeys.supportActionError => l10n.supportActionError,
    LocalizationKeys.auditLogLoadError => l10n.auditLogLoadError,
    _ => l10n.errorGenericBody,
  };
}

String resolveRegistrationKey(
  BuildContext context,
  String key, {
  Map<String, String> params = const {},
}) {
  final l10n = AppLocalizations.of(context);
  return switch (key) {
    'registrationFilterAll' => l10n.registrationFilterAll,
    'registrationFilterPending' => l10n.registrationFilterPending,
    'registrationFilterNeedsInfo' => l10n.registrationFilterNeedsInfo,
    'registrationFilterAiReviewed' => l10n.registrationFilterAiReviewed,
    'registrationFilterApproved' => l10n.registrationFilterApproved,
    'registrationFilterRejected' => l10n.registrationFilterRejected,
    'registrationFilterHighRisk' => l10n.registrationFilterHighRisk,
    'registrationStatusPending' => l10n.registrationStatusPending,
    'registrationStatusNeedsInfo' => l10n.registrationStatusNeedsInfo,
    'registrationStatusApproved' => l10n.registrationStatusApproved,
    'registrationStatusRejected' => l10n.registrationStatusRejected,
    'registrationStatusCancelled' => l10n.registrationStatusCancelled,
    'registrationStatusUnknown' => l10n.registrationStatusUnknown,
    'registrationRiskLow' => l10n.registrationRiskLow,
    'registrationRiskMedium' => l10n.registrationRiskMedium,
    'registrationRiskHigh' => l10n.registrationRiskHigh,
    'registrationRiskUnknown' => l10n.registrationRiskUnknown,
    'registrationTypeCompany' => l10n.registrationTypeCompany,
    'registrationTypeUser' => l10n.registrationTypeUser,
    'registrationTypeBulkOnboarding' => l10n.registrationTypeBulkOnboarding,
    'registrationSearchHint' => l10n.registrationSearchHint,
    'registrationListEmpty' => l10n.registrationListEmpty,
    'registrationListError' => l10n.registrationListError,
    'registrationDetailError' => l10n.registrationDetailError,
    'registrationMockDataBadge' => l10n.registrationMockDataBadge,
    'registrationSubmittedAt' => l10n.registrationSubmittedAt(
      params['date'] ?? '',
    ),
    'registrationSectionCompany' => l10n.registrationSectionCompany,
    'registrationSectionContact' => l10n.registrationSectionContact,
    'registrationSectionStatus' => l10n.registrationSectionStatus,
    'registrationSectionAiReview' => l10n.registrationSectionAiReview,
    'registrationSectionDocuments' => l10n.registrationSectionDocuments,
    'registrationFieldCompanyName' => l10n.registrationFieldCompanyName,
    'registrationFieldCountry' => l10n.registrationFieldCountry,
    'registrationFieldVatNumber' => l10n.registrationFieldVatNumber,
    'registrationFieldRegistrationNumber' =>
      l10n.registrationFieldRegistrationNumber,
    'registrationFieldContactName' => l10n.registrationFieldContactName,
    'registrationFieldContactEmail' => l10n.registrationFieldContactEmail,
    'registrationFieldSubmittedAt' => l10n.registrationFieldSubmittedAt,
    'registrationFieldReviewedAt' => l10n.registrationFieldReviewedAt,
    'registrationFieldReviewedBy' => l10n.registrationFieldReviewedBy,
    'registrationFieldAiRecommendation' =>
      l10n.registrationFieldAiRecommendation,
    'registrationFieldAiSummary' => l10n.registrationFieldAiSummary,
    'registrationFieldMissingInformation' =>
      l10n.registrationFieldMissingInformation,
    'registrationFieldDuplicateWarnings' =>
      l10n.registrationFieldDuplicateWarnings,
    'registrationFieldRiskFlags' => l10n.registrationFieldRiskFlags,
    'registrationNoneReported' => l10n.registrationNoneReported,
    'registrationDocumentsMetadataOnly' =>
      l10n.registrationDocumentsMetadataOnly,
    'registrationDocumentsEmpty' => l10n.registrationDocumentsEmpty,
    'registrationActionApprove' => l10n.registrationActionApprove,
    'registrationActionReject' => l10n.registrationActionReject,
    'registrationActionRequestInfo' => l10n.registrationActionRequestInfo,
    'registrationDecisionApproveTitle' => l10n.registrationDecisionApproveTitle,
    'registrationDecisionRejectTitle' => l10n.registrationDecisionRejectTitle,
    'registrationDecisionRequestInfoTitle' =>
      l10n.registrationDecisionRequestInfoTitle,
    'registrationDecisionApproveBody' => l10n.registrationDecisionApproveBody,
    'registrationDecisionAuditNotice' => l10n.registrationDecisionAuditNotice,
    'registrationDecisionNotesLabel' => l10n.registrationDecisionNotesLabel,
    'registrationDecisionNotesRequired' =>
      l10n.registrationDecisionNotesRequired,
    'registrationDecisionCancel' => l10n.registrationDecisionCancel,
    'registrationDecisionApproveConfirm' =>
      l10n.registrationDecisionApproveConfirm,
    'registrationDecisionRejectConfirm' =>
      l10n.registrationDecisionRejectConfirm,
    'registrationDecisionRequestInfoConfirm' =>
      l10n.registrationDecisionRequestInfoConfirm,
    'registrationDecisionSuccess' => l10n.registrationDecisionSuccess,
    'registrationDecisionError' => l10n.registrationDecisionError,
    _ => l10n.errorGenericBody,
  };
}

String resolvePublicIntakeKey(
  BuildContext context,
  String key, {
  Map<String, String> params = const {},
}) {
  final l10n = AppLocalizations.of(context);
  return switch (key) {
    'publicIntakeFilterAll' => l10n.publicIntakeFilterAll,
    'publicIntakeFilterNew' => l10n.publicIntakeFilterNew,
    'publicIntakeFilterReviewing' => l10n.publicIntakeFilterReviewing,
    'publicIntakeFilterQuoteDemo' => l10n.publicIntakeFilterQuoteDemo,
    'publicIntakeFilterContacted' => l10n.publicIntakeFilterContacted,
    'publicIntakeFilterClosed' => l10n.publicIntakeFilterClosed,
    'publicIntakeTypeContact' => l10n.publicIntakeTypeContact,
    'publicIntakeTypeDemoRequest' => l10n.publicIntakeTypeDemoRequest,
    'publicIntakeTypeQuoteRequest' => l10n.publicIntakeTypeQuoteRequest,
    'publicIntakeTypeRegistrationInterest' =>
      l10n.publicIntakeTypeRegistrationInterest,
    'publicIntakeTypeSupportRequest' => l10n.publicIntakeTypeSupportRequest,
    'publicIntakeTypeUnknown' => l10n.publicIntakeTypeUnknown,
    'publicIntakeStatusNew' => l10n.publicIntakeStatusNew,
    'publicIntakeStatusReviewing' => l10n.publicIntakeStatusReviewing,
    'publicIntakeStatusContacted' => l10n.publicIntakeStatusContacted,
    'publicIntakeStatusQuoted' => l10n.publicIntakeStatusQuoted,
    'publicIntakeStatusConverted' => l10n.publicIntakeStatusConverted,
    'publicIntakeStatusRejected' => l10n.publicIntakeStatusRejected,
    'publicIntakeStatusClosed' => l10n.publicIntakeStatusClosed,
    'publicIntakeStatusUnknown' => l10n.publicIntakeStatusUnknown,
    'publicIntakeSearchHint' => l10n.publicIntakeSearchHint,
    'publicIntakeListEmpty' => l10n.publicIntakeListEmpty,
    'publicIntakeListError' => l10n.publicIntakeListError,
    'publicIntakeDetailError' => l10n.publicIntakeDetailError,
    'publicIntakeMockDataBadge' => l10n.publicIntakeMockDataBadge,
    'publicIntakeUnknownCustomer' => l10n.publicIntakeUnknownCustomer,
    'publicIntakeCreatedAt' => l10n.publicIntakeCreatedAt(params['date'] ?? ''),
    'publicIntakeSectionCustomer' => l10n.publicIntakeSectionCustomer,
    'publicIntakeSectionConsent' => l10n.publicIntakeSectionConsent,
    'publicIntakeSectionMessage' => l10n.publicIntakeSectionMessage,
    'publicIntakeSectionQuote' => l10n.publicIntakeSectionQuote,
    'publicIntakeSectionLinks' => l10n.publicIntakeSectionLinks,
    'publicIntakeFieldCustomerName' => l10n.publicIntakeFieldCustomerName,
    'publicIntakeFieldEmailDomain' => l10n.publicIntakeFieldEmailDomain,
    'publicIntakeFieldCompany' => l10n.publicIntakeFieldCompany,
    'publicIntakeFieldCountry' => l10n.publicIntakeFieldCountry,
    'publicIntakeFieldOriginalLanguage' =>
      l10n.publicIntakeFieldOriginalLanguage(params['lang'] ?? ''),
    'publicIntakeFieldFleetSize' =>
      l10n.publicIntakeFieldFleetSize(params['count'] ?? ''),
    'publicIntakeFieldOfficeUsers' =>
      l10n.publicIntakeFieldOfficeUsers(params['count'] ?? ''),
    'publicIntakeFieldDriverApps' =>
      l10n.publicIntakeFieldDriverApps(params['count'] ?? ''),
    'publicIntakeFieldModules' => l10n.publicIntakeFieldModules,
    'publicIntakeFieldAiFeatures' => l10n.publicIntakeFieldAiFeatures,
    'publicIntakeFieldStatus' => l10n.publicIntakeFieldStatus,
    'publicIntakeFieldConsentVersion' => l10n.publicIntakeFieldConsentVersion,
    'publicIntakeConsentPrivacy' => l10n.publicIntakeConsentPrivacy,
    'publicIntakeConsentTerms' => l10n.publicIntakeConsentTerms,
    'publicIntakeConsentMarketing' => l10n.publicIntakeConsentMarketing,
    'publicIntakeConsentYes' => l10n.publicIntakeConsentYes,
    'publicIntakeConsentNo' => l10n.publicIntakeConsentNo,
    'publicIntakeOpenThreadAction' => l10n.publicIntakeOpenThreadAction,
    'publicIntakeLinkedQuote' => l10n.publicIntakeLinkedQuote,
    'publicIntakeLinkedPricing' => l10n.publicIntakeLinkedPricing,
    'publicIntakeChangeStatusAction' => l10n.publicIntakeChangeStatusAction,
    'publicIntakeStatusDialogTitle' => l10n.publicIntakeStatusDialogTitle,
    'publicIntakeReasonLabel' => l10n.publicIntakeReasonLabel,
    'publicIntakeReasonRequired' => l10n.publicIntakeReasonRequired,
    'publicIntakeReasonMinLength' => l10n.publicIntakeReasonMinLength,
    'publicIntakeCancel' => l10n.publicIntakeCancel,
    'publicIntakeStatusConfirm' => l10n.publicIntakeStatusConfirm,
    'publicIntakeStatusSuccess' => l10n.publicIntakeStatusSuccess,
    'publicIntakeStatusError' => l10n.publicIntakeStatusError,
    'publicIntakeEvidenceNotice' => l10n.publicIntakeEvidenceNotice,
    'publicIntakeDashboardNew' =>
      l10n.publicIntakeDashboardNew(params['count'] ?? '0'),
    'publicIntakeDashboardHighPriority' =>
      l10n.publicIntakeDashboardHighPriority(params['count'] ?? '0'),
    'publicIntakesTitle' => l10n.publicIntakesTitle,
    'publicIntakeDashboardSubtitle' => l10n.publicIntakeDashboardSubtitle,
    'publicIntakeDashboardOpenAction' => l10n.publicIntakeDashboardOpenAction,
    'publicIntakeModuleDescription' => l10n.publicIntakeModuleDescription,
    'publicIntakeNoLinkedThreadTitle' => l10n.publicIntakeNoLinkedThreadTitle,
    'publicIntakeNoLinkedThreadBody' => l10n.publicIntakeNoLinkedThreadBody,
    'publicIntakeNoLinksTitle' => l10n.publicIntakeNoLinksTitle,
    'publicIntakeNoLinksBody' => l10n.publicIntakeNoLinksBody,
    _ => l10n.errorGenericBody,
  };
}

String roleLabel(BuildContext context, String roleKey) =>
    resolveLocalizationKey(context, roleKey);

String resolveSystemHealthKey(
  BuildContext context,
  String key, {
  Map<String, String> params = const {},
}) {
  final l10n = AppLocalizations.of(context);
  return switch (key) {
    'systemHealthLoadError' => l10n.systemHealthLoadError,
    'systemHealthActionUnavailable' => l10n.systemHealthActionUnavailable,
    'systemHealthMockDataBadge' => l10n.systemHealthMockDataBadge,
    'systemHealthServicesTitle' => l10n.systemHealthServicesTitle,
    'systemHealthEventsTitle' => l10n.systemHealthEventsTitle,
    'systemHealthEventsEmpty' => l10n.systemHealthEventsEmpty,
    'systemHealthEventDetailTitle' => l10n.systemHealthEventDetailTitle,
    'systemHealthEventStartedAt' => l10n.systemHealthEventStartedAt(
      params['date'] ?? '',
    ),
    'systemHealthOpenModule' => l10n.systemHealthOpenModule,
    'systemHealthOverallStatusLabel' => l10n.systemHealthOverallStatusLabel(
      params['status'] ?? '',
    ),
    'systemHealthLastUpdated' => l10n.systemHealthLastUpdated(
      params['date'] ?? '',
    ),
    'systemHealthMetricHealthyServices' =>
      l10n.systemHealthMetricHealthyServices,
    'systemHealthMetricWarningServices' =>
      l10n.systemHealthMetricWarningServices,
    'systemHealthMetricCriticalServices' =>
      l10n.systemHealthMetricCriticalServices,
    'systemHealthMetricCriticalEvents' => l10n.systemHealthMetricCriticalEvents,
    'systemHealthMetricWarningEvents' => l10n.systemHealthMetricWarningEvents,
    'systemHealthMetricFailedJobs' => l10n.systemHealthMetricFailedJobs,
    'systemHealthSeverityInfo' => l10n.systemHealthSeverityInfo,
    'systemHealthSeverityWarning' => l10n.systemHealthSeverityWarning,
    'systemHealthSeverityCritical' => l10n.systemHealthSeverityCritical,
    'systemHealthSeverityUnknown' => l10n.systemHealthSeverityUnknown,
    'systemHealthOverallHealthy' => l10n.systemHealthOverallHealthy,
    'systemHealthOverallDegraded' => l10n.systemHealthOverallDegraded,
    'systemHealthOverallCritical' => l10n.systemHealthOverallCritical,
    'systemHealthOverallUnknown' => l10n.systemHealthOverallUnknown,
    'systemHealthFilterAll' => l10n.systemHealthFilterAll,
    'systemHealthFilterCritical' => l10n.systemHealthFilterCritical,
    'systemHealthFilterWarning' => l10n.systemHealthFilterWarning,
    'systemHealthFilterOpen' => l10n.systemHealthFilterOpen,
    'systemHealthFilterAcknowledged' => l10n.systemHealthFilterAcknowledged,
    'systemHealthFilterResolved' => l10n.systemHealthFilterResolved,
    'systemHealthFilterTenantImpacting' =>
      l10n.systemHealthFilterTenantImpacting,
    'systemHealthEventStatusOpen' => l10n.systemHealthEventStatusOpen,
    'systemHealthEventStatusAcknowledged' =>
      l10n.systemHealthEventStatusAcknowledged,
    'systemHealthEventStatusInvestigating' =>
      l10n.systemHealthEventStatusInvestigating,
    'systemHealthEventStatusResolved' => l10n.systemHealthEventStatusResolved,
    'systemHealthEventStatusUnknown' => l10n.systemHealthEventStatusUnknown,
    'systemHealthImpactNone' => l10n.systemHealthImpactNone,
    'systemHealthImpactSingleTenant' => l10n.systemHealthImpactSingleTenant,
    'systemHealthImpactMultipleTenants' =>
      l10n.systemHealthImpactMultipleTenants,
    'systemHealthImpactPlatformWide' => l10n.systemHealthImpactPlatformWide,
    'systemHealthImpactUnknown' => l10n.systemHealthImpactUnknown,
    'systemHealthServiceBackendApi' => l10n.systemHealthServiceBackendApi,
    'systemHealthServiceDatabase' => l10n.systemHealthServiceDatabase,
    'systemHealthServiceDocumentStorage' =>
      l10n.systemHealthServiceDocumentStorage,
    'systemHealthServiceBackgroundWorkers' =>
      l10n.systemHealthServiceBackgroundWorkers,
    'systemHealthServiceAiOcrWorkers' => l10n.systemHealthServiceAiOcrWorkers,
    'systemHealthServiceTranslationService' =>
      l10n.systemHealthServiceTranslationService,
    'systemHealthServiceEmailService' => l10n.systemHealthServiceEmailService,
    'systemHealthServicePushNotificationService' =>
      l10n.systemHealthServicePushNotificationService,
    'systemHealthServiceQueueSystem' => l10n.systemHealthServiceQueueSystem,
    'systemHealthServiceAuthService' => l10n.systemHealthServiceAuthService,
    'systemHealthAiDiagnosticTitle' => l10n.systemHealthAiDiagnosticTitle,
    'systemHealthAiAdvisoryOnly' => l10n.systemHealthAiAdvisoryOnly,
    'systemHealthRecommendedAction' => l10n.systemHealthRecommendedAction,
    'systemHealthActionAcknowledgeTitle' =>
      l10n.systemHealthActionAcknowledgeTitle,
    'systemHealthActionEscalateTitle' => l10n.systemHealthActionEscalateTitle,
    'systemHealthActionAuditNotice' => l10n.systemHealthActionAuditNotice,
    'systemHealthActionNoAutoRepair' => l10n.systemHealthActionNoAutoRepair,
    'systemHealthActionNoteLabel' => l10n.systemHealthActionNoteLabel,
    'systemHealthActionNoteRequired' => l10n.systemHealthActionNoteRequired,
    'systemHealthActionAcknowledgeBody' =>
      l10n.systemHealthActionAcknowledgeBody,
    'systemHealthActionCancel' => l10n.systemHealthActionCancel,
    'systemHealthActionAcknowledgeConfirm' =>
      l10n.systemHealthActionAcknowledgeConfirm,
    'systemHealthActionEscalateConfirm' =>
      l10n.systemHealthActionEscalateConfirm,
    'systemHealthActionAcknowledge' => l10n.systemHealthActionAcknowledge,
    'systemHealthActionEscalate' => l10n.systemHealthActionEscalate,
    'systemHealthActionSuccess' => l10n.systemHealthActionSuccess,
    'systemHealthActionError' => l10n.systemHealthActionError,
    'systemHealthCreateTicketDisabled' => l10n.systemHealthCreateTicketDisabled,
    'systemHealthCreateTicket' => l10n.systemHealthCreateTicket,
    'systemHealthPrivacyNotice' => l10n.systemHealthPrivacyNotice,
    'systemHealthFieldServiceName' => l10n.systemHealthFieldServiceName,
    'systemHealthFieldTenantImpact' => l10n.systemHealthFieldTenantImpact,
    'systemHealthFieldAffectedCompany' => l10n.systemHealthFieldAffectedCompany,
    'systemHealthFieldStartedAt' => l10n.systemHealthFieldStartedAt,
    'systemHealthFieldLastSeenAt' => l10n.systemHealthFieldLastSeenAt,
    'systemHealthFieldResolvedAt' => l10n.systemHealthFieldResolvedAt,
    'systemHealthFieldFailedJobs' => l10n.systemHealthFieldFailedJobs,
    'systemHealthFieldCorrelationId' => l10n.systemHealthFieldCorrelationId,
    _ => l10n.errorGenericBody,
  };
}

String resolveSupportKey(
  BuildContext context,
  String key, {
  Map<String, String> params = const {},
}) {
  final l10n = AppLocalizations.of(context);
  return switch (key) {
    'supportLoadError' => l10n.supportLoadError,
    'supportActionUnavailable' => l10n.supportActionUnavailable,
    'supportActionError' => l10n.supportActionError,
    'supportActionSuccess' => l10n.supportActionSuccess,
    'supportTicketAcknowledgedSuccess' => l10n.supportTicketAcknowledgedSuccess,
    'supportTicketClosedSuccess' => l10n.supportTicketClosedSuccess,
    'supportMockDataBadge' => l10n.supportMockDataBadge,
    'supportOpenModule' => l10n.supportOpenModule,
    'supportPrivacyNotice' => l10n.supportPrivacyNotice,
    'supportActionAuditNotice' => l10n.supportActionAuditNotice,
    'supportActionNoteLabel' => l10n.supportActionNoteLabel,
    'supportActionNoteRequired' => l10n.supportActionNoteRequired,
    'supportActionCancel' => l10n.supportActionCancel,
    'supportTicketSearchHint' => l10n.supportTicketSearchHint,
    'supportTicketListEmpty' => l10n.supportTicketListEmpty,
    'supportTicketLastActivity' => l10n.supportTicketLastActivity(
      params['date'] ?? '',
    ),
    'supportTicketDetailTitle' => l10n.supportTicketDetailTitle,
    'supportGrantDetailTitle' => l10n.supportGrantDetailTitle,
    'supportGrantSearchHint' => l10n.supportGrantSearchHint,
    'supportGrantListEmpty' => l10n.supportGrantListEmpty,
    'supportGrantScopeIdLabel' => l10n.supportGrantScopeIdLabel(
      params['id'] ?? '',
    ),
    'supportGrantExpiresAt' => l10n.supportGrantExpiresAt(params['date'] ?? ''),
    'supportSummaryTitle' => l10n.supportSummaryTitle,
    'supportSummaryOpenTickets' => l10n.supportSummaryOpenTickets,
    'supportSummaryUrgentCritical' => l10n.supportSummaryUrgentCritical,
    'supportSummaryActiveGrants' => l10n.supportSummaryActiveGrants,
    'supportSummaryLastUpdated' => l10n.supportSummaryLastUpdated(
      params['date'] ?? '',
    ),
    'supportTicketCreateSuccess' => l10n.supportTicketCreateSuccess,
    'supportTicketFilterAll' => l10n.supportTicketFilterAll,
    'supportTicketFilterOpen' => l10n.supportTicketFilterOpen,
    'supportTicketFilterUrgent' => l10n.supportTicketFilterUrgent,
    'supportTicketFilterCritical' => l10n.supportTicketFilterCritical,
    'supportTicketFilterSystemHealth' => l10n.supportTicketFilterSystemHealth,
    'supportTicketFilterWaitingForCustomer' =>
      l10n.supportTicketFilterWaitingForCustomer,
    'supportTicketFilterResolved' => l10n.supportTicketFilterResolved,
    'supportGrantFilterAll' => l10n.supportGrantFilterAll,
    'supportGrantFilterPending' => l10n.supportGrantFilterPending,
    'supportGrantFilterActive' => l10n.supportGrantFilterActive,
    'supportGrantFilterExpired' => l10n.supportGrantFilterExpired,
    'supportGrantFilterRevoked' => l10n.supportGrantFilterRevoked,
    'supportTicketStatusOpen' => l10n.supportTicketStatusOpen,
    'supportTicketStatusAcknowledged' => l10n.supportTicketStatusAcknowledged,
    'supportTicketStatusInvestigating' => l10n.supportTicketStatusInvestigating,
    'supportTicketStatusWaitingForCustomer' =>
      l10n.supportTicketStatusWaitingForCustomer,
    'supportTicketStatusResolved' => l10n.supportTicketStatusResolved,
    'supportTicketStatusClosed' => l10n.supportTicketStatusClosed,
    'supportTicketStatusUnknown' => l10n.supportTicketStatusUnknown,
    'supportTicketPriorityLow' => l10n.supportTicketPriorityLow,
    'supportTicketPriorityNormal' => l10n.supportTicketPriorityNormal,
    'supportTicketPriorityHigh' => l10n.supportTicketPriorityHigh,
    'supportTicketPriorityUrgent' => l10n.supportTicketPriorityUrgent,
    'supportTicketPriorityCritical' => l10n.supportTicketPriorityCritical,
    'supportTicketPriorityUnknown' => l10n.supportTicketPriorityUnknown,
    'supportTicketCategoryRegistration' =>
      l10n.supportTicketCategoryRegistration,
    'supportTicketCategorySystemHealth' =>
      l10n.supportTicketCategorySystemHealth,
    'supportTicketCategoryUploadIssue' => l10n.supportTicketCategoryUploadIssue,
    'supportTicketCategoryBilling' => l10n.supportTicketCategoryBilling,
    'supportTicketCategoryAccess' => l10n.supportTicketCategoryAccess,
    'supportTicketCategoryIntegration' => l10n.supportTicketCategoryIntegration,
    'supportTicketCategoryOther' => l10n.supportTicketCategoryOther,
    'supportTicketCategoryUnknown' => l10n.supportTicketCategoryUnknown,
    'supportGrantStatusPending' => l10n.supportGrantStatusPending,
    'supportGrantStatusActive' => l10n.supportGrantStatusActive,
    'supportGrantStatusExpired' => l10n.supportGrantStatusExpired,
    'supportGrantStatusRevoked' => l10n.supportGrantStatusRevoked,
    'supportGrantStatusDenied' => l10n.supportGrantStatusDenied,
    'supportGrantStatusUnknown' => l10n.supportGrantStatusUnknown,
    'supportScopeCompanyMetadata' => l10n.supportScopeCompanyMetadata,
    'supportScopeSpecificTrip' => l10n.supportScopeSpecificTrip,
    'supportScopeSpecificDocumentIssue' =>
      l10n.supportScopeSpecificDocumentIssue,
    'supportScopeUploadQueueIssue' => l10n.supportScopeUploadQueueIssue,
    'supportScopeSystemHealthIssue' => l10n.supportScopeSystemHealthIssue,
    'supportScopeIntegrationIssue' => l10n.supportScopeIntegrationIssue,
    'supportScopeBillingIssue' => l10n.supportScopeBillingIssue,
    'supportScopeUnknown' => l10n.supportScopeUnknown,
    'supportGrantWarningTitle' => l10n.supportGrantWarningTitle,
    'supportGrantWarningBody' => l10n.supportGrantWarningBody,
    'supportGrantAuditNotice' => l10n.supportGrantAuditNotice,
    'supportGrantCreateTitle' => l10n.supportGrantCreateTitle,
    'supportGrantCreateWarning' => l10n.supportGrantCreateWarning,
    'supportGrantCreateConfirm' => l10n.supportGrantCreateConfirm,
    'supportGrantCreateSuccess' => l10n.supportGrantCreateSuccess,
    'supportGrantCompanyLabel' => l10n.supportGrantCompanyLabel(
      params['name'] ?? '',
    ),
    'supportGrantScopeTypeLabel' => l10n.supportGrantScopeTypeLabel,
    'supportGrantScopeIdFieldLabel' => l10n.supportGrantScopeIdFieldLabel,
    'supportGrantScopeIdRequired' => l10n.supportGrantScopeIdRequired,
    'supportGrantReasonLabel' => l10n.supportGrantReasonLabel,
    'supportGrantReasonRequired' => l10n.supportGrantReasonRequired,
    'supportGrantExpiryRequired' => l10n.supportGrantExpiryRequired,
    'supportGrantBroadAccessRejected' => l10n.supportGrantBroadAccessRejected,
    'supportGrantExpiryLabel' => l10n.supportGrantExpiryLabel,
    'supportGrantExpiryTwoHours' => l10n.supportGrantExpiryTwoHours,
    'supportGrantExpiryTwentyFourHours' =>
      l10n.supportGrantExpiryTwentyFourHours,
    'supportGrantRevokeTitle' => l10n.supportGrantRevokeTitle,
    'supportGrantRevokeNoteLabel' => l10n.supportGrantRevokeNoteLabel,
    'supportGrantRevokeConfirm' => l10n.supportGrantRevokeConfirm,
    'supportGrantRevokeSuccess' => l10n.supportGrantRevokeSuccess,
    'supportGrantActionRevoke' => l10n.supportGrantActionRevoke,
    'supportGrantFieldCompany' => l10n.supportGrantFieldCompany,
    'supportGrantFieldScopeId' => l10n.supportGrantFieldScopeId,
    'supportGrantFieldReason' => l10n.supportGrantFieldReason,
    'supportGrantFieldAllowedCategories' =>
      l10n.supportGrantFieldAllowedCategories,
    'supportGrantFieldExcludesDocuments' =>
      l10n.supportGrantFieldExcludesDocuments,
    'supportGrantFieldCreatedAt' => l10n.supportGrantFieldCreatedAt,
    'supportGrantFieldExpiresAt' => l10n.supportGrantFieldExpiresAt,
    'supportGrantFieldRevokedAt' => l10n.supportGrantFieldRevokedAt,
    'supportGrantFieldApprovedBy' => l10n.supportGrantFieldApprovedBy,
    'supportGrantFieldAuditLogId' => l10n.supportGrantFieldAuditLogId,
    'supportGrantYes' => l10n.supportGrantYes,
    'supportGrantNo' => l10n.supportGrantNo,
    'supportTicketFieldCompany' => l10n.supportTicketFieldCompany,
    'supportTicketFieldRequester' => l10n.supportTicketFieldRequester,
    'supportTicketFieldCategory' => l10n.supportTicketFieldCategory,
    'supportTicketFieldSummary' => l10n.supportTicketFieldSummary,
    'supportTicketFieldCreatedAt' => l10n.supportTicketFieldCreatedAt,
    'supportTicketFieldUpdatedAt' => l10n.supportTicketFieldUpdatedAt,
    'supportTicketFieldLastActivity' => l10n.supportTicketFieldLastActivity,
    'supportTicketFieldLinkedHealthEvent' =>
      l10n.supportTicketFieldLinkedHealthEvent,
    'supportTicketFieldSupportGrant' => l10n.supportTicketFieldSupportGrant,
    'supportTicketActionAcknowledge' => l10n.supportTicketActionAcknowledge,
    'supportTicketActionClose' => l10n.supportTicketActionClose,
    'supportTicketActionCreateGrant' => l10n.supportTicketActionCreateGrant,
    'supportTicketActionAcknowledgeTitle' =>
      l10n.supportTicketActionAcknowledgeTitle,
    'supportTicketActionCloseTitle' => l10n.supportTicketActionCloseTitle,
    'supportTicketActionAcknowledgeBody' =>
      l10n.supportTicketActionAcknowledgeBody,
    'supportTicketActionAcknowledgeConfirm' =>
      l10n.supportTicketActionAcknowledgeConfirm,
    'supportTicketActionCloseConfirm' => l10n.supportTicketActionCloseConfirm,
    _ => l10n.errorGenericBody,
  };
}

String resolveDashboardKey(
  BuildContext context,
  String key, {
  Map<String, String> params = const {},
}) {
  final l10n = AppLocalizations.of(context);
  return switch (key) {
    'dashboardOperationalOverviewTitle' =>
      l10n.dashboardOperationalOverviewTitle,
    'dashboardOperationalOverviewBody' => l10n.dashboardOperationalOverviewBody,
    'dashboardSystemStatusHealthy' => l10n.dashboardSystemStatusHealthy,
    'dashboardSystemStatusAttention' => l10n.dashboardSystemStatusAttention,
    'dashboardMetricSystemStatus' => l10n.dashboardMetricSystemStatus,
    'dashboardMetricPendingRegistrations' =>
      l10n.dashboardMetricPendingRegistrations,
    'dashboardMetricCompaniesAttention' =>
      l10n.dashboardMetricCompaniesAttention,
    'dashboardMetricBulkOnboardingReview' =>
      l10n.dashboardMetricBulkOnboardingReview,
    'dashboardMetricAiHighRisk' => l10n.dashboardMetricAiHighRisk,
    'dashboardMetricSupportIssues' => l10n.dashboardMetricSupportIssues,
    'dashboardMetricAuditRisks' => l10n.dashboardMetricAuditRisks,
    'dashboardMetricBillingAttention' => l10n.dashboardMetricBillingAttention,
    _ => l10n.errorGenericBody,
  };
}

String resolveAuditLogKey(
  BuildContext context,
  String key, {
  Map<String, String> params = const {},
}) {
  final l10n = AppLocalizations.of(context);
  return switch (key) {
    'auditLogLoadError' => l10n.auditLogLoadError,
    'auditLogMockDataBadge' => l10n.auditLogMockDataBadge,
    'auditLogOpenModule' => l10n.auditLogOpenModule,
    'auditLogSearchHint' => l10n.auditLogSearchHint,
    'auditLogListEmpty' => l10n.auditLogListEmpty,
    'auditLogDateRangeLabel' => l10n.auditLogDateRangeLabel,
    'auditLogDateRangeSelected' => l10n.auditLogDateRangeSelected(
      params['from'] ?? '',
      params['to'] ?? '',
    ),
    'auditLogDateRangeClear' => l10n.auditLogDateRangeClear,
    'auditLogDateRangeComingSoon' => l10n.auditLogDateRangeComingSoon,
    'auditLogTimestampLabel' => l10n.auditLogTimestampLabel(
      params['date'] ?? '',
    ),
    'auditLogDetailTitle' => l10n.auditLogDetailTitle,
    'auditLogPrivacyNotice' => l10n.auditLogPrivacyNotice,
    'auditLogExportDisabled' => l10n.auditLogExportDisabled,
    'auditLogExportCsv' => l10n.auditLogExportCsv,
    'auditLogExportCopied' => l10n.auditLogExportCopied,
    'auditLogExportFailed' => l10n.auditLogExportFailed,
    'auditLogExportUnavailable' => l10n.auditLogExportUnavailable,
    'auditLogExportSafetyNotice' => l10n.auditLogExportSafetyNotice,
    'auditLogSummaryTitle' => l10n.auditLogSummaryTitle,
    'auditLogSummaryLastCritical' => l10n.auditLogSummaryLastCritical,
    'auditLogSummaryNoCritical' => l10n.auditLogSummaryNoCritical,
    'auditLogSummaryFailedDenied' => l10n.auditLogSummaryFailedDenied,
    'auditLogSummaryRecentActions' => l10n.auditLogSummaryRecentActions,
    'auditLogSummaryLastUpdated' => l10n.auditLogSummaryLastUpdated(
      params['date'] ?? '',
    ),
    'auditLogFilterAll' => l10n.auditLogFilterAll,
    'auditLogFilterCritical' => l10n.auditLogFilterCritical,
    'auditLogFilterWarning' => l10n.auditLogFilterWarning,
    'auditLogFilterFailures' => l10n.auditLogFilterFailures,
    'auditLogFilterDenied' => l10n.auditLogFilterDenied,
    'auditLogFilterRegistration' => l10n.auditLogFilterRegistration,
    'auditLogFilterSupportAccess' => l10n.auditLogFilterSupportAccess,
    'auditLogFilterSystemHealth' => l10n.auditLogFilterSystemHealth,
    'auditLogFilterSecurity' => l10n.auditLogFilterSecurity,
    'auditLogResultSuccess' => l10n.auditLogResultSuccess,
    'auditLogResultFailure' => l10n.auditLogResultFailure,
    'auditLogResultDenied' => l10n.auditLogResultDenied,
    'auditLogResultPartial' => l10n.auditLogResultPartial,
    'auditLogResultUnknown' => l10n.auditLogResultUnknown,
    'auditLogSeverityInfo' => l10n.auditLogSeverityInfo,
    'auditLogSeverityWarning' => l10n.auditLogSeverityWarning,
    'auditLogSeverityCritical' => l10n.auditLogSeverityCritical,
    'auditLogSeverityUnknown' => l10n.auditLogSeverityUnknown,
    'auditLogActionLogin' => l10n.auditLogActionLogin,
    'auditLogActionLogout' => l10n.auditLogActionLogout,
    'auditLogActionLoginFailed' => l10n.auditLogActionLoginFailed,
    'auditLogActionRegistrationApproved' =>
      l10n.auditLogActionRegistrationApproved,
    'auditLogActionRegistrationRejected' =>
      l10n.auditLogActionRegistrationRejected,
    'auditLogActionRegistrationInfoRequested' =>
      l10n.auditLogActionRegistrationInfoRequested,
    'auditLogActionSupportTicketAcknowledged' =>
      l10n.auditLogActionSupportTicketAcknowledged,
    'auditLogActionSupportTicketClosed' =>
      l10n.auditLogActionSupportTicketClosed,
    'auditLogActionSupportAccessGranted' =>
      l10n.auditLogActionSupportAccessGranted,
    'auditLogActionSupportAccessRevoked' =>
      l10n.auditLogActionSupportAccessRevoked,
    'auditLogActionSystemHealthAcknowledged' =>
      l10n.auditLogActionSystemHealthAcknowledged,
    'auditLogActionSystemHealthEscalated' =>
      l10n.auditLogActionSystemHealthEscalated,
    'auditLogActionBillingUpdated' => l10n.auditLogActionBillingUpdated,
    'auditLogActionRoleChanged' => l10n.auditLogActionRoleChanged,
    'auditLogActionPermissionDenied' => l10n.auditLogActionPermissionDenied,
    'auditLogActionExportRequested' => l10n.auditLogActionExportRequested,
    'auditLogActionApiKeyCreated' => l10n.auditLogActionApiKeyCreated,
    'auditLogActionApiKeyRevoked' => l10n.auditLogActionApiKeyRevoked,
    'auditLogActionUnknown' => l10n.auditLogActionUnknown,
    'auditLogFieldTimestamp' => l10n.auditLogFieldTimestamp,
    'auditLogFieldActor' => l10n.auditLogFieldActor,
    'auditLogFieldActorRole' => l10n.auditLogFieldActorRole,
    'auditLogFieldTargetType' => l10n.auditLogFieldTargetType,
    'auditLogFieldTargetId' => l10n.auditLogFieldTargetId,
    'auditLogFieldCompany' => l10n.auditLogFieldCompany,
    'auditLogFieldTenantId' => l10n.auditLogFieldTenantId,
    'auditLogFieldReason' => l10n.auditLogFieldReason,
    'auditLogFieldNote' => l10n.auditLogFieldNote,
    'auditLogFieldIpAddress' => l10n.auditLogFieldIpAddress,
    'auditLogFieldDeviceLabel' => l10n.auditLogFieldDeviceLabel,
    'auditLogFieldCorrelationId' => l10n.auditLogFieldCorrelationId,
    'auditLogFieldRegistrationApplicationId' =>
      l10n.auditLogFieldRegistrationApplicationId,
    'auditLogFieldSupportAccessGrantId' =>
      l10n.auditLogFieldSupportAccessGrantId,
    'auditLogFieldSystemHealthEventId' => l10n.auditLogFieldSystemHealthEventId,
    _ => l10n.errorGenericBody,
  };
}

String resolveBulkOnboardingKey(
  BuildContext context,
  String key, {
  Map<String, String> params = const {},
}) {
  final l10n = AppLocalizations.of(context);
  return switch (key) {
    'bulkOnboardingMockDataBadge' => l10n.bulkOnboardingMockDataBadge,
    'bulkOnboardingSearchHint' => l10n.bulkOnboardingSearchHint,
    'bulkOnboardingListEmpty' => l10n.bulkOnboardingListEmpty,
    'bulkOnboardingListError' => l10n.bulkOnboardingListError,
    'bulkOnboardingDetailError' => l10n.bulkOnboardingDetailError,
    'bulkOnboardingRowsError' => l10n.bulkOnboardingRowsError,
    'bulkOnboardingRowsEmpty' => l10n.bulkOnboardingRowsEmpty,
    'bulkOnboardingPrivacyNotice' => l10n.bulkOnboardingPrivacyNotice,
    'bulkOnboardingOpenModule' => l10n.bulkOnboardingOpenModule,
    'bulkOnboardingOpenRows' => l10n.bulkOnboardingOpenRows,
    'bulkOnboardingNoSourceFile' => l10n.bulkOnboardingNoSourceFile,
    'bulkOnboardingFieldSourceFile' => l10n.bulkOnboardingFieldSourceFile,
    'bulkOnboardingDashboardTitle' => l10n.bulkOnboardingDashboardTitle,
    'bulkOnboardingDashboardWaitingReview' =>
      l10n.bulkOnboardingDashboardWaitingReview,
    'bulkOnboardingDashboardHighRisk' => l10n.bulkOnboardingDashboardHighRisk,
    'bulkOnboardingDashboardInvalidRows' =>
      l10n.bulkOnboardingDashboardInvalidRows,
    'bulkOnboardingDashboardProcessing' =>
      l10n.bulkOnboardingDashboardProcessing,
    'bulkOnboardingFilterAll' => l10n.bulkOnboardingFilterAll,
    'bulkOnboardingFilterReadyForReview' =>
      l10n.bulkOnboardingFilterReadyForReview,
    'bulkOnboardingFilterValidationFailed' =>
      l10n.bulkOnboardingFilterValidationFailed,
    'bulkOnboardingFilterProcessing' => l10n.bulkOnboardingFilterProcessing,
    'bulkOnboardingFilterCompleted' => l10n.bulkOnboardingFilterCompleted,
    'bulkOnboardingFilterRejected' => l10n.bulkOnboardingFilterRejected,
    'bulkOnboardingFilterHighRisk' => l10n.bulkOnboardingFilterHighRisk,
    'bulkOnboardingStatusDraft' => l10n.bulkOnboardingStatusDraft,
    'bulkOnboardingStatusUploaded' => l10n.bulkOnboardingStatusUploaded,
    'bulkOnboardingStatusValidating' => l10n.bulkOnboardingStatusValidating,
    'bulkOnboardingStatusValidationFailed' =>
      l10n.bulkOnboardingStatusValidationFailed,
    'bulkOnboardingStatusReadyForReview' =>
      l10n.bulkOnboardingStatusReadyForReview,
    'bulkOnboardingStatusApprovedForProcessing' =>
      l10n.bulkOnboardingStatusApprovedForProcessing,
    'bulkOnboardingStatusProcessing' => l10n.bulkOnboardingStatusProcessing,
    'bulkOnboardingStatusPartiallyCompleted' =>
      l10n.bulkOnboardingStatusPartiallyCompleted,
    'bulkOnboardingStatusCompleted' => l10n.bulkOnboardingStatusCompleted,
    'bulkOnboardingStatusRejected' => l10n.bulkOnboardingStatusRejected,
    'bulkOnboardingStatusCancelled' => l10n.bulkOnboardingStatusCancelled,
    'bulkOnboardingStatusUnknown' => l10n.bulkOnboardingStatusUnknown,
    'bulkOnboardingRowStatusPending' => l10n.bulkOnboardingRowStatusPending,
    'bulkOnboardingRowStatusValid' => l10n.bulkOnboardingRowStatusValid,
    'bulkOnboardingRowStatusWarning' => l10n.bulkOnboardingRowStatusWarning,
    'bulkOnboardingRowStatusInvalid' => l10n.bulkOnboardingRowStatusInvalid,
    'bulkOnboardingRowStatusDuplicate' => l10n.bulkOnboardingRowStatusDuplicate,
    'bulkOnboardingRowStatusApproved' => l10n.bulkOnboardingRowStatusApproved,
    'bulkOnboardingRowStatusSkipped' => l10n.bulkOnboardingRowStatusSkipped,
    'bulkOnboardingRowStatusProcessed' => l10n.bulkOnboardingRowStatusProcessed,
    'bulkOnboardingRowStatusFailed' => l10n.bulkOnboardingRowStatusFailed,
    'bulkOnboardingRowStatusUnknown' => l10n.bulkOnboardingRowStatusUnknown,
    'bulkOnboardingTypeCompanyUsers' => l10n.bulkOnboardingTypeCompanyUsers,
    'bulkOnboardingTypeDrivers' => l10n.bulkOnboardingTypeDrivers,
    'bulkOnboardingTypeVehicles' => l10n.bulkOnboardingTypeVehicles,
    'bulkOnboardingTypeTrailers' => l10n.bulkOnboardingTypeTrailers,
    'bulkOnboardingTypeMixedCompanyImport' =>
      l10n.bulkOnboardingTypeMixedCompanyImport,
    'bulkOnboardingTypeUnknown' => l10n.bulkOnboardingTypeUnknown,
    'bulkOnboardingRiskLow' => l10n.bulkOnboardingRiskLow,
    'bulkOnboardingRiskMedium' => l10n.bulkOnboardingRiskMedium,
    'bulkOnboardingRiskHigh' => l10n.bulkOnboardingRiskHigh,
    'bulkOnboardingRiskUnknown' => l10n.bulkOnboardingRiskUnknown,
    'bulkOnboardingMetricTotalRows' => l10n.bulkOnboardingMetricTotalRows(
      params['count'] ?? '0',
    ),
    'bulkOnboardingMetricValidRows' => l10n.bulkOnboardingMetricValidRows(
      params['count'] ?? '0',
    ),
    'bulkOnboardingMetricWarningRows' => l10n.bulkOnboardingMetricWarningRows(
      params['count'] ?? '0',
    ),
    'bulkOnboardingMetricInvalidRows' => l10n.bulkOnboardingMetricInvalidRows(
      params['count'] ?? '0',
    ),
    'bulkOnboardingMetricDuplicateRows' =>
      l10n.bulkOnboardingMetricDuplicateRows(params['count'] ?? '0'),
    'bulkOnboardingValidationSummaryTitle' =>
      l10n.bulkOnboardingValidationSummaryTitle,
    'bulkOnboardingValidationErrors' => l10n.bulkOnboardingValidationErrors,
    'bulkOnboardingDuplicateReason' => l10n.bulkOnboardingDuplicateReason(
      params['reason'] ?? '',
    ),
    'bulkOnboardingAiReviewTitle' => l10n.bulkOnboardingAiReviewTitle,
    'bulkOnboardingAiAdvisoryNotice' => l10n.bulkOnboardingAiAdvisoryNotice,
    'bulkOnboardingRecommendedAction' => l10n.bulkOnboardingRecommendedAction(
      params['action'] ?? '',
    ),
    'bulkOnboardingRowFilterAll' => l10n.bulkOnboardingRowFilterAll,
    'bulkOnboardingRowFilterInvalid' => l10n.bulkOnboardingRowFilterInvalid,
    'bulkOnboardingRowFilterWarning' => l10n.bulkOnboardingRowFilterWarning,
    'bulkOnboardingRowFilterDuplicate' => l10n.bulkOnboardingRowFilterDuplicate,
    'bulkOnboardingActionValidate' => l10n.bulkOnboardingActionValidate,
    'bulkOnboardingActionApprove' => l10n.bulkOnboardingActionApprove,
    'bulkOnboardingActionReject' => l10n.bulkOnboardingActionReject,
    'bulkOnboardingActionCancel' => l10n.bulkOnboardingActionCancel,
    'bulkOnboardingActionProcess' => l10n.bulkOnboardingActionProcess,
    'bulkOnboardingProcessDisabled' => l10n.bulkOnboardingProcessDisabled,
    'bulkOnboardingProcessUnavailable' => l10n.bulkOnboardingProcessUnavailable,
    'bulkOnboardingActionUnavailable' => l10n.bulkOnboardingActionUnavailable,
    'bulkOnboardingActionSuccess' => l10n.bulkOnboardingActionSuccess,
    'bulkOnboardingActionAuditNotice' => l10n.bulkOnboardingActionAuditNotice,
    'bulkOnboardingActionNoteLabel' => l10n.bulkOnboardingActionNoteLabel,
    'bulkOnboardingActionOptionalNoteLabel' =>
      l10n.bulkOnboardingActionOptionalNoteLabel,
    'bulkOnboardingActionNoteRequired' => l10n.bulkOnboardingActionNoteRequired,
    'bulkOnboardingActionConfirmRequired' =>
      l10n.bulkOnboardingActionConfirmRequired,
    'bulkOnboardingActionExplicitConfirm' =>
      l10n.bulkOnboardingActionExplicitConfirm,
    'bulkOnboardingActionDismiss' => l10n.bulkOnboardingActionDismiss,
    'bulkOnboardingActionValidateTitle' =>
      l10n.bulkOnboardingActionValidateTitle,
    'bulkOnboardingActionApproveTitle' => l10n.bulkOnboardingActionApproveTitle,
    'bulkOnboardingActionRejectTitle' => l10n.bulkOnboardingActionRejectTitle,
    'bulkOnboardingActionCancelTitle' => l10n.bulkOnboardingActionCancelTitle,
    'bulkOnboardingActionProcessTitle' => l10n.bulkOnboardingActionProcessTitle,
    'bulkOnboardingActionValidateConfirm' =>
      l10n.bulkOnboardingActionValidateConfirm,
    'bulkOnboardingActionApproveConfirm' =>
      l10n.bulkOnboardingActionApproveConfirm,
    'bulkOnboardingActionRejectConfirm' =>
      l10n.bulkOnboardingActionRejectConfirm,
    'bulkOnboardingActionCancelConfirm' =>
      l10n.bulkOnboardingActionCancelConfirm,
    'bulkOnboardingActionProcessConfirm' =>
      l10n.bulkOnboardingActionProcessConfirm,
    'bulkOnboardingDryRunAction' => l10n.bulkOnboardingDryRunAction,
    'bulkOnboardingExecuteAction' => l10n.bulkOnboardingExecuteAction,
    'bulkOnboardingExecuteDisabled' => l10n.bulkOnboardingExecuteDisabled,
    'bulkOnboardingDryRunSuccess' => l10n.bulkOnboardingDryRunSuccess,
    'bulkOnboardingExecuteSuccess' => l10n.bulkOnboardingExecuteSuccess,
    'bulkOnboardingProvisioningTitle' => l10n.bulkOnboardingProvisioningTitle,
    'bulkOnboardingProvisioningStatus' => l10n.bulkOnboardingProvisioningStatus(
      params['status'] ?? '',
    ),
    'bulkOnboardingExecutePolicyDisabled' =>
      l10n.bulkOnboardingExecutePolicyDisabled(params['reason'] ?? ''),
    'bulkOnboardingExecuteDialogTitle' => l10n.bulkOnboardingExecuteDialogTitle,
    'bulkOnboardingExecuteMetadataNotice' =>
      l10n.bulkOnboardingExecuteMetadataNotice,
    'bulkOnboardingExecuteIrreversibleWarning' =>
      l10n.bulkOnboardingExecuteIrreversibleWarning,
    'bulkOnboardingExecuteRowWindow' => l10n.bulkOnboardingExecuteRowWindow(
      params['count'] ?? '0',
      params['maxRows'] ?? '0',
    ),
    'bulkOnboardingExecuteReasonLabel' => l10n.bulkOnboardingExecuteReasonLabel,
    'bulkOnboardingExecuteReasonRequired' =>
      l10n.bulkOnboardingExecuteReasonRequired,
    'bulkOnboardingExecuteConfirmRequired' =>
      l10n.bulkOnboardingExecuteConfirmRequired,
    'bulkOnboardingExecuteConfirmCheckbox' =>
      l10n.bulkOnboardingExecuteConfirmCheckbox,
    'bulkOnboardingExecuteConfirmAction' =>
      l10n.bulkOnboardingExecuteConfirmAction,
    'bulkOnboardingSummaryDryRunOk' => l10n.bulkOnboardingSummaryDryRunOk,
    'bulkOnboardingSummaryBlocked' => l10n.bulkOnboardingSummaryBlocked,
    'bulkOnboardingSummaryDuplicates' => l10n.bulkOnboardingSummaryDuplicates,
    'bulkOnboardingSummaryFailed' => l10n.bulkOnboardingSummaryFailed,
    'bulkOnboardingSummaryProvisioned' => l10n.bulkOnboardingSummaryProvisioned,
    'bulkOnboardingRowExecutionStatusesTitle' =>
      l10n.bulkOnboardingRowExecutionStatusesTitle,
    'bulkOnboardingExecuteRejectedPolicy' =>
      l10n.bulkOnboardingExecuteRejectedPolicy,
    'bulkOnboardingExecuteRejectedValidation' =>
      l10n.bulkOnboardingExecuteRejectedValidation,
    'bulkOnboardingExecuteForbidden' => l10n.bulkOnboardingExecuteForbidden,
    'bulkOnboardingUploadCsv' => l10n.bulkOnboardingUploadCsv,
    'bulkOnboardingChooseFile' => l10n.bulkOnboardingChooseFile,
    'bulkOnboardingSelectedFile' => l10n.bulkOnboardingSelectedFile(
      params['name'] ?? '',
    ),
    'bulkOnboardingFileSize' => l10n.bulkOnboardingFileSize(
      params['size'] ?? '',
    ),
    'bulkOnboardingUploadPreviewTitle' => l10n.bulkOnboardingUploadPreviewTitle,
    'bulkOnboardingImportTemplate' => l10n.bulkOnboardingImportTemplate,
    'bulkOnboardingDownloadTemplate' => l10n.bulkOnboardingDownloadTemplate,
    'bulkOnboardingTemplateCopied' => l10n.bulkOnboardingTemplateCopied,
    'bulkOnboardingDownloadValidationReport' =>
      l10n.bulkOnboardingDownloadValidationReport,
    'bulkOnboardingValidationReportCopied' =>
      l10n.bulkOnboardingValidationReportCopied,
    'bulkOnboardingValidationReportFailed' =>
      l10n.bulkOnboardingValidationReportFailed,
    'bulkOnboardingCsvOnlyNotice' => l10n.bulkOnboardingCsvOnlyNotice,
    'bulkOnboardingExcelComingLater' => l10n.bulkOnboardingExcelComingLater,
    'bulkOnboardingNoRealProvisioningNotice' =>
      l10n.bulkOnboardingNoRealProvisioningNotice,
    'bulkOnboardingHumanApprovalNotice' =>
      l10n.bulkOnboardingHumanApprovalNotice,
    'bulkOnboardingValidationCompleted' =>
      l10n.bulkOnboardingValidationCompleted,
    'bulkOnboardingRowsParsed' => l10n.bulkOnboardingRowsParsed,
    'bulkOnboardingUploadSuccessful' => l10n.bulkOnboardingUploadSuccessful,
    'bulkOnboardingUploadFailed' => l10n.bulkOnboardingUploadFailed,
    'bulkOnboardingUnsupportedFileType' =>
      l10n.bulkOnboardingUnsupportedFileType,
    'bulkOnboardingTooManyRows' => l10n.bulkOnboardingTooManyRows,
    'bulkOnboardingEmptyFile' => l10n.bulkOnboardingEmptyFile,
    'bulkOnboardingFileRequired' => l10n.bulkOnboardingFileRequired,
    'bulkOnboardingUploadTypeRequired' => l10n.bulkOnboardingUploadTypeRequired,
    'bulkOnboardingUploadTypeLabel' => l10n.bulkOnboardingUploadTypeLabel,
    'bulkOnboardingUploadCompanyIdLabel' =>
      l10n.bulkOnboardingUploadCompanyIdLabel,
    'bulkOnboardingUploadCompanyNameLabel' =>
      l10n.bulkOnboardingUploadCompanyNameLabel,
    'bulkOnboardingUploadNoteLabel' => l10n.bulkOnboardingUploadNoteLabel,
    'bulkOnboardingUploadProgress' => l10n.bulkOnboardingUploadProgress,
    'bulkOnboardingUploadForbidden' => l10n.bulkOnboardingUploadForbidden,
    'bulkOnboardingMockUploadBadge' => l10n.bulkOnboardingMockUploadBadge,
    'bulkOnboardingRowsSearchHint' => l10n.bulkOnboardingRowsSearchHint,
    'bulkOnboardingRowFilterValid' => l10n.bulkOnboardingRowFilterValid,
    'bulkOnboardingRowFilterProcessed' => l10n.bulkOnboardingRowFilterProcessed,
    'bulkOnboardingRowFilterFailed' => l10n.bulkOnboardingRowFilterFailed,
    'bulkOnboardingRowFilterSkipped' => l10n.bulkOnboardingRowFilterSkipped,
    'bulkOnboardingRowDetailTitle' => l10n.bulkOnboardingRowDetailTitle,
    'bulkOnboardingRowDetailError' => l10n.bulkOnboardingRowDetailError,
    'bulkOnboardingRowOriginalValuesTitle' =>
      l10n.bulkOnboardingRowOriginalValuesTitle,
    'bulkOnboardingRowCorrectedValuesTitle' =>
      l10n.bulkOnboardingRowCorrectedValuesTitle,
    'bulkOnboardingRowLastValidatedAt' => l10n.bulkOnboardingRowLastValidatedAt(
      params['date'] ?? '',
    ),
    'bulkOnboardingJobLastValidatedAt' => l10n.bulkOnboardingJobLastValidatedAt(
      params['date'] ?? '',
    ),
    'bulkOnboardingRowCorrectionTitle' => l10n.bulkOnboardingRowCorrectionTitle,
    'bulkOnboardingRowCorrectionNotice' =>
      l10n.bulkOnboardingRowCorrectionNotice,
    'bulkOnboardingRowCorrectionNoteLabel' =>
      l10n.bulkOnboardingRowCorrectionNoteLabel,
    'bulkOnboardingRowCorrectionConfirm' =>
      l10n.bulkOnboardingRowCorrectionConfirm,
    'bulkOnboardingRowCorrectionAction' =>
      l10n.bulkOnboardingRowCorrectionAction,
    'bulkOnboardingRowCorrectionFieldRequired' =>
      l10n.bulkOnboardingRowCorrectionFieldRequired,
    'bulkOnboardingRowFieldName' => l10n.bulkOnboardingRowFieldName,
    'bulkOnboardingRowFieldEmail' => l10n.bulkOnboardingRowFieldEmail,
    'bulkOnboardingRowFieldPhone' => l10n.bulkOnboardingRowFieldPhone,
    'bulkOnboardingRowFieldCountry' => l10n.bulkOnboardingRowFieldCountry,
    'bulkOnboardingRowFieldRole' => l10n.bulkOnboardingRowFieldRole,
    'bulkOnboardingRowFieldVehiclePlate' =>
      l10n.bulkOnboardingRowFieldVehiclePlate,
    'bulkOnboardingRowFieldTrailerPlate' =>
      l10n.bulkOnboardingRowFieldTrailerPlate,
    'bulkOnboardingRowSkipTitle' => l10n.bulkOnboardingRowSkipTitle,
    'bulkOnboardingRowSkipNotice' => l10n.bulkOnboardingRowSkipNotice,
    'bulkOnboardingRowSkipReasonLabel' => l10n.bulkOnboardingRowSkipReasonLabel,
    'bulkOnboardingRowSkipReasonRequired' =>
      l10n.bulkOnboardingRowSkipReasonRequired,
    'bulkOnboardingRowSkipConfirm' => l10n.bulkOnboardingRowSkipConfirm,
    'bulkOnboardingRowSkipAction' => l10n.bulkOnboardingRowSkipAction,
    'bulkOnboardingRowRevalidateAction' =>
      l10n.bulkOnboardingRowRevalidateAction,
    'bulkOnboardingJobRevalidateAction' =>
      l10n.bulkOnboardingJobRevalidateAction,
    'bulkOnboardingJobRevalidateSuccess' =>
      l10n.bulkOnboardingJobRevalidateSuccess,
    'bulkOnboardingRowActionAuditNotice' =>
      l10n.bulkOnboardingRowActionAuditNotice,
    'bulkOnboardingRowActionSuccess' => l10n.bulkOnboardingRowActionSuccess,
    'bulkOnboardingRowActionUnavailable' =>
      l10n.bulkOnboardingRowActionUnavailable,
    'bulkOnboardingMetricSkippedRows' => l10n.bulkOnboardingMetricSkippedRows(
      params['count'] ?? '0',
    ),
    'bulkOnboardingValidationWarnings' => l10n.bulkOnboardingValidationWarnings,
    _ => l10n.errorGenericBody,
  };
}

String resolvePlatformCompanyKey(
  BuildContext context,
  String key, {
  Map<String, String> params = const {},
}) {
  final l10n = AppLocalizations.of(context);
  return switch (key) {
    'platformCompanySearchHint' => l10n.platformCompanySearchHint,
    'platformCompanyListEmpty' => l10n.platformCompanyListEmpty,
    'platformCompanyListError' => l10n.platformCompanyListError,
    'platformCompanyDetailError' => l10n.platformCompanyDetailError,
    'platformCompanySummaryError' => l10n.platformCompanySummaryError,
    'platformCompanyMockDataBadge' => l10n.platformCompanyMockDataBadge,
    'platformCompanyMetadataBadge' => l10n.platformCompanyMetadataBadge,
    'platformCompanyOpenModule' => l10n.platformCompanyOpenModule,
    'platformCompanyPrivacyNotice' => l10n.platformCompanyPrivacyNotice,
    'platformCompanyDashboardTitle' => l10n.platformCompanyDashboardTitle,
    'platformCompanyDashboardActive' => l10n.platformCompanyDashboardActive(
      params['count'] ?? '0',
    ),
    'platformCompanyDashboardPendingReview' =>
      l10n.platformCompanyDashboardPendingReview(params['count'] ?? '0'),
    'platformCompanyDashboardSuspended' =>
      l10n.platformCompanyDashboardSuspended(params['count'] ?? '0'),
    'platformCompanyDashboardOpenSupport' =>
      l10n.platformCompanyDashboardOpenSupport(params['count'] ?? '0'),
    'platformCompanyDashboardPendingOnboarding' =>
      l10n.platformCompanyDashboardPendingOnboarding(params['count'] ?? '0'),
    'platformCompanyFilterAll' => l10n.platformCompanyFilterAll,
    'platformCompanyFilterActive' => l10n.platformCompanyFilterActive,
    'platformCompanyFilterPendingReview' =>
      l10n.platformCompanyFilterPendingReview,
    'platformCompanyFilterSuspended' => l10n.platformCompanyFilterSuspended,
    'platformCompanyFilterDisabled' => l10n.platformCompanyFilterDisabled,
    'platformCompanyStatusActive' => l10n.platformCompanyStatusActive,
    'platformCompanyStatusPendingReview' =>
      l10n.platformCompanyStatusPendingReview,
    'platformCompanyStatusSuspended' => l10n.platformCompanyStatusSuspended,
    'platformCompanyStatusDisabled' => l10n.platformCompanyStatusDisabled,
    'platformCompanyStatusArchived' => l10n.platformCompanyStatusArchived,
    'platformCompanyStatusUnknown' => l10n.platformCompanyStatusUnknown,
    'platformCompanyMetricActiveUsers' => l10n.platformCompanyMetricActiveUsers(
      params['count'] ?? '0',
    ),
    'platformCompanyMetricDrivers' => l10n.platformCompanyMetricDrivers(
      params['count'] ?? '0',
    ),
    'platformCompanyMetricVehicles' => l10n.platformCompanyMetricVehicles(
      params['count'] ?? '0',
    ),
    'platformCompanyMetricTrailers' => l10n.platformCompanyMetricTrailers(
      params['count'] ?? '0',
    ),
    'platformCompanyMetricOpenSupport' => l10n.platformCompanyMetricOpenSupport(
      params['count'] ?? '0',
    ),
    'platformCompanyMetricActiveGrants' =>
      l10n.platformCompanyMetricActiveGrants(params['count'] ?? '0'),
    'platformCompanyMetricTotalUsers' => l10n.platformCompanyMetricTotalUsers(
      params['count'] ?? '0',
    ),
    'platformCompanyMetricPendingRegistrations' =>
      l10n.platformCompanyMetricPendingRegistrations(params['count'] ?? '0'),
    'platformCompanyMetricPendingBulkJobs' =>
      l10n.platformCompanyMetricPendingBulkJobs(params['count'] ?? '0'),
    'platformCompanySectionMetadata' => l10n.platformCompanySectionMetadata,
    'platformCompanySectionUsers' => l10n.platformCompanySectionUsers,
    'platformCompanySectionSupport' => l10n.platformCompanySectionSupport,
    'platformCompanySectionOnboarding' => l10n.platformCompanySectionOnboarding,
    'platformCompanyFieldCountry' => l10n.platformCompanyFieldCountry,
    'platformCompanyFieldVat' => l10n.platformCompanyFieldVat,
    'platformCompanyFieldRegistrationNumber' =>
      l10n.platformCompanyFieldRegistrationNumber,
    'platformCompanyFieldPlan' => l10n.platformCompanyFieldPlan,
    'platformCompanyFieldSubscriptionStatus' =>
      l10n.platformCompanyFieldSubscriptionStatus,
    'platformCompanyFieldLastAdminActivity' =>
      l10n.platformCompanyFieldLastAdminActivity,
    'platformCompanyChangeStatusAction' =>
      l10n.platformCompanyChangeStatusAction,
    'platformCompanyStatusDialogTitle' => l10n.platformCompanyStatusDialogTitle,
    'platformCompanyStatusDialogNotice' =>
      l10n.platformCompanyStatusDialogNotice,
    'platformCompanyStatusFieldLabel' => l10n.platformCompanyStatusFieldLabel,
    'platformCompanyStatusReasonLabel' => l10n.platformCompanyStatusReasonLabel,
    'platformCompanyStatusReasonRequired' =>
      l10n.platformCompanyStatusReasonRequired,
    'platformCompanyStatusAuditNotice' => l10n.platformCompanyStatusAuditNotice,
    'platformCompanyStatusDismiss' => l10n.platformCompanyStatusDismiss,
    'platformCompanyStatusConfirm' => l10n.platformCompanyStatusConfirm,
    'platformCompanyStatusSuccess' => l10n.platformCompanyStatusSuccess,
    'platformCompanyStatusUnavailable' => l10n.platformCompanyStatusUnavailable,
    _ => l10n.errorGenericBody,
  };
}

String resolveAiReviewKey(
  BuildContext context,
  String key, {
  Map<String, String> params = const {},
}) {
  final l10n = AppLocalizations.of(context);
  return switch (key) {
    'aiReviewLoadError' => l10n.aiReviewLoadError,
    'aiReviewDetailError' => l10n.aiReviewDetailError,
    'aiReviewListEmpty' => l10n.aiReviewListEmpty,
    'aiReviewSearchHint' => l10n.aiReviewSearchHint,
    'aiReviewMockDataBadge' => l10n.aiReviewMockDataBadge,
    'aiReviewOpenModule' => l10n.aiReviewOpenModule,
    'aiReviewAdvisoryNotice' => l10n.aiReviewAdvisoryNotice,
    'aiReviewDashboardTitle' => l10n.aiReviewDashboardTitle,
    'aiReviewDashboardTotal' => l10n.aiReviewDashboardTotal(
      params['count'] ?? '0',
    ),
    'aiReviewDashboardHighRisk' => l10n.aiReviewDashboardHighRisk(
      params['count'] ?? '0',
    ),
    'aiReviewDashboardNeedsHumanReview' =>
      l10n.aiReviewDashboardNeedsHumanReview(params['count'] ?? '0'),
    'aiReviewFilterAll' => l10n.aiReviewFilterAll,
    'aiReviewFilterHighRisk' => l10n.aiReviewFilterHighRisk,
    'aiReviewFilterRegistration' => l10n.aiReviewFilterRegistration,
    'aiReviewFilterBulkOnboarding' => l10n.aiReviewFilterBulkOnboarding,
    'aiReviewFilterSystemHealth' => l10n.aiReviewFilterSystemHealth,
    'aiReviewFilterNeedsHumanReview' => l10n.aiReviewFilterNeedsHumanReview,
    'aiReviewSourceRegistration' => l10n.aiReviewSourceRegistration,
    'aiReviewSourceBulkOnboarding' => l10n.aiReviewSourceBulkOnboarding,
    'aiReviewSourceSystemHealth' => l10n.aiReviewSourceSystemHealth,
    'aiReviewSourceSupportTicket' => l10n.aiReviewSourceSupportTicket,
    'aiReviewSourceUnknown' => l10n.aiReviewSourceUnknown,
    'aiReviewRiskLow' => l10n.aiReviewRiskLow,
    'aiReviewRiskMedium' => l10n.aiReviewRiskMedium,
    'aiReviewRiskHigh' => l10n.aiReviewRiskHigh,
    'aiReviewRiskUnknown' => l10n.aiReviewRiskUnknown,
    'aiReviewRecommendationReview' => l10n.aiReviewRecommendationReview,
    'aiReviewRecommendationRequestInfo' =>
      l10n.aiReviewRecommendationRequestInfo,
    'aiReviewRecommendationApproveCandidate' =>
      l10n.aiReviewRecommendationApproveCandidate,
    'aiReviewRecommendationRejectCandidate' =>
      l10n.aiReviewRecommendationRejectCandidate,
    'aiReviewRecommendationEscalate' => l10n.aiReviewRecommendationEscalate,
    'aiReviewRecommendationCannotApproveYet' =>
      l10n.aiReviewRecommendationCannotApproveYet,
    'aiReviewRecommendationUnknown' => l10n.aiReviewRecommendationUnknown,
    'aiReviewSectionSummary' => l10n.aiReviewSectionSummary,
    'aiReviewSectionChecks' => l10n.aiReviewSectionChecks,
    'aiReviewFieldChecksPerformed' => l10n.aiReviewFieldChecksPerformed,
    'aiReviewFieldMissingInformation' => l10n.aiReviewFieldMissingInformation,
    'aiReviewFieldDuplicateWarnings' => l10n.aiReviewFieldDuplicateWarnings,
    'aiReviewFieldConfidenceScore' => l10n.aiReviewFieldConfidenceScore(
      params['score'] ?? '',
    ),
    'aiReviewUpdatedAt' => l10n.aiReviewUpdatedAt(params['date'] ?? ''),
    _ => l10n.errorGenericBody,
  };
}

String resolveBillingKey(
  BuildContext context,
  String key, {
  Map<String, String> params = const {},
}) {
  final l10n = AppLocalizations.of(context);
  return switch (key) {
    'billingLoadError' => l10n.billingLoadError,
    'billingDetailError' => l10n.billingDetailError,
    'billingMockDataBadge' => l10n.billingMockDataBadge,
    'billingMetadataBadge' => l10n.billingMetadataBadge,
    'billingOpenModule' => l10n.billingOpenModule,
    'billingPrivacyNotice' => l10n.billingPrivacyNotice,
    'billingOverviewTitle' => l10n.billingOverviewTitle,
    'billingOverviewActive' => l10n.billingOverviewActive(
      params['count'] ?? '0',
    ),
    'billingOverviewTrial' => l10n.billingOverviewTrial(params['count'] ?? '0'),
    'billingOverviewPastDue' => l10n.billingOverviewPastDue(
      params['count'] ?? '0',
    ),
    'billingOverviewSuspended' => l10n.billingOverviewSuspended(
      params['count'] ?? '0',
    ),
    'billingOverviewPricingNew' => l10n.billingOverviewPricingNew(
      params['count'] ?? '0',
    ),
    'billingOverviewQuotesPending' => l10n.billingOverviewQuotesPending(
      params['count'] ?? '0',
    ),
    'billingOverviewLastUpdated' => l10n.billingOverviewLastUpdated(
      params['date'] ?? '',
    ),
    'billingTabSubscriptions' => l10n.billingTabSubscriptions,
    'billingTabPricingIntakes' => l10n.billingTabPricingIntakes,
    'billingTabQuoteRequests' => l10n.billingTabQuoteRequests,
    'billingSubscriptionSearchHint' => l10n.billingSubscriptionSearchHint,
    'billingSubscriptionListEmpty' => l10n.billingSubscriptionListEmpty,
    'billingSubscriptionDetailTitle' => l10n.billingSubscriptionDetailTitle,
    'billingSubscriptionFilterAll' => l10n.billingSubscriptionFilterAll,
    'billingSubscriptionFilterActive' => l10n.billingSubscriptionFilterActive,
    'billingSubscriptionFilterTrial' => l10n.billingSubscriptionFilterTrial,
    'billingSubscriptionFilterPastDue' => l10n.billingSubscriptionFilterPastDue,
    'billingSubscriptionFilterSuspended' =>
      l10n.billingSubscriptionFilterSuspended,
    'billingSubscriptionFilterCancelled' =>
      l10n.billingSubscriptionFilterCancelled,
    'billingSubscriptionStatusTrial' => l10n.billingSubscriptionStatusTrial,
    'billingSubscriptionStatusActive' => l10n.billingSubscriptionStatusActive,
    'billingSubscriptionStatusPastDue' => l10n.billingSubscriptionStatusPastDue,
    'billingSubscriptionStatusSuspended' =>
      l10n.billingSubscriptionStatusSuspended,
    'billingSubscriptionStatusCancelled' =>
      l10n.billingSubscriptionStatusCancelled,
    'billingSubscriptionStatusCustomQuotePending' =>
      l10n.billingSubscriptionStatusCustomQuotePending,
    'billingSubscriptionStatusUnknown' => l10n.billingSubscriptionStatusUnknown,
    'billingPricingIntakeSearchHint' => l10n.billingPricingIntakeSearchHint,
    'billingPricingIntakeListEmpty' => l10n.billingPricingIntakeListEmpty,
    'billingPricingIntakeDetailTitle' => l10n.billingPricingIntakeDetailTitle,
    'billingPricingIntakeNeedsReview' => l10n.billingPricingIntakeNeedsReview,
    'billingPricingIntakeFilterAll' => l10n.billingPricingIntakeFilterAll,
    'billingPricingIntakeFilterNew' => l10n.billingPricingIntakeFilterNew,
    'billingPricingIntakeFilterReviewing' =>
      l10n.billingPricingIntakeFilterReviewing,
    'billingPricingIntakeFilterQuoted' => l10n.billingPricingIntakeFilterQuoted,
    'billingPricingIntakeFilterAccepted' =>
      l10n.billingPricingIntakeFilterAccepted,
    'billingPricingIntakeFilterRejected' =>
      l10n.billingPricingIntakeFilterRejected,
    'billingPricingIntakeStatusNew' => l10n.billingPricingIntakeStatusNew,
    'billingPricingIntakeStatusReviewing' =>
      l10n.billingPricingIntakeStatusReviewing,
    'billingPricingIntakeStatusQuoted' => l10n.billingPricingIntakeStatusQuoted,
    'billingPricingIntakeStatusAccepted' =>
      l10n.billingPricingIntakeStatusAccepted,
    'billingPricingIntakeStatusRejected' =>
      l10n.billingPricingIntakeStatusRejected,
    'billingPricingIntakeStatusUnknown' =>
      l10n.billingPricingIntakeStatusUnknown,
    'billingQuoteRequestSearchHint' => l10n.billingQuoteRequestSearchHint,
    'billingQuoteRequestListEmpty' => l10n.billingQuoteRequestListEmpty,
    'billingQuoteRequestDetailTitle' => l10n.billingQuoteRequestDetailTitle,
    'billingQuoteRequestFilterAll' => l10n.billingQuoteRequestFilterAll,
    'billingQuoteRequestFilterSubmitted' =>
      l10n.billingQuoteRequestFilterSubmitted,
    'billingQuoteRequestFilterUnderReview' =>
      l10n.billingQuoteRequestFilterUnderReview,
    'billingQuoteRequestFilterQuoted' => l10n.billingQuoteRequestFilterQuoted,
    'billingQuoteRequestFilterAccepted' =>
      l10n.billingQuoteRequestFilterAccepted,
    'billingQuoteRequestFilterRejected' =>
      l10n.billingQuoteRequestFilterRejected,
    'billingQuoteRequestStatusDraft' => l10n.billingQuoteRequestStatusDraft,
    'billingQuoteRequestStatusSubmitted' =>
      l10n.billingQuoteRequestStatusSubmitted,
    'billingQuoteRequestStatusUnderReview' =>
      l10n.billingQuoteRequestStatusUnderReview,
    'billingQuoteRequestStatusQuoted' => l10n.billingQuoteRequestStatusQuoted,
    'billingQuoteRequestStatusAccepted' =>
      l10n.billingQuoteRequestStatusAccepted,
    'billingQuoteRequestStatusRejected' =>
      l10n.billingQuoteRequestStatusRejected,
    'billingQuoteRequestStatusUnknown' => l10n.billingQuoteRequestStatusUnknown,
    'billingMetricSeats' => l10n.billingMetricSeats(
      params['used'] ?? '0',
      params['included'] ?? '0',
    ),
    'billingMetricDriverApps' => l10n.billingMetricDriverApps(
      params['used'] ?? '0',
      params['included'] ?? '0',
    ),
    'billingMetricFleetSize' => l10n.billingMetricFleetSize(
      params['count'] ?? '0',
    ),
    'billingMetricOfficeUsers' => l10n.billingMetricOfficeUsers(
      params['count'] ?? '0',
    ),
    'billingMetricDriverAppsRequested' => l10n.billingMetricDriverAppsRequested(
      params['count'] ?? '0',
    ),
    'billingFieldCompanyId' => l10n.billingFieldCompanyId(params['id'] ?? ''),
    'billingFieldPlan' => l10n.billingFieldPlan,
    'billingFieldBillingCycle' => l10n.billingFieldBillingCycle,
    'billingFieldCurrency' => l10n.billingFieldCurrency,
    'billingFieldPricingSource' => l10n.billingFieldPricingSource,
    'billingFieldOperatingModel' => l10n.billingFieldOperatingModel,
    'billingFieldAiAddOn' => l10n.billingFieldAiAddOn,
    'billingFieldStartedAt' => l10n.billingFieldStartedAt,
    'billingFieldRenewsAt' => l10n.billingFieldRenewsAt,
    'billingFieldCancelledAt' => l10n.billingFieldCancelledAt,
    'billingFieldLastPaymentStatus' => l10n.billingFieldLastPaymentStatus,
    'billingFieldContactEmail' => l10n.billingFieldContactEmail,
    'billingFieldCountry' => l10n.billingFieldCountry,
    'billingFieldCreatedAt' => l10n.billingFieldCreatedAt,
    'billingSectionPlan' => l10n.billingSectionPlan,
    'billingSectionUsage' => l10n.billingSectionUsage,
    'billingSectionDates' => l10n.billingSectionDates,
    'billingSectionContact' => l10n.billingSectionContact,
    'billingSectionFleet' => l10n.billingSectionFleet,
    'billingSectionModules' => l10n.billingSectionModules,
    'billingSectionAiFeatures' => l10n.billingSectionAiFeatures,
    'billingYes' => l10n.billingYes,
    'billingNo' => l10n.billingNo,
    'billingNoneReported' => l10n.billingNoneReported,
    'billingChangeStatusAction' => l10n.billingChangeStatusAction,
    'billingActionDialogTitle' => l10n.billingActionDialogTitle,
    'billingActionAuditNotice' => l10n.billingActionAuditNotice,
    'billingActionCurrentStatus' => l10n.billingActionCurrentStatus(
      params['status'] ?? '',
    ),
    'billingActionStatusLabel' => l10n.billingActionStatusLabel,
    'billingActionStatusRequired' => l10n.billingActionStatusRequired,
    'billingActionReasonLabel' => l10n.billingActionReasonLabel,
    'billingActionReasonRequired' => l10n.billingActionReasonRequired,
    'billingActionNoteLabel' => l10n.billingActionNoteLabel,
    'billingActionConfirm' => l10n.billingActionConfirm,
    'billingActionSuccess' => l10n.billingActionSuccess,
    'billingActionError' => l10n.billingActionError,
    'billingActionUnavailable' => l10n.billingActionUnavailable,
    _ => l10n.errorGenericBody,
  };
}

String resolveAdminUserKey(
  BuildContext context,
  String key, {
  Map<String, String> params = const {},
}) {
  final l10n = AppLocalizations.of(context);
  return switch (key) {
    'adminUserLoadError' => l10n.adminUserLoadError,
    'adminUserDetailError' => l10n.adminUserDetailError,
    'adminUserMockDataBadge' => l10n.adminUserMockDataBadge,
    'adminUserMetadataBadge' => l10n.adminUserMetadataBadge,
    'adminUserOpenModule' => l10n.adminUserOpenModule,
    'adminUserPrivacyNotice' => l10n.adminUserPrivacyNotice,
    'adminUserSearchHint' => l10n.adminUserSearchHint,
    'adminUserListEmpty' => l10n.adminUserListEmpty,
    'adminUserInviteAction' => l10n.adminUserInviteAction,
    'adminUserInviteTitle' => l10n.adminUserInviteTitle,
    'adminUserInviteNotice' => l10n.adminUserInviteNotice,
    'adminUserInviteNoteLabel' => l10n.adminUserInviteNoteLabel,
    'adminUserInviteConfirm' => l10n.adminUserInviteConfirm,
    'adminUserInviteSuccess' => l10n.adminUserInviteSuccess,
    'adminUserFilterAll' => l10n.adminUserFilterAll,
    'adminUserFilterActive' => l10n.adminUserFilterActive,
    'adminUserFilterInvited' => l10n.adminUserFilterInvited,
    'adminUserFilterSuspended' => l10n.adminUserFilterSuspended,
    'adminUserFilterDisabled' => l10n.adminUserFilterDisabled,
    'adminUserStatusActive' => l10n.adminUserStatusActive,
    'adminUserStatusInvited' => l10n.adminUserStatusInvited,
    'adminUserStatusSuspended' => l10n.adminUserStatusSuspended,
    'adminUserStatusDisabled' => l10n.adminUserStatusDisabled,
    'adminUserStatusUnknown' => l10n.adminUserStatusUnknown,
    'adminUserRoleUnknown' => l10n.adminUserRoleUnknown,
    'adminUserLastLogin' => l10n.adminUserLastLogin(params['date'] ?? ''),
    'adminUserFailedLogins' => l10n.adminUserFailedLogins(
      params['count'] ?? '0',
    ),
    'adminUserFieldName' => l10n.adminUserFieldName,
    'adminUserFieldEmail' => l10n.adminUserFieldEmail,
    'adminUserFieldRole' => l10n.adminUserFieldRole,
    'adminUserFieldStatus' => l10n.adminUserFieldStatus,
    'adminUserFieldCreatedAt' => l10n.adminUserFieldCreatedAt,
    'adminUserFieldLastLoginAt' => l10n.adminUserFieldLastLoginAt,
    'adminUserFieldFailedLoginCount' => l10n.adminUserFieldFailedLoginCount,
    'adminUserChangeRoleAction' => l10n.adminUserChangeRoleAction,
    'adminUserChangeStatusAction' => l10n.adminUserChangeStatusAction,
    'adminUserRoleDialogTitle' => l10n.adminUserRoleDialogTitle,
    'adminUserStatusDialogTitle' => l10n.adminUserStatusDialogTitle,
    'adminUserActionCurrentRole' => l10n.adminUserActionCurrentRole(
      params['role'] ?? '',
    ),
    'adminUserActionCurrentStatus' => l10n.adminUserActionCurrentStatus(
      params['status'] ?? '',
    ),
    'adminUserReasonLabel' => l10n.adminUserReasonLabel,
    'adminUserReasonRequired' => l10n.adminUserReasonRequired,
    'adminUserNameRequired' => l10n.adminUserNameRequired,
    'adminUserActionAuditNotice' => l10n.adminUserActionAuditNotice,
    'adminUserActionCancel' => l10n.adminUserActionCancel,
    'adminUserRoleConfirm' => l10n.adminUserRoleConfirm,
    'adminUserStatusConfirm' => l10n.adminUserStatusConfirm,
    'adminUserRoleSuccess' => l10n.adminUserRoleSuccess,
    'adminUserStatusSuccess' => l10n.adminUserStatusSuccess,
    'adminUserActionError' => l10n.adminUserActionError,
    'adminUserActionUnavailable' => l10n.adminUserActionUnavailable,
    _ => l10n.errorGenericBody,
  };
}

String resolveSecurityKey(
  BuildContext context,
  String key, {
  Map<String, String> params = const {},
}) {
  final l10n = AppLocalizations.of(context);
  return switch (key) {
    'securityLoadError' => l10n.securityLoadError,
    'securityMockDataBadge' => l10n.securityMockDataBadge,
    'securityOpenModule' => l10n.securityOpenModule,
    'securityPrivacyNotice' => l10n.securityPrivacyNotice,
    'securityOverviewTitle' => l10n.securityOverviewTitle,
    'securityOverviewFailedLogins' => l10n.securityOverviewFailedLogins(
      params['count'] ?? '0',
    ),
    'securityOverviewDeniedActions' => l10n.securityOverviewDeniedActions(
      params['count'] ?? '0',
    ),
    'securityOverviewActiveGrants' => l10n.securityOverviewActiveGrants(
      params['count'] ?? '0',
    ),
    'securityOverviewCriticalEvents' => l10n.securityOverviewCriticalEvents(
      params['count'] ?? '0',
    ),
    'securityOverviewExpiringGrants' => l10n.securityOverviewExpiringGrants(
      params['count'] ?? '0',
    ),
    'securityOverviewHighRiskAi' => l10n.securityOverviewHighRiskAi(
      params['count'] ?? '0',
    ),
    'securityOverviewSuspiciousBulk' => l10n.securityOverviewSuspiciousBulk(
      params['count'] ?? '0',
    ),
    'securityOverviewNoCritical' => l10n.securityOverviewNoCritical,
    'securityOverviewLastCritical' => l10n.securityOverviewLastCritical(
      params['date'] ?? '',
    ),
    'securityEventSearchHint' => l10n.securityEventSearchHint,
    'securityEventListEmpty' => l10n.securityEventListEmpty,
    'securityEventDetailError' => l10n.securityEventDetailError,
    'securityEventCompanyLabel' => l10n.securityEventCompanyLabel(
      params['name'] ?? '',
    ),
    'securityEventCreatedAt' => l10n.securityEventCreatedAt(
      params['date'] ?? '',
    ),
    'securityEventFieldSourceType' => l10n.securityEventFieldSourceType,
    'securityEventFieldSourceId' => l10n.securityEventFieldSourceId,
    'securityEventFieldActorEmail' => l10n.securityEventFieldActorEmail,
    'securityEventFieldActorRole' => l10n.securityEventFieldActorRole,
    'securityEventFieldCompany' => l10n.securityEventFieldCompany,
    'securityEventFieldCorrelationId' => l10n.securityEventFieldCorrelationId,
    'securityEventFieldCreatedAt' => l10n.securityEventFieldCreatedAt,
    'securityEventFilterAll' => l10n.securityEventFilterAll,
    'securityEventFilterFailedLogin' => l10n.securityEventFilterFailedLogin,
    'securityEventFilterPermissionDenied' =>
      l10n.securityEventFilterPermissionDenied,
    'securityEventFilterSupportAccess' => l10n.securityEventFilterSupportAccess,
    'securityEventFilterHighRiskAi' => l10n.securityEventFilterHighRiskAi,
    'securityEventFilterCriticalSystem' =>
      l10n.securityEventFilterCriticalSystem,
    'securityEventFilterAdminRoleChange' =>
      l10n.securityEventFilterAdminRoleChange,
    'securityEventFilterSuspiciousBulkOnboarding' =>
      l10n.securityEventFilterSuspiciousBulkOnboarding,
    'securityEventFilterCritical' => l10n.securityEventFilterCritical,
    'securityEventFilterWarning' => l10n.securityEventFilterWarning,
    'securityEventTypeFailedLogin' => l10n.securityEventTypeFailedLogin,
    'securityEventTypePermissionDenied' =>
      l10n.securityEventTypePermissionDenied,
    'securityEventTypeSupportAccess' => l10n.securityEventTypeSupportAccess,
    'securityEventTypeHighRiskAi' => l10n.securityEventTypeHighRiskAi,
    'securityEventTypeCriticalSystem' => l10n.securityEventTypeCriticalSystem,
    'securityEventTypeAdminRoleChange' => l10n.securityEventTypeAdminRoleChange,
    'securityEventTypeSuspiciousBulkOnboarding' =>
      l10n.securityEventTypeSuspiciousBulkOnboarding,
    'securityEventTypeUnknown' => l10n.securityEventTypeUnknown,
    'securityEventSeverityInfo' => l10n.securityEventSeverityInfo,
    'securityEventSeverityWarning' => l10n.securityEventSeverityWarning,
    'securityEventSeverityCritical' => l10n.securityEventSeverityCritical,
    'securityEventSeverityUnknown' => l10n.securityEventSeverityUnknown,
    _ => l10n.errorGenericBody,
  };
}

String resolveActionCenterKey(
  BuildContext context,
  String key, {
  Map<String, String> params = const {},
}) {
  final l10n = AppLocalizations.of(context);
  return switch (key) {
    'actionCenterLoadError' => l10n.actionCenterLoadError,
    'actionCenterMockDataBadge' => l10n.actionCenterMockDataBadge,
    'actionCenterOpenModule' => l10n.actionCenterOpenModule,
    'actionCenterPrivacyNotice' => l10n.actionCenterPrivacyNotice,
    'actionCenterReadOnlyNotice' => l10n.actionCenterReadOnlyNotice,
    'actionCenterSearchHint' => l10n.actionCenterSearchHint,
    'actionCenterListEmpty' => l10n.actionCenterListEmpty,
    'actionCenterListEmptyDetail' => l10n.actionCenterListEmptyDetail,
    'actionCenterNeedsAttentionTitle' => l10n.actionCenterNeedsAttentionTitle,
    'actionCenterNeedsAttentionOpen' => l10n.actionCenterNeedsAttentionOpen(
      params['count'] ?? '0',
    ),
    'actionCenterNeedsAttentionCritical' =>
      l10n.actionCenterNeedsAttentionCritical(params['count'] ?? '0'),
    'actionCenterNeedsAttentionTotal' => l10n.actionCenterNeedsAttentionTotal(
      params['count'] ?? '0',
    ),
    'actionCenterCompanyLabel' => l10n.actionCenterCompanyLabel(
      params['name'] ?? '',
    ),
    'actionCenterCreatedAt' => l10n.actionCenterCreatedAt(params['date'] ?? ''),
    'actionCenterFilterAll' => l10n.actionCenterFilterAll,
    'actionCenterFilterRegistration' => l10n.actionCenterFilterRegistration,
    'actionCenterFilterBulkOnboarding' => l10n.actionCenterFilterBulkOnboarding,
    'actionCenterFilterSupport' => l10n.actionCenterFilterSupport,
    'actionCenterFilterSystemHealth' => l10n.actionCenterFilterSystemHealth,
    'actionCenterFilterSecurity' => l10n.actionCenterFilterSecurity,
    'actionCenterFilterBilling' => l10n.actionCenterFilterBilling,
    'actionCenterFilterAiReview' => l10n.actionCenterFilterAiReview,
    'actionCenterFilterCritical' => l10n.actionCenterFilterCritical,
    'actionCenterFilterCustomerCommunication' =>
      l10n.actionCenterFilterCustomerCommunication,
    'actionCenterFilterPublicIntake' => l10n.actionCenterFilterPublicIntake,
    'actionCenterTypeRegistration' => l10n.actionCenterTypeRegistration,
    'actionCenterTypeBulkOnboarding' => l10n.actionCenterTypeBulkOnboarding,
    'actionCenterTypeSupport' => l10n.actionCenterTypeSupport,
    'actionCenterTypeSystemHealth' => l10n.actionCenterTypeSystemHealth,
    'actionCenterTypeSecurity' => l10n.actionCenterTypeSecurity,
    'actionCenterTypeBilling' => l10n.actionCenterTypeBilling,
    'actionCenterTypeAiReview' => l10n.actionCenterTypeAiReview,
    'actionCenterTypeCompany' => l10n.actionCenterTypeCompany,
    'actionCenterTypeCustomerCommunication' =>
      l10n.actionCenterTypeCustomerCommunication,
    'actionCenterTypePublicIntake' => l10n.actionCenterTypePublicIntake,
    'actionCenterTypeUnknown' => l10n.actionCenterTypeUnknown,
    'actionCenterPriorityLow' => l10n.actionCenterPriorityLow,
    'actionCenterPriorityNormal' => l10n.actionCenterPriorityNormal,
    'actionCenterPriorityHigh' => l10n.actionCenterPriorityHigh,
    'actionCenterPriorityUrgent' => l10n.actionCenterPriorityUrgent,
    'actionCenterPriorityCritical' => l10n.actionCenterPriorityCritical,
    'actionCenterPriorityUnknown' => l10n.actionCenterPriorityUnknown,
    'actionCenterStatusOpen' => l10n.actionCenterStatusOpen,
    'actionCenterStatusAcknowledged' => l10n.actionCenterStatusAcknowledged,
    'actionCenterStatusDismissed' => l10n.actionCenterStatusDismissed,
    'actionCenterStatusResolved' => l10n.actionCenterStatusResolved,
    'actionCenterStatusUnknown' => l10n.actionCenterStatusUnknown,
    _ => l10n.errorGenericBody,
  };
}

String resolveCustomerCommunicationsKey(
  BuildContext context,
  String key, {
  Map<String, String> params = const {},
}) {
  final l10n = AppLocalizations.of(context);
  return switch (key) {
    'customerCommunicationLoadError' => l10n.customerCommunicationLoadError,
    'customerCommunicationActionError' => l10n.customerCommunicationActionError,
    'customerCommunicationMockDataBadge' => l10n.customerCommunicationMockDataBadge,
    'customerCommunicationOpenModule' => l10n.customerCommunicationOpenModule,
    'customerCommunicationPrivacyNotice' => l10n.customerCommunicationPrivacyNotice,
    'customerCommunicationDetailMetadataOnly' =>
      l10n.customerCommunicationDetailMetadataOnly,
    'customerCommunicationSearchHint' => l10n.customerCommunicationSearchHint,
    'customerCommunicationListEmpty' => l10n.customerCommunicationListEmpty,
    'customerCommunicationDisputedBadge' => l10n.customerCommunicationDisputedBadge,
    'customerCommunicationBillingRelatedBadge' =>
      l10n.customerCommunicationBillingRelatedBadge,
    'customerCommunicationThreadSubtitle' =>
      l10n.customerCommunicationThreadSubtitle(
      params['domain'] ?? '',
      params['companyId'] ?? '',
    ),
    'customerCommunicationUpdatedAt' => l10n.customerCommunicationUpdatedAt(
      params['date'] ?? '',
    ),
    'customerCommunicationFilterAll' => l10n.customerCommunicationFilterAll,
    'customerCommunicationFilterOpen' => l10n.customerCommunicationFilterOpen,
    'customerCommunicationFilterDisputed' =>
      l10n.customerCommunicationFilterDisputed,
    'customerCommunicationFilterClosed' => l10n.customerCommunicationFilterClosed,
    'customerCommunicationFilterBillingRelated' =>
      l10n.customerCommunicationFilterBillingRelated,
    'customerCommunicationStatusOpen' => l10n.customerCommunicationStatusOpen,
    'customerCommunicationStatusClosed' => l10n.customerCommunicationStatusClosed,
    'customerCommunicationStatusArchived' =>
      l10n.customerCommunicationStatusArchived,
    'customerCommunicationStatusDisputed' =>
      l10n.customerCommunicationStatusDisputed,
    'customerCommunicationStatusUnknown' =>
      l10n.customerCommunicationStatusUnknown,
    'customerCommunicationSourcePublicSite' =>
      l10n.customerCommunicationSourcePublicSite,
    'customerCommunicationSourceEmail' => l10n.customerCommunicationSourceEmail,
    'customerCommunicationSourceAdminApp' =>
      l10n.customerCommunicationSourceAdminApp,
    'customerCommunicationSourceAdminWeb' =>
      l10n.customerCommunicationSourceAdminWeb,
    'customerCommunicationSourceImport' => l10n.customerCommunicationSourceImport,
    'customerCommunicationSourceSupport' => l10n.customerCommunicationSourceSupport,
    'customerCommunicationSourceSystem' => l10n.customerCommunicationSourceSystem,
    'customerCommunicationSourceUnknown' => l10n.customerCommunicationSourceUnknown,
    'customerCommunicationDirectionInbound' =>
      l10n.customerCommunicationDirectionInbound,
    'customerCommunicationDirectionOutbound' =>
      l10n.customerCommunicationDirectionOutbound,
    'customerCommunicationDirectionInternalNote' =>
      l10n.customerCommunicationDirectionInternalNote,
    'customerCommunicationDirectionSystemEvent' =>
      l10n.customerCommunicationDirectionSystemEvent,
    'customerCommunicationDirectionUnknown' =>
      l10n.customerCommunicationDirectionUnknown,
    'customerCommunicationSenderCustomer' =>
      l10n.customerCommunicationSenderCustomer,
    'customerCommunicationSenderPlatformAdmin' =>
      l10n.customerCommunicationSenderPlatformAdmin,
    'customerCommunicationSenderCompanyAdmin' =>
      l10n.customerCommunicationSenderCompanyAdmin,
    'customerCommunicationSenderSystem' => l10n.customerCommunicationSenderSystem,
    'customerCommunicationSenderUnknown' => l10n.customerCommunicationSenderUnknown,
    'customerCommunicationHumanReviewedBadge' =>
      l10n.customerCommunicationHumanReviewedBadge,
    'customerCommunicationOriginalLabel' => l10n.customerCommunicationOriginalLabel(
      params['language'] ?? '',
    ),
    'customerCommunicationTranslatedLabel' =>
      l10n.customerCommunicationTranslatedLabel(params['language'] ?? ''),
    'customerCommunicationMessageMetadataOnly' =>
      l10n.customerCommunicationMessageMetadataOnly,
    'customerCommunicationMessagesEmpty' => l10n.customerCommunicationMessagesEmpty,
    'customerCommunicationTimelineTitle' => l10n.customerCommunicationTimelineTitle,
    'customerCommunicationAgreementsTitle' => l10n.customerCommunicationAgreementsTitle,
    'customerCommunicationEvidencePackagesTitle' =>
      l10n.customerCommunicationEvidencePackagesTitle,
    'customerCommunicationPackagesEmpty' => l10n.customerCommunicationPackagesEmpty,
    'customerCommunicationAgreementPrice' => l10n.customerCommunicationAgreementPrice(
      params['amount'] ?? '',
      params['currency'] ?? '',
      params['cycle'] ?? '',
    ),
    'customerCommunicationAgreementModules' =>
      l10n.customerCommunicationAgreementModules(params['modules'] ?? ''),
    'customerCommunicationAgreementAcceptedAt' =>
      l10n.customerCommunicationAgreementAcceptedAt(params['date'] ?? ''),
    'customerCommunicationPdfPendingNotice' =>
      l10n.customerCommunicationPdfPendingNotice,
    'customerCommunicationPdfReadyNotice' =>
      l10n.customerCommunicationPdfReadyNotice,
    'customerCommunicationPdfFailedNotice' =>
      l10n.customerCommunicationPdfFailedNotice,
    'customerCommunicationPdfSourceOfTruthNotice' =>
      l10n.customerCommunicationPdfSourceOfTruthNotice,
    'customerCommunicationDownloadPdfAction' =>
      l10n.customerCommunicationDownloadPdfAction,
    'customerCommunicationDownloadPdfSuccess' =>
      l10n.customerCommunicationDownloadPdfSuccess(params['bytes'] ?? '0'),
    'customerCommunicationDownloadPdfFailed' =>
      l10n.customerCommunicationDownloadPdfFailed,
    'customerCommunicationSharePdfAction' => l10n.customerCommunicationSharePdfAction,
    'customerCommunicationSharePdfSuccess' =>
      l10n.customerCommunicationSharePdfSuccess,
    'customerCommunicationSharePdfFailed' =>
      l10n.customerCommunicationSharePdfFailed,
    'customerCommunicationSharePdfInvalid' =>
      l10n.customerCommunicationSharePdfInvalid,
    'customerCommunicationSharePdfUnavailable' =>
      l10n.customerCommunicationSharePdfUnavailable,
    'customerCommunicationSharePdfNotReady' =>
      l10n.customerCommunicationSharePdfNotReady,
    'customerCommunicationGeneratedBy' =>
      l10n.customerCommunicationGeneratedBy(params['userId'] ?? ''),
    'customerCommunicationSendReplyTitle' =>
      l10n.customerCommunicationSendReplyTitle,
    'customerCommunicationSendReplyAction' =>
      l10n.customerCommunicationSendReplyAction,
    'customerCommunicationSendReplyMessageLabel' =>
      l10n.customerCommunicationSendReplyMessageLabel,
    'customerCommunicationSendReplySubjectLabel' =>
      l10n.customerCommunicationSendReplySubjectLabel,
    'customerCommunicationUseTranslatedTextLabel' =>
      l10n.customerCommunicationUseTranslatedTextLabel,
    'customerCommunicationHumanConfirmationLabel' =>
      l10n.customerCommunicationHumanConfirmationLabel,
    'customerCommunicationHumanConfirmedBadge' =>
      l10n.customerCommunicationHumanConfirmedBadge,
    'customerCommunicationTranslationApprovedBadge' =>
      l10n.customerCommunicationTranslationApprovedBadge,
    'customerCommunicationTranslatedReplyWarning' =>
      l10n.customerCommunicationTranslatedReplyWarning,
    'customerCommunicationDeliveryProviderDisabledNotice' =>
      l10n.customerCommunicationDeliveryProviderDisabledNotice,
    'customerCommunicationReplyLoggedSkippedNotice' =>
      l10n.customerCommunicationReplyLoggedSkippedNotice,
    'customerCommunicationReplySentSuccess' =>
      l10n.customerCommunicationReplySentSuccess,
    'customerCommunicationEvidenceDeliveryNotice' =>
      l10n.customerCommunicationEvidenceDeliveryNotice,
    'customerCommunicationDeliveryStatusDraft' =>
      l10n.customerCommunicationDeliveryStatusDraft,
    'customerCommunicationDeliveryStatusQueued' =>
      l10n.customerCommunicationDeliveryStatusQueued,
    'customerCommunicationDeliveryStatusSkipped' =>
      l10n.customerCommunicationDeliveryStatusSkipped,
    'customerCommunicationDeliveryStatusSent' =>
      l10n.customerCommunicationDeliveryStatusSent,
    'customerCommunicationDeliveryStatusFailed' =>
      l10n.customerCommunicationDeliveryStatusFailed,
    'customerCommunicationDeliveryStatusCancelled' =>
      l10n.customerCommunicationDeliveryStatusCancelled,
    'customerCommunicationDeliveryStatusUnknown' =>
      l10n.customerCommunicationDeliveryStatusUnknown,
    'customerCommunicationDeliveryChannelEmail' =>
      l10n.customerCommunicationDeliveryChannelEmail,
    'customerCommunicationDeliveryChannelPortal' =>
      l10n.customerCommunicationDeliveryChannelPortal,
    'customerCommunicationDeliveryChannelManual' =>
      l10n.customerCommunicationDeliveryChannelManual,
    'customerCommunicationDeliveryChannelNone' =>
      l10n.customerCommunicationDeliveryChannelNone,
    'customerCommunicationDeliveryChannelUnknown' =>
      l10n.customerCommunicationDeliveryChannelUnknown,
    'customerCommunicationDeliveryHistoryTitle' =>
      l10n.customerCommunicationDeliveryHistoryTitle,
    'customerCommunicationDeliveryHistoryEmpty' =>
      l10n.customerCommunicationDeliveryHistoryEmpty,
    'customerCommunicationDeliveryFilterAll' =>
      l10n.customerCommunicationDeliveryFilterAll,
    'customerCommunicationDeliveryFilterSkipped' =>
      l10n.customerCommunicationDeliveryFilterSkipped,
    'customerCommunicationDeliveryFilterFailed' =>
      l10n.customerCommunicationDeliveryFilterFailed,
    'customerCommunicationDeliveryFilterSent' =>
      l10n.customerCommunicationDeliveryFilterSent,
    'customerCommunicationDeliveryFilterQueued' =>
      l10n.customerCommunicationDeliveryFilterQueued,
    'customerCommunicationResendTitle' => l10n.customerCommunicationResendTitle,
    'customerCommunicationResendAction' => l10n.customerCommunicationResendAction,
    'customerCommunicationResendAuditNotice' =>
      l10n.customerCommunicationResendAuditNotice,
    'customerCommunicationResendTranslationNotice' =>
      l10n.customerCommunicationResendTranslationNotice,
    'customerCommunicationResendSuccess' => l10n.customerCommunicationResendSuccess,
    'customerCommunicationDeliveryMultipleAttempts' =>
      l10n.customerCommunicationDeliveryMultipleAttempts,
    'customerCommunicationDeliveryResendAttempt' =>
      l10n.customerCommunicationDeliveryResendAttempt,
    'customerCommunicationDeliveryTemplateLabel' =>
      l10n.customerCommunicationDeliveryTemplateLabel,
    'customerCommunicationEvidenceRegenerationNotice' =>
      l10n.customerCommunicationEvidenceRegenerationNotice,
    'customerCommunicationHumanConfirmRequired' =>
      l10n.customerCommunicationHumanConfirmRequired,
    'customerCommunicationPackageGeneratedAt' =>
      l10n.customerCommunicationPackageGeneratedAt(params['date'] ?? ''),
    'customerCommunicationPackageTypeCommunicationEvidence' =>
      l10n.customerCommunicationPackageTypeCommunicationEvidence,
    'customerCommunicationPackageTypeSubscriptionDispute' =>
      l10n.customerCommunicationPackageTypeSubscriptionDispute,
    'customerCommunicationPackageTypeRegistrationEvidence' =>
      l10n.customerCommunicationPackageTypeRegistrationEvidence,
    'customerCommunicationPackageTypePricingEvidence' =>
      l10n.customerCommunicationPackageTypePricingEvidence,
    'customerCommunicationPackageTypeUnknown' =>
      l10n.customerCommunicationPackageTypeUnknown,
    'customerCommunicationPackageStatusGenerated' =>
      l10n.customerCommunicationPackageStatusGenerated,
    'customerCommunicationPackageStatusFailed' =>
      l10n.customerCommunicationPackageStatusFailed,
    'customerCommunicationPackageStatusUnknown' =>
      l10n.customerCommunicationPackageStatusUnknown,
    'customerCommunicationGeneratePackageTitle' =>
      l10n.customerCommunicationGeneratePackageTitle,
    'customerCommunicationGeneratePackageAction' =>
      l10n.customerCommunicationGeneratePackageAction,
    'customerCommunicationMarkDisputedTitle' =>
      l10n.customerCommunicationMarkDisputedTitle,
    'customerCommunicationMarkDisputedAction' =>
      l10n.customerCommunicationMarkDisputedAction,
    'customerCommunicationDisputedSectionTitle' =>
      l10n.customerCommunicationDisputedSectionTitle,
    'customerCommunicationReasonLabel' => l10n.customerCommunicationReasonLabel,
    'customerCommunicationReasonRequired' => l10n.customerCommunicationReasonRequired,
    'customerCommunicationPackageTypeLabel' =>
      l10n.customerCommunicationPackageTypeLabel,
    'customerCommunicationExportAuditWarning' =>
      l10n.customerCommunicationExportAuditWarning,
    'customerCommunicationCancel' => l10n.customerCommunicationCancel,
    'customerCommunicationDisputeMarkedSuccess' =>
      l10n.customerCommunicationDisputeMarkedSuccess,
    'customerCommunicationPackageGeneratedSuccess' =>
      l10n.customerCommunicationPackageGeneratedSuccess,
    'customerCommunicationSummaryJsonTitle' =>
      l10n.customerCommunicationSummaryJsonTitle,
    'customerCommunicationPackageReason' => l10n.customerCommunicationPackageReason(
      params['reason'] ?? '',
    ),
    'customerCommunicationFileHash' => l10n.customerCommunicationFileHash(
      params['hash'] ?? '',
    ),
    'customerCommunicationPackageNotFound' =>
      l10n.customerCommunicationPackageNotFound,
    'customerCommunicationSummaryTitle' => l10n.customerCommunicationSummaryTitle,
    'customerCommunicationSummaryDisputed' =>
      l10n.customerCommunicationSummaryDisputed(params['count'] ?? '0'),
    'customerCommunicationSummaryOpen' =>
      l10n.customerCommunicationSummaryOpen(params['count'] ?? '0'),
    'customerCommunicationSummaryTotal' =>
      l10n.customerCommunicationSummaryTotal(params['count'] ?? '0'),
    _ => l10n.errorGenericBody,
  };
}

String resolveReleaseCenterKey(
  BuildContext context,
  String key, {
  Map<String, String> params = const {},
}) {
  final l10n = AppLocalizations.of(context);
  return switch (key) {
    'releaseLoadError' => l10n.releaseLoadError,
    'releaseMockDataBadge' => l10n.releaseMockDataBadge,
    'releaseReadOnlyBadge' => l10n.releaseReadOnlyBadge,
    'releasePrivacyNotice' => l10n.releasePrivacyNotice,
    'releaseTabOverview' => l10n.releaseTabOverview,
    'releaseTabAppVersions' => l10n.releaseTabAppVersions,
    'releaseTabEnvironment' => l10n.releaseTabEnvironment,
    'releaseOverviewTitle' => l10n.releaseOverviewTitle,
    'releaseAppVersionsTitle' => l10n.releaseAppVersionsTitle,
    'releaseEnvironmentTitle' => l10n.releaseEnvironmentTitle,
    'releaseFieldBackendVersion' => l10n.releaseFieldBackendVersion,
    'releaseFieldEnvironment' => l10n.releaseFieldEnvironment,
    'releaseFieldNodeEnv' => l10n.releaseFieldNodeEnv,
    'releaseFieldMaintenanceMode' => l10n.releaseFieldMaintenanceMode,
    'releaseFieldLatestAdminApp' => l10n.releaseFieldLatestAdminApp,
    'releaseFieldLatestDriverApp' => l10n.releaseFieldLatestDriverApp,
    'releaseFieldMinAdminApp' => l10n.releaseFieldMinAdminApp,
    'releaseFieldMinDriverApp' => l10n.releaseFieldMinDriverApp,
    'releaseFieldLastDeployment' => l10n.releaseFieldLastDeployment(
      params['date'] ?? '',
    ),
    'releaseFieldMigrationStatus' => l10n.releaseFieldMigrationStatus,
    'releaseFieldDeploymentReady' => l10n.releaseFieldDeploymentReady,
    'releaseFieldApiPublicName' => l10n.releaseFieldApiPublicName,
    'releaseActiveAdminVersions' => l10n.releaseActiveAdminVersions,
    'releaseActiveDriverVersions' => l10n.releaseActiveDriverVersions,
    'releaseDeploymentWarnings' => l10n.releaseDeploymentWarnings,
    'releaseYes' => l10n.releaseYes,
    'releaseNo' => l10n.releaseNo,
    'releaseEmailDeliveryTitle' => l10n.releaseEmailDeliveryTitle,
    'releaseEmailDeliveryProvider' => l10n.releaseEmailDeliveryProvider,
    'releaseEmailDeliveryEnabled' => l10n.releaseEmailDeliveryEnabled,
    'releaseEmailDeliveryLastStatus' => l10n.releaseEmailDeliveryLastStatus,
    'releaseEmailDeliveryNotice' => l10n.releaseEmailDeliveryNotice,
    'releaseEmailDeliveryAllowlistEnabled' =>
      l10n.releaseEmailDeliveryAllowlistEnabled,
    'releaseEmailDeliveryAllowlistDomains' =>
      l10n.releaseEmailDeliveryAllowlistDomains,
    'releaseEmailDeliveryAllowlistRecipients' =>
      l10n.releaseEmailDeliveryAllowlistRecipients,
    'releaseEmailDeliveryLastFailureCode' =>
      l10n.releaseEmailDeliveryLastFailureCode,
    'releaseEmailDeliveryStagingAllowlistMissing' =>
      l10n.releaseEmailDeliveryStagingAllowlistMissing,
    'releaseEmailProviderNoop' => l10n.releaseEmailProviderNoop,
    'releaseEmailProviderSmtp' => l10n.releaseEmailProviderSmtp,
    'releaseEmailProviderPlaceholder' => l10n.releaseEmailProviderPlaceholder,
    'releaseObservabilityTitle' => l10n.releaseObservabilityTitle,
    'releaseObservabilityLogLevel' => l10n.releaseObservabilityLogLevel,
    'releaseObservabilityMetricsEnabled' => l10n.releaseObservabilityMetricsEnabled,
    'releaseObservabilitySentryConfigured' => l10n.releaseObservabilitySentryConfigured,
    'releaseObservabilityOtelConfigured' => l10n.releaseObservabilityOtelConfigured,
    'releaseObservabilityCorrelationId' => l10n.releaseObservabilityCorrelationId,
    'releaseObservabilityNotice' => l10n.releaseObservabilityNotice,
    _ => l10n.errorGenericBody,
  };
}

String resolveNotificationsKey(
  BuildContext context,
  String key, {
  Map<String, String> params = const {},
}) {
  final l10n = AppLocalizations.of(context);
  return switch (key) {
    'notificationsPushProviderTitle' => l10n.notificationsPushProviderTitle,
    'notificationsPushStateInAppOnly' => l10n.notificationsPushStateInAppOnly,
    'notificationsPushStateExternalNotConfigured' =>
      l10n.notificationsPushStateExternalNotConfigured,
    'notificationsPushStateConfigured' => l10n.notificationsPushStateConfigured,
    'notificationsPushProviderField' => l10n.notificationsPushProviderField,
    'notificationsPushDeliveryEnabled' => l10n.notificationsPushDeliveryEnabled,
    'notificationsPushTokenStorage' => l10n.notificationsPushTokenStorage,
    'notificationsPushLastFailureCode' => l10n.notificationsPushLastFailureCode,
    'notificationsPushProviderNotice' => l10n.notificationsPushProviderNotice,
    'notificationsPushProviderNone' => l10n.notificationsPushProviderNone,
    'notificationsPushProviderFcm' => l10n.notificationsPushProviderFcm,
    'notificationsPushProviderApns' => l10n.notificationsPushProviderApns,
    'notificationsYes' => l10n.notificationsYes,
    'notificationsNo' => l10n.notificationsNo,
    _ => l10n.errorGenericBody,
  };
}

String resolveAppConfigKey(BuildContext context, String key) {
  final l10n = AppLocalizations.of(context);
  return switch (key) {
    'appEnvLocal' => l10n.appEnvLocal,
    'appEnvDev' => l10n.appEnvDev,
    'appEnvStaging' => l10n.appEnvStaging,
    'appEnvProduction' => l10n.appEnvProduction,
    'appConfigEnvironmentLabel' => l10n.appConfigEnvironmentLabel,
    'appConfigApiStatusLabel' => l10n.appConfigApiStatusLabel,
    'appConfigApiConfigured' => l10n.appConfigApiConfigured,
    'appConfigApiNotConfigured' => l10n.appConfigApiNotConfigured,
    'appConfigMockFallbackActive' => l10n.appConfigMockFallbackActive,
    'appConfigProductionMisconfigured' => l10n.appConfigProductionMisconfigured,
    'appConfigProductionLoginBlocked' => l10n.appConfigProductionLoginBlocked,
    'backendMockFallbackBanner' => l10n.backendMockFallbackBanner,
    _ => l10n.errorGenericBody,
  };
}
