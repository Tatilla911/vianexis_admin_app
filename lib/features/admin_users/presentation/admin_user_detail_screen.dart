import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/api/api_exception_feedback.dart';
import '../../../core/auth/admin_auth_state.dart';
import '../../../core/localization/localization_resolver.dart';
import '../../../core/widgets/vianexis_error_view.dart';
import '../../../core/widgets/vianexis_loading_view.dart';
import '../../../core/widgets/vianexis_metadata_notice.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/platform_admin_user_role.dart';
import '../domain/platform_admin_user_status.dart';
import 'admin_users_providers.dart';
import 'widgets/admin_user_role_badge.dart';
import 'widgets/admin_user_role_dialog.dart';
import 'widgets/admin_user_status_badge.dart';
import 'widgets/admin_user_status_dialog.dart';

class AdminUserDetailScreen extends ConsumerWidget {
  const AdminUserDetailScreen({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final userAsync = ref.watch(adminUserDetailProvider(userId));
    final canManage =
        ref.watch(adminAuthProvider).user?.role.canManageAdminUsers ?? false;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.adminUserDetailTitle)),
      body: userAsync.when(
        loading: () => const VianexisLoadingView(),
        error: (error, _) => VianexisErrorView.fromError(
          context,
          error,
          fallbackMessage: resolveAdminUserKey(context, 'adminUserDetailError'),
          onRetry: () => ref.invalidate(adminUserDetailProvider(userId)),
        ),
        data: (user) {
          final locale = Localizations.localeOf(context).toString();
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(user.displayName, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(user.email),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: [
                  AdminUserRoleBadge(role: user.role),
                  AdminUserStatusBadge(status: user.status),
                ],
              ),
              const SizedBox(height: 20),
              _field(context, 'adminUserFieldEmail', user.email),
              if (user.name != null)
                _field(context, 'adminUserFieldName', user.name!),
              _field(
                context,
                'adminUserFieldRole',
                roleLabel(context, user.role.localizationKey()),
              ),
              _field(
                context,
                'adminUserFieldStatus',
                resolveAdminUserKey(context, user.status.localizationKey()),
              ),
              if (user.createdAt != null)
                _field(
                  context,
                  'adminUserFieldCreatedAt',
                  DateFormat.yMMMd(locale).add_Hm().format(user.createdAt!.toLocal()),
                ),
              if (user.lastLoginAt != null)
                _field(
                  context,
                  'adminUserFieldLastLoginAt',
                  DateFormat.yMMMd(locale).add_Hm().format(user.lastLoginAt!.toLocal()),
                ),
              _field(
                context,
                'adminUserFieldFailedLoginCount',
                '${user.failedLoginCount}',
              ),
              if (canManage) ...[
                const SizedBox(height: 24),
                FilledButton.tonal(
                  onPressed: () => _changeRole(context, ref, user.role),
                  child: Text(resolveAdminUserKey(context, 'adminUserChangeRoleAction')),
                ),
                const SizedBox(height: 8),
                FilledButton.tonal(
                  onPressed: () => _changeStatus(context, ref, user.status),
                  child: Text(resolveAdminUserKey(context, 'adminUserChangeStatusAction')),
                ),
              ],
              const SizedBox(height: 16),
              VianexisMetadataNotice(
                message: resolveAdminUserKey(context, 'adminUserPrivacyNotice'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _field(BuildContext context, String labelKey, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              resolveAdminUserKey(context, labelKey),
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Future<void> _changeRole(
    BuildContext context,
    WidgetRef ref,
    PlatformAdminUserRole currentRole,
  ) async {
    final request = await showAdminUserRoleDialog(
      context: context,
      currentRole: currentRole,
    );
    if (request == null || !context.mounted) return;
    try {
      await submitAdminUserRoleChange(ref, userId: userId, request: request);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resolveAdminUserKey(context, 'adminUserRoleSuccess'))),
      );
    } on ApiException catch (error) {
      if (!context.mounted) return;
      showApiExceptionSnackBar(context, error);
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resolveAdminUserKey(context, 'adminUserActionError'))),
      );
    }
  }

  Future<void> _changeStatus(
    BuildContext context,
    WidgetRef ref,
    PlatformAdminUserStatus currentStatus,
  ) async {
    final request = await showAdminUserStatusDialog(
      context: context,
      currentStatus: currentStatus,
    );
    if (request == null || !context.mounted) return;
    try {
      await submitAdminUserStatusChange(ref, userId: userId, request: request);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resolveAdminUserKey(context, 'adminUserStatusSuccess'))),
      );
    } on ApiException catch (error) {
      if (!context.mounted) return;
      showApiExceptionSnackBar(context, error);
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resolveAdminUserKey(context, 'adminUserActionError'))),
      );
    }
  }
}
