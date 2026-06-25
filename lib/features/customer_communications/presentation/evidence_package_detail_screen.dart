import 'dart:convert';

import 'package:flutter/material.dart';
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
import '../services/evidence_pdf_bytes.dart';
import '../services/evidence_pdf_share_service.dart';
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
  static const _shareService = EvidencePdfShareService();

  bool _sharing = false;

  Future<void> _sharePdf(CustomerEvidencePackage pkg) async {
    if (!pkg.canDownload || _sharing) return;
    setState(() => _sharing = true);
    try {
      final bytes = await ref
          .read(customerCommunicationsRepositoryProvider)
          .downloadEvidencePackagePdf(
            threadId: widget.threadId,
            packageId: widget.packageId,
          );
      if (!mounted) return;
      if (!EvidencePdfBytes.isValidPdf(bytes)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              resolveCustomerCommunicationsKey(
                context,
                'customerCommunicationSharePdfInvalid',
              ),
            ),
          ),
        );
        return;
      }

      final shareSubject = resolveCustomerCommunicationsKey(
        context,
        'customerCommunicationEvidencePackageTitle',
      );

      await _shareService.sharePdfBytes(
        bytes: bytes,
        packageId: widget.packageId,
        shareSubject: shareSubject,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            resolveCustomerCommunicationsKey(
              context,
              'customerCommunicationSharePdfSuccess',
            ),
          ),
        ),
      );
    } on EvidencePdfShareFailure catch (failure) {
      if (!mounted) return;
      final key = switch (failure) {
        EvidencePdfShareFailure.empty ||
        EvidencePdfShareFailure.invalid =>
          'customerCommunicationSharePdfInvalid',
        EvidencePdfShareFailure.shareUnavailable =>
          'customerCommunicationSharePdfUnavailable',
      };
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resolveCustomerCommunicationsKey(context, key))),
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
              'customerCommunicationSharePdfFailed',
            ),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _sharing = false);
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          resolveCustomerCommunicationsKey(
                            context,
                            'customerCommunicationEvidenceDeliveryNotice',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          resolveCustomerCommunicationsKey(
                            context,
                            'customerCommunicationEvidenceRegenerationNotice',
                          ),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
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
                  onPressed: _sharing ? null : () => _sharePdf(pkg!),
                  icon: _sharing
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.ios_share_outlined),
                  label: Text(
                    resolveCustomerCommunicationsKey(
                      context,
                      'customerCommunicationSharePdfAction',
                    ),
                  ),
                ),
              ] else if (pkg.isPdfPending) ...[
                const SizedBox(height: 8),
                Text(
                  resolveCustomerCommunicationsKey(
                    context,
                    'customerCommunicationSharePdfNotReady',
                  ),
                  style: Theme.of(context).textTheme.bodySmall,
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
