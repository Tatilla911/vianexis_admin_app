import 'package:flutter/foundation.dart';

import '../../../core/api/api_exception.dart';

/// Safe (secret-free) diagnostics for activation-invite send/resend actions.
void logActivationInviteAction({
  required String action,
  required String method,
  required String endpoint,
  String? applicationId,
  String? companyId,
  String? inviteId,
  int? httpStatus,
  String? apiErrorCode,
  String? backendMessage,
  String? requestId,
  String? deliveryStatus,
  bool? usedMockRepository,
}) {
  debugPrint(
    [
      'action=$action',
      'method=$method',
      'endpoint=$endpoint',
      if (applicationId != null) 'applicationId=$applicationId',
      if (companyId != null) 'companyId=$companyId',
      if (inviteId != null) 'inviteId=$inviteId',
      if (httpStatus != null) 'httpStatus=$httpStatus',
      if (apiErrorCode != null) 'apiErrorCode=$apiErrorCode',
      if (backendMessage != null && backendMessage.isNotEmpty)
        'backendMessage=$backendMessage',
      if (requestId != null) 'requestId=$requestId',
      if (deliveryStatus != null) 'deliveryStatus=$deliveryStatus',
      if (usedMockRepository != null) 'usedMock=$usedMockRepository',
    ].join(' '),
  );
}

void logActivationInviteApiException({
  required String action,
  required String method,
  required String endpoint,
  required ApiException error,
  String? applicationId,
  String? companyId,
  String? inviteId,
}) {
  logActivationInviteAction(
    action: action,
    method: method,
    endpoint: endpoint,
    applicationId: applicationId,
    companyId: companyId,
    inviteId: inviteId,
    httpStatus: error.statusCode,
    apiErrorCode: error.errorCode,
    backendMessage: error.backendMessage,
    requestId: error.requestId,
  );
}
