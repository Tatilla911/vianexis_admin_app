/// Active backend session row from `GET /auth/sessions`.
class AdminAuthSession {
  const AdminAuthSession({
    required this.id,
    required this.rememberDevice,
    required this.createdAt,
    required this.expiresAt,
    required this.isCurrent,
    this.deviceName,
    this.platform,
    this.appType,
    this.lastUsedAt,
  });

  final String id;
  final String? deviceName;
  final String? platform;
  final String? appType;
  final bool rememberDevice;
  final DateTime createdAt;
  final DateTime? lastUsedAt;
  final DateTime expiresAt;
  final bool isCurrent;

  factory AdminAuthSession.fromJson(Map<String, dynamic> json) {
    return AdminAuthSession(
      id: json['id']?.toString() ?? '',
      deviceName: _nullableString(json['deviceName']),
      platform: _nullableString(json['platform']),
      appType: _nullableString(json['appType']),
      rememberDevice: json['rememberDevice'] == true,
      createdAt: DateTime.parse(json['createdAt'].toString()),
      lastUsedAt: json['lastUsedAt'] == null
          ? null
          : DateTime.tryParse(json['lastUsedAt'].toString()),
      expiresAt: DateTime.parse(json['expiresAt'].toString()),
      isCurrent: json['isCurrent'] == true,
    );
  }

  static String? _nullableString(dynamic value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }
}
