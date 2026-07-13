import 'package:flutter/material.dart';

import 'package:vianexis_admin_app/l10n/app_localizations.dart';

String resolveSessionDeviceLabel(
  AppLocalizations l10n, {
  String? deviceName,
  String? platform,
  String? appType,
}) {
  if (deviceName != null && deviceName.trim().isNotEmpty) {
    return deviceName.trim();
  }
  if ((platform == null || platform.trim().isEmpty) &&
      (appType == null || appType.trim().isEmpty)) {
    return l10n.authLegacySession;
  }
  if (platform != null && platform.trim().isNotEmpty) {
    return platform.trim();
  }
  return l10n.authUnknownDevice;
}

String resolveSessionPlatformLabel(AppLocalizations l10n, String? platform) {
  if (platform == null || platform.trim().isEmpty) {
    return l10n.authUnknownDevice;
  }
  return switch (platform.trim().toLowerCase()) {
    'android' => 'Android',
    'ios' => 'iOS',
    'desktop' => 'Desktop',
    'web' => 'Web',
    'unknown' => l10n.authUnknownDevice,
    _ => platform.trim(),
  };
}

String formatSessionTimestamp(BuildContext context, DateTime? value) {
  if (value == null) return '—';
  final local = value.toLocal();
  final materialLocalizations = MaterialLocalizations.of(context);
  final date = materialLocalizations.formatMediumDate(local);
  final time = materialLocalizations.formatTimeOfDay(
    TimeOfDay.fromDateTime(local),
  );
  return '$date $time';
}
