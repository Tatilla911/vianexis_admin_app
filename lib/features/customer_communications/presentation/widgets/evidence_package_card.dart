import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/app_router.dart';
import '../../../../core/localization/localization_resolver.dart';
import '../../domain/customer_evidence_package.dart';

class EvidencePackageCard extends StatelessWidget {
  const EvidencePackageCard({
    super.key,
    required this.package,
    required this.threadId,
  });

  final CustomerEvidencePackage package;
  final String threadId;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final generated = package.generatedAt;
    final generatedLabel = generated != null
        ? DateFormat.yMMMd(locale).add_Hm().format(generated.toLocal())
        : '—';

    String? statusNoticeKey;
    if (package.isPdfReady) {
      statusNoticeKey = 'customerCommunicationPdfReadyNotice';
    } else if (package.isPdfFailed) {
      statusNoticeKey = 'customerCommunicationPdfFailedNotice';
    } else if (package.isPdfPending) {
      statusNoticeKey = 'customerCommunicationPdfPendingNotice';
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => context.go(
          AdminRoutes.customerCommunicationEvidencePackageDetail(
            threadId,
            package.id,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                resolveCustomerCommunicationsKey(
                  context,
                  package.packageType.localizationKey(),
                ),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                resolveCustomerCommunicationsKey(
                  context,
                  package.status.localizationKey(),
                ),
              ),
              if (statusNoticeKey != null) ...[
                const SizedBox(height: 8),
                Text(
                  resolveCustomerCommunicationsKey(context, statusNoticeKey),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: package.isPdfFailed
                            ? Theme.of(context).colorScheme.error
                            : Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
              if (package.fileHash != null) ...[
                const SizedBox(height: 8),
                Text(
                  resolveCustomerCommunicationsKey(
                    context,
                    'customerCommunicationFileHash',
                    params: {'hash': package.fileHash!},
                  ),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              const SizedBox(height: 8),
              Text(
                resolveCustomerCommunicationsKey(
                  context,
                  'customerCommunicationPackageGeneratedAt',
                  params: {'date': generatedLabel},
                ),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
