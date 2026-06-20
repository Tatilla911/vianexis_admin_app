import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/admin_user.dart';
import '../data/admin_users_repository.dart';
import '../domain/admin_user_invite_request.dart';
import '../domain/admin_user_role_update_request.dart';
import '../domain/admin_user_status_update_request.dart';
import '../domain/platform_admin_user.dart';
import '../domain/platform_admin_user_status.dart';

extension AdminRoleAdminUserDecisions on AdminRole {
  bool get canManageAdminUsers => this == AdminRole.superAdmin;
}

class AdminUserListQuery {
  const AdminUserListQuery({
    this.search = '',
    this.filter = AdminUserListFilter.all,
  });

  final String search;
  final AdminUserListFilter filter;

  AdminUserListQuery copyWith({
    String? search,
    AdminUserListFilter? filter,
  }) {
    return AdminUserListQuery(
      search: search ?? this.search,
      filter: filter ?? this.filter,
    );
  }
}

final adminUserListQueryProvider =
    NotifierProvider<AdminUserListQueryNotifier, AdminUserListQuery>(
      AdminUserListQueryNotifier.new,
    );

class AdminUserListQueryNotifier extends Notifier<AdminUserListQuery> {
  @override
  AdminUserListQuery build() => const AdminUserListQuery();

  void setSearch(String value) {
    state = state.copyWith(search: value);
  }

  void setFilter(AdminUserListFilter filter) {
    state = state.copyWith(filter: filter);
  }
}

final adminUsersProvider =
    AsyncNotifierProvider<AdminUsersNotifier, List<PlatformAdminUser>>(
      AdminUsersNotifier.new,
    );

class AdminUsersNotifier extends AsyncNotifier<List<PlatformAdminUser>> {
  @override
  Future<List<PlatformAdminUser>> build() => _load();

  Future<List<PlatformAdminUser>> _load() {
    return ref.read(adminUsersRepositoryProvider).fetchAdminUsers();
  }

  Future<void> refresh() async {
    state = const AsyncLoading<List<PlatformAdminUser>>();
    state = await AsyncValue.guard(_load);
  }
}

List<PlatformAdminUser> filteredAdminUsers({
  required List<PlatformAdminUser> items,
  required AdminUserListQuery query,
}) {
  return items
      .where((item) => item.matchesFilter(query.filter))
      .where((item) => item.matchesSearch(query.search))
      .toList(growable: false);
}

final filteredAdminUsersProvider =
    Provider<AsyncValue<List<PlatformAdminUser>>>((ref) {
      final query = ref.watch(adminUserListQueryProvider);
      final users = ref.watch(adminUsersProvider);
      return users.whenData(
        (items) => filteredAdminUsers(items: items, query: query),
      );
    });

final adminUserDetailProvider =
    FutureProvider.autoDispose.family<PlatformAdminUser, String>((ref, id) {
      return ref.watch(adminUsersRepositoryProvider).fetchAdminUser(id);
    });

Future<PlatformAdminUser> submitAdminUserInvite(
  WidgetRef ref, {
  required AdminUserInviteRequest request,
}) async {
  final created = await ref.read(adminUsersRepositoryProvider).inviteAdminUser(request);
  await ref.read(adminUsersProvider.notifier).refresh();
  return created;
}

Future<PlatformAdminUser> submitAdminUserRoleChange(
  WidgetRef ref, {
  required String userId,
  required AdminUserRoleUpdateRequest request,
}) async {
  final updated = await ref.read(adminUsersRepositoryProvider).updateAdminUserRole(
    id: userId,
    request: request,
  );
  ref.invalidate(adminUserDetailProvider(userId));
  await ref.read(adminUsersProvider.notifier).refresh();
  return updated;
}

Future<PlatformAdminUser> submitAdminUserStatusChange(
  WidgetRef ref, {
  required String userId,
  required AdminUserStatusUpdateRequest request,
}) async {
  final updated = await ref.read(adminUsersRepositoryProvider).updateAdminUserStatus(
    id: userId,
    request: request,
  );
  ref.invalidate(adminUserDetailProvider(userId));
  await ref.read(adminUsersProvider.notifier).refresh();
  return updated;
}
