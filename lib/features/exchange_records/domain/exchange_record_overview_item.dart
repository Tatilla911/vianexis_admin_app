enum ExchangeRecordStatusFilter {
  all,
  disputed,
  damaged,
  missing;

  String get localizationKey => switch (this) {
    all => 'exchangeRecordsFilterAll',
    disputed => 'exchangeRecordsFilterDisputed',
    damaged => 'exchangeRecordsFilterDamaged',
    missing => 'exchangeRecordsFilterMissing',
  };
}

/// Privacy-safe exchange record metadata.
class ExchangeRecordOverviewItem {
  const ExchangeRecordOverviewItem({
    required this.id,
    required this.recordType,
    required this.itemLabel,
    required this.tripId,
    required this.driverName,
    required this.status,
    required this.missingQuantity,
    required this.damagedQuantity,
    this.stopId,
    this.notesPreview,
    this.recordedAt,
    this.metadataOnly = true,
  });

  final String id;
  final String recordType;
  final String itemLabel;
  final String tripId;
  final String driverName;
  final String status;
  final int missingQuantity;
  final int damagedQuantity;
  final String? stopId;
  final String? notesPreview;
  final DateTime? recordedAt;
  final bool metadataOnly;

  bool get requiresAttention =>
      missingQuantity > 0 ||
      damagedQuantity > 0 ||
      status.toLowerCase() == 'disputed' ||
      status.toLowerCase() == 'damaged';

  factory ExchangeRecordOverviewItem.fromJson(Map<String, dynamic> json) {
    return ExchangeRecordOverviewItem(
      id: json['id']?.toString() ?? '',
      recordType: json['recordType']?.toString() ?? 'pallet',
      itemLabel:
          json['itemLabel']?.toString() ??
          json['itemName']?.toString() ??
          json['itemType']?.toString() ??
          json['palletType']?.toString() ??
          '—',
      tripId: json['tripId']?.toString() ?? '',
      driverName: json['driverName']?.toString() ?? '—',
      status: json['status']?.toString() ?? 'completed',
      missingQuantity:
          int.tryParse(json['missingQuantity']?.toString() ?? '') ?? 0,
      damagedQuantity:
          int.tryParse(json['damagedQuantity']?.toString() ?? '') ?? 0,
      stopId: json['stopId']?.toString(),
      notesPreview:
          json['notesPreview']?.toString() ??
          json['notes']?.toString() ??
          json['counterpartyName']?.toString(),
      recordedAt: DateTime.tryParse(json['recordedAt']?.toString() ?? ''),
      metadataOnly: json['metadataOnly'] != false,
    );
  }
}

class ExchangeRecordsListResult {
  const ExchangeRecordsListResult({
    required this.items,
    required this.listEndpointReady,
    required this.metadataOnly,
  });

  final List<ExchangeRecordOverviewItem> items;
  final bool listEndpointReady;
  final bool metadataOnly;
}
