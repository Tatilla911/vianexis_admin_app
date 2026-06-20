import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/localization/localization_resolver.dart';
import '../../../core/widgets/vianexis_error_view.dart';
import '../../../core/widgets/vianexis_loading_view.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/customer_evidence_package.dart';
import 'customer_communications_providers.dart';

class EvidencePackageDetailScreen extends ConsumerWidget {
  const EvidencePackageDetailScreen({
    super.key,
    required this.threadId,
    required this.packageId,
  });

  final String threadId;
  final String packageId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final detailAsync = ref.watch(customerCommunicationDetailProvider(threadId));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.customerCommunicationEvidencePackageTitle)),
      body: detailAsync.when(
        loading: () => const VianexisLoadingView(),
        error: (error, _) => VianexisErrorView.fromError(
          context,
          error,
          fallbackMessage: resolveCustomerCommunicationsKey(
            context,
            'customerCommunicationLoadError',
          ),
          onRetry: () => refreshCustomerCommunicationDetail(ref, threadId),
        ),
        data: (detail) {
          CustomerEvidencePackage? pkg;
          for (final item in detail.evidencePackages) {
            if (item.id == packageId) {
              pkg = item;
              break;
            }
          }
          if (pkg == null) {
            return Center(
              child: Text(
                resolveCustomerCommunicationsKey(
                  context,
                  'customerCommunicationPackageNotFound',
                ),
              ),
            );
          }

          final locale = Localizations.localeOf(context).toString();
          final generated = pkg.generatedAt;
          final generatedLabel = generated != null
              ? DateFormat.yMMMd(locale).add_Hm().format(generated.toLocal())
              : '—';
          final summaryText = pkg.summaryJson == null
              ? '—'
              : const JsonEncoder.withIndent('  ').convert(pkg.summaryJson);

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                resolveCustomerCommunicationsKey(
                  context,
                  pkg.packageType.localizationKey(),
                ),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                resolveCustomerCommunicationsKey(
                  context,
                  pkg.status.localizationKey(),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                resolveCustomerCommunicationsKey(
                  context,
                  'customerCommunicationPackageGeneratedAt',
                  params: {'date': generatedLabel},
                ),
              ),
              if (pkg.generationReason != null) ...[
                const SizedBox(height: 12),
                Text(
                  resolveCustomerCommunicationsKey(
                    context,
                    'customerCommunicationPackageReason',
                    params: {'reason': pkg.generationReason!},
                  ),
                ),
              ],
              if (pkg.isPdfPending) ...[
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      resolveCustomerCommunicationsKey(
                        context,
                        'customerCommunicationPdfPendingNotice',
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Text(
                resolveCustomerCommunicationsKey(
                  context,
                  'customerCommunicationSummaryJsonTitle',
                ),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              SelectableText(summaryText),
              if (pkg.fileHash != null) ...[
                const SizedBox(height: 12),
                Text(
                  resolveCustomerCommunicationsKey(
                    context,
                    'customerCommunicationFileHash',
                    params: {'hash': pkg.fileHash!},
                  ),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
