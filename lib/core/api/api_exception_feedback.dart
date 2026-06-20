import 'package:flutter/material.dart';

import '../api/api_error_resolver.dart';
import '../api/api_exception.dart';

void showApiExceptionSnackBar(BuildContext context, ApiException error) {
  final presentation = resolveApiException(context, error);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(presentation.message)),
  );
}

String apiExceptionMessage(BuildContext context, ApiException error) {
  return resolveApiException(context, error).message;
}
