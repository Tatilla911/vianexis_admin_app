import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

/// Maps invite / password-setup API delivery fields to an honest user message.
///
/// Backend may return HTTP 200 after creating a token while skipping real email
/// (`emailSent: false`, `deliveryStatus: provider_disabled`, etc.).
String emailDeliveryUserMessage(
  BuildContext context,
  Map<String, dynamic> result, {
  required String successFallback,
}) {
  final l10n = AppLocalizations.of(context);
  final delivery =
      (result['deliveryStatus'] ??
              result['emailDeliveryStatus'] ??
              result['emailInviteDeliveryStatus'])
          ?.toString()
          .trim()
          .toLowerCase();
  final emailSent =
      result['emailSent'] == true ||
      result['emailInviteSent'] == true ||
      result['emailAccepted'] == true;

  if (emailSent ||
      delivery == 'sent' ||
      delivery == 'accepted_by_provider') {
    return successFallback;
  }

  if (delivery == 'queued') {
    return l10n.registrationInviteDeliveryPending;
  }

  return switch (delivery) {
    'provider_disabled' || 'skipped' =>
      l10n.registrationInviteDeliveryProviderDisabled,
    'provider_not_configured' || 'console' =>
      l10n.registrationInviteDeliveryProviderNotConfigured,
    'blocked_by_staging_allowlist' || 'staging_allowlist_missing' =>
      l10n.registrationInviteDeliveryAllowlistBlocked,
    'failed' || 'pending_or_failed' =>
      l10n.registrationInviteDeliveryFailed,
    _ when result.containsKey('emailSent') ||
            result.containsKey('emailInviteSent') ||
            delivery != null =>
      l10n.registrationInviteDeliveryFailed,
    _ => l10n.registrationInviteDeliveryFailed,
  };
}

bool emailDeliverySucceeded(Map<String, dynamic> result) {
  final delivery =
      (result['deliveryStatus'] ??
              result['emailDeliveryStatus'] ??
              result['emailInviteDeliveryStatus'])
          ?.toString()
          .trim()
          .toLowerCase();
  return result['emailSent'] == true ||
      result['emailInviteSent'] == true ||
      result['emailAccepted'] == true ||
      delivery == 'sent' ||
      delivery == 'accepted_by_provider';
}
