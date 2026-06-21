import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/app_router.dart';
import '../../../../core/localization/localization_resolver.dart';
import '../../domain/public_intake.dart';
import 'public_intake_language_badge.dart';
import 'public_intake_status_badge.dart';
import 'public_intake_type_badge.dart';

class PublicIntakeCard extends StatelessWidget {
  const PublicIntakeCard({super.key, required this.intake});

  final PublicIntake intake;

  @override
  Widget build(BuildContext context) {
    final created = intake.createdAt;
    final dateLabel = created != null
        ? DateFormat.yMMMd(Localizations.localeOf(context).toString()).format(created)
        : '—';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push(AdminRoutes.publicIntakeDetail(intake.id)),
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
                      intake.companyName ??
                          intake.customerName ??
                          intake.customerEmailDomain ??
                          resolvePublicIntakeKey(context, 'publicIntakeUnknownCustomer'),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  PublicIntakeStatusBadge(status: intake.status),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  PublicIntakeTypeBadge(type: intake.type),
                  PublicIntakeLanguageBadge(intake: intake),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                resolvePublicIntakeKey(
                  context,
                  'publicIntakeCreatedAt',
                  params: {'date': dateLabel},
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
