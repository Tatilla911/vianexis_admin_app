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

ApiException mapHttpStatusException({
  required int? statusCode,
  required String path,
  required DioException error,
}) {
  final messageKey = apiExceptionMessageKeyForStatus(
    statusCode: statusCode,
    path: path,
    responseData: error.response?.data,
  );

  return switch (statusCode) {
    400 => ApiException(
      messageKey: messageKey,
      kind: ApiExceptionKind.validation,
      statusCode: statusCode,
      errorCode: readApiErrorCode(error.response?.data),
      cause: error,
    ),
    401 => ApiException(
      messageKey: messageKey,
      kind: ApiExceptionKind.unauthorized,
      statusCode: statusCode,
      errorCode: readApiErrorCode(error.response?.data),
      cause: error,
    ),
    403 => ApiException(
      messageKey: messageKey,
      kind: ApiExceptionKind.forbidden,
      statusCode: statusCode,
      errorCode: readApiErrorCode(error.response?.data),
      cause: error,
    ),
    404 => ApiException(
      messageKey: messageKey,
      kind: ApiExceptionKind.notFound,
      statusCode: statusCode,
      errorCode: readApiErrorCode(error.response?.data),
      cause: error,
    ),
    409 => ApiException(
      messageKey: LocalizationKeys.errorGenericBody,
      kind: ApiExceptionKind.conflict,
      statusCode: statusCode,
      errorCode: readApiErrorCode(error.response?.data),
      cause: error,
    ),
    500 || 502 || 503 || 504 => ApiException(
      messageKey: LocalizationKeys.authServerError,
      kind: ApiExceptionKind.server,
      statusCode: statusCode,
      errorCode: readApiErrorCode(error.response?.data),
      cause: error,
    ),
    _ => ApiException(
      messageKey: messageKey,
      kind: ApiExceptionKind.unknown,
      statusCode: statusCode,
      errorCode: readApiErrorCode(error.response?.data),
      cause: error,
    ),
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
