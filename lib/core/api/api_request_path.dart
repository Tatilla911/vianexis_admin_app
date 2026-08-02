import 'package:dio/dio.dart';

/// Normalizes Dio request paths so login/auth routes are recognized with or without base URL.
String resolveApiRequestPath(RequestOptions options) {
  final rawPath = options.path.trim();
  if (rawPath.isNotEmpty) {
    if (rawPath.startsWith('http://') || rawPath.startsWith('https://')) {
      return Uri.parse(rawPath).path;
    }
    if (rawPath.startsWith('/')) {
      return rawPath;
    }
  }

  final uriPath = options.uri.path.trim();
  if (uriPath.isNotEmpty) {
    return uriPath.startsWith('/') ? uriPath : '/$uriPath';
  }

  if (rawPath.isNotEmpty) {
    return rawPath.startsWith('/') ? rawPath : '/$rawPath';
  }

  return '';
}

bool isCompanyAmendmentRequestPath(String path) {
  final normalized = resolveApiRequestPath(
    RequestOptions(path: path),
  ).trim().toLowerCase();
  return normalized.contains('/amendments') ||
      normalized.contains('/amendment-fields');
}

bool isAuthLoginRequestPath(String path) {
  final normalized = resolveApiRequestPath(
    RequestOptions(path: path),
  ).trim().toLowerCase();
  return normalized.endsWith('/auth/login') || normalized == '/auth/login';
}

bool isAuthRefreshRequestPath(String path) {
  final normalized = resolveApiRequestPath(
    RequestOptions(path: path),
  ).trim().toLowerCase();
  return normalized.endsWith('/auth/refresh') || normalized == '/auth/refresh';
}

bool isAuthExemptFromRefreshRetry(String path) {
  return isAuthLoginRequestPath(path) || isAuthRefreshRequestPath(path);
}

bool isAuthPasswordChangeRequestPath(String path) {
  final normalized = resolveApiRequestPath(
    RequestOptions(path: path),
  ).trim().toLowerCase();
  return normalized.endsWith('/auth/me/password') ||
      normalized == '/auth/me/password';
}

String? _readNonEmptyString(Object? value) {
  if (value is String && value.trim().isNotEmpty) {
    return value.trim();
  }
  return null;
}

/// Prefer backend `errorCode`, then legacy `code`.
String? readApiErrorCode(Object? responseData) {
  if (responseData is Map) {
    return _readNonEmptyString(responseData['errorCode']) ??
        _readNonEmptyString(responseData['code']);
  }
  return null;
}

String? readApiRequestId(Object? responseData) {
  if (responseData is Map) {
    return _readNonEmptyString(responseData['requestId']);
  }
  return null;
}

String? readApiMessageKey(Object? responseData) {
  if (responseData is Map) {
    return _readNonEmptyString(responseData['messageKey']);
  }
  return null;
}

String? readApiMessage(Object? responseData) {
  if (responseData is Map) {
    return _readNonEmptyString(responseData['message']);
  }
  return null;
}

bool isInvalidCredentialsStatus(int? statusCode, String path) {
  if (statusCode == null) {
    return false;
  }
  if (statusCode == 401 && isAuthLoginRequestPath(path)) {
    return true;
  }
  if ((statusCode == 400 || statusCode == 401) &&
      isAuthLoginRequestPath(path)) {
    return true;
  }
  return false;
}
