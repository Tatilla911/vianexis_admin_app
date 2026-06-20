import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/platform_admin_user.dart';
import 'admin_user_role_badge.dart';
import 'admin_user_status_badge.dart';

class AdminUserCard extends StatelessWidget {
  const AdminUserCard({
    super.key,
    required this.user,
    this.onTap,
  });

  final PlatformAdminUser user;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final lastLogin = user.lastLoginAt;
    final lastLoginLabel = lastLogin != null
        ? DateFormat.yMMMd(locale).add_Hm().format(lastLogin.toLocal())
        : '—';

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.displayName,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(user.email, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  AdminUserRoleBadge(role: user.role),
                  AdminUserStatusBadge(status: user.status),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                resolveAdminUserKey(
                  context,
                  'adminUserLastLogin',
                  params: {'date': lastLoginLabel},
                ),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              if (user.failedLoginCount > 0)
                Text(
                  resolveAdminUserKey(
                    context,
                    'adminUserFailedLogins',
                    params: {'count': '${user.failedLoginCount}'},
                  ),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
