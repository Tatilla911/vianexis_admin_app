enum ApiExceptionKind {
  notConfigured,
  network,
  timeout,
  validation,
  unauthorized,
  forbidden,
  notFound,
  conflict,
  server,
  unknown,
}

class ApiException implements Exception {
  const ApiException({
    required this.messageKey,
    this.kind = ApiExceptionKind.unknown,
    this.statusCode,
    this.errorCode,
    this.cause,
  });

  final String messageKey;
  final ApiExceptionKind kind;
  final int? statusCode;
  final String? errorCode;
  final Object? cause;

  @override
  String toString() =>
      'ApiException(kind: $kind, messageKey: $messageKey, '
      'statusCode: $statusCode, errorCode: $errorCode)';
}
