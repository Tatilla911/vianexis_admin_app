import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vianexis_admin_app/audio/vn_sound_definition.dart';
import 'package:vianexis_admin_app/audio/vn_sound_preferences.dart';
import 'package:vianexis_admin_app/audio/vn_sound_router.dart';
import 'package:vianexis_admin_app/features/notifications/domain/admin_notification.dart';
import 'package:vianexis_admin_app/features/notifications/domain/notification_severity.dart';
import 'package:vianexis_admin_app/features/notifications/domain/notification_type.dart';
import 'package:vianexis_admin_app/services/alerts/admin_alert_mapper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('maps critical system health to alarm event', () {
    final notification = AdminNotification(
      id: 'n-1',
      title: 'System health',
      body: 'Queue backlog',
      type: NotificationType.systemHealth,
      severity: NotificationSeverity.critical,
      createdAt: DateTime.utc(2026, 7, 31, 12),
    );
    expect(AdminAlertMapper.eventIdFor(notification), 'system_critical_state');
    expect(AdminAlertMapper.categoryFor(notification), VnSoundCategory.alarm);
    expect(AdminAlertMapper.isCritical(notification), isTrue);
  });

  test('maps support to message event', () {
    final notification = AdminNotification(
      id: 'n-2',
      title: 'Support',
      body: 'New ticket',
      type: NotificationType.support,
      severity: NotificationSeverity.info,
      createdAt: DateTime.utc(2026, 7, 31, 12),
    );
    expect(AdminAlertMapper.eventIdFor(notification), 'support_ticket_new');
    expect(AdminAlertMapper.categoryFor(notification), VnSoundCategory.message);
  });

  test('honors explicit metadata eventId', () {
    final notification = AdminNotification(
      id: 'n-3',
      title: 'Generic',
      body: 'Body',
      type: NotificationType.general,
      severity: NotificationSeverity.info,
      createdAt: DateTime.utc(2026, 7, 31, 12),
      metadata: const {'eventId': 'billing_problem'},
    );
    expect(AdminAlertMapper.eventIdFor(notification), 'billing_problem');
  });

  test('maps driver application submitted to driver_registration_new', () {
    final notification = AdminNotification(
      id: 'n-4',
      title: 'New driver registration',
      body: 'Review required.',
      type: NotificationType.driverApplicationSubmitted,
      severity: NotificationSeverity.info,
      createdAt: DateTime.utc(2026, 7, 31, 12),
    );
    expect(AdminAlertMapper.eventIdFor(notification), 'driver_registration_new');
  });

  test('sound router dedupes occurrence ids', () async {
    final router = VnSoundRouter(
      preferences: VnSoundPreferences(userIdResolver: () async => 'test-admin'),
    );
    router.skipActualPlayback = true;
    final first = await router.play(
      eventId: 'support_ticket_new',
      occurrenceId: 'occ-1',
      source: 'test',
    );
    final second = await router.play(
      eventId: 'support_ticket_new',
      occurrenceId: 'occ-1',
      source: 'test',
    );
    expect(first.played, isTrue);
    expect(second.played, isFalse);
    expect(second.deduplicated, isTrue);
  });
}
