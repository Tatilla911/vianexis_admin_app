/// Metadata-only driver push registration from
/// GET /platform-admin/drivers/:id/device-notification-status.
class DriverDeviceNotificationStatus {
  const DriverDeviceNotificationStatus({
    required this.metadataOnly,
    required this.sourceUnavailable,
    required this.hasPushToken,
    this.tokenProvider,
    this.platform,
    this.appVersion,
    this.lastRegisteredAt,
    this.lastSeenAt,
    this.tokenLast4,
    this.deliveryEnabled,
    this.notificationPermissionStatus,
  });

  final bool metadataOnly;
  final bool sourceUnavailable;
  final bool hasPushToken;
  final String? tokenProvider;
  final String? platform;
  final String? appVersion;
  final DateTime? lastRegisteredAt;
  final DateTime? lastSeenAt;
  final String? tokenLast4;
  final Object? deliveryEnabled;
  final String? notificationPermissionStatus;

  factory DriverDeviceNotificationStatus.fromJson(Map<String, dynamic> json) {
    return DriverDeviceNotificationStatus(
      metadataOnly: json['metadataOnly'] != false,
      sourceUnavailable: json['sourceUnavailable'] == true,
      hasPushToken: json['hasPushToken'] == true,
      tokenProvider: json['tokenProvider']?.toString(),
      platform: json['platform']?.toString(),
      appVersion: json['appVersion']?.toString(),
      lastRegisteredAt: DateTime.tryParse(
        json['lastRegisteredAt']?.toString() ?? '',
      ),
      lastSeenAt: DateTime.tryParse(json['lastSeenAt']?.toString() ?? ''),
      tokenLast4: json['tokenLast4']?.toString(),
      deliveryEnabled: json['deliveryEnabled'],
      notificationPermissionStatus:
          json['notificationPermissionStatus']?.toString(),
    );
  }
}
