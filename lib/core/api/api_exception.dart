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
    this.requestId,
    this.backendMessage,
    this.messageKeyFromApi,
    this.endpoint,
    this.cause,
  });

  final String messageKey;
  final ApiExceptionKind kind;
  final int? statusCode;
  final String? errorCode;
  final String? requestId;
  final String? backendMessage;
  final String? messageKeyFromApi;
  final String? endpoint;
  final Object? cause;

  @override
  String toString() =>
      'ApiException(kind: $kind, messageKey: $messageKey, '
      'statusCode: $statusCode, errorCode: $errorCode, '
      'requestId: $requestId, endpoint: $endpoint)';
}
