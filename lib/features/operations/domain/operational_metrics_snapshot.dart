/// Privacy-safe aggregates from GET /platform-admin/operational-metrics.
class OperationalMetricsSnapshot {
  const OperationalMetricsSnapshot({
    required this.metadataOnly,
    required this.exchangeRecordsTotal,
    required this.exchangeDisputed,
    required this.exchangeDamaged,
    required this.exchangeMissing,
    required this.pendingSyncCount,
    required this.pendingSyncSourceUnavailable,
    required this.driversActive,
    required this.driversDisabled,
    required this.driversPending,
  });

  final bool metadataOnly;
  final int exchangeRecordsTotal;
  final int exchangeDisputed;
  final int exchangeDamaged;
  final int exchangeMissing;
  final int? pendingSyncCount;
  final bool pendingSyncSourceUnavailable;
  final int driversActive;
  final int driversDisabled;
  final int driversPending;

  factory OperationalMetricsSnapshot.fromJson(Map<String, dynamic> json) {
    final exchange = _map(json['exchangeRecords']);
    final pendingSync = _map(json['pendingSync']);
    final drivers = _map(json['drivers']);

    return OperationalMetricsSnapshot(
      metadataOnly: json['metadataOnly'] != false,
      exchangeRecordsTotal: _int(exchange['total']),
      exchangeDisputed: _int(exchange['disputed']),
      exchangeDamaged: _int(exchange['damaged']),
      exchangeMissing: _int(exchange['missing']),
      pendingSyncCount: pendingSync['count'] == null
          ? null
          : _int(pendingSync['count']),
      pendingSyncSourceUnavailable: pendingSync['sourceUnavailable'] == true,
      driversActive: _int(drivers['active']),
      driversDisabled: _int(drivers['disabled']),
      driversPending: _int(drivers['pending']),
    );
  }

  static Map<String, dynamic> _map(Object? raw) {
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) return raw.map((k, v) => MapEntry(k.toString(), v));
    return const {};
  }

  static int _int(Object? raw) {
    if (raw is int) return raw;
    return int.tryParse(raw?.toString() ?? '') ?? 0;
  }
}
