import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/app_router.dart';
import '../../../../core/localization/localization_resolver.dart';
import '../../../../core/widgets/vianexis_status_badge.dart';
import '../../domain/registration_application.dart';
import '../../domain/registration_application_status.dart';
import 'ai_risk_badge.dart';

class RegistrationApplicationCard extends StatelessWidget {
  const RegistrationApplicationCard({
    super.key,
    required this.application,
  });

  final RegistrationApplication application;

  @override
  Widget build(BuildContext context) {
    final submitted = application.submittedAt;
    final dateLabel = submitted != null
        ? DateFormat.yMMMd(Localizations.localeOf(context).toString()).format(submitted)
        : '—';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push(AdminRoutes.registrationDetail(application.id)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      application.companyName,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  VianexisStatusBadge(
                    label: resolveRegistrationKey(
                      context,
                      application.status.localizationKey(),
                    ),
                    tone: _statusTone(application.status),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                [
                  if (application.country != null) application.country,
                  if (application.vatNumber != null) application.vatNumber,
                  application.contactEmail,
                ].whereType<String>().join(' · '),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  AiRiskBadge(riskLevel: application.riskLevel),
                  const Spacer(),
                  Text(
                    resolveRegistrationKey(
                      context,
                      'registrationSubmittedAt',
                      params: {'date': dateLabel},
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

  VianexisStatusTone _statusTone(RegistrationApplicationStatus status) {
    return switch (status) {
      RegistrationApplicationStatus.approved => VianexisStatusTone.healthy,
      RegistrationApplicationStatus.rejected ||
      RegistrationApplicationStatus.cancelled => VianexisStatusTone.degraded,
      RegistrationApplicationStatus.needsMoreInfo => VianexisStatusTone.unknown,
      _ => VianexisStatusTone.unknown,
    };
  }
}
