import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/core/api/api_client.dart';
import 'package:vianexis_admin_app/core/api/api_exception.dart';
import 'package:vianexis_admin_app/core/api/auth_token_storage.dart';
import 'package:vianexis_admin_app/features/system_monitoring/data/system_monitoring_api.dart';
import 'package:vianexis_admin_app/features/system_monitoring/data/system_monitoring_repository.dart';
import 'package:vianexis_admin_app/features/system_monitoring/domain/system_component_status.dart';
import 'package:vianexis_admin_app/features/system_monitoring/domain/system_monitoring_action_request.dart';
import 'package:vianexis_admin_app/features/system_monitoring/domain/system_monitoring_incident.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
  });

  group('LiveSystemMonitoringRepository', () {
    late Dio dio;
    late LiveSystemMonitoringRepository repository;

    setUp(() {
      dio = Dio(BaseOptions(baseUrl: 'https://api.test.local'));
      final apiClient = ApiClient(
        tokenStorage: AuthTokenStorage(),
        dio: dio,
        enableDebugLogging: false,
      );
      repository = LiveSystemMonitoringRepository(
        SystemMonitoringApi(apiClient),
      );
    });

    test('fetchSnapshot parses live overview without mock flag', () async {
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path.endsWith('/overview')) {
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'overallStatus': 'unhealthy',
                    'healthyCount': 1,
                    'degradedCount': 0,
                    'unhealthyCount': 1,
                    'unknownCount': 0,
                    'notConfiguredCount': 1,
                    'disabledCount': 0,
                    'activeIncidentCount': 1,
                    'criticalIncidentCount': 1,
                    'components': [
                      {
                        'componentKey': 'backend_api',
                        'displayName': 'Backend API',
                        'status': 'healthy',
                        'message': 'ok',
                        'isCritical': true,
                        'isConfigured': true,
                      },
                      {
                        'componentKey': 'background_jobs',
                        'displayName': 'Background jobs',
                        'status': 'unhealthy',
                        'message': 'worker error',
                        'isCritical': true,
                        'isConfigured': true,
                      },
                    ],
                    'privacyNoteKey': 'systemMonitoringPrivacyNotice',
                  },
                ),
              );
              return;
            }
            if (options.path.endsWith('/metrics')) {
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'aggregates': {
                      'apiErrorsLastHour': 2,
                      'activeIncidentCount': 1,
                      'unresolvedCriticalIncidentCount': 1,
                    },
                  },
                ),
              );
              return;
            }
            if (options.path.endsWith('/incidents')) {
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'items': [
                      {
                        'id': 'inc-9',
                        'title': 'Jobs unhealthy',
                        'summary': 'Worker failing',
                        'severity': 'critical',
                        'status': 'open',
                        'source': 'alert_rule',
                        'componentKey': 'background_jobs',
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

      final snapshot = await repository.fetchSnapshot();
      expect(repository.usesMockData, isFalse);
      expect(
        snapshot.overview.overallStatus,
        SystemComponentStatusValue.unhealthy,
      );
      expect(snapshot.activeIncidents, hasLength(1));
      expect(
        snapshot.components.any(
          (c) => c.status == SystemComponentStatusValue.unhealthy,
        ),
        isTrue,
      );
    });

    test('live overview error does not return mock healthy data', () async {
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            handler.reject(
              DioException(
                requestOptions: options,
                type: DioExceptionType.badResponse,
                response: Response(requestOptions: options, statusCode: 500),
              ),
            );
          },
        ),
      );

      expect(repository.usesMockData, isFalse);
      await expectLater(
        repository.fetchSnapshot(),
        throwsA(isA<ApiException>()),
      );
    });
  });

  group('MockSystemMonitoringRepository', () {
    test('uses mock data with not_configured and sample incidents', () async {
      final repository = MockSystemMonitoringRepository();
      expect(repository.usesMockData, isTrue);

      final snapshot = await repository.fetchSnapshot();
      expect(
        snapshot.components.any(
          (c) => c.status == SystemComponentStatusValue.notConfigured,
        ),
        isTrue,
      );
      expect(snapshot.activeIncidents.length, greaterThanOrEqualTo(1));
      expect(
        snapshot.overview.overallStatus,
        isNot(SystemComponentStatusValue.healthy),
      );
    });

    test('acknowledge updates incident status', () async {
      final repository = MockSystemMonitoringRepository();
      final snapshot = await repository.fetchSnapshot();
      final id = snapshot.activeIncidents.first.id;

      final updated = await repository.acknowledgeIncident(
        id: id,
        request: const SystemMonitoringAcknowledgeRequest(note: 'looking'),
      );

      expect(updated.status, SystemIncidentStatus.investigating);
      expect(updated.acknowledgedAt, isNotNull);
    });
  });
}
