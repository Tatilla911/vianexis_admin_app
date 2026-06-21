import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/public_intake.dart';

class PublicIntakeCustomerCard extends StatelessWidget {
  const PublicIntakeCustomerCard({super.key, required this.intake});

  final PublicIntake intake;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              resolvePublicIntakeKey(context, 'publicIntakeSectionCustomer'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            _field(
              context,
              'publicIntakeFieldCustomerName',
              intake.customerName ?? '—',
            ),
            _field(
              context,
              'publicIntakeFieldEmailDomain',
              intake.customerEmailDomain ?? '—',
            ),
            _field(
              context,
              'publicIntakeFieldCompany',
              intake.companyName ?? '—',
            ),
            _field(context, 'publicIntakeFieldCountry', intake.country ?? '—'),
          ],
        ),
      ),
    );
  }

  Widget _field(BuildContext context, String key, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              resolvePublicIntakeKey(context, key),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Expanded(flex: 3, child: Text(value)),
        ],
      ),
    );
  }
}
