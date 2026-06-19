import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vianexis_admin_app/core/api/api_client.dart';
import 'package:vianexis_admin_app/core/api/api_exception.dart';
import 'package:vianexis_admin_app/core/api/auth_token_storage.dart';
import 'package:vianexis_admin_app/features/audit_logs/data/platform_audit_logs_api.dart';
import 'package:vianexis_admin_app/features/audit_logs/data/platform_audit_logs_repository.dart';
import 'package:vianexis_admin_app/features/audit_logs/domain/platform_audit_action_type.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
  });

  group('LivePlatformAuditLogsRepository', () {
    late Dio dio;
    late ApiClient apiClient;
    late PlatformAuditLogsApi api;
    late LivePlatformAuditLogsRepository repository;

    setUp(() {
      dio = Dio(BaseOptions(baseUrl: 'https://api.test.local'));
      apiClient = ApiClient(
        tokenStorage: AuthTokenStorage(),
        dio: dio,
        enableDebugLogging: false,
      );
      api = PlatformAuditLogsApi(apiClient);
      repository = LivePlatformAuditLogsRepository(api);

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path == '/platform-admin/audit-logs' && options.method == 'GET') {
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'items': [
                      {
                        'id': 1001,
                        'eventType': 'platform.registration.approved',
                        'description': 'Approved registration application #101',
                        'companyId': 12,
                        'userId': 1,
                        'registrationApplicationId': 101,
                        'platformAdminRole': 'super_admin',
                        'createdAt': '2026-06-18T09:30:00.000Z',
                      },
                    ],
                  },
                ),
              );
              return;
            }

            handler.reject(
              DioException(
                requestOptions: options,
                type: DioExceptionType.badResponse,
                response: Response(requestOptions: options, statusCode: 404),
              ),
            );
          },
        ),
      );
    });

    test('fetchLogs returns parsed items', () async {
      final logs = await repository.fetchLogs();
      expect(logs, hasLength(1));
      expect(logs.first.id, '1001');
      expect(logs.first.actionType, PlatformAuditActionType.registrationApproved);
      expect(repository.usesMockData, isFalse);
    });

    test('fetchLog falls back to cached list item when detail missing', () async {
      await repository.fetchLogs();
      final detail = await repository.fetchLog('1001');
      expect(detail.id, '1001');
      expect(detail.registrationApplicationId, '101');
    });

    test('fetchLog throws when id not in cache and detail missing', () async {
      await repository.fetchLogs();
      await expectLater(
        repository.fetchLog('9999'),
        throwsA(isA<ApiException>()),
      );
    });
  });

  group('MockPlatformAuditLogsRepository', () {
    test('returns mock logs', () async {
      final repository = MockPlatformAuditLogsRepository();
      expect(repository.usesMockData, isTrue);
      final logs = await repository.fetchLogs();
      expect(logs, isNotEmpty);
      final detail = await repository.fetchLog(logs.first.id);
      expect(detail.id, logs.first.id);
    });
  });
}
