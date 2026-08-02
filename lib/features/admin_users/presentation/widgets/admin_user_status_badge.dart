import 'package:flutter/material.dart';
import 'package:vianexis_admin_app/core/theme/admin_status_colors.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/platform_admin_user_status.dart';

class AdminUserStatusBadge extends StatelessWidget {
  const AdminUserStatusBadge({super.key, required this.status});

  final PlatformAdminUserStatus status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      PlatformAdminUserStatus.active => Colors.green,
      PlatformAdminUserStatus.invited => Colors.blue,
      PlatformAdminUserStatus.suspended => Colors.orange,
      PlatformAdminUserStatus.disabled => Colors.red,
      PlatformAdminUserStatus.unknown => AdminStatusColors.muted,
    };

    return Chip(
      label: Text(resolveAdminUserKey(context, status.localizationKey())),
      backgroundColor: color.withValues(alpha: 0.12),
      side: BorderSide(color: color.withValues(alpha: 0.4)),
    );
  }
}
