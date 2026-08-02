import 'package:flutter/material.dart';
import 'package:vianexis_admin_app/core/theme/admin_status_colors.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/subscription_status.dart';

class SubscriptionStatusBadge extends StatelessWidget {
  const SubscriptionStatusBadge({super.key, required this.status});

  final SubscriptionStatus status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      SubscriptionStatus.active => Colors.green,
      SubscriptionStatus.trial => Colors.blue,
      SubscriptionStatus.pastDue => Colors.orange,
      SubscriptionStatus.suspended => Colors.red,
      SubscriptionStatus.cancelled => AdminStatusColors.neutral,
      SubscriptionStatus.customQuotePending => Colors.deepPurple,
      SubscriptionStatus.unknown => AdminStatusColors.muted,
    };

    return Chip(
      label: Text(resolveBillingKey(context, status.localizationKey())),
      backgroundColor: color.withValues(alpha: 0.12),
      side: BorderSide(color: color.withValues(alpha: 0.4)),
    );
  }
}
