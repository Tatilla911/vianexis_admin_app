import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_exception.dart';
import '../../../../core/api/api_exception_feedback.dart';
import '../../../../core/localization/localization_resolver.dart';
import '../../../release_center/presentation/release_center_providers.dart';
import '../../domain/customer_delivery_models.dart';
import '../../domain/customer_message_delivery.dart';
import '../../domain/send_reply_request.dart';
import '../customer_communications_providers.dart';
import 'delivery_status_badge.dart';
import 'resend_customer_reply_dialog.dart';

class DeliveryHistorySection extends ConsumerStatefulWidget {
  const DeliveryHistorySection({
    super.key,
    required this.threadId,
    required this.deliveries,
  });

  final String threadId;
  final List<CustomerMessageDelivery> deliveries;

  @override
  ConsumerState<DeliveryHistorySection> createState() =>
      _DeliveryHistorySectionState();
}

class _DeliveryHistorySectionState extends ConsumerState<DeliveryHistorySection> {
  CustomerDeliveryHistoryFilter _filter = CustomerDeliveryHistoryFilter.all;

  List<CustomerMessageDelivery> get _filteredItems {
    final status = _filter.backendStatusValue();
    if (status == null) return widget.deliveries;
    return widget.deliveries
        .where((item) => item.deliveryStatus.name == status)
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.deliveries.isEmpty) {
      return Text(
        resolveCustomerCommunicationsKey(
          context,
          'customerCommunicationDeliveryHistoryEmpty',
        ),
      );
    }

    final emailStatusAsync = ref.watch(emailDeliveryStatusProvider);
    final emailStatus = emailStatusAsync.asData?.value;
    final providerDisabled =
        emailStatus == null || !emailStatus.deliveryEnabled || emailStatus.noopMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: CustomerDeliveryHistoryFilter.values.map((filter) {
            final selected = _filter == filter;
            return FilterChip(
              label: Text(
                resolveCustomerCommunicationsKey(context, filter.localizationKey()),
              ),
              selected: selected,
              onSelected: (_) => setState(() => _filter = filter),
            );
          }).toList(growable: false),
        ),
        const SizedBox(height: 12),
        for (final delivery in _filteredItems)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DeliveryStatusBadge(delivery: delivery),
                    if (delivery.failureMessageSafe != null &&
                        delivery.failureMessageSafe!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        delivery.failureMessageSafe!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                    if (delivery.emailTemplateKey != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        '${resolveCustomerCommunicationsKey(context, 'customerCommunicationDeliveryTemplateLabel')}: '
                        '${delivery.emailTemplateKey} '
                        '(${delivery.emailTemplateVersion ?? '—'})',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                    if (delivery.isResendAttempt) ...[
                      const SizedBox(height: 8),
                      Text(
                        resolveCustomerCommunicationsKey(
                          context,
                          'customerCommunicationDeliveryResendAttempt',
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () => _resend(context, delivery, providerDisabled),
                      icon: const Icon(Icons.refresh_outlined),
                      label: Text(
                        resolveCustomerCommunicationsKey(
                          context,
                          'customerCommunicationResendAction',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _resend(
    BuildContext context,
    CustomerMessageDelivery delivery,
    bool providerDisabled,
  ) async {
    final request = await showDialog<ResendCustomerReplyRequest>(
      context: context,
      builder: (context) => ResendCustomerReplyDialog(
        providerDisabled: providerDisabled,
        translationApproved: delivery.translationApproved,
      ),
    );
    if (request == null) return;

    try {
      final result = await resendCustomerDelivery(
        ref: ref,
        threadId: widget.threadId,
        deliveryId: delivery.id,
        request: request,
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            resolveCustomerCommunicationsKey(
              context,
              result.delivery.isSkippedOrNoop
                  ? 'customerCommunicationReplyLoggedSkippedNotice'
                  : 'customerCommunicationResendSuccess',
            ),
          ),
        ),
      );
    } catch (error) {
      if (!context.mounted) return;
      if (error is ApiException) {
        showApiExceptionSnackBar(context, error);
      }
    }
  }
}
