import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import 'admin_notification.dart';
import 'notification_type.dart';

/// Presentation helpers for inbox cards — does not change API fields.
abstract final class AdminNotificationPresentation {
  static const titleMaxLines = 2;
  static const bodyPreviewMaxLines = 3;

  static String displayTitle(BuildContext context, AdminNotification item) {
    final l10n = AppLocalizations.of(context);
    final isHu = Localizations.localeOf(context).languageCode == 'hu';
    final candidates = isHu
        ? [item.metadata['titleHu'], item.metadata['titleEn'], item.title]
        : [item.metadata['titleEn'], item.metadata['titleHu'], item.title];
    for (final candidate in candidates) {
      if (!isUnusableNotificationText(candidate)) {
        return candidate!.trim();
      }
    }
    final fromKey = titleFromKey(l10n, item.titleKey, item.type);
    if (fromKey != null) return fromKey;
    return fallbackTitleForType(l10n, item.type);
  }

  static String displayBody(BuildContext context, AdminNotification item) {
    final l10n = AppLocalizations.of(context);
    final isHu = Localizations.localeOf(context).languageCode == 'hu';
    final candidates = isHu
        ? [
            item.metadata['inAppBodyHu'],
            item.metadata['bodyHu'],
            item.metadata['inAppBodyEn'],
            item.metadata['bodyEn'],
            item.body,
          ]
        : [
            item.metadata['inAppBodyEn'],
            item.metadata['bodyEn'],
            item.metadata['inAppBodyHu'],
            item.metadata['bodyHu'],
            item.body,
          ];
    for (final candidate in candidates) {
      if (!isUnusableNotificationText(candidate)) {
        return _collapsePreviewWhitespace(candidate!.trim());
      }
    }
    final fromKey = bodyFromKey(l10n, item.messageKey, item.type);
    if (fromKey != null) return fromKey;
    return l10n.notificationsNoAdditionalContent;
  }

  static String formatTimestamp(
    BuildContext context,
    DateTime createdAt, {
    DateTime? now,
  }) {
    final l10n = AppLocalizations.of(context);
    return formatNotificationTimestamp(
      createdAt: createdAt,
      now: now ?? DateTime.now(),
      localeName: Localizations.localeOf(context).toString(),
      yesterdayLabel: l10n.notificationsYesterday,
    );
  }

  static String? titleFromKey(
    AppLocalizations l10n,
    String? titleKey,
    NotificationType type,
  ) {
    final key = titleKey?.trim() ?? '';
    if (key.contains('driverApplicationSubmitted')) {
      return l10n.notificationDriverRegistrationTitle;
    }
    if (key.contains('companyApplicationSubmitted')) {
      return l10n.notificationCompanyApplicationTitle;
    }
    if (key.contains('emergencyAlert') ||
        type == NotificationType.emergencyAlert) {
      return l10n.notificationEmergencyAlertTitle;
    }
    if (type.isRegistrationReview) {
      return type == NotificationType.companyApplicationSubmitted
          ? l10n.notificationCompanyApplicationTitle
          : l10n.notificationDriverRegistrationTitle;
    }
    return null;
  }

  static String? bodyFromKey(
    AppLocalizations l10n,
    String? messageKey,
    NotificationType type,
  ) {
    final key = messageKey?.trim() ?? '';
    if (key.contains('driverApplicationSubmitted')) {
      return l10n.notificationDriverRegistrationBody;
    }
    if (key.contains('companyApplicationSubmitted')) {
      return l10n.notificationCompanyApplicationBody;
    }
    if (key.contains('emergencyAlert') ||
        type == NotificationType.emergencyAlert) {
      return l10n.notificationEmergencyAlertBody;
    }
    if (type.isRegistrationReview) {
      return type == NotificationType.companyApplicationSubmitted
          ? l10n.notificationCompanyApplicationBody
          : l10n.notificationDriverRegistrationBody;
    }
    return null;
  }

  static String fallbackTitleForType(
    AppLocalizations l10n,
    NotificationType type,
  ) {
    return switch (type) {
      NotificationType.systemHealth => l10n.notificationsPrefSystemHealth,
      NotificationType.security => l10n.notificationsPrefSecurity,
      NotificationType.support => l10n.notificationsPrefSupport,
      NotificationType.billing => l10n.notificationsPrefBilling,
      NotificationType.release => l10n.notificationsPrefRelease,
      NotificationType.driverApplicationSubmitted =>
        l10n.notificationDriverRegistrationTitle,
      NotificationType.companyApplicationSubmitted =>
        l10n.notificationCompanyApplicationTitle,
      NotificationType.emergencyAlert => l10n.notificationEmergencyAlertTitle,
      NotificationType.general ||
      NotificationType.unknown => l10n.notificationsFallbackTitle,
    };
  }
}

/// Compact inbox timestamp from [createdAt] — today `HH:mm`, yesterday + time,
/// older `DateFormat.yMMMd`.
String formatNotificationTimestamp({
  required DateTime createdAt,
  required DateTime now,
  required String localeName,
  required String yesterdayLabel,
}) {
  final local = createdAt.toLocal();
  final today = DateTime(
    now.toLocal().year,
    now.toLocal().month,
    now.toLocal().day,
  );
  final day = DateTime(local.year, local.month, local.day);
  final time = DateFormat.Hm(localeName).format(local);
  if (day == today) {
    return time;
  }
  if (day == today.subtract(const Duration(days: 1))) {
    return '$yesterdayLabel $time';
  }
  return DateFormat.yMMMd(localeName).format(local);
}

bool isUnusableNotificationText(String? raw) {
  final value = raw?.trim() ?? '';
  if (value.isEmpty) return true;
  if (value.startsWith('platformAdmin.')) return true;
  if (value.startsWith('{') || value.startsWith('[')) return true;
  if (value.startsWith('/') && !value.contains(' ')) return true;
  if (RegExp(r'^[a-zA-Z0-9_.]+$').hasMatch(value) &&
      value.contains(RegExp(r'[._]'))) {
    return true;
  }
  return false;
}

String _collapsePreviewWhitespace(String value) {
  return value.replaceAll(RegExp(r'[ \t]+'), ' ').trim();
}
