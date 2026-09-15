class AdminDeviceRegistration {
  const AdminDeviceRegistration({
    required this.deviceId,
    required this.platform,
    required this.environment,
    required this.appVersion,
    required this.appBuild,
    this.pushProvider,
    this.pushToken,
    this.inAppOnly = true,
  });

  final String deviceId;
  final String platform;
  final String environment;
  final String appVersion;
  final String appBuild;
  final String? pushProvider;
  final String? pushToken;
  final bool inAppOnly;

  Map<String, dynamic> toJson() {
    return {
      'deviceId': deviceId,
      'platform': platform,
      'environment': environment,
      'appVersion': appVersion,
      'appBuild': appBuild,
      if (pushProvider != null && pushProvider!.isNotEmpty)
        'pushProvider': pushProvider,
      if (pushToken != null && pushToken!.isNotEmpty) 'pushToken': pushToken,
      'inAppOnly': inAppOnly,
    };
  }
}
