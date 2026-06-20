import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_router.dart';
import '../../../core/auth/admin_auth_state.dart';
import '../../../core/localization/localization_resolver.dart';
import '../../../core/widgets/mock_data_badge.dart';
import '../../../core/widgets/vianexis_error_view.dart';
import '../../../core/widgets/vianexis_loading_view.dart';
import '../../../core/widgets/vianexis_metadata_notice.dart';
import '../../../l10n/app_localizations.dart';
import '../data/admin_users_repository.dart';
import '../domain/platform_admin_user_status.dart';
import 'admin_users_providers.dart';
import 'widgets/admin_user_card.dart';
import 'widgets/admin_user_invite_dialog.dart';

class AdminUsersScreen extends ConsumerStatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  ConsumerState<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends ConsumerState<AdminUsersScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _inviteUser() async {
    final canManage =
        ref.read(adminAuthProvider).user?.role.canManageAdminUsers ?? false;
    if (!canManage) return;

    final request = await showAdminUserInviteDialog(context: context);
    if (request == null || !mounted) return;

    try {
      await submitAdminUserInvite(ref, request: request);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resolveAdminUserKey(context, 'adminUserInviteSuccess'))),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resolveAdminUserKey(context, 'adminUserActionError'))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final usesMock = ref.watch(adminUsersRepositoryProvider).usesMockData;
    final usersAsync = ref.watch(filteredAdminUsersProvider);
    final query = ref.watch(adminUserListQueryProvider);
    final canManage =
        ref.watch(adminAuthProvider).user?.role.canManageAdminUsers ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.adminUsersTitle),
        actions: [
          if (usesMock)
            MockDataBadge(label: resolveAdminUserKey(context, 'adminUserMockDataBadge')),
          if (canManage)
            IconButton(
              tooltip: resolveAdminUserKey(context, 'adminUserInviteAction'),
              onPressed: _inviteUser,
              icon: const Icon(Icons.person_add_outlined),
            ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Center(
              child: Text(
                resolveAdminUserKey(context, 'adminUserMetadataBadge'),
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: resolveAdminUserKey(context, 'adminUserSearchHint'),
              ),
              onChanged: (value) =>
                  ref.read(adminUserListQueryProvider.notifier).setSearch(value),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: AdminUserListFilter.values.map((filter) {
                final key = switch (filter) {
                  AdminUserListFilter.all => 'adminUserFilterAll',
                  AdminUserListFilter.active => 'adminUserFilterActive',
                  AdminUserListFilter.invited => 'adminUserFilterInvited',
                  AdminUserListFilter.suspended => 'adminUserFilterSuspended',
                  AdminUserListFilter.disabled => 'adminUserFilterDisabled',
                };
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(resolveAdminUserKey(context, key)),
                    selected: query.filter == filter,
                    onSelected: (_) =>
                        ref.read(adminUserListQueryProvider.notifier).setFilter(filter),
                  ),
                );
              }).toList(growable: false),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: usersAsync.when(
              loading: () => const VianexisLoadingView(),
              error: (error, _) => VianexisErrorView.fromError(
                context,
                error,
                fallbackMessage: resolveAdminUserKey(context, 'adminUserLoadError'),
                onRetry: () => ref.read(adminUsersProvider.notifier).refresh(),
              ),
              data: (items) {
                if (items.isEmpty) {
                  return Center(
                    child: Text(resolveAdminUserKey(context, 'adminUserListEmpty')),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () => ref.read(adminUsersProvider.notifier).refresh(),
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final user = items[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: AdminUserCard(
                          user: user,
                          onTap: () => context.push(AdminRoutes.adminUserDetail(user.id)),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: VianexisMetadataNotice(
              message: resolveAdminUserKey(context, 'adminUserPrivacyNotice'),
            ),
          ),
        ],
      ),
    );
  }
}
