import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../domain/admin_user_invite_request.dart';
import '../domain/admin_user_role_update_request.dart';
import '../domain/admin_user_status_update_request.dart';
import '../domain/platform_admin_user.dart';

class AdminUsersApi {
  AdminUsersApi(this._apiClient);

  final ApiClient _apiClient;

  Future<PlatformAdminUsersPage> listAdminUsers() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/admin-users',
    );
    final data = response.data;
    if (data == null) {
      return const PlatformAdminUsersPage(items: []);
    }
    return PlatformAdminUsersPage.fromJson(data);
  }

  Future<PlatformAdminUser> getAdminUser(String id) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/admin-users/$id',
    );
    final data = response.data;
    if (data == null) {
      throw StateError('Empty admin user response');
    }
    final userJson = data['user'];
    if (userJson is Map<String, dynamic>) {
      return PlatformAdminUser.fromJson(userJson);
    }
    return PlatformAdminUser.fromJson(data);
  }

  Future<AdminUserInviteResponse> inviteAdminUser(
    AdminUserInviteRequest request,
  ) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/platform-admin/admin-users/invite',
      data: request.toJson(),
    );
    final data = response.data;
    if (data == null) {
      throw StateError('Empty admin user invite response');
    }
    return AdminUserInviteResponse.fromJson(data);
  }

  Future<AdminUserRoleUpdateResponse> updateAdminUserRole({
    required String id,
    required AdminUserRoleUpdateRequest request,
  }) async {
    final response = await _apiClient.patch<Map<String, dynamic>>(
      '/platform-admin/admin-users/$id/role',
      data: request.toJson(),
    );
    final data = response.data;
    if (data == null) {
      throw StateError('Empty admin user role response');
    }
    return AdminUserRoleUpdateResponse.fromJson(data);
  }

  Future<AdminUserStatusUpdateResponse> updateAdminUserStatus({
    required String id,
    required AdminUserStatusUpdateRequest request,
  }) async {
    final response = await _apiClient.patch<Map<String, dynamic>>(
      '/platform-admin/admin-users/$id/status',
      data: request.toJson(),
    );
    final data = response.data;
    if (data == null) {
      throw StateError('Empty admin user status response');
    }
    return AdminUserStatusUpdateResponse.fromJson(data);
  }
}

final adminUsersApiProvider = Provider<AdminUsersApi>(
  (ref) => AdminUsersApi(ref.watch(apiClientProvider)),
);
