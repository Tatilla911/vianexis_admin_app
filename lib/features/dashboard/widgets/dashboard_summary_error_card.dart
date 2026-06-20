import 'package:flutter/material.dart';

import '../../../core/api/api_error_resolver.dart';
import '../../../core/api/api_exception.dart';
import '../../../l10n/app_localizations.dart';

class DashboardSummaryErrorCard extends StatelessWidget {
  const DashboardSummaryErrorCard({
    super.key,
    required this.error,
    required this.fallbackMessage,
    required this.onRetry,
  });

  final Object error;
  final String fallbackMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final message = error is ApiException
        ? resolveApiException(context, error as ApiException).message
        : fallbackMessage;

    return Card(
      child: ListTile(
        title: Text(message),
        trailing: TextButton(
          onPressed: onRetry,
          child: Text(l10n.errorRetryButton),
        ),
      ),
    );
  }
}
