import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/api/api_exception_feedback.dart';
import '../../../core/localization/localization_resolver.dart';
import '../../../core/widgets/vianexis_error_view.dart';
import '../../../core/widgets/vianexis_loading_view.dart';
import '../../../core/widgets/vianexis_metadata_notice.dart';
import '../../../core/widgets/vianexis_status_badge.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/evidence_package_request.dart';
import 'customer_communications_providers.dart';
import 'widgets/agreement_snapshot_card.dart';
import 'widgets/communication_message_timeline.dart';
import 'widgets/evidence_package_card.dart';
import 'widgets/generate_evidence_package_dialog.dart';

class CustomerCommunicationDetailScreen extends ConsumerWidget {
  const CustomerCommunicationDetailScreen({
    super.key,
    required this.threadId,
  });

  final String threadId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final detailAsync = ref.watch(customerCommunicationDetailProvider(threadId));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.customerCommunicationDetailTitle),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: VianexisStatusBadge(
                label: l10n.privacyMetadataOnlyBadge,
                tone: VianexisStatusTone.unknown,
              ),
            ),
          ),
        ],
      ),
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
        data: (detail) => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            if (detail.metadataOnly)
              VianexisMetadataNotice(
                message: resolveCustomerCommunicationsKey(
                  context,
                  'customerCommunicationDetailMetadataOnly',
                ),
              ),
            if (detail.thread.disputed ||
                detail.thread.disputeReason != null) ...[
              const SizedBox(height: 12),
              Card(
                color: Theme.of(context).colorScheme.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        resolveCustomerCommunicationsKey(
                          context,
                          'customerCommunicationDisputedSectionTitle',
                        ),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      if (detail.thread.disputeReason != null) ...[
                        const SizedBox(height: 8),
                        Text(detail.thread.disputeReason!),
                      ],
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            Text(
              resolveCustomerCommunicationsKey(
                context,
                'customerCommunicationTimelineTitle',
              ),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            CommunicationMessageTimeline(messages: detail.messages),
            if (detail.agreementSnapshots.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                resolveCustomerCommunicationsKey(
                  context,
                  'customerCommunicationAgreementsTitle',
                ),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              for (final snapshot in detail.agreementSnapshots)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AgreementSnapshotCard(snapshot: snapshot),
                ),
            ],
            const SizedBox(height: 16),
            Text(
              resolveCustomerCommunicationsKey(
                context,
                'customerCommunicationEvidencePackagesTitle',
              ),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            if (detail.evidencePackages.isEmpty)
              Text(
                resolveCustomerCommunicationsKey(
                  context,
                  'customerCommunicationPackagesEmpty',
                ),
              )
            else
              for (final pkg in detail.evidencePackages)
                EvidencePackageCard(package: pkg, threadId: threadId),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                OutlinedButton.icon(
                  onPressed: detail.thread.disputed
                      ? null
                      : () => _markDisputed(context, ref),
                  icon: const Icon(Icons.flag_outlined),
                  label: Text(
                    resolveCustomerCommunicationsKey(
                      context,
                      'customerCommunicationMarkDisputedAction',
                    ),
                  ),
                ),
                FilledButton.icon(
                  onPressed: () => _generatePackage(context, ref),
                  icon: const Icon(Icons.description_outlined),
                  label: Text(
                    resolveCustomerCommunicationsKey(
                      context,
                      'customerCommunicationGeneratePackageAction',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _markDisputed(BuildContext context, WidgetRef ref) async {
    final reason = await showDialog<String>(
      context: context,
      builder: (context) => _DisputeReasonDialog(),
    );
    if (reason == null || reason.trim().length < 5) return;

    try {
      await markCustomerCommunicationDisputed(
        ref: ref,
        threadId: threadId,
        request: MarkCustomerDisputeRequest(reason: reason),
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              resolveCustomerCommunicationsKey(
                context,
                'customerCommunicationDisputeMarkedSuccess',
              ),
            ),
          ),
        );
      }
    } catch (error) {
      if (context.mounted) {
        if (error is ApiException) {
          showApiExceptionSnackBar(context, error);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                resolveCustomerCommunicationsKey(
                  context,
                  'customerCommunicationActionError',
                ),
              ),
            ),
          );
        }
      }
    }
  }

  Future<void> _generatePackage(BuildContext context, WidgetRef ref) async {
    final request = await showDialog<EvidencePackageRequest>(
      context: context,
      builder: (context) => const GenerateEvidencePackageDialog(),
    );
    if (request == null) return;

    try {
      await generateCustomerEvidencePackage(
        ref: ref,
        threadId: threadId,
        request: request,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              resolveCustomerCommunicationsKey(
                context,
                'customerCommunicationPackageGeneratedSuccess',
              ),
            ),
          ),
        );
      }
    } catch (error) {
      if (context.mounted) {
        if (error is ApiException) {
          showApiExceptionSnackBar(context, error);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                resolveCustomerCommunicationsKey(
                  context,
                  'customerCommunicationActionError',
                ),
              ),
            ),
          );
        }
      }
    }
  }
}

class _DisputeReasonDialog extends StatefulWidget {
  @override
  State<_DisputeReasonDialog> createState() => _DisputeReasonDialogState();
}

class _DisputeReasonDialogState extends State<_DisputeReasonDialog> {
  final _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        resolveCustomerCommunicationsKey(
          context,
          'customerCommunicationMarkDisputedTitle',
        ),
      ),
      content: TextField(
        controller: _controller,
        maxLines: 4,
        decoration: InputDecoration(
          labelText: resolveCustomerCommunicationsKey(
            context,
            'customerCommunicationReasonLabel',
          ),
          errorText: _error,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            resolveCustomerCommunicationsKey(
              context,
              'customerCommunicationCancel',
            ),
          ),
        ),
        FilledButton(
          onPressed: () {
            final reason = _controller.text.trim();
            if (reason.length < 5) {
              setState(() {
                _error = resolveCustomerCommunicationsKey(
                  context,
                  'customerCommunicationReasonRequired',
                );
              });
              return;
            }
            Navigator.of(context).pop(reason);
          },
          child: Text(
            resolveCustomerCommunicationsKey(
              context,
              'customerCommunicationMarkDisputedAction',
            ),
          ),
        ),
      ],
    );
  }
}
