import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/driver_access/domain/driver_access_profile.dart';
import 'package:vianexis_admin_app/features/driver_access/domain/driver_operational_health_detail.dart';

void main() {
  group('DriverOperationalHealthSummary', () {
    test('is null when missing so UI does not invent healthy status', () {
      expect(DriverOperationalHealthSummary.fromJson(null), isNull);
      expect(DriverOperationalHealthSummary.fromJson({}), isNull);
      expect(
        DriverAccessProfile.fromJson({
          'id': 'd-1',
          'displayName': 'Ada',
          'companyName': 'Acme',
          'companyId': '9',
          'status': 'active',
        }).operationalHealth,
        isNull,
      );
    });

    test('parses yellow summary from list payload', () {
      final summary = DriverOperationalHealthSummary.fromJson({
        'level': 'yellow',
        'activeIssueCount': 1,
        'labelKey': 'driverHealth.warning',
      });
      expect(summary, isNotNull);
      expect(summary!.level, DriverOperationalHealthLevel.yellow);
      expect(summary.activeIssueCount, 1);

      final profile = DriverAccessProfile.fromJson({
        'id': 'd-1',
        'displayName': 'Ada',
        'companyName': 'Acme',
        'companyId': '9',
        'status': 'active',
        'operationalHealth': {'level': 'yellow', 'activeIssueCount': 1},
      });
      expect(
        profile.operationalHealth?.level,
        DriverOperationalHealthLevel.yellow,
      );
    });
  });

  group('DriverOperationalHealthDetail', () {
    test('parses issues without payload fields', () {
      final detail = DriverOperationalHealthDetail.fromJson({
        'overallLevel': 'yellow',
        'activeIssueCount': 1,
        'remoteRetryPossible': false,
        'issues': [
          {
            'id': '9',
            'category': 'profile_sync',
            'code': 'sync.profile.failed',
            'severity': 'yellow',
            'status': 'active',
            'attemptCount': 1,
            'lastAttemptedAt': '2026-09-02T10:00:00.000Z',
            'safeErrorCode': 'network',
            'payloadIncluded': false,
          },
        ],
      });
      expect(detail.overallLevel, DriverOperationalHealthLevel.yellow);
      expect(detail.issues, hasLength(1));
      expect(detail.issues.first.category, 'profile_sync');
      expect(detail.issues.first.safeErrorCode, 'network');
      expect(detail.remoteRetryPossible, isFalse);
    });

    test('resolved empty detail stays green', () {
      final detail = DriverOperationalHealthDetail.fromJson({
        'overallLevel': 'green',
        'activeIssueCount': 0,
        'issues': [],
      });
      expect(detail.overallLevel, DriverOperationalHealthLevel.green);
      expect(detail.issues, isEmpty);
    });
  });
}
