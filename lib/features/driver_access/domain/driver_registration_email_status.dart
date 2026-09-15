import 'package:flutter/material.dart';

/// Localized driver-registration decision email status.
/// Kept independent of generated ARB so canonical l10n WIP stays unstaged.
String resolveDriverRegistrationEmailStatus(
  BuildContext context,
  String? status,
) {
  final normalized = status?.trim().toLowerCase();
  if (normalized == null || normalized.isEmpty) {
    return '';
  }
  final hu = Localizations.localeOf(context).languageCode == 'hu';
  return switch (normalized) {
    'queued' || 'pending' => hu ? 'E-mail sorban' : 'Email queued',
    'sent' || 'skipped' || 'already_notified' =>
      hu ? 'E-mail elküldve' : 'Email sent',
    'failed' => hu ? 'E-mail kézbesítés sikertelen' : 'Email delivery failed',
    _ => hu ? 'E-mail állapot nem elérhető' : 'Email status unavailable',
  };
}

String driverRegistrationNotificationEmailLabel(BuildContext context) {
  final hu = Localizations.localeOf(context).languageCode == 'hu';
  return hu ? 'E-mail értesítés' : 'Email notification';
}
