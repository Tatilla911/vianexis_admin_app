import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';

class AuditMetadataCard extends StatelessWidget {
  const AuditMetadataCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.shield_outlined, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(resolveAuditLogKey(context, 'auditLogPrivacyNotice')),
            ),
          ],
        ),
      ),
    );
  }
}
