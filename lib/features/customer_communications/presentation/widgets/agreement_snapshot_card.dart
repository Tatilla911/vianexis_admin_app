import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/customer_agreement_snapshot.dart';

class AgreementSnapshotCard extends StatelessWidget {
  const AgreementSnapshotCard({
    super.key,
    required this.snapshot,
  });

  final CustomerAgreementSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final accepted = snapshot.acceptedAt;
    final acceptedLabel = accepted != null
        ? DateFormat.yMMMd(locale).add_Hm().format(accepted.toLocal())
        : '—';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              snapshot.planName,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text('${snapshot.planCode} · ${snapshot.planVersion ?? '—'}'),
            if (snapshot.priceAmount != null) ...[
              const SizedBox(height: 8),
              Text(
                resolveCustomerCommunicationsKey(
                  context,
                  'customerCommunicationAgreementPrice',
                  params: {
                    'amount': snapshot.priceAmount!,
                    'currency': snapshot.currency ?? '',
                    'cycle': snapshot.billingCycle ?? '',
                  },
                ),
              ),
            ],
            if (snapshot.selectedModules.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                resolveCustomerCommunicationsKey(
                  context,
                  'customerCommunicationAgreementModules',
                  params: {'modules': snapshot.selectedModules.join(', ')},
                ),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              resolveCustomerCommunicationsKey(
                context,
                'customerCommunicationAgreementAcceptedAt',
                params: {'date': acceptedLabel},
              ),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
