/// Outcome returned by PATCH .../registration-applications/:id/approve.
class RegistrationApprovalOutcome {
  const RegistrationApprovalOutcome({
    required this.companyId,
    required this.companyName,
    required this.adminEmail,
    required this.emailInviteSent,
    required this.inviteDeliveryStatus,
    this.inviteExpiresAt,
    this.inviteTokenId,
  });

  final String? companyId;
  final String? companyName;
  final String? adminEmail;
  final bool emailInviteSent;
  final String inviteDeliveryStatus;
  final DateTime? inviteExpiresAt;
  final String? inviteTokenId;

  factory RegistrationApprovalOutcome.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const RegistrationApprovalOutcome(
        companyId: null,
        companyName: null,
        adminEmail: null,
        emailInviteSent: false,
        inviteDeliveryStatus: 'unknown',
      );
    }

    final companyId = json['companyId']?.toString();
    final companyName = json['companyName']?.toString();
    final admin = json['adminUser'];
    final adminEmail = admin is Map
        ? admin['email']?.toString()
        : json['adminEmail']?.toString();
    final invite = json['invite'];
    final inviteMap = invite is Map ? Map<String, dynamic>.from(invite) : null;
    final emailInviteSent = json['emailInviteSent'] == true;
    final delivery =
        json['emailInviteDeliveryStatus']?.toString() ??
        (emailInviteSent ? 'sent' : 'pending_or_failed');

    DateTime? expiresAt;
    final rawExpires = inviteMap?['expiresAt']?.toString();
    if (rawExpires != null) {
      expiresAt = DateTime.tryParse(rawExpires);
    }

    return RegistrationApprovalOutcome(
      companyId: companyId,
      companyName: companyName,
      adminEmail: adminEmail,
      emailInviteSent: emailInviteSent,
      inviteDeliveryStatus: delivery,
      inviteExpiresAt: expiresAt,
      inviteTokenId: inviteMap?['tokenId']?.toString(),
    );
  }
}
