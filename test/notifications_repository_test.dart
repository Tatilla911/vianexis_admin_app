import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vianexis_admin_app/core/api/api_client.dart';
import 'package:vianexis_admin_app/core/api/auth_token_storage.dart';
import 'package:vianexis_admin_app/features/notifications/data/notifications_api.dart';
import 'package:vianexis_admin_app/features/notifications/data/notifications_repository.dart';
import 'package:vianexis_admin_app/features/notifications/domain/admin_device_registration.dart';
import 'package:vianexis_admin_app/features/notifications/domain/admin_notification.dart';
import 'package:vianexis_admin_app/features/notifications/domain/notification_preferences.dart';
import 'package:vianexis_admin_app/features/notifications/domain/notification_severity.dart';
import 'package:vianexis_admin_app/features/notifications/domain/notification_type.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
  });

  test('admin notification JSON parsing works', () {
    final model = AdminNotification.fromJson({
      'id': 44,
      'title': 'Test',
      'body': 'Body',
      'type': 'security',
      'severity': 'critical',
      'createdAt': '2026-06-20T00:00:00.000Z',
      'metadata': {'scope': 'in_app'},
      'inAppOnly': true,
    });
    expect(model.id, '44');
    expect(model.type, NotificationType.security);
    expect(model.severity, NotificationSeverity.critical);
    expect(model.inAppOnly, isTrue);
  });

  test('preferences validation and in-app-only guard', () {
    final invalid = const NotificationPreferences(
      systemHealth: false,
      security: false,
      support: false,
      billing: false,
      release: false,
    );
    expect(invalid.validate(), 'notificationsPrefValidationAtLeastOne');
    const external = NotificationPreferences(inAppOnly: false);
    expect(external.validate(), 'notificationsPrefValidationInAppOnly');
  });

  test('device registration serialization has no raw token field', () {
    const registration = AdminDeviceRegistration(
      deviceId: 'device-1',
      platform: 'windows',
      environment: 'dev',
      appVersion: '1.0.0',
      appBuild: '100',
    );
    final json = registration.toJson();
    expect(json.containsKey('token'), isFalse);
    expect(json.containsKey('fcmToken'), isFalse);
    expect(json['inAppOnly'], isTrue);
  });

  group('LiveNotificationsRepository', () {
    test('uses live API and exposes in-app only state', () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://api.test.local'));
      final apiClient = ApiClient(
        tokenStorage: AuthTokenStorage(),
        dio: dio,
        enableDebugLogging: false,
      );
      final repo = LiveNotificationsRepository(NotificationsApi(apiClient));

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path == '/platform-admin/notifications') {
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'items': [
                      {
                        'id': 'n-1',
                        'title': 'Security notice',
                        'body': 'Body',
                        'type': 'security',
                        'severity': 'warning',
                        'createdAt': '2026-06-20T10:00:00.000Z',
                        'inAppOnly': true,
                      },
                    ],
                  },
                ),
              );
              return;
            }
            if (options.path == '/platform-admin/notifications/n-1/read' ||
                options.path == '/platform-admin/notifications/read-all') {
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: const {},
                ),
              );
              return;
            }
            if (options.path == '/platform-admin/notification-preferences') {
              if (options.method == 'GET') {
                handler.resolve(
                  Response<Map<String, dynamic>>(
                    requestOptions: options,
                    statusCode: 200,
                    data: const {'systemHealth': true, 'inAppOnly': true},
                  ),
                );
                return;
              }
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: (options.data as Map<String, dynamic>?) ?? const {},
                ),
              );
              return;
            }
            if (options.path == '/platform-admin/notification-devices/register') {
              expect(options.data, isA<Map<String, dynamic>>());
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: const {},
                ),
              );
              return;
            }
            handler.reject(
              DioException(requestOptions: options, message: 'Unexpected path'),
            );
          },
        ),
      );

      final list = await repo.listNotifications();
      expect(list, hasLength(1));
      expect(repo.usesMockData, isFalse);
      expect(repo.inAppOnly, isTrue);
      await repo.markRead('n-1');
      await repo.markAllRead();
      final prefs = await repo.getPreferences();
      expect(prefs.systemHealth, isTrue);
      final updated = await repo.updatePreferences(
        prefs.copyWith(billing: true, inAppOnly: false),
      );
      expect(updated.inAppOnly, isTrue);
    });
  });

  group('MockNotificationsRepository', () {
    test('mark read and mark all read update unread states', () async {
      final repo = MockNotificationsRepository();
      final initial = await repo.listNotifications();
      expect(initial.any((n) => !n.isRead), isTrue);

      await repo.markRead(initial.first.id);
      final afterOne = await repo.listNotifications();
      expect(afterOne.first.isRead, isTrue);

      await repo.markAllRead();
      final afterAll = await repo.listNotifications();
      expect(afterAll.every((n) => n.isRead), isTrue);
      expect(repo.inAppOnly, isTrue);
    });
  });
}
