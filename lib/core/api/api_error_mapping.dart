import 'package:dio/dio.dart';

import '../localization/localization_keys.dart';
import 'api_exception.dart';
import 'api_request_path.dart';

String apiExceptionMessageKeyForStatus({
  required int? statusCode,
  required String path,
  Object? responseData,
}) {
  final errorCode = readApiErrorCode(responseData);
  if (errorCode == 'APPLICATION_DETAILED_INTAKE_REQUIRED' ||
      errorCode == 'application.detailedIntakeRequired') {
    return LocalizationKeys.applicationDetailedIntakeRequired;
  }
  if (errorCode == 'EMAIL_PROVIDER_DISABLED' ||
      errorCode == 'provider_not_configured' ||
      errorCode == 'provider_disabled') {
    return isDriverApprovalRelatedPath(path)
        ? LocalizationKeys.driverApprovalEmailProviderDisabled
        : LocalizationKeys.emailProviderDisabled;
  }
  if (errorCode == 'EMAIL_RECIPIENT_NOT_ALLOWED' ||
      errorCode == 'blocked_by_staging_allowlist' ||
      errorCode == 'staging_allowlist_missing') {
    return LocalizationKeys.emailRecipientNotAllowed;
  }
  if (errorCode == 'EMAIL_SEND_FAILED') {
    return isDriverApprovalRelatedPath(path)
        ? LocalizationKeys.driverApprovalEmailSendFailed
        : LocalizationKeys.emailSendFailed;
  }
  if (errorCode == 'already_registered' ||
      errorCode == 'EMAIL_ALREADY_HAS_ACTIVE_ACCOUNT') {
    return LocalizationKeys.driverApprovalAlreadyRegistered;
  }
  if (errorCode == 'ACCOUNT_ACTIVATION_REQUIRED' ||
      errorCode == 'ACCOUNT_PENDING_ACTIVATION') {
    return LocalizationKeys.driverApprovalConflict;
  }
  if (errorCode == 'MEMBERSHIP_ALREADY_EXISTS') {
    return LocalizationKeys.driverApprovalConflict;
  }
  if (errorCode == 'invalid_company_id' ||
      errorCode == 'invalid_registration_status') {
    return LocalizationKeys.driverApprovalInvalidRequest;
  }
  if (errorCode == 'invalid_current_password') {
    return LocalizationKeys.authPasswordChangeInvalidCurrent;
  }
  if (errorCode == 'weak_password') {
    return LocalizationKeys.authPasswordChangeWeakPassword;
  }
  if (errorCode == 'password_unchanged') {
    return LocalizationKeys.authPasswordChangeUnchanged;
  }
  if (errorCode == 'REFRESH_TOKEN_INVALID') {
    return LocalizationKeys.authSessionExpired;
  }
  if (errorCode == 'SESSION_EXPIRED') {
    return LocalizationKeys.authSessionExpired;
  }
  if (errorCode == 'SESSION_REVOKED') {
    return LocalizationKeys.authSessionRevoked;
  }
  if (errorCode == 'USER_DISABLED') {
    return LocalizationKeys.authForbiddenRole;
  }

  if (isInvalidCredentialsStatus(statusCode, path)) {
    return LocalizationKeys.authInvalidCredentials;
  }

  final backendMessage = readApiMessage(responseData)?.toLowerCase() ?? '';
  final isAmendmentPath = isCompanyAmendmentRequestPath(path);
  final isDriverApprovalPath = isDriverApprovalRelatedPath(path);
  final looksLikeMissingRelation =
      backendMessage.contains('does not exist') ||
      (backendMessage.contains('relation') &&
          backendMessage.contains('company_data_amendments')) ||
      errorCode == 'COMPANY_DATA_AMENDMENT_TABLE_MISSING' ||
      errorCode == '42P01';

  if (isAmendmentPath && looksLikeMissingRelation) {
    return LocalizationKeys.platformCompanyAmendErrorMigrationMissing;
  }

  if (backendMessage.contains('already exists with this email') ||
      backendMessage.contains('account already exists')) {
    return LocalizationKeys.driverApprovalAlreadyRegistered;
  }

  if (statusCode == 401) {
    return LocalizationKeys.authSessionExpired;
  }
  if (statusCode == 403) {
    if (isDriverApprovalPath) {
      return LocalizationKeys.driverApprovalForbidden;
    }
    return isAmendmentPath
        ? LocalizationKeys.platformCompanyAmendErrorForbidden
        : LocalizationKeys.authForbiddenRole;
  }
  if (statusCode == 404 && isAuthLoginRequestPath(path)) {
    return LocalizationKeys.authLoginServiceUnavailable;
  }
  if (statusCode == 404) {
    if (isDriverApprovalPath) {
      return LocalizationKeys.driverApprovalNotFound;
    }
    return isAmendmentPath
        ? LocalizationKeys.platformCompanyAmendErrorNotFound
        : LocalizationKeys.errorActionUnavailable;
  }
  if (statusCode == 400) {
    if (isDriverApprovalPath) {
      return LocalizationKeys.driverApprovalInvalidRequest;
    }
    if (isAmendmentPath) {
      return LocalizationKeys.platformCompanyAmendErrorValidation;
    }
  }
  if (statusCode == 422) {
    return LocalizationKeys.driverApprovalMissingFields;
  }
  if (statusCode == 409) {
    if (isDriverApprovalPath) {
      return LocalizationKeys.driverApprovalConflict;
    }
    if (isAmendmentPath) {
      return LocalizationKeys.platformCompanyAmendErrorConflict;
    }
  }
  if ((statusCode == 500 ||
          statusCode == 502 ||
          statusCode == 503 ||
          statusCode == 504) &&
      isAmendmentPath) {
    return LocalizationKeys.platformCompanyAmendErrorServer;
  }
  if ((statusCode == 500 ||
          statusCode == 502 ||
          statusCode == 503 ||
          statusCode == 504) &&
      isDriverApprovalPath) {
    return LocalizationKeys.driverApprovalServerError;
  }
  return LocalizationKeys.errorGenericBody;
}

ApiException mapHttpStatusException({
  required int? statusCode,
  required String path,
  required DioException error,
}) {
  final responseData = error.response?.data;
  final messageKey = apiExceptionMessageKeyForStatus(
    statusCode: statusCode,
    path: path,
    responseData: responseData,
  );
  final errorCode = readApiErrorCode(responseData);
  final requestId = readApiRequestId(responseData);
  final backendMessage = readApiMessage(responseData);
  final messageKeyFromApi = readApiMessageKey(responseData);

  ApiException build(ApiExceptionKind kind, {String? overrideMessageKey}) {
    return ApiException(
      messageKey: overrideMessageKey ?? messageKey,
      kind: kind,
      statusCode: statusCode,
      errorCode: errorCode,
      requestId: requestId,
      backendMessage: backendMessage,
      messageKeyFromApi: messageKeyFromApi,
      endpoint: path,
      cause: error,
    );
  }

  final isAmendmentPath = isCompanyAmendmentRequestPath(path);
  final intakeRequired =
      messageKey == LocalizationKeys.applicationDetailedIntakeRequired ||
      errorCode == 'APPLICATION_DETAILED_INTAKE_REQUIRED';
  final hasSpecificMessage = messageKey != LocalizationKeys.errorGenericBody;

  return switch (statusCode) {
    400 => build(ApiExceptionKind.validation),
    401 => build(ApiExceptionKind.unauthorized),
    403 => build(ApiExceptionKind.forbidden),
    404 => build(ApiExceptionKind.notFound),
    409 => build(
      ApiExceptionKind.conflict,
      overrideMessageKey: intakeRequired
          ? LocalizationKeys.applicationDetailedIntakeRequired
          : hasSpecificMessage
          ? messageKey
          : isAmendmentPath
          ? LocalizationKeys.platformCompanyAmendErrorConflict
          : LocalizationKeys.errorGenericBody,
    ),
    422 => build(ApiExceptionKind.validation),
    500 || 502 || 503 || 504 => build(
      ApiExceptionKind.server,
      overrideMessageKey: hasSpecificMessage
          ? messageKey
          : isAmendmentPath
          ? LocalizationKeys.platformCompanyAmendErrorServer
          : LocalizationKeys.authServerError,
    ),
    _ => build(ApiExceptionKind.unknown),
  };
}

bool isTransportLevelDioException(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.badCertificate:
      return true;
    case DioExceptionType.connectionError:
      return error.response == null;
    case DioExceptionType.unknown:
      return error.response == null && error.error != null;
    case DioExceptionType.cancel:
    case DioExceptionType.badResponse:
      return false;
  }
}
