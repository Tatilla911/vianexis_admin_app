enum QrPurpose {
  userInvite('user_invite'),
  userActivation('user_activation'),
  passwordSetup('password_setup'),
  driverAppLink('driver_app_link'),
  driverProfile('driver_profile'),
  companyProfile('company_profile'),
  companyInvite('company_invite'),
  companyPortalLogin('company_portal_login'),
  companyOnboarding('company_onboarding'),
  supportReference('support_reference'),
  internalAdminRecord('internal_admin_record'),
  publicCompanyInfo('public_company_info'),
  publicDriverId('public_driver_id');

  const QrPurpose(this.apiValue);
  final String apiValue;

  static QrPurpose? tryParse(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    for (final value in QrPurpose.values) {
      if (value.apiValue == raw) return value;
    }
    return null;
  }

  String get l10nKey => switch (this) {
    QrPurpose.userInvite => 'qrCodesPurposeUserInvite',
    QrPurpose.userActivation => 'qrCodesPurposeUserActivation',
    QrPurpose.passwordSetup => 'qrCodesPurposePasswordSetup',
    QrPurpose.driverAppLink => 'qrCodesPurposeDriverAppLink',
    QrPurpose.driverProfile => 'qrCodesPurposeDriverProfile',
    QrPurpose.companyProfile => 'qrCodesPurposeCompanyProfile',
    QrPurpose.companyInvite => 'qrCodesPurposeCompanyInvite',
    QrPurpose.companyPortalLogin => 'qrCodesPurposeCompanyPortalLogin',
    QrPurpose.companyOnboarding => 'qrCodesPurposeCompanyOnboarding',
    QrPurpose.supportReference => 'qrCodesPurposeSupportReference',
    QrPurpose.internalAdminRecord => 'qrCodesPurposeInternalAdmin',
    QrPurpose.publicCompanyInfo => 'qrCodesPurposePublicCompany',
    QrPurpose.publicDriverId => 'qrCodesPurposePublicDriver',
  };
}

enum QrEntityType {
  user('user'),
  driver('driver'),
  company('company'),
  companyAdmin('company_admin');

  const QrEntityType(this.apiValue);
  final String apiValue;
}

class QrEmailDelivery {
  const QrEmailDelivery({
    this.sent,
    this.skipped,
    this.status,
    this.statusReason,
  });

  final bool? sent;
  final bool? skipped;
  final String? status;
  final String? statusReason;

  bool get isDeliveryDisabled {
    final normalized = (status ?? '').trim().toLowerCase();
    return skipped == true ||
        normalized == 'skipped' ||
        normalized == 'console' ||
        normalized == 'provider_not_configured';
  }

  bool get isSent => sent == true || (status ?? '').trim().toLowerCase() == 'sent';

  factory QrEmailDelivery.fromJson(Map<String, dynamic> json) {
    return QrEmailDelivery(
      sent: json['sent'] is bool ? json['sent'] as bool : null,
      skipped: json['skipped'] is bool ? json['skipped'] as bool : null,
      status: json['status']?.toString(),
      statusReason: json['statusReason']?.toString(),
    );
  }
}

class PlatformQrCode {
  const PlatformQrCode({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.displayName,
    required this.status,
    this.purpose,
    this.expiresAt,
    this.maxUses,
    this.usedCount = 0,
    this.resolveUrl,
    this.opaqueCode,
    this.qrPayload,
    this.environment,
    this.secure = false,
    this.consumedAt,
    this.revokedAt,
    this.lastUsedAt,
    this.createdAt,
    this.emailDelivery,
  });

  final int id;
  final String entityType;
  final int entityId;
  final String displayName;
  final String status;
  final String? purpose;
  final DateTime? expiresAt;
  final int? maxUses;
  final int usedCount;
  final String? resolveUrl;
  final String? opaqueCode;
  final String? qrPayload;
  final String? environment;
  final bool secure;
  final DateTime? consumedAt;
  final DateTime? revokedAt;
  final DateTime? lastUsedAt;
  final DateTime? createdAt;
  final QrEmailDelivery? emailDelivery;

  String? get displayPayload => resolveUrl ?? qrPayload;

  PlatformQrCode copyWith({
    int? id,
    String? entityType,
    int? entityId,
    String? displayName,
    String? status,
    String? purpose,
    DateTime? expiresAt,
    int? maxUses,
    int? usedCount,
    String? resolveUrl,
    String? opaqueCode,
    String? qrPayload,
    String? environment,
    bool? secure,
    DateTime? consumedAt,
    DateTime? revokedAt,
    DateTime? lastUsedAt,
    DateTime? createdAt,
    QrEmailDelivery? emailDelivery,
  }) {
    return PlatformQrCode(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      displayName: displayName ?? this.displayName,
      status: status ?? this.status,
      purpose: purpose ?? this.purpose,
      expiresAt: expiresAt ?? this.expiresAt,
      maxUses: maxUses ?? this.maxUses,
      usedCount: usedCount ?? this.usedCount,
      resolveUrl: resolveUrl ?? this.resolveUrl,
      opaqueCode: opaqueCode ?? this.opaqueCode,
      qrPayload: qrPayload ?? this.qrPayload,
      environment: environment ?? this.environment,
      secure: secure ?? this.secure,
      consumedAt: consumedAt ?? this.consumedAt,
      revokedAt: revokedAt ?? this.revokedAt,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      createdAt: createdAt ?? this.createdAt,
      emailDelivery: emailDelivery ?? this.emailDelivery,
    );
  }

  factory PlatformQrCode.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic value) {
      if (value is! String || value.isEmpty) return null;
      return DateTime.tryParse(value);
    }

    QrEmailDelivery? emailDelivery;
    final nested = json['emailDelivery'];
    if (nested is Map) {
      emailDelivery = QrEmailDelivery.fromJson(
        Map<String, dynamic>.from(nested),
      );
    } else if (json.containsKey('emailDeliveryStatus') ||
        json.containsKey('emailSent') ||
        json.containsKey('emailDeliverySkipped')) {
      emailDelivery = QrEmailDelivery(
        sent: json['emailSent'] == true,
        skipped: json['emailDeliverySkipped'] == true,
        status: json['emailDeliveryStatus']?.toString(),
        statusReason: json['emailDeliveryStatusReason']?.toString(),
      );
    }

    return PlatformQrCode(
      id: (json['id'] as num?)?.toInt() ?? 0,
      entityType: (json['entityType'] as String?) ?? '',
      entityId: (json['entityId'] as num?)?.toInt() ?? 0,
      displayName: (json['displayName'] as String?) ?? '',
      status: (json['status'] as String?) ?? 'active',
      purpose: json['purpose'] as String?,
      expiresAt: parseDate(json['expiresAt']),
      maxUses: (json['maxUses'] as num?)?.toInt(),
      usedCount: (json['usedCount'] as num?)?.toInt() ?? 0,
      resolveUrl: json['resolveUrl'] as String?,
      opaqueCode: json['opaqueCode'] as String?,
      qrPayload: json['qrPayload'] as String?,
      environment: json['environment'] as String?,
      secure: json['secure'] == true,
      consumedAt: parseDate(json['consumedAt']),
      revokedAt: parseDate(json['revokedAt']),
      lastUsedAt: parseDate(json['lastUsedAt']),
      createdAt: parseDate(json['createdAt']),
      emailDelivery: emailDelivery,
    );
  }
}

class CreatePlatformQrRequest {
  const CreatePlatformQrRequest({
    required this.entityType,
    required this.entityId,
    required this.displayName,
    required this.purpose,
    this.companyId,
    this.expiresInSeconds,
    this.maxUses,
    this.locale,
    this.notifyEmail,
    this.preferredLanguage,
    this.inviteeName,
  });

  final String entityType;
  final int entityId;
  final String displayName;
  final String purpose;
  final int? companyId;
  final int? expiresInSeconds;
  final int? maxUses;
  final String? locale;
  final String? notifyEmail;
  final String? preferredLanguage;
  final String? inviteeName;

  Map<String, dynamic> toJson() => {
    'entityType': entityType,
    'entityId': entityId,
    'displayName': displayName,
    'purpose': purpose,
    if (companyId != null) 'companyId': companyId,
    if (expiresInSeconds != null) 'expiresInSeconds': expiresInSeconds,
    if (maxUses != null) 'maxUses': maxUses,
    if (locale != null) 'locale': locale,
    if (notifyEmail != null && notifyEmail!.trim().isNotEmpty)
      'notifyEmail': notifyEmail!.trim(),
    if (preferredLanguage != null && preferredLanguage!.trim().isNotEmpty)
      'preferredLanguage': preferredLanguage!.trim(),
    if (inviteeName != null && inviteeName!.trim().isNotEmpty)
      'inviteeName': inviteeName!.trim(),
  };
}

class SendPlatformQrRequest {
  const SendPlatformQrRequest({
    this.notifyEmail,
    this.preferredLanguage,
    this.resolveUrl,
    this.sendEmail = true,
  });

  final String? notifyEmail;
  final String? preferredLanguage;
  final String? resolveUrl;
  final bool sendEmail;

  Map<String, dynamic> toJson() => {
    if (notifyEmail != null && notifyEmail!.trim().isNotEmpty)
      'notifyEmail': notifyEmail!.trim(),
    if (preferredLanguage != null && preferredLanguage!.trim().isNotEmpty)
      'preferredLanguage': preferredLanguage!.trim(),
    if (resolveUrl != null && resolveUrl!.trim().isNotEmpty)
      'resolveUrl': resolveUrl!.trim(),
    'sendEmail': sendEmail,
  };
}
