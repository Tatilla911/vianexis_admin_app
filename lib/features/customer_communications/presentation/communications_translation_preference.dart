import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/locale/app_locale_provider.dart';

/// Target language for inbound customer-communication auto-translation.
///
/// Defaults to Hungarian. Switches to English only when the admin language
/// setting is explicitly set to English (or the resolved UI locale is `en`).
String resolveCommunicationsTranslationTarget({
  required Locale? savedLocale,
  required Locale uiLocale,
}) {
  final code =
      savedLocale?.languageCode ?? uiLocale.languageCode.toLowerCase();
  return code == 'en' ? 'en' : 'hu';
}

/// Watches [appLocaleProvider] and the ambient UI locale.
String communicationsTranslationTargetOf(WidgetRef ref, BuildContext context) {
  return resolveCommunicationsTranslationTarget(
    savedLocale: ref.watch(appLocaleProvider),
    uiLocale: Localizations.localeOf(context),
  );
}

/// Admin draft language for replies — same rule as inbound target.
String communicationsAdminDraftLanguageOf(WidgetRef ref, BuildContext context) {
  return communicationsTranslationTargetOf(ref, context);
}
