enum DriverOperationalHealthLevel {
  green,
  yellow,
  red;

  static DriverOperationalHealthLevel fromBackend(String? raw) {
    return switch (raw?.toLowerCase()) {
      'yellow' => DriverOperationalHealthLevel.yellow,
      'red' => DriverOperationalHealthLevel.red,
      'green' => DriverOperationalHealthLevel.green,
      _ => DriverOperationalHealthLevel.green,
    };
  }

  String get localizationKey => switch (this) {
    DriverOperationalHealthLevel.green => 'driverHealthOk',
    DriverOperationalHealthLevel.yellow => 'driverHealthWarning',
    DriverOperationalHealthLevel.red => 'driverHealthActionRequired',
  };
}

class DriverOperationalHealthSummary {
  const DriverOperationalHealthSummary({
    required this.level,
    required this.activeIssueCount,
    this.labelKey,
  });

  final DriverOperationalHealthLevel level;
  final int activeIssueCount;
  final String? labelKey;

  /// Returns null when the list payload omitted operational health so the UI
  /// does not invent a healthy status.
  static DriverOperationalHealthSummary? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    final rawLevel = json['level']?.toString().trim();
    if (rawLevel == null || rawLevel.isEmpty) return null;
    return DriverOperationalHealthSummary(
      level: DriverOperationalHealthLevel.fromBackend(rawLevel),
      activeIssueCount:
          int.tryParse(json['activeIssueCount']?.toString() ?? '') ?? 0,
      labelKey: json['labelKey']?.toString(),
    );
  }
}

enum DriverRegistrationStatus {
  pending,
  active,
  disabled,
  invited;

  String get localizationKey => switch (this) {
    pending => 'driverAccessStatusPending',
    active => 'driverAccessStatusActive',
    disabled => 'driverAccessStatusDisabled',
    invited => 'driverAccessStatusInvited',
  };

  static DriverRegistrationStatus fromBackend(String? raw) {
    return switch (raw?.toLowerCase()) {
      'pending' => DriverRegistrationStatus.pending,
      'active' => DriverRegistrationStatus.active,
      'disabled' ||
      'suspended' ||
      'inactive' => DriverRegistrationStatus.disabled,
      'invited' => DriverRegistrationStatus.invited,
      _ => DriverRegistrationStatus.pending,
    };
  }

  /// Prefer account lifecycle when present so invite/password UI matches server.
  static DriverRegistrationStatus resolve({
    String? profileStatus,
    String? userStatus,
  }) {
    final user = userStatus?.trim().toLowerCase();
    if (user == 'invited') return DriverRegistrationStatus.invited;
    if (user == 'pending') return DriverRegistrationStatus.pending;
    if (user == 'suspended' || user == 'disabled' || user == 'inactive') {
      return DriverRegistrationStatus.disabled;
    }
    if (user == 'active') {
      return fromBackend(profileStatus);
    }
    return fromBackend(profileStatus);
  }
}

/// Privacy-safe driver access metadata — no tokens, PIN, or message content.
class DriverAccessProfile {
  const DriverAccessProfile({
    required this.id,
    required this.displayName,
    required this.companyName,
    required this.companyId,
    required this.registrationStatus,
    this.lastActivityAt,
    this.deviceLabel,
    this.activeSessionCount = 0,
    this.metadataOnly = true,
    this.operationalHealth,
  });

  final String id;
  final String displayName;
  final String companyName;
  final String companyId;
  final DriverRegistrationStatus registrationStatus;
  final DateTime? lastActivityAt;
  final String? deviceLabel;
  final int activeSessionCount;
  final bool metadataOnly;
  final DriverOperationalHealthSummary? operationalHealth;

  factory DriverAccessProfile.fromJson(Map<String, dynamic> json) {
    final healthRaw = json['operationalHealth'];
    return DriverAccessProfile(
      id: json['id']?.toString() ?? '',
      displayName:
          json['displayName']?.toString() ?? json['name']?.toString() ?? '—',
      companyName: json['companyName']?.toString() ?? '—',
      companyId: json['companyId']?.toString() ?? '',
      registrationStatus: DriverRegistrationStatus.resolve(
        profileStatus:
            json['status']?.toString() ??
            json['registrationStatus']?.toString(),
        userStatus: json['userStatus']?.toString(),
      ),
      lastActivityAt: DateTime.tryParse(
        json['lastActivityAt']?.toString() ??
            json['lastSeenAt']?.toString() ??
            '',
      ),
      deviceLabel:
          json['deviceLabel']?.toString() ??
          json['devicePlatform']?.toString() ??
          (json['deviceRegistered'] == true ? 'registered' : null),
      activeSessionCount:
          int.tryParse(json['activeSessionCount']?.toString() ?? '') ??
          (json['deviceRegistered'] == true ? 1 : 0),
      metadataOnly: json['metadataOnly'] != false,
      operationalHealth: DriverOperationalHealthSummary.fromJson(
        healthRaw is Map<String, dynamic>
            ? healthRaw
            : (healthRaw is Map ? Map<String, dynamic>.from(healthRaw) : null),
      ),
    );
  }
}

class DriverAccessListResult {
  const DriverAccessListResult({
    required this.items,
    required this.listEndpointReady,
    required this.metadataOnly,
  });

  final List<DriverAccessProfile> items;
  final bool listEndpointReady;
  final bool metadataOnly;
}
