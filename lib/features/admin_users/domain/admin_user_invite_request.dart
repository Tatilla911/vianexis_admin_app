import 'platform_admin_user_role.dart';

class AdminUserInviteRequest {
  const AdminUserInviteRequest({
    required this.email,
    required this.name,
    required this.role,
    this.note,
  });

  final String email;
  final String name;
  final PlatformAdminUserRole role;
  final String? note;

  Map<String, dynamic> toJson() {
    return {
      'email': email.trim(),
      'name': name.trim(),
      'role': role.backendValue,
      if (note != null && note!.trim().isNotEmpty) 'note': note!.trim(),
    };
  }
}

class AdminUserInviteResponse {
  const AdminUserInviteResponse({
    required this.user,
    this.inviteDeliveryPending = false,
    this.metadataOnly = true,
  });

  final PlatformAdminUserInviteResult user;
  final bool inviteDeliveryPending;
  final bool metadataOnly;

  factory AdminUserInviteResponse.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'];
    return AdminUserInviteResponse(
      user: userJson is Map<String, dynamic>
          ? PlatformAdminUserInviteResult.fromJson(userJson)
          : const PlatformAdminUserInviteResult(id: '', email: '', status: 'invited'),
      inviteDeliveryPending: json['inviteDeliveryPending'] == true,
      metadataOnly: json['metadataOnly'] != false,
    );
  }
}

class PlatformAdminUserInviteResult {
  const PlatformAdminUserInviteResult({
    required this.id,
    required this.email,
    required this.status,
  });

  final String id;
  final String email;
  final String status;

  factory PlatformAdminUserInviteResult.fromJson(Map<String, dynamic> json) {
    return PlatformAdminUserInviteResult(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      status: json['status']?.toString() ?? 'invited',
    );
  }
}
