enum ApiExceptionKind {
  notConfigured,
  network,
  unauthorized,
  forbidden,
  validation,
  server,
  unknown,
}

class ApiException implements Exception {
  const ApiException({
    required this.messageKey,
    this.kind = ApiExceptionKind.unknown,
    this.statusCode,
    this.cause,
  });

  final String messageKey;
  final ApiExceptionKind kind;
  final int? statusCode;
  final Object? cause;

  @override
  String toString() =>
      'ApiException(kind: $kind, messageKey: $messageKey, statusCode: $statusCode)';
}
