import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/api/api_exception_feedback.dart';
import '../../../core/localization/localization_resolver.dart';
import '../../../core/widgets/vianexis_error_view.dart';
import '../../../core/widgets/vianexis_loading_view.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/customer_evidence_package.dart';
import '../data/customer_communications_repository.dart';
import 'customer_communications_providers.dart';

class EvidencePackageDetailScreen extends ConsumerStatefulWidget {
  const EvidencePackageDetailScreen({
    super.key,
    required this.threadId,
    required this.packageId,
  });

  final String threadId;
  final String packageId;

  @override
  ConsumerState<EvidencePackageDetailScreen> createState() =>
      _EvidencePackageDetailScreenState();
}

class _EvidencePackageDetailScreenState
    extends ConsumerState<EvidencePackageDetailScreen> {
  bool _downloading = false;

  Future<void> _downloadPdf(CustomerEvidencePackage pkg) async {
    if (!pkg.canDownload || _downloading) return;
    setState(() => _downloading = true);
    try {
      final bytes = await ref
          .read(customerCommunicationsRepositoryProvider)
          .downloadEvidencePackagePdf(
            threadId: widget.threadId,
            packageId: widget.packageId,
          );
      if (bytes.length >= 4 &&
          String.fromCharCodes(bytes.take(4)) == '%PDF') {
        await Clipboard.setData(
          ClipboardData(text: base64Encode(bytes)),
        );
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            resolveCustomerCommunicationsKey(
              context,
              'customerCommunicationDownloadPdfSuccess',
              params: {'bytes': '${bytes.length}'},
            ),
          ),
        ),
      );
    } on ApiException catch (error) {
      if (!mounted) return;
      showApiExceptionSnackBar(context, error);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            resolveCustomerCommunicationsKey(
              context,
              'customerCommunicationDownloadPdfFailed',
            ),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _downloading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final detailAsync =
        ref.watch(customerCommunicationDetailProvider(widget.threadId));

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
          onRetry: () =>
              refreshCustomerCommunicationDetail(ref, widget.threadId),
        ),
        data: (detail) {
          CustomerEvidencePackage? pkg;
          for (final item in detail.evidencePackages) {
            if (item.id == widget.packageId) {
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
              if (pkg.generatedByUserId != null) ...[
                const SizedBox(height: 8),
                Text(
                  resolveCustomerCommunicationsKey(
                    context,
                    'customerCommunicationGeneratedBy',
                    params: {'userId': pkg.generatedByUserId!},
                  ),
                ),
              ],
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
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    resolveCustomerCommunicationsKey(
                      context,
                      'customerCommunicationPdfSourceOfTruthNotice',
                    ),
                  ),
                ),
              ),
              if (pkg.isPdfReady) ...[
                const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    resolveCustomerCommunicationsKey(
                      context,
                      'customerCommunicationEvidenceDeliveryNotice',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      resolveCustomerCommunicationsKey(
                        context,
                        'customerCommunicationPdfReadyNotice',
                      ),
                    ),
                  ),
                ),
              ] else if (pkg.isPdfFailed) ...[
                const SizedBox(height: 12),
                Card(
                  color: Theme.of(context).colorScheme.errorContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      resolveCustomerCommunicationsKey(
                        context,
                        'customerCommunicationPdfFailedNotice',
                      ),
                    ),
                  ),
                ),
              ] else if (pkg.isPdfPending) ...[
                const SizedBox(height: 12),
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
              if (pkg.canDownload) ...[
                const SizedBox(height: 12),
                Text(
                  resolveCustomerCommunicationsKey(
                    context,
                    'customerCommunicationExportAuditWarning',
                  ),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                FilledButton.icon(
                  onPressed: _downloading ? null : () => _downloadPdf(pkg!),
                  icon: _downloading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.download_outlined),
                  label: Text(
                    resolveCustomerCommunicationsKey(
                      context,
                      'customerCommunicationDownloadPdfAction',
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
