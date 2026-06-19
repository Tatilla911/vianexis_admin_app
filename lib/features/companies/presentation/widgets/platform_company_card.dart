import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/platform_company.dart';

class PlatformCompanyCard extends StatelessWidget {
  const PlatformCompanyCard({
    super.key,
    required this.company,
    this.onTap,
  });

  final PlatformCompany company;
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
              Text(
                company.name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                [
                  if (company.country != null) company.country,
                  if (company.vatNumber != null) company.vatNumber,
                ].join(' · '),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  _metric(
                    context,
                    'platformCompanyMetricActiveUsers',
                    '${company.activeUsersCount}',
                  ),
                  _metric(
                    context,
                    'platformCompanyMetricVehicles',
                    '${company.vehiclesCount}',
                  ),
                  if (company.openSupportTicketsCount > 0)
                    _metric(
                      context,
                      'platformCompanyMetricOpenSupport',
                      '${company.openSupportTicketsCount}',
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _metric(BuildContext context, String key, String value) {
    return Text(
      resolvePlatformCompanyKey(
        context,
        key,
        params: {'count': value},
      ),
      style: Theme.of(context).textTheme.bodySmall,
    );
  }
}
