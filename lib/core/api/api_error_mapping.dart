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

  return switch (statusCode) {
    400 => build(ApiExceptionKind.validation),
    401 => build(ApiExceptionKind.unauthorized),
    403 => build(ApiExceptionKind.forbidden),
    404 => build(ApiExceptionKind.notFound),
    409 => build(
      ApiExceptionKind.conflict,
      overrideMessageKey: LocalizationKeys.errorGenericBody,
    ),
    500 || 502 || 503 || 504 => build(
      ApiExceptionKind.server,
      overrideMessageKey: LocalizationKeys.authServerError,
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
