import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../localization/localization_keys.dart';

String resolveLocalizationKey(BuildContext context, String key) {
  final l10n = AppLocalizations.of(context);
  return switch (key) {
    LocalizationKeys.loginBackendNotConfigured => l10n.loginBackendNotConfigured,
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
