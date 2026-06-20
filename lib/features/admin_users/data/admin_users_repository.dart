import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/localization/localization_keys.dart';
import '../domain/admin_user_invite_request.dart';
import '../domain/admin_user_role_update_request.dart';
import '../domain/admin_user_status_update_request.dart';
import '../domain/platform_admin_user.dart';
import '../domain/platform_admin_user_role.dart';
import '../domain/platform_admin_user_status.dart';
import 'admin_users_api.dart';

abstract class AdminUsersRepository {
  Future<List<PlatformAdminUser>> fetchAdminUsers();

  Future<PlatformAdminUser> fetchAdminUser(String id);

  Future<PlatformAdminUser> inviteAdminUser(AdminUserInviteRequest request);

  Future<PlatformAdminUser> updateAdminUserRole({
    required String id,
    required AdminUserRoleUpdateRequest request,
  });

  Future<PlatformAdminUser> updateAdminUserStatus({
    required String id,
    required AdminUserStatusUpdateRequest request,
  });

  bool get usesMockData;
}

class LiveAdminUsersRepository implements AdminUsersRepository {
  LiveAdminUsersRepository(this._api);

  final AdminUsersApi _api;

  @override
  bool get usesMockData => false;

  @override
  Future<List<PlatformAdminUser>> fetchAdminUsers() async {
    final page = await _api.listAdminUsers();
    return page.items;
  }

  @override
  Future<PlatformAdminUser> fetchAdminUser(String id) => _api.getAdminUser(id);

  @override
  Future<PlatformAdminUser> inviteAdminUser(AdminUserInviteRequest request) async {
    final response = await _api.inviteAdminUser(request);
    return fetchAdminUser(response.user.id);
  }

  @override
  Future<PlatformAdminUser> updateAdminUserRole({
    required String id,
    required AdminUserRoleUpdateRequest request,
  }) async {
    final response = await _api.updateAdminUserRole(id: id, request: request);
    return response.user;
  }

  @override
  Future<PlatformAdminUser> updateAdminUserStatus({
    required String id,
    required AdminUserStatusUpdateRequest request,
  }) async {
    final response = await _api.updateAdminUserStatus(id: id, request: request);
    return response.user;
  }
}

class MockAdminUsersRepository implements AdminUsersRepository {
  MockAdminUsersRepository();

  final List<PlatformAdminUser> _users = [
    PlatformAdminUser(
      id: '1',
      email: 'super@vianexis.test',
      name: 'Super Admin',
      role: PlatformAdminUserRole.superAdmin,
      status: PlatformAdminUserStatus.active,
      createdAt: DateTime.utc(2025, 1, 10),
      updatedAt: DateTime.utc(2026, 6, 1),
      lastLoginAt: DateTime.utc(2026, 6, 19, 8, 30),
      failedLoginCount: 0,
    ),
    PlatformAdminUser(
      id: '2',
      email: 'support@vianexis.test',
      name: 'Support Admin',
      role: PlatformAdminUserRole.supportAdmin,
      status: PlatformAdminUserStatus.active,
      createdAt: DateTime.utc(2025, 3, 15),
      updatedAt: DateTime.utc(2026, 6, 10),
      lastLoginAt: DateTime.utc(2026, 6, 18, 14, 0),
      failedLoginCount: 1,
      lastFailedLoginAt: DateTime.utc(2026, 5, 2),
    ),
    PlatformAdminUser(
      id: '3',
      email: 'billing@vianexis.test',
      name: 'Billing Admin',
      role: PlatformAdminUserRole.billingAdmin,
      status: PlatformAdminUserStatus.active,
      createdAt: DateTime.utc(2025, 6, 1),
      updatedAt: DateTime.utc(2026, 6, 5),
      lastLoginAt: DateTime.utc(2026, 6, 17),
    ),
    PlatformAdminUser(
      id: '4',
      email: 'invited@vianexis.test',
      name: 'Invited Reviewer',
      role: PlatformAdminUserRole.onboardingReviewer,
      status: PlatformAdminUserStatus.invited,
      createdAt: DateTime.utc(2026, 6, 15),
      updatedAt: DateTime.utc(2026, 6, 15),
    ),
    PlatformAdminUser(
      id: '5',
      email: 'suspended@vianexis.test',
      name: 'Suspended Admin',
      role: PlatformAdminUserRole.supportAdmin,
      status: PlatformAdminUserStatus.suspended,
      createdAt: DateTime.utc(2024, 11, 20),
      updatedAt: DateTime.utc(2026, 4, 1),
      lastLoginAt: DateTime.utc(2026, 3, 10),
      failedLoginCount: 4,
      lastFailedLoginAt: DateTime.utc(2026, 3, 28),
    ),
  ];

  @override
  bool get usesMockData => true;

  @override
  Future<List<PlatformAdminUser>> fetchAdminUsers() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return List<PlatformAdminUser>.from(_users);
  }

  @override
  Future<PlatformAdminUser> fetchAdminUser(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return _users.firstWhere(
      (item) => item.id == id,
      orElse: () => throw const ApiException(
        messageKey: LocalizationKeys.errorGenericBody,
        kind: ApiExceptionKind.notFound,
      ),
    );
  }

  @override
  Future<PlatformAdminUser> inviteAdminUser(AdminUserInviteRequest request) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    final id = '${_users.length + 1}';
    final created = PlatformAdminUser(
      id: id,
      email: request.email.trim().toLowerCase(),
      name: request.name.trim(),
      role: request.role,
      status: PlatformAdminUserStatus.invited,
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
    );
    _users.insert(0, created);
    return created;
  }

  @override
  Future<PlatformAdminUser> updateAdminUserRole({
    required String id,
    required AdminUserRoleUpdateRequest request,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    final index = _users.indexWhere((item) => item.id == id);
    if (index < 0) {
      throw const ApiException(
        messageKey: LocalizationKeys.errorGenericBody,
        kind: ApiExceptionKind.notFound,
      );
    }
    final current = _users[index];
    final updated = PlatformAdminUser(
      id: current.id,
      email: current.email,
      name: current.name,
      role: request.role,
      status: current.status,
      createdAt: current.createdAt,
      updatedAt: DateTime.now().toUtc(),
      lastLoginAt: current.lastLoginAt,
      failedLoginCount: current.failedLoginCount,
      lastFailedLoginAt: current.lastFailedLoginAt,
    );
    _users[index] = updated;
    return updated;
  }

  @override
  Future<PlatformAdminUser> updateAdminUserStatus({
    required String id,
    required AdminUserStatusUpdateRequest request,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    final index = _users.indexWhere((item) => item.id == id);
    if (index < 0) {
      throw const ApiException(
        messageKey: LocalizationKeys.errorGenericBody,
        kind: ApiExceptionKind.notFound,
      );
    }
    final current = _users[index];
    final updated = PlatformAdminUser(
      id: current.id,
      email: current.email,
      name: current.name,
      role: current.role,
      status: request.status,
      createdAt: current.createdAt,
      updatedAt: DateTime.now().toUtc(),
      lastLoginAt: current.lastLoginAt,
      failedLoginCount: current.failedLoginCount,
      lastFailedLoginAt: current.lastFailedLoginAt,
    );
    _users[index] = updated;
    return updated;
  }
}

final adminUsersRepositoryProvider = Provider<AdminUsersRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  if (apiClient.isConfigured) {
    return LiveAdminUsersRepository(ref.watch(adminUsersApiProvider));
  }
  return MockAdminUsersRepository();
});
