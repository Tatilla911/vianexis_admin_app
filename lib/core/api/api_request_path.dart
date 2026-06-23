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

bool isAuthLoginRequestPath(String path) {
  final normalized = resolveApiRequestPath(
    RequestOptions(path: path),
  ).trim().toLowerCase();
  return normalized.endsWith('/auth/login') || normalized == '/auth/login';
}

bool isAuthPasswordChangeRequestPath(String path) {
  final normalized = resolveApiRequestPath(
    RequestOptions(path: path),
  ).trim().toLowerCase();
  return normalized.endsWith('/auth/me/password') ||
      normalized == '/auth/me/password';
}

String? readApiErrorCode(Object? responseData) {
  if (responseData is Map) {
    final code = responseData['code'];
    if (code is String && code.trim().isNotEmpty) {
      return code.trim();
    }
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
  if ((statusCode == 400 || statusCode == 401) && isAuthLoginRequestPath(path)) {
    return true;
  }
  return false;
}
