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
      'disabled' => DriverRegistrationStatus.disabled,
      'suspended' => DriverRegistrationStatus.disabled,
      'invited' => DriverRegistrationStatus.invited,
      _ => DriverRegistrationStatus.pending,
    };
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

  factory DriverAccessProfile.fromJson(Map<String, dynamic> json) {
    return DriverAccessProfile(
      id: json['id']?.toString() ?? '',
      displayName: json['displayName']?.toString() ?? json['name']?.toString() ?? '—',
      companyName: json['companyName']?.toString() ?? '—',
      companyId: json['companyId']?.toString() ?? '',
      registrationStatus: DriverRegistrationStatus.fromBackend(
        json['status']?.toString() ?? json['registrationStatus']?.toString(),
      ),
      lastActivityAt: DateTime.tryParse(json['lastActivityAt']?.toString() ?? ''),
      deviceLabel: json['deviceLabel']?.toString(),
      activeSessionCount: int.tryParse(json['activeSessionCount']?.toString() ?? '') ?? 0,
      metadataOnly: json['metadataOnly'] != false,
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
