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

String roleLabel(BuildContext context, String roleKey) =>
    resolveLocalizationKey(context, roleKey);
