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

  if (isInvalidCredentialsStatus(statusCode, path)) {
    return LocalizationKeys.authInvalidCredentials;
  }

  if (statusCode == 401) {
    return LocalizationKeys.authSessionExpired;
  }
  if (statusCode == 403) {
    return LocalizationKeys.authForbiddenRole;
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
      cause: error,
    ),
    401 => ApiException(
      messageKey: messageKey,
      kind: ApiExceptionKind.unauthorized,
      statusCode: statusCode,
      cause: error,
    ),
    403 => ApiException(
      messageKey: messageKey,
      kind: ApiExceptionKind.forbidden,
      statusCode: statusCode,
      cause: error,
    ),
    404 => ApiException(
      messageKey: messageKey,
      kind: ApiExceptionKind.notFound,
      statusCode: statusCode,
      cause: error,
    ),
    409 => ApiException(
      messageKey: LocalizationKeys.errorGenericBody,
      kind: ApiExceptionKind.conflict,
      statusCode: statusCode,
      cause: error,
    ),
    500 || 502 || 503 || 504 => ApiException(
      messageKey: LocalizationKeys.authServerError,
      kind: ApiExceptionKind.server,
      statusCode: statusCode,
      cause: error,
    ),
    _ => ApiException(
      messageKey: messageKey,
      kind: ApiExceptionKind.unknown,
      statusCode: statusCode,
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
