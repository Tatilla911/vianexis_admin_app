enum TripOverviewStatus {
  active,
  completed,
  parked,
  pending;

  String get localizationKey => switch (this) {
    active => 'tripsOverviewStatusActive',
    completed => 'tripsOverviewStatusCompleted',
    parked => 'tripsOverviewStatusParked',
    pending => 'tripsOverviewStatusPending',
  };
}

/// Privacy-safe trip operations row — no document/message content.
class TripOverviewItem {
  const TripOverviewItem({
    required this.id,
    required this.reference,
    required this.companyName,
    required this.driverName,
    required this.status,
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
  final bool hasExchangeRecords;
  final bool hasExchangeAttention;
  final bool hasPackage;
  final bool pendingSyncWarning;
  final bool metadataOnly;

  factory TripOverviewItem.fromJson(Map<String, dynamic> json) {
    return TripOverviewItem(
      id: json['id']?.toString() ?? '',
      reference:
          json['reference']?.toString() ??
          json['tripReference']?.toString() ??
          json['tripNumber']?.toString() ??
          '—',
      companyName: json['companyName']?.toString() ?? '—',
      driverName: json['driverName']?.toString() ?? '—',
      status: _statusFrom(json['status']?.toString()),
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

  static TripOverviewStatus _statusFrom(String? raw) {
    return switch (raw?.toLowerCase()) {
      'completed' => TripOverviewStatus.completed,
      'parked' => TripOverviewStatus.parked,
      'pending' => TripOverviewStatus.pending,
      'assigned' => TripOverviewStatus.pending,
      _ => TripOverviewStatus.active,
    };
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
