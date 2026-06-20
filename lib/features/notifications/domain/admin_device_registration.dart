class AdminDeviceRegistration {
  const AdminDeviceRegistration({
    required this.deviceId,
    required this.platform,
    required this.environment,
    required this.appVersion,
    required this.appBuild,
    this.inAppOnly = true,
  });

  final String deviceId;
  final String platform;
  final String environment;
  final String appVersion;
  final String appBuild;
  final bool inAppOnly;

  Map<String, dynamic> toJson() {
    return {
      'deviceId': deviceId,
      'platform': platform,
      'environment': environment,
      'appVersion': appVersion,
      'appBuild': appBuild,
      'inAppOnly': inAppOnly,
    };
  }
}
