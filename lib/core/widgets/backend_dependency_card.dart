import 'package:flutter/material.dart';

/// Shows that a feature depends on a backend endpoint not yet wired.
class BackendDependencyCard extends StatelessWidget {
  const BackendDependencyCard({
    super.key,
    required this.title,
    required this.message,
    this.endpointHint,
  });

  final String title;
  final String message;
  final String? endpointHint;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    message,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (endpointHint != null && endpointHint!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      endpointHint!,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontFamily: 'monospace',
                          ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
