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

  String? get displayPayload => resolveUrl ?? qrPayload;

  factory PlatformQrCode.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic value) {
      if (value is! String || value.isEmpty) return null;
      return DateTime.tryParse(value);
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
  });

  final String entityType;
  final int entityId;
  final String displayName;
  final String purpose;
  final int? companyId;
  final int? expiresInSeconds;
  final int? maxUses;
  final String? locale;

  Map<String, dynamic> toJson() => {
    'entityType': entityType,
    'entityId': entityId,
    'displayName': displayName,
    'purpose': purpose,
    if (companyId != null) 'companyId': companyId,
    if (expiresInSeconds != null) 'expiresInSeconds': expiresInSeconds,
    if (maxUses != null) 'maxUses': maxUses,
    if (locale != null) 'locale': locale,
  };
}
