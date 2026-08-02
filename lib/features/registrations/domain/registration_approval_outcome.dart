/// Outcome returned by PATCH .../registration-applications/:id/approve
/// and POST .../applications/:id/approve conversion payload.
class RegistrationApprovalOutcome {
  const RegistrationApprovalOutcome({
    required this.companyId,
    required this.companyName,
    required this.adminEmail,
    required this.emailInviteSent,
    required this.inviteDeliveryStatus,
    this.inviteExpiresAt,
    this.inviteTokenId,
    this.activationUrl,
    this.activationUrlHost,
    this.recipientEmailMasked,
    this.recipientSource,
    this.templateKey,
    this.retryAllowed = true,
    this.passwordSetupRequired,
    this.userCreated,
    this.userResolved,
  });

  final String? companyId;
  final String? companyName;
  final String? adminEmail;
  final bool emailInviteSent;
  final String inviteDeliveryStatus;
  final DateTime? inviteExpiresAt;
  final String? inviteTokenId;
  final String? activationUrl;
  final String? activationUrlHost;
  final String? recipientEmailMasked;
  final String? recipientSource;
  final String? templateKey;
  final bool retryAllowed;
  final bool? passwordSetupRequired;
  final bool? userCreated;
  final bool? userResolved;

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

    // Support both registration-applications root and applications.conversion.
    final root = json['conversion'] is Map
        ? Map<String, dynamic>.from(json['conversion'] as Map)
        : json;

    final companyId = root['companyId']?.toString();
    final companyName = root['companyName']?.toString();
    final admin = root['adminUser'];
    final adminEmail = admin is Map
        ? admin['email']?.toString()
        : root['adminEmail']?.toString();
    final invite = root['invite'];
    final inviteMap = invite is Map ? Map<String, dynamic>.from(invite) : null;
    final emailInviteSent = root['emailInviteSent'] == true;
    final delivery =
        root['emailInviteDeliveryStatus']?.toString() ??
        root['deliveryStatus']?.toString() ??
        (emailInviteSent ? 'sent' : 'pending_or_failed');

    DateTime? expiresAt;
    final rawExpires =
        inviteMap?['expiresAt']?.toString() ?? root['expiresAt']?.toString();
    if (rawExpires != null) {
      expiresAt = DateTime.tryParse(rawExpires);
    }

    final activationUrl =
        root['activationUrl']?.toString() ??
        inviteMap?['activationUrl']?.toString() ??
        (inviteMap?['preview'] is Map
            ? (inviteMap!['preview'] as Map)['acceptInviteUrl']?.toString()
            : null);

    return RegistrationApprovalOutcome(
      companyId: companyId,
      companyName: companyName,
      adminEmail: adminEmail,
      emailInviteSent: emailInviteSent,
      inviteDeliveryStatus: delivery,
      inviteExpiresAt: expiresAt,
      inviteTokenId:
          inviteMap?['tokenId']?.toString() ??
          inviteMap?['inviteId']?.toString() ??
          root['inviteId']?.toString(),
      activationUrl: activationUrl,
      activationUrlHost: root['activationUrlHost']?.toString(),
      recipientEmailMasked: root['recipientEmailMasked']?.toString(),
      recipientSource: root['recipientSource']?.toString(),
      templateKey: root['templateKey']?.toString(),
      retryAllowed: root['retryAllowed'] != false,
      passwordSetupRequired: root['passwordSetupRequired'] as bool?,
      userCreated: root['userCreated'] as bool?,
      userResolved: root['userResolved'] as bool?,
    );
  }
}
