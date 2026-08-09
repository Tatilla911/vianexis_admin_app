import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../api/api_exception.dart';

/// Staging/dev-safe snackbar for platform-admin ops failures.
///
/// Normal Admin UI shows a localized explanation only.
/// Never surfaces raw Nest text such as "Cannot POST", HTTP status,
/// `resource_not_found`, or requestId — those stay in debug logs.
void showAdminOpsFailureSnackBar(
  BuildContext context,
  Object error, {
  required String Function(BuildContext, String) resolveKey,
  required String fallbackKey,
  required String endpointMissingKey,
  String? permissionDeniedKey,
  String? actionLabel,
}) {
  if (error is! ApiException) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(resolveKey(context, fallbackKey))),
    );
    return;
  }

  final backendMessage = (error.backendMessage ?? '').toLowerCase();
  final isNestRouteMissing =
      error.statusCode == 404 && backendMessage.contains('cannot ');
  final isMissingRoute =
      isNestRouteMissing ||
      error.statusCode == 501 ||
      (error.kind == ApiExceptionKind.notFound &&
          error.errorCode == 'resource_not_found' &&
          backendMessage.contains('cannot '));
  final isForbidden =
      error.statusCode == 403 || error.kind == ApiExceptionKind.forbidden;

  final String message;
  if (isMissingRoute) {
    message = resolveKey(context, endpointMissingKey);
  } else if (isForbidden &&
      permissionDeniedKey != null &&
      permissionDeniedKey.isNotEmpty) {
    message = resolveKey(context, permissionDeniedKey);
  } else {
    message = resolveKey(context, fallbackKey);
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 6),
    ),
  );
  if (kDebugMode) {
    debugPrint(
      '[AdminOps] action=${actionLabel ?? '-'} '
      'endpoint=${error.endpoint} '
      'status=${error.statusCode} '
      'code=${error.errorCode} '
      'backendMessage=${error.backendMessage} '
      'requestId=${error.requestId}',
    );
  }
}
