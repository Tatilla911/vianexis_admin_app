class ReleaseOverview {
  const ReleaseOverview({
    required this.backendVersion,
    required this.environment,
    required this.nodeEnv,
    required this.databaseMigrationStatus,
    required this.maintenanceMode,
    this.backendCommit,
    this.latestAdminAppVersion,
    this.latestDriverAppVersion,
    this.minimumSupportedDriverAppVersion,
    this.minimumSupportedAdminAppVersion,
    this.activeDriverAppVersions,
    this.activeAdminAppVersions,
    this.lastDeploymentAt,
    this.apiBaseUrlPublicName,
    this.metadataOnly = true,
  });

  final String backendVersion;
  final String? backendCommit;
  final String environment;
  final String nodeEnv;
  final String databaseMigrationStatus;
  final String? latestAdminAppVersion;
  final String? latestDriverAppVersion;
  final String? minimumSupportedDriverAppVersion;
  final String? minimumSupportedAdminAppVersion;
  final Map<String, int>? activeDriverAppVersions;
  final Map<String, int>? activeAdminAppVersions;
  final DateTime? lastDeploymentAt;
  final bool maintenanceMode;
  final String? apiBaseUrlPublicName;
  final bool metadataOnly;

  factory ReleaseOverview.fromJson(Map<String, dynamic> json) {
    return ReleaseOverview(
      backendVersion: json['backendVersion']?.toString() ?? '—',
      backendCommit: json['backendCommit']?.toString(),
      environment: json['environment']?.toString() ?? 'unknown',
      nodeEnv: json['nodeEnv']?.toString() ?? 'development',
      databaseMigrationStatus:
          json['databaseMigrationStatus']?.toString() ?? 'unknown',
      latestAdminAppVersion: json['latestAdminAppVersion']?.toString(),
      latestDriverAppVersion: json['latestDriverAppVersion']?.toString(),
      minimumSupportedDriverAppVersion:
          json['minimumSupportedDriverAppVersion']?.toString(),
      minimumSupportedAdminAppVersion:
          json['minimumSupportedAdminAppVersion']?.toString(),
      activeDriverAppVersions: _parseVersionMap(json['activeDriverAppVersions']),
      activeAdminAppVersions: _parseVersionMap(json['activeAdminAppVersions']),
      lastDeploymentAt: _parseDate(json['lastDeploymentAt']),
      maintenanceMode: json['maintenanceMode'] == true,
      apiBaseUrlPublicName: json['apiBaseUrlPublicName']?.toString(),
      metadataOnly: json['metadataOnly'] != false,
    );
  }
}

class ReleaseAppVersions {
  const ReleaseAppVersions({
    this.latestAdminAppVersion,
    this.latestDriverAppVersion,
    this.minimumSupportedDriverAppVersion,
    this.minimumSupportedAdminAppVersion,
    this.activeDriverAppVersions,
    this.activeAdminAppVersions,
    this.metadataOnly = true,
  });

  final String? latestAdminAppVersion;
  final String? latestDriverAppVersion;
  final String? minimumSupportedDriverAppVersion;
  final String? minimumSupportedAdminAppVersion;
  final Map<String, int>? activeDriverAppVersions;
  final Map<String, int>? activeAdminAppVersions;
  final bool metadataOnly;

  factory ReleaseAppVersions.fromJson(Map<String, dynamic> json) {
    return ReleaseAppVersions(
      latestAdminAppVersion: json['latestAdminAppVersion']?.toString(),
      latestDriverAppVersion: json['latestDriverAppVersion']?.toString(),
      minimumSupportedDriverAppVersion:
          json['minimumSupportedDriverAppVersion']?.toString(),
      minimumSupportedAdminAppVersion:
          json['minimumSupportedAdminAppVersion']?.toString(),
      activeDriverAppVersions: _parseVersionMap(json['activeDriverAppVersions']),
      activeAdminAppVersions: _parseVersionMap(json['activeAdminAppVersions']),
      metadataOnly: json['metadataOnly'] != false,
    );
  }
}

class ReleaseEnvironment {
  const ReleaseEnvironment({
    required this.environment,
    required this.nodeEnv,
    required this.databaseMigrationStatus,
    required this.maintenanceMode,
    required this.deploymentReady,
    this.backendVersion,
    this.backendCommit,
    this.lastDeploymentAt,
    this.apiBaseUrlPublicName,
    this.deploymentWarnings = const [],
    this.metadataOnly = true,
  });

  final String environment;
  final String nodeEnv;
  final String? backendVersion;
  final String? backendCommit;
  final String databaseMigrationStatus;
  final DateTime? lastDeploymentAt;
  final bool maintenanceMode;
  final String? apiBaseUrlPublicName;
  final bool deploymentReady;
  final List<String> deploymentWarnings;
  final bool metadataOnly;

  factory ReleaseEnvironment.fromJson(Map<String, dynamic> json) {
    final rawWarnings = json['deploymentWarnings'];
    return ReleaseEnvironment(
      environment: json['environment']?.toString() ?? 'unknown',
      nodeEnv: json['nodeEnv']?.toString() ?? 'development',
      backendVersion: json['backendVersion']?.toString(),
      backendCommit: json['backendCommit']?.toString(),
      databaseMigrationStatus:
          json['databaseMigrationStatus']?.toString() ?? 'unknown',
      lastDeploymentAt: _parseDate(json['lastDeploymentAt']),
      maintenanceMode: json['maintenanceMode'] == true,
      apiBaseUrlPublicName: json['apiBaseUrlPublicName']?.toString(),
      deploymentReady: json['deploymentReady'] == true,
      deploymentWarnings: rawWarnings is List
          ? rawWarnings.map((item) => item.toString()).toList(growable: false)
          : const [],
      metadataOnly: json['metadataOnly'] != false,
    );
  }
}

Map<String, int>? _parseVersionMap(Object? raw) {
  if (raw is! Map) return null;
  return raw.map(
    (key, value) => MapEntry(
      key.toString(),
      value is int ? value : int.tryParse(value.toString()) ?? 0,
    ),
  );
}

DateTime? _parseDate(Object? raw) {
  if (raw == null) return null;
  return DateTime.tryParse(raw.toString());
}
