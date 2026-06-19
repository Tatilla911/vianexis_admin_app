import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';

class SupportAccessWarningCard extends StatelessWidget {
  const SupportAccessWarningCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.35),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.warning_amber_outlined,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    resolveSupportKey(context, 'supportGrantWarningTitle'),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(resolveSupportKey(context, 'supportGrantWarningBody')),
                  const SizedBox(height: 4),
                  Text(
                    resolveSupportKey(context, 'supportGrantAuditNotice'),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
