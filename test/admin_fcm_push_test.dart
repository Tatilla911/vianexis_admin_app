import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/app/app_router.dart';
import 'package:vianexis_admin_app/features/notifications/domain/admin_notification_routing.dart';
import 'package:vianexis_admin_app/features/notifications/domain/notification_severity.dart';
import 'package:vianexis_admin_app/features/notifications/domain/notification_type.dart';
import 'package:vianexis_admin_app/services/alerts/admin_fcm_payload.dart';
import 'package:vianexis_admin_app/services/alerts/admin_fcm_service.dart';
import 'package:vianexis_admin_app/services/alerts/admin_fcm_tap_coordinator.dart';
import 'package:vianexis_admin_app/services/alerts/admin_push_dedupe.dart';

void main() {
  setUp(() {
    AdminPushDedupe.instance.clear();
    AdminFcmTapCoordinator.instance.clear();
  });

  test('parses driver registration FCM data with JSON deep link', () {
    final payload = AdminFcmPayload.fromDataMap(
      {
        'notificationId': '177',
        'type': 'driver_application_submitted',
        'resourceType': 'driver_registration',
        'resourceId': '900',
        'deepLink': '{"path":"/applications/900"}',
      },
      titleText: 'New driver registration',
      bodyText: 'Review required.',
    );

    expect(payload, isNotNull);
    expect(payload!.notificationId, '177');
    expect(payload.type, NotificationType.driverApplicationSubmitted);
    expect(payload.deepLink, '/applications/900');
    expect(payload.applicationId, '900');
    expect(payload.title, 'New driver registration');
    expect(
      resolveAdminNotificationDestination(payload.toAdminNotification()),
      AdminRoutes.applicationDetail('900'),
    );
  });

  test('parses emergency_alert FCM without coordinates and deep-links', () {
    final payload = AdminFcmPayload.fromDataMap(
      {
        'notificationId': '501',
        'type': 'emergency_alert',
        'severity': 'critical',
        'emergencyEventId': '88',
        'deepLink': '{"path":"/emergencies/88"}',
      },
      titleText: 'New emergency alert received.',
      bodyText: 'New emergency alert received.',
    );

    expect(payload, isNotNull);
    expect(payload!.type, NotificationType.emergencyAlert);
    expect(payload.severity, NotificationSeverity.critical);
    expect(payload.deepLink, '/emergencies/88');
    expect(payload.title, 'New emergency alert received.');
    expect(payload.body?.contains(RegExp(r'\d+\.\d+')), isFalse);
    expect(
      resolveAdminNotificationDestination(payload.toAdminNotification()),
      AdminRoutes.emergencyDetail('88'),
    );
  });

  test('rejects external FCM deep links', () {
    final payload = AdminFcmPayload.fromDataMap({
      'notificationId': '177',
      'type': 'driver_application_submitted',
      'deepLink': 'https://evil.example/phish',
      'applicationId': '900',
    });
    expect(payload, isNotNull);
    expect(payload!.deepLink, '/applications/900');
    expect(payload.deepLink?.startsWith('https://'), isNot(isTrue));
    expect(
      resolveAdminNotificationDestination(payload.toAdminNotification()),
      AdminRoutes.applicationDetail('900'),
    );
  });

  test('unsafe deep link without locator falls back to applications inbox', () {
    final payload = AdminFcmPayload.fromDataMap({
      'notificationId': '177',
      'type': 'driver_application_submitted',
      'deepLink': 'https://evil.example/phish',
    });
    expect(payload!.deepLink, isNull);
    expect(
      resolveAdminNotificationDestination(payload.toAdminNotification()),
      AdminRoutes.applications,
    );
  });

  test('polling and FCM dedupe suppress duplicate alert ids', () {
    expect(AdminPushDedupe.instance.markSeen('177'), isTrue);
    expect(AdminPushDedupe.instance.wasSeen('177'), isTrue);
    expect(AdminPushDedupe.instance.markSeen('177'), isFalse);
    expect(AdminPushDedupe.instance.wasSeen('178'), isFalse);
  });

  test('redacts raw token in logs', () {
    expect(AdminFcmService.redactTokenForLog('abcdefghijklmnop'), 'abcd…mnop');
    expect(AdminFcmService.redactTokenForLog('short'), '***');
    expect(AdminFcmService.redactTokenForLog(null), '[empty]');
  });

  test('FCM payload metadata excludes personal identifiers', () {
    final payload = AdminFcmPayload.fromDataMap({
      'notificationId': '10',
      'type': 'driver_application_submitted',
      'resourceType': 'driver_registration',
      'resourceId': '55',
      'email': 'driver@example.com',
      'phone': '+361234567',
    });
    final metadata = payload!.toAdminNotification().metadata;
    expect(metadata.containsKey('email'), isFalse);
    expect(metadata.containsKey('phone'), isFalse);
    expect(metadata['applicationId'], '55');
  });

  test('tap coordinator stages until a handler is attached', () {
    final payload = AdminFcmPayload.fromDataMap({
      'notificationId': '12',
      'type': 'driver_application_submitted',
      'applicationId': '900',
    })!;
    AdminFcmPayload? received;
    AdminFcmTapCoordinator.instance.handlePayload(payload);
    expect(AdminFcmTapCoordinator.instance.consumePendingPayload(), payload);

    AdminFcmTapCoordinator.instance.onPayloadTap = (value) => received = value;
    AdminFcmTapCoordinator.instance.handlePayload(payload);
    expect(received, payload);
    expect(AdminFcmTapCoordinator.instance.consumePendingPayload(), isNull);
    AdminFcmTapCoordinator.instance.onPayloadTap = null;
  });

  test('logout helper is a no-op when FCM was never configured', () async {
    await AdminFcmService.revokeOnLogoutIfConfigured();
  });
}
