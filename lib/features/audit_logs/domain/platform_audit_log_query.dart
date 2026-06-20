import 'platform_audit_filter.dart';

class PlatformAuditLogListQuery {
  const PlatformAuditLogListQuery({
    this.search = '',
    this.filter = PlatformAuditLogFilter.all,
    this.dateFrom,
    this.dateTo,
  });

  final String search;
  final PlatformAuditLogFilter filter;
  final DateTime? dateFrom;
  final DateTime? dateTo;

  PlatformAuditLogListQuery copyWith({
    String? search,
    PlatformAuditLogFilter? filter,
    DateTime? dateFrom,
    DateTime? dateTo,
    bool clearDateFrom = false,
    bool clearDateTo = false,
  }) {
    return PlatformAuditLogListQuery(
      search: search ?? this.search,
      filter: filter ?? this.filter,
      dateFrom: clearDateFrom ? null : (dateFrom ?? this.dateFrom),
      dateTo: clearDateTo ? null : (dateTo ?? this.dateTo),
    );
  }

  Map<String, dynamic> toApiQuery({int limit = 200}) {
    return {
      'limit': limit,
      if (dateFrom != null) 'dateFrom': _formatDate(dateFrom!),
      if (dateTo != null) 'dateTo': _formatDate(dateTo!),
      ...filter.apiQueryParams(),
    };
  }

  static String _formatDate(DateTime value) {
    final utc = value.toUtc();
    return '${utc.year.toString().padLeft(4, '0')}-'
        '${utc.month.toString().padLeft(2, '0')}-'
        '${utc.day.toString().padLeft(2, '0')}';
  }
}
