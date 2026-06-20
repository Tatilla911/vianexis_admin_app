import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/auth/admin_user.dart';
import '../domain/action_center_item.dart';
import '../domain/action_center_item_type.dart';
import 'action_center_api.dart';

abstract class ActionCenterRepository {
  Future<ActionCenterSnapshot> fetchActionCenter();

  bool get usesMockData;
}

class LiveActionCenterRepository implements ActionCenterRepository {
  LiveActionCenterRepository(this._api);

  final ActionCenterApi _api;

  @override
  bool get usesMockData => false;

  @override
  Future<ActionCenterSnapshot> fetchActionCenter() => _api.getActionCenter();
}

class MockActionCenterRepository implements ActionCenterRepository {
  MockActionCenterRepository();

  final List<ActionCenterItem> _items = [
    ActionCenterItem(
      id: 'registration:101',
      type: ActionCenterItemType.registration,
      priority: ActionCenterPriority.high,
      title: 'Registration application pending review',
      summary: 'Baltic Freight OÜ',
      sourceType: 'registration_application',
      sourceId: '101',
      companyName: 'Baltic Freight OÜ',
      createdAt: DateTime.utc(2026, 6, 18),
      status: ActionCenterStatus.open,
      actionRouteHint: '/registrations/101',
    ),
    ActionCenterItem(
      id: 'bulk_onboarding:502',
      type: ActionCenterItemType.bulkOnboarding,
      priority: ActionCenterPriority.urgent,
      title: 'Bulk onboarding needs review',
      summary: 'High Risk Cargo SRL — validation_failed',
      sourceType: 'bulk_onboarding_job',
      sourceId: '502',
      companyId: '6',
      companyName: 'High Risk Cargo SRL',
      createdAt: DateTime.utc(2026, 6, 17),
      status: ActionCenterStatus.open,
      actionRouteHint: '/bulk-onboarding/502',
    ),
    ActionCenterItem(
      id: 'support_ticket:33',
      type: ActionCenterItemType.support,
      priority: ActionCenterPriority.critical,
      title: 'Support ticket needs attention',
      summary: 'Upload queue stalled for company metadata scope',
      sourceType: 'support_ticket',
      sourceId: '33',
      companyId: '1',
      createdAt: DateTime.utc(2026, 6, 19, 6, 0),
      status: ActionCenterStatus.open,
      actionRouteHint: '/support/tickets/33',
    ),
    ActionCenterItem(
      id: 'subscription:104',
      type: ActionCenterItemType.billing,
      priority: ActionCenterPriority.urgent,
      title: 'Subscription past due',
      summary: 'Danube Spedition Zrt.',
      sourceType: 'company_subscription',
      sourceId: '104',
      companyId: '4',
      companyName: 'Danube Spedition Zrt.',
      createdAt: DateTime.utc(2026, 6, 12),
      dueAt: DateTime.utc(2026, 6, 12),
      status: ActionCenterStatus.open,
      actionRouteHint: '/billing/subscription/104',
    ),
    ActionCenterItem(
      id: 'security:audit:903',
      type: ActionCenterItemType.security,
      priority: ActionCenterPriority.critical,
      title: 'Platform admin access changed',
      summary: 'Role changed for billing@vianexis.test',
      sourceType: 'system_audit_log',
      sourceId: '903',
      createdAt: DateTime.utc(2026, 6, 16),
      status: ActionCenterStatus.open,
      actionRouteHint: '/security',
    ),
    ActionCenterItem(
      id: 'system_health:44',
      type: ActionCenterItemType.systemHealth,
      priority: ActionCenterPriority.high,
      title: 'Background worker backlog',
      summary: 'Queue depth exceeded warning threshold',
      sourceType: 'system_health_event',
      sourceId: '44',
      createdAt: DateTime.utc(2026, 6, 18),
      status: ActionCenterStatus.open,
      actionRouteHint: '/system-health/events/44',
    ),
  ];

  @override
  bool get usesMockData => true;

  @override
  Future<ActionCenterSnapshot> fetchActionCenter() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return ActionCenterSnapshot(items: List<ActionCenterItem>.from(_items));
  }

  ActionCenterSnapshot filteredForRole(AdminRole role) {
    final allowedTypes = _allowedTypesForRole(role);
    final filtered = _items
        .where((item) => allowedTypes.contains(item.type))
        .toList(growable: false);
    return ActionCenterSnapshot(items: filtered);
  }

  Set<ActionCenterItemType> _allowedTypesForRole(AdminRole role) {
    return switch (role) {
      AdminRole.superAdmin => ActionCenterItemType.values.toSet(),
      AdminRole.supportAdmin => {
        ActionCenterItemType.support,
        ActionCenterItemType.systemHealth,
        ActionCenterItemType.security,
        ActionCenterItemType.registration,
        ActionCenterItemType.company,
      },
      AdminRole.onboardingReviewer => {
        ActionCenterItemType.registration,
        ActionCenterItemType.bulkOnboarding,
        ActionCenterItemType.aiReview,
        ActionCenterItemType.company,
      },
      AdminRole.billingAdmin => {ActionCenterItemType.billing},
    };
  }
}

final actionCenterRepositoryProvider = Provider<ActionCenterRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  if (apiClient.isConfigured) {
    return LiveActionCenterRepository(ref.watch(actionCenterApiProvider));
  }
  return MockActionCenterRepository();
});
