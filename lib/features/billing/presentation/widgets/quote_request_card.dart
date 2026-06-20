import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/quote_request.dart';
import '../../domain/quote_request_status.dart';

class QuoteRequestCard extends StatelessWidget {
  const QuoteRequestCard({
    super.key,
    required this.quoteRequest,
    this.onTap,
  });

  final QuoteRequest quoteRequest;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      quoteRequest.companyName,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  _StatusChip(status: quoteRequest.status),
                ],
              ),
              const SizedBox(height: 4),
              Text(quoteRequest.contactEmail),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  if (quoteRequest.fleetSize != null)
                    Text(
                      resolveBillingKey(
                        context,
                        'billingMetricFleetSize',
                        params: {'count': '${quoteRequest.fleetSize}'},
                      ),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  if (quoteRequest.officeUsers != null)
                    Text(
                      resolveBillingKey(
                        context,
                        'billingMetricOfficeUsers',
                        params: {'count': '${quoteRequest.officeUsers}'},
                      ),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final QuoteRequestStatus status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      QuoteRequestStatus.draft => Colors.grey,
      QuoteRequestStatus.submitted => Colors.blue,
      QuoteRequestStatus.underReview => Colors.orange,
      QuoteRequestStatus.quoted => Colors.deepPurple,
      QuoteRequestStatus.accepted => Colors.green,
      QuoteRequestStatus.rejected => Colors.red,
      QuoteRequestStatus.unknown => Colors.black54,
    };

    return Chip(
      label: Text(resolveBillingKey(context, status.localizationKey())),
      backgroundColor: color.withValues(alpha: 0.12),
      side: BorderSide(color: color.withValues(alpha: 0.4)),
    );
  }
}
