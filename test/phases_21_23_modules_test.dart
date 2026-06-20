import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/action_center/data/action_center_repository.dart';
import 'package:vianexis_admin_app/features/action_center/domain/action_center_filter.dart';
import 'package:vianexis_admin_app/features/action_center/domain/action_center_item.dart';
import 'package:vianexis_admin_app/features/action_center/domain/action_center_item_type.dart';
import 'package:vianexis_admin_app/features/action_center/presentation/action_center_providers.dart';
import 'package:vianexis_admin_app/features/security_center/data/security_center_repository.dart';
import 'package:vianexis_admin_app/features/security_center/domain/security_event.dart';
import 'package:vianexis_admin_app/features/security_center/domain/security_event_filter.dart';
import 'package:vianexis_admin_app/features/security_center/domain/security_event_severity.dart';
import 'package:vianexis_admin_app/features/security_center/domain/security_event_type.dart';
import 'package:vianexis_admin_app/features/security_center/domain/security_overview.dart';
import 'package:vianexis_admin_app/features/security_center/presentation/security_center_providers.dart';
import 'package:vianexis_admin_app/features/release_center/data/release_center_repository.dart';

void main() {
  group('SecurityOverview JSON', () {
    test('parses metadata-only overview counts', () {
      final overview = SecurityOverview.fromJson({
        'metadataOnly': true,
        'failedLoginCount': 3,
        'permissionDeniedCount': 2,
        'activeSupportGrantsCount': 4,
        'expiringSupportGrantsCount': 1,
        'highRiskAiReviewsCount': 1,
        'criticalSystemHealthEventsCount': 2,
        'suspiciousBulkOnboardingJobsCount': 1,
        'adminRoleChangesCount': 5,
      });

      expect(overview.metadataOnly, isTrue);
      expect(overview.failedLoginCount, 3);
      expect(overview.criticalSecurityEventsCount, 8);
    });
  });

  group('filteredSecurityEvents', () {
    final events = [
      SecurityEvent(
        id: '1',
        type: SecurityEventType.failedLogin,
        severity: SecurityEventSeverity.warning,
        title: 'Failed login',
        summary: 'A',
        sourceType: 'audit',
      ),
      SecurityEvent(
        id: '2',
        type: SecurityEventType.criticalSystem,
        severity: SecurityEventSeverity.critical,
        title: 'Critical',
        summary: 'B',
        sourceType: 'health',
      ),
    ];

    test('filters by severity critical', () {
      final filtered = filteredSecurityEvents(
        items: events,
        query: const SecurityEventListQuery(filter: SecurityEventFilter.critical),
      );
      expect(filtered, hasLength(1));
      expect(filtered.first.id, '2');
    });

    test('filters by type failed login', () {
      final filtered = filteredSecurityEvents(
        items: events,
        query: const SecurityEventListQuery(filter: SecurityEventFilter.failedLogin),
      );
      expect(filtered, hasLength(1));
      expect(filtered.first.type, SecurityEventType.failedLogin);
    });
  });

  group('MockSecurityCenterRepository', () {
    test('returns mock security overview and events', () async {
      final repo = MockSecurityCenterRepository();
      expect(repo.usesMockData, isTrue);

      final overview = await repo.fetchOverview();
      expect(overview.failedLoginCount, greaterThan(0));

      final events = await repo.fetchEvents(
        type: SecurityEventType.adminRoleChange,
      );
      expect(events.every((event) => event.type == SecurityEventType.adminRoleChange), isTrue);
    });
  });

  group('ActionCenterSnapshot', () {
    test('computes needs attention counts', () {
      const snapshot = ActionCenterSnapshot(
        items: [
          ActionCenterItem(
            id: '1',
            type: ActionCenterItemType.support,
            priority: ActionCenterPriority.critical,
            title: 'A',
            summary: 'A',
            sourceType: 'ticket',
            sourceId: '1',
            status: ActionCenterStatus.open,
          ),
          ActionCenterItem(
            id: '2',
            type: ActionCenterItemType.billing,
            priority: ActionCenterPriority.normal,
            title: 'B',
            summary: 'B',
            sourceType: 'sub',
            sourceId: '2',
            status: ActionCenterStatus.resolved,
          ),
        ],
      );

      expect(snapshot.needsAttentionCount, 1);
      expect(snapshot.criticalCount, 1);
    });
  });

  group('filteredActionCenterItems', () {
    test('filters by critical priority', () {
      final items = [
        ActionCenterItem(
          id: '1',
          type: ActionCenterItemType.security,
          priority: ActionCenterPriority.critical,
          title: 'Critical',
          summary: 'A',
          sourceType: 'security',
          sourceId: '1',
          status: ActionCenterStatus.open,
        ),
        ActionCenterItem(
          id: '2',
          type: ActionCenterItemType.billing,
          priority: ActionCenterPriority.normal,
          title: 'Normal',
          summary: 'B',
          sourceType: 'billing',
          sourceId: '2',
          status: ActionCenterStatus.open,
        ),
      ];

      final filtered = filteredActionCenterItems(
        items: items,
        query: const ActionCenterListQuery(filter: ActionCenterFilter.critical),
      );

      expect(filtered, hasLength(1));
      expect(filtered.first.priority, ActionCenterPriority.critical);
    });
  });

  group('MockActionCenterRepository', () {
    test('returns mock action center snapshot', () async {
      final repo = MockActionCenterRepository();
      expect(repo.usesMockData, isTrue);

      final snapshot = await repo.fetchActionCenter();
      expect(snapshot.items, isNotEmpty);
      expect(snapshot.needsAttentionCount, greaterThan(0));
    });
  });

  group('MockReleaseCenterRepository', () {
    test('returns mock release metadata', () async {
      final repo = MockReleaseCenterRepository();
      expect(repo.usesMockData, isTrue);

      final overview = await repo.fetchOverview();
      expect(overview.metadataOnly, isTrue);
      expect(overview.backendVersion, isNotEmpty);

      final versions = await repo.fetchAppVersions();
      expect(versions.latestAdminAppVersion, isNotNull);

      final environment = await repo.fetchEnvironment();
      expect(environment.deploymentReady, isTrue);
    });
  });
}
