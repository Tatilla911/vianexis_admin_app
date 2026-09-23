enum EmergencyStatus {
  active('ACTIVE'),
  acknowledged('ACKNOWLEDGED'),
  resolved('RESOLVED'),
  cancelledByDriver('CANCELLED_BY_DRIVER'),
  unknown('unknown');

  const EmergencyStatus(this.backendValue);
  final String backendValue;

  static EmergencyStatus fromBackendValue(String? raw) {
    final value = raw?.trim().toUpperCase();
    if (value == null || value.isEmpty) return EmergencyStatus.unknown;
    for (final item in EmergencyStatus.values) {
      if (item.backendValue == value) return item;
    }
    return EmergencyStatus.unknown;
  }

  bool get isActiveUnacknowledged => this == EmergencyStatus.active;
  bool get isOpen =>
      this == EmergencyStatus.active || this == EmergencyStatus.acknowledged;
}

enum EmergencyLocationStatus {
  fresh('FRESH'),
  lastKnown('LAST_KNOWN'),
  unavailable('UNAVAILABLE'),
  permissionDenied('PERMISSION_DENIED'),
  unknown('unknown');

  const EmergencyLocationStatus(this.backendValue);
  final String backendValue;

  static EmergencyLocationStatus fromBackendValue(String? raw) {
    final value = raw?.trim().toUpperCase();
    if (value == null || value.isEmpty) return EmergencyLocationStatus.unknown;
    for (final item in EmergencyLocationStatus.values) {
      if (item.backendValue == value) return item;
    }
    return EmergencyLocationStatus.unknown;
  }
}

class DriverEmergencyEvent {
  const DriverEmergencyEvent({
    required this.id,
    required this.companyId,
    required this.driverUserId,
    required this.status,
    required this.severity,
    required this.triggeredAt,
    required this.locationStatus,
    required this.companyNotificationStatus,
    required this.platformNotificationStatus,
    required this.adminPushStatus,
    this.driverNameSnapshot,
    this.vehiclePlateSnapshot,
    this.trailerPlateSnapshot,
    this.tripReferenceSnapshot,
    this.tripId,
    this.message,
    this.latitude,
    this.longitude,
    this.accuracyMeters,
    this.locationCapturedAt,
    this.locationSource,
    this.locality,
    this.administrativeArea,
    this.countryName,
    this.countryCode,
    this.roadName,
    this.acknowledgedAt,
    this.acknowledgedByUserId,
    this.resolvedAt,
    this.resolutionNote,
  });

  final String id;
  final String companyId;
  final String driverUserId;
  final EmergencyStatus status;
  final String severity;
  final DateTime? triggeredAt;
  final EmergencyLocationStatus locationStatus;
  final String companyNotificationStatus;
  final String platformNotificationStatus;
  final String adminPushStatus;
  final String? driverNameSnapshot;
  final String? vehiclePlateSnapshot;
  final String? trailerPlateSnapshot;
  final String? tripReferenceSnapshot;
  final String? tripId;
  final String? message;
  final double? latitude;
  final double? longitude;
  final double? accuracyMeters;
  final DateTime? locationCapturedAt;
  final String? locationSource;
  final String? locality;
  final String? administrativeArea;
  final String? countryName;
  final String? countryCode;
  final String? roadName;
  final DateTime? acknowledgedAt;
  final String? acknowledgedByUserId;
  final DateTime? resolvedAt;
  final String? resolutionNote;

  bool get hasExactCoordinates =>
      latitude != null &&
      longitude != null &&
      latitude!.isFinite &&
      longitude!.isFinite;

  factory DriverEmergencyEvent.fromJson(Map<String, dynamic> json) {
    return DriverEmergencyEvent(
      id: json['id']?.toString() ?? '',
      companyId: json['companyId']?.toString() ?? '',
      driverUserId: json['driverUserId']?.toString() ?? '',
      status: EmergencyStatus.fromBackendValue(json['status']?.toString()),
      severity: json['severity']?.toString() ?? 'CRITICAL',
      triggeredAt: DateTime.tryParse(json['triggeredAt']?.toString() ?? ''),
      locationStatus: EmergencyLocationStatus.fromBackendValue(
        json['locationStatus']?.toString(),
      ),
      companyNotificationStatus:
          json['companyNotificationStatus']?.toString() ?? '',
      platformNotificationStatus:
          json['platformNotificationStatus']?.toString() ?? '',
      adminPushStatus: json['adminPushStatus']?.toString() ?? '',
      driverNameSnapshot: json['driverNameSnapshot']?.toString(),
      vehiclePlateSnapshot: json['vehiclePlateSnapshot']?.toString(),
      trailerPlateSnapshot: json['trailerPlateSnapshot']?.toString(),
      tripReferenceSnapshot: json['tripReferenceSnapshot']?.toString(),
      tripId: json['tripId']?.toString(),
      message: json['message']?.toString(),
      latitude: _asDouble(json['latitude']),
      longitude: _asDouble(json['longitude']),
      accuracyMeters: _asDouble(json['accuracyMeters']),
      locationCapturedAt: DateTime.tryParse(
        json['locationCapturedAt']?.toString() ?? '',
      ),
      locationSource: json['locationSource']?.toString(),
      locality: json['locality']?.toString(),
      administrativeArea: json['administrativeArea']?.toString(),
      countryName: json['countryName']?.toString(),
      countryCode: json['countryCode']?.toString(),
      roadName: json['roadName']?.toString(),
      acknowledgedAt: DateTime.tryParse(json['acknowledgedAt']?.toString() ?? ''),
      acknowledgedByUserId: json['acknowledgedByUserId']?.toString(),
      resolvedAt: DateTime.tryParse(json['resolvedAt']?.toString() ?? ''),
      resolutionNote: json['resolutionNote']?.toString(),
    );
  }

  static double? _asDouble(Object? value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }
}

class DriverEmergencyListResult {
  const DriverEmergencyListResult({required this.items, required this.total});

  final List<DriverEmergencyEvent> items;
  final int total;

  factory DriverEmergencyListResult.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    final items = rawItems is List
        ? rawItems
              .whereType<Map>()
              .map(
                (item) => DriverEmergencyEvent.fromJson(
                  item.map((key, value) => MapEntry(key.toString(), value)),
                ),
              )
              .toList()
        : const <DriverEmergencyEvent>[];
    final total = json['total'];
    return DriverEmergencyListResult(
      items: items,
      total: total is int ? total : items.length,
    );
  }
}
