import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/app_router.dart';
import '../../../../core/localization/localization_resolver.dart';
import '../../domain/customer_communication_thread.dart';

class CommunicationThreadCard extends StatelessWidget {
  const CommunicationThreadCard({
    super.key,
    required this.thread,
  });

  final CustomerCommunicationThread thread;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final updated = thread.updatedAt;
    final updatedLabel = updated != null
        ? DateFormat.yMMMd(locale).add_Hm().format(updated.toLocal())
        : '—';

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => context.go(
          AdminRoutes.customerCommunicationDetail(thread.id),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      thread.customerDisplayName ??
                          thread.customerEmailDomain ??
                          '—',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  if (thread.disputed ||
                      thread.status == CustomerCommunicationThreadStatus.disputed)
                    Chip(
                      label: Text(
                        resolveCustomerCommunicationsKey(
                          context,
                          'customerCommunicationDisputedBadge',
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                resolveCustomerCommunicationsKey(
                  context,
                  'customerCommunicationThreadSubtitle',
                  params: {
                    'domain': thread.customerEmailDomain ?? '—',
                    'companyId': thread.companyId ?? '—',
                  },
                ),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(
                    label: Text(
                      resolveCustomerCommunicationsKey(
                        context,
                        thread.status.localizationKey(),
                      ),
                    ),
                  ),
                  Chip(
                    label: Text(
                      resolveCustomerCommunicationsKey(
                        context,
                        thread.source.localizationKey(),
                      ),
                    ),
                  ),
                  if (thread.isBillingRelated)
                    Chip(
                      label: Text(
                        resolveCustomerCommunicationsKey(
                          context,
                          'customerCommunicationBillingRelatedBadge',
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                resolveCustomerCommunicationsKey(
                  context,
                  'customerCommunicationUpdatedAt',
                  params: {'date': updatedLabel},
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
