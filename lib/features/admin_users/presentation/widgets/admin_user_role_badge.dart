import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/platform_admin_user_role.dart';

class AdminUserRoleBadge extends StatelessWidget {
  const AdminUserRoleBadge({super.key, required this.role});

  final PlatformAdminUserRole role;

  @override
  Widget build(BuildContext context) {
    final color = switch (role) {
      PlatformAdminUserRole.superAdmin => Colors.red,
      PlatformAdminUserRole.supportAdmin => Colors.blue,
      PlatformAdminUserRole.billingAdmin => Colors.orange,
      PlatformAdminUserRole.onboardingReviewer => Colors.teal,
      PlatformAdminUserRole.unknown => Colors.black54,
    };

    return Chip(
      label: Text(roleLabel(context, role.localizationKey())),
      backgroundColor: color.withValues(alpha: 0.12),
      side: BorderSide(color: color.withValues(alpha: 0.4)),
    );
  }
}
