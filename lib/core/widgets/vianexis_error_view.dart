import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../api/api_error_resolver.dart';
import '../api/api_exception.dart';

class VianexisErrorView extends StatelessWidget {
  const VianexisErrorView({
    super.key,
    this.title,
    this.message,
    this.onRetry,
    this.icon,
    this.showRetry,
    ApiException? apiException,
  }) : _apiException = apiException;

  factory VianexisErrorView.fromApiException(
    BuildContext context,
    ApiException error, {
    Key? key,
    VoidCallback? onRetry,
    String? overrideMessage,
  }) {
    return VianexisErrorView(
      key: key,
      apiException: error,
      message: overrideMessage,
      onRetry: onRetry,
    );
  }

  factory VianexisErrorView.fromError(
    BuildContext context,
    Object error, {
    Key? key,
    required String fallbackMessage,
    VoidCallback? onRetry,
  }) {
    if (error is ApiException) {
      return VianexisErrorView.fromApiException(
        context,
        error,
        key: key,
        onRetry: onRetry,
      );
    }
    return VianexisErrorView(
      key: key,
      message: fallbackMessage,
      onRetry: onRetry,
    );
  }

  final String? title;
  final String? message;
  final VoidCallback? onRetry;
  final IconData? icon;
  final bool? showRetry;
  final ApiException? _apiException;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final presentation = _apiException == null
        ? null
        : resolveApiException(context, _apiException);
    final resolvedTitle = title ?? presentation?.title ?? l10n.errorGenericTitle;
    final resolvedMessage =
        message ?? presentation?.message ?? l10n.errorGenericBody;
    final resolvedIcon = icon ?? presentation?.icon ?? Icons.error_outline;
    final resolvedShowRetry =
        showRetry ?? presentation?.showRetry ?? onRetry != null;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              resolvedIcon,
              size: 40,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              resolvedTitle,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              resolvedMessage,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (resolvedShowRetry && onRetry != null) ...[
              const SizedBox(height: 20),
              FilledButton(
                onPressed: onRetry,
                child: Text(l10n.errorRetryButton),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
