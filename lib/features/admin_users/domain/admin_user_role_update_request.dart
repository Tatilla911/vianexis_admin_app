import 'platform_admin_user.dart';
import 'platform_admin_user_role.dart';
import 'platform_admin_user_status.dart';

class AdminUserRoleUpdateRequest {
  const AdminUserRoleUpdateRequest({
    required this.role,
    required this.reason,
  });

  final PlatformAdminUserRole role;
  final String reason;

  Map<String, dynamic> toJson() {
    return {
      'role': role.backendValue,
      'reason': reason.trim(),
    };
  }
}

class AdminUserRoleUpdateResponse {
  const AdminUserRoleUpdateResponse({
    required this.user,
    this.metadataOnly = true,
  });

  final PlatformAdminUser user;
  final bool metadataOnly;

  factory AdminUserRoleUpdateResponse.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'];
    return AdminUserRoleUpdateResponse(
      user: userJson is Map<String, dynamic>
          ? PlatformAdminUser.fromJson(userJson)
          : const PlatformAdminUser(
              id: '',
              email: '',
              role: PlatformAdminUserRole.unknown,
              status: PlatformAdminUserStatus.unknown,
            ),
      metadataOnly: json['metadataOnly'] != false,
    );
  }
}
