import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/public_intake.dart';

class PublicIntakeConsentCard extends StatelessWidget {
  const PublicIntakeConsentCard({super.key, required this.intake});

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
              resolvePublicIntakeKey(context, 'publicIntakeSectionConsent'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            _consentRow(context, 'publicIntakeConsentPrivacy', intake.consentPrivacy),
            _consentRow(context, 'publicIntakeConsentTerms', intake.consentTerms),
            _consentRow(
              context,
              'publicIntakeConsentMarketing',
              intake.consentMarketing,
            ),
            if (intake.consentVersion != null)
              _field(
                context,
                'publicIntakeFieldConsentVersion',
                intake.consentVersion!,
              ),
          ],
        ),
      ),
    );
  }

  Widget _consentRow(BuildContext context, String key, bool? value) {
    final label = resolvePublicIntakeKey(context, key);
    final display = value == null
        ? '—'
        : resolvePublicIntakeKey(
            context,
            value ? 'publicIntakeConsentYes' : 'publicIntakeConsentNo',
          );
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(display),
        ],
      ),
    );
  }

  Widget _field(BuildContext context, String key, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              resolvePublicIntakeKey(context, key),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}
