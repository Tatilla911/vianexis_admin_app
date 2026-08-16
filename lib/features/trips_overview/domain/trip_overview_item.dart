enum TripOverviewStatus {
  active,
  completed,
  parked,
  pending,
  unknown;

  String get localizationKey => switch (this) {
    active => 'tripsOverviewStatusActive',
    completed => 'tripsOverviewStatusCompleted',
    parked => 'tripsOverviewStatusParked',
    pending => 'tripsOverviewStatusPending',
    unknown => 'tripsOverviewStatusUnknown',
  };
}

/// Map backend TripStatus to a display bucket without collapsing truth.
/// Unknown / future / diagnostic states (e.g. completion_pending) stay unknown,
/// never active.
TripOverviewStatus mapTripOverviewStatus(String? raw) {
  return switch (raw?.trim().toLowerCase()) {
    'active' => TripOverviewStatus.active,
    'completed' => TripOverviewStatus.completed,
    'parked' => TripOverviewStatus.parked,
    'pending' => TripOverviewStatus.pending,
    _ => TripOverviewStatus.unknown,
  };
}

String normalizeTripCanonicalStatus(String? raw) {
  final v = raw?.trim().toLowerCase() ?? '';
  return v.isEmpty ? 'unknown' : v;
}

/// Localized label when the backend value matches a known bucket;
/// otherwise the canonical backend status (diagnostic truth).
String tripOverviewDiagnosticStatusLabel({
  required TripOverviewStatus status,
  required String canonicalStatus,
  required String Function(String key) resolve,
}) {
  if (status == TripOverviewStatus.unknown) {
    return canonicalStatus.isEmpty ? 'unknown' : canonicalStatus;
  }
  return resolve(status.localizationKey);
}

/// Privacy-safe trip operations row — no document/message content.
class TripOverviewItem {
  const TripOverviewItem({
    required this.id,
    required this.reference,
    required this.companyName,
    required this.driverName,
    required this.status,
    required this.canonicalStatus,
    required this.hasExchangeRecords,
    required this.hasExchangeAttention,
    required this.hasPackage,
    required this.pendingSyncWarning,
    this.metadataOnly = true,
  });

  final String id;
  final String reference;
  final String companyName;
  final String driverName;
  final TripOverviewStatus status;
  final String canonicalStatus;
  final bool hasExchangeRecords;
  final bool hasExchangeAttention;
  final bool hasPackage;
  final bool pendingSyncWarning;
  final bool metadataOnly;

  factory TripOverviewItem.fromJson(Map<String, dynamic> json) {
    final rawStatus = json['status']?.toString();
    return TripOverviewItem(
      id: json['id']?.toString() ?? '',
      reference:
          json['reference']?.toString() ??
          json['tripReference']?.toString() ??
          json['tripNumber']?.toString() ??
          '—',
      companyName: json['companyName']?.toString() ?? '—',
      driverName: json['driverName']?.toString() ?? '—',
      status: mapTripOverviewStatus(rawStatus),
      canonicalStatus: normalizeTripCanonicalStatus(rawStatus),
      hasExchangeRecords:
          json['hasExchangeRecords'] == true ||
          (int.tryParse(json['exchangeRecordCount']?.toString() ?? '') ?? 0) >
              0,
      hasExchangeAttention: json['hasExchangeAttention'] == true,
      hasPackage:
          json['hasPackage'] == true ||
          (int.tryParse(json['packageCount']?.toString() ?? '') ?? 0) > 0,
      pendingSyncWarning: json['pendingSyncWarning'] == true,
      metadataOnly: json['metadataOnly'] != false,
    );
  }
}

class TripOverviewListResult {
  const TripOverviewListResult({
    required this.items,
    required this.listEndpointReady,
    required this.metadataOnly,
  });

  final List<TripOverviewItem> items;
  final bool listEndpointReady;
  final bool metadataOnly;
}
