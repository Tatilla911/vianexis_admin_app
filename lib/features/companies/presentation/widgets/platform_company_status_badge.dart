import 'package:flutter/material.dart';
import 'package:vianexis_admin_app/core/theme/admin_status_colors.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/platform_company_status.dart';

class PlatformCompanyStatusBadge extends StatelessWidget {
  const PlatformCompanyStatusBadge({super.key, required this.status});

  final PlatformCompanyStatus status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      PlatformCompanyStatus.active => Colors.green,
      PlatformCompanyStatus.pendingReview => Colors.orange,
      PlatformCompanyStatus.suspended => Colors.red,
      PlatformCompanyStatus.disabled ||
      PlatformCompanyStatus.inactive => AdminStatusColors.neutral,
      PlatformCompanyStatus.archived => AdminStatusColors.muted,
      PlatformCompanyStatus.unknown => AdminStatusColors.muted,
    };

    return Chip(
      label: Text(resolvePlatformCompanyKey(context, status.localizationKey())),
      backgroundColor: color.withValues(alpha: 0.12),
      side: BorderSide(color: color.withValues(alpha: 0.4)),
    );
  }
}
