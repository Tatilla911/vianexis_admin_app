import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/emergencies/domain/driver_emergency_event.dart';
import 'package:vianexis_admin_app/features/notifications/domain/notification_type.dart';

void main() {
  test('maps emergency_alert notification type', () {
    expect(
      NotificationType.fromBackendValue('emergency_alert'),
      NotificationType.emergencyAlert,
    );
  });

  test('parses emergency detail location fields', () {
    final event = DriverEmergencyEvent.fromJson({
      'id': 3,
      'companyId': 10,
      'driverUserId': 42,
      'status': 'ACTIVE',
      'severity': 'CRITICAL',
      'triggeredAt': '2026-09-23T12:00:00.000Z',
      'locationStatus': 'FRESH',
      'latitude': 47.497913,
      'longitude': 19.040236,
      'accuracyMeters': 12,
      'locality': 'Budapest',
      'locationSource': 'driver_app',
      'companyNotificationStatus': 'CREATED',
      'platformNotificationStatus': 'CREATED',
      'adminPushStatus': 'SENT',
    });

    expect(event.id, '3');
    expect(event.status.isActiveUnacknowledged, isTrue);
    expect(event.hasExactCoordinates, isTrue);
    expect(event.locality, 'Budapest');
    expect(event.accuracyMeters, 12);
  });
}
