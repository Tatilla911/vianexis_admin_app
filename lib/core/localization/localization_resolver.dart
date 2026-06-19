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
    LocalizationKeys.authNetworkError => l10n.authNetworkError,
    LocalizationKeys.authServerError => l10n.authServerError,
    LocalizationKeys.authForbiddenRole => l10n.authForbiddenRole,
    LocalizationKeys.authBackendNotConfigured => l10n.authBackendNotConfigured,
    LocalizationKeys.authRequiredField => l10n.authRequiredField,
    LocalizationKeys.authShowPassword => l10n.authShowPassword,
    LocalizationKeys.authHidePassword => l10n.authHidePassword,
    LocalizationKeys.errorGenericBody => l10n.errorGenericBody,
    LocalizationKeys.roleSuperAdmin => l10n.roleSuperAdmin,
    LocalizationKeys.roleSupportAdmin => l10n.roleSupportAdmin,
    LocalizationKeys.roleOnboardingReviewer => l10n.roleOnboardingReviewer,
    LocalizationKeys.roleBillingAdmin => l10n.roleBillingAdmin,
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
    'registrationSubmittedAt' => l10n.registrationSubmittedAt(params['date'] ?? ''),
    'registrationSectionCompany' => l10n.registrationSectionCompany,
    'registrationSectionContact' => l10n.registrationSectionContact,
    'registrationSectionStatus' => l10n.registrationSectionStatus,
    'registrationSectionAiReview' => l10n.registrationSectionAiReview,
    'registrationSectionDocuments' => l10n.registrationSectionDocuments,
    'registrationFieldCompanyName' => l10n.registrationFieldCompanyName,
    'registrationFieldCountry' => l10n.registrationFieldCountry,
    'registrationFieldVatNumber' => l10n.registrationFieldVatNumber,
    'registrationFieldRegistrationNumber' => l10n.registrationFieldRegistrationNumber,
    'registrationFieldContactName' => l10n.registrationFieldContactName,
    'registrationFieldContactEmail' => l10n.registrationFieldContactEmail,
    'registrationFieldSubmittedAt' => l10n.registrationFieldSubmittedAt,
    'registrationFieldReviewedAt' => l10n.registrationFieldReviewedAt,
    'registrationFieldReviewedBy' => l10n.registrationFieldReviewedBy,
    'registrationFieldAiRecommendation' => l10n.registrationFieldAiRecommendation,
    'registrationFieldAiSummary' => l10n.registrationFieldAiSummary,
    'registrationFieldMissingInformation' => l10n.registrationFieldMissingInformation,
    'registrationFieldDuplicateWarnings' => l10n.registrationFieldDuplicateWarnings,
    'registrationFieldRiskFlags' => l10n.registrationFieldRiskFlags,
    'registrationNoneReported' => l10n.registrationNoneReported,
    'registrationDocumentsMetadataOnly' => l10n.registrationDocumentsMetadataOnly,
    'registrationDocumentsEmpty' => l10n.registrationDocumentsEmpty,
    'registrationActionApprove' => l10n.registrationActionApprove,
    'registrationActionReject' => l10n.registrationActionReject,
    'registrationActionRequestInfo' => l10n.registrationActionRequestInfo,
    'registrationDecisionApproveTitle' => l10n.registrationDecisionApproveTitle,
    'registrationDecisionRejectTitle' => l10n.registrationDecisionRejectTitle,
    'registrationDecisionRequestInfoTitle' => l10n.registrationDecisionRequestInfoTitle,
    'registrationDecisionApproveBody' => l10n.registrationDecisionApproveBody,
    'registrationDecisionAuditNotice' => l10n.registrationDecisionAuditNotice,
    'registrationDecisionNotesLabel' => l10n.registrationDecisionNotesLabel,
    'registrationDecisionNotesRequired' => l10n.registrationDecisionNotesRequired,
    'registrationDecisionCancel' => l10n.registrationDecisionCancel,
    'registrationDecisionApproveConfirm' => l10n.registrationDecisionApproveConfirm,
    'registrationDecisionRejectConfirm' => l10n.registrationDecisionRejectConfirm,
    'registrationDecisionRequestInfoConfirm' =>
      l10n.registrationDecisionRequestInfoConfirm,
    'registrationDecisionSuccess' => l10n.registrationDecisionSuccess,
    'registrationDecisionError' => l10n.registrationDecisionError,
    _ => l10n.errorGenericBody,
  };
}

String roleLabel(BuildContext context, String roleKey) =>
    resolveLocalizationKey(context, roleKey);
