import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/audit_logs/domain/platform_audit_filter.dart';
import 'package:vianexis_admin_app/features/audit_logs/domain/platform_audit_log_query.dart';

void main() {
  test('toApiQuery maps date range and severity filter', () {
    final query = PlatformAuditLogListQuery(
      filter: PlatformAuditLogFilter.critical,
      dateFrom: DateTime.utc(2026, 6, 1),
      dateTo: DateTime.utc(2026, 6, 18),
    );

    expect(
      query.toApiQuery(limit: 100),
      {
        'limit': 100,
        'dateFrom': '2026-06-01',
        'dateTo': '2026-06-18',
        'severity': 'critical',
      },
    );
  });

  test('apiQueryParams maps denied filter to result', () {
    expect(
      PlatformAuditLogFilter.denied.apiQueryParams(),
      {'result': 'denied'},
    );
  });
}
