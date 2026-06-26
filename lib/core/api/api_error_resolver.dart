import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../localization/localization_keys.dart';
import '../localization/localization_resolver.dart';
import 'api_exception.dart';
import 'api_request_path.dart';

class ApiErrorPresentation {
  const ApiErrorPresentation({
    required this.title,
    required this.message,
    this.showRetry = false,
    this.icon = Icons.error_outline,
  });

  final String title;
  final String message;
  final bool showRetry;
  final IconData icon;
}

ApiErrorPresentation resolveApiException(
  BuildContext context,
  ApiException error,
) {
  final l10n = AppLocalizations.of(context);
  final message = resolveLocalizationKey(context, error.messageKey);

  return switch (error.kind) {
    ApiExceptionKind.notConfigured => ApiErrorPresentation(
      title: l10n.errorBackendNotConfiguredTitle,
      message: message,
      icon: Icons.cloud_off_outlined,
    ),
    ApiExceptionKind.unauthorized => ApiErrorPresentation(
      title: l10n.errorSessionExpiredTitle,
      message: message,
      icon: Icons.lock_clock_outlined,
    ),
    ApiExceptionKind.forbidden => ApiErrorPresentation(
      title: l10n.errorPermissionDeniedTitle,
      message: message,
      icon: Icons.block_outlined,
    ),
    ApiExceptionKind.notFound => ApiErrorPresentation(
      title: l10n.errorActionUnavailableTitle,
      message: l10n.errorActionUnavailableBody,
      icon: Icons.search_off_outlined,
    ),
    ApiExceptionKind.network || ApiExceptionKind.timeout => ApiErrorPresentation(
      title: l10n.errorNetworkTitle,
      message: message,
      showRetry: true,
      icon: Icons.wifi_off_outlined,
    ),
    ApiExceptionKind.server => ApiErrorPresentation(
      title: l10n.errorGenericTitle,
      message: message,
      showRetry: true,
      icon: Icons.cloud_off_outlined,
    ),
    ApiExceptionKind.validation ||
    ApiExceptionKind.conflict ||
    ApiExceptionKind.unknown => ApiErrorPresentation(
      title: l10n.errorGenericTitle,
      message: message,
    ),
  };
}

String apiExceptionMessageKeyForStatus({
  required int? statusCode,
  required String path,
  Object? responseData,
}) {
  if (isInvalidCredentialsStatus(statusCode, path)) {
    return LocalizationKeys.authInvalidCredentials;
  }
  if (statusCode == 401) {
    return LocalizationKeys.authSessionExpired;
  }
  if (statusCode == 403) {
    return LocalizationKeys.authForbiddenRole;
  }
  if (statusCode == 404 && isAuthLoginRequestPath(path)) {
    return LocalizationKeys.authLoginServiceUnavailable;
  }
  if (statusCode == 404) {
    return LocalizationKeys.errorActionUnavailable;
  }
  return LocalizationKeys.errorGenericBody;
}
