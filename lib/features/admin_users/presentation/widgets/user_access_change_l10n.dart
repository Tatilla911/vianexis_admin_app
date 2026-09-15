import 'package:flutter/material.dart';

/// Localized user-access change dialog strings that are not yet in canonical ARB.
String userAccessChangeNoChangesSelected(BuildContext context) {
  final hu = Localizations.localeOf(context).languageCode == 'hu';
  return hu ? 'Nincs kiválasztott módosítás.' : 'No changes selected.';
}

String userAccessChangeRequiredFields(BuildContext context) {
  final hu = Localizations.localeOf(context).languageCode == 'hu';
  return hu
      ? 'Az indok, a kérelmező és a jóváhagyó megadása kötelező.'
      : 'Reason, requested by and authorized by are required.';
}
