import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../api/api_error_resolver.dart';
import '../api/api_exception.dart';

void showApiExceptionSnackBar(BuildContext context, ApiException error) {
  final presentation = resolveApiException(context, error);
  final requestId = error.requestId?.trim();
  final message = (requestId != null && requestId.isNotEmpty)
      ? '${presentation.message} (requestId: $requestId)'
      : presentation.message;
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

String apiExceptionMessage(BuildContext context, ApiException error) {
  final message = resolveApiException(context, error).message;
  final requestId = error.requestId?.trim();
  if (requestId != null && requestId.isNotEmpty) {
    return '$message (requestId: $requestId)';
  }
  return message;
}

/// Safe diagnostics for approval failures — never logs tokens or PII payloads.
void logApiExceptionDiagnostics(ApiException error, {String? applicationId}) {
  if (!kDebugMode) return;
  debugPrint(
    '[ApiException] endpoint=${error.endpoint} '
    'status=${error.statusCode} '
    'code=${error.errorCode} '
    'message=${error.backendMessage} '
    'requestId=${error.requestId} '
    'applicationId=$applicationId '
    'messageKey=${error.messageKey}',
  );
}
