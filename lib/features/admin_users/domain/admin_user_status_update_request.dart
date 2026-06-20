import 'platform_admin_user.dart';
import 'platform_admin_user_role.dart';
import 'platform_admin_user_status.dart';

class AdminUserStatusUpdateRequest {
  const AdminUserStatusUpdateRequest({
    required this.status,
    this.reason,
  });

  final PlatformAdminUserStatus status;
  final String? reason;

  Map<String, dynamic> toJson() {
    return {
      'status': status.backendValue,
      if (reason != null && reason!.trim().isNotEmpty) 'reason': reason!.trim(),
    };
  }
}

class AdminUserStatusUpdateResponse {
  const AdminUserStatusUpdateResponse({
    required this.user,
    this.metadataOnly = true,
  });

  final PlatformAdminUser user;
  final bool metadataOnly;

  factory AdminUserStatusUpdateResponse.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'];
    return AdminUserStatusUpdateResponse(
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
