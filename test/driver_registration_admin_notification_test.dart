import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/app/app_router.dart';
import 'package:vianexis_admin_app/features/notifications/domain/admin_notification.dart';
import 'package:vianexis_admin_app/features/notifications/domain/admin_notification_routing.dart';
import 'package:vianexis_admin_app/features/notifications/domain/notification_severity.dart';
import 'package:vianexis_admin_app/features/notifications/domain/notification_type.dart';

void main() {
  test('parses driver_application_submitted with titleKey/messageKey', () {
    final model = AdminNotification.fromJson({
      'id': 77,
      'type': 'driver_application_submitted',
      'severity': 'info',
      'titleKey':
          'platformAdmin.notifications.driverApplicationSubmitted.title',
      'messageKey':
          'platformAdmin.notifications.driverApplicationSubmitted.message',
      'createdAt': '2026-09-02T10:00:00.000Z',
      'metadata': {
        'deepLink': '/applications/900',
        'applicationId': '900',
        'driverRegistrationRequestId': '55',
        'email': 'driver@example.com',
        'titleEn': 'New driver registration',
        'titleHu': 'Új sofőrregisztráció',
        'bodyEn': 'A new driver registration was received and is waiting for review.',
        'bodyHu': 'Új sofőrregisztráció érkezett. Elbírálás szükséges.',
      },
    });

    expect(model.type, NotificationType.driverApplicationSubmitted);
    expect(model.title, 'New driver registration');
    expect(model.body, contains('waiting for review'));
    expect(model.deepLink, '/applications/900');
    expect(model.applicationId, '900');
    expect(model.driverRegistrationRequestId, '55');
    expect(model.metadata.containsKey('email'), isFalse);
    expect(model.displayMetadata.containsKey('email'), isFalse);
  });

  test('deep link resolves to application review, not notifications list', () {
    final model = AdminNotification(
      id: '77',
      title: 'New driver registration',
      body: 'Review required.',
      type: NotificationType.driverApplicationSubmitted,
      severity: NotificationSeverity.info,
      createdAt: DateTime.utc(2026, 9, 2),
      metadata: const {
        'deepLink': '/applications/900',
        'applicationId': '900',
      },
    );
    expect(
      resolveAdminNotificationDestination(model),
      AdminRoutes.applicationDetail('900'),
    );
  });

  test('fallback destination is applications inbox', () {
    final model = AdminNotification(
      id: '77',
      title: 'New driver registration',
      body: 'Review required.',
      type: NotificationType.driverApplicationSubmitted,
      severity: NotificationSeverity.info,
      createdAt: DateTime.utc(2026, 9, 2),
    );
    expect(
      resolveAdminNotificationDestination(model),
      AdminRoutes.applications,
    );
  });

  test('rejects unsafe deep links', () {
    final model = AdminNotification(
      id: '77',
      title: 'New driver registration',
      body: 'Review required.',
      type: NotificationType.driverApplicationSubmitted,
      severity: NotificationSeverity.info,
      createdAt: DateTime.utc(2026, 9, 2),
      metadata: const {'deepLink': 'https://evil.example/takeover'},
    );
    expect(
      resolveAdminNotificationDestination(model),
      AdminRoutes.applications,
    );
  });

}
