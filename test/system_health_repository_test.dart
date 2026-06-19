import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vianexis_admin_app/core/api/api_client.dart';
import 'package:vianexis_admin_app/core/api/auth_token_storage.dart';
import 'package:vianexis_admin_app/features/system_health/data/system_health_api.dart';
import 'package:vianexis_admin_app/features/system_health/data/system_health_repository.dart';
import 'package:vianexis_admin_app/features/system_health/domain/system_health_action_request.dart';
import 'package:vianexis_admin_app/features/system_health/domain/system_health_event.dart';
import 'package:vianexis_admin_app/features/system_health/domain/system_health_severity.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
  });

  group('LiveSystemHealthRepository', () {
    late Dio dio;
    late ApiClient apiClient;
    late SystemHealthApi api;
    late LiveSystemHealthRepository repository;

    setUp(() {
      dio = Dio(BaseOptions(baseUrl: 'https://api.test.local'));
      apiClient = ApiClient(
        tokenStorage: AuthTokenStorage(),
        dio: dio,
        enableDebugLogging: false,
      );
      api = SystemHealthApi(apiClient);
      repository = LiveSystemHealthRepository(api);

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path == '/platform-admin/system-health') {
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'components': [
                      {
                        'component': 'api',
                        'severity': 'ok',
                        'detailSummary': 'API healthy',
                      },
                      {
                        'component': 'database',
                        'severity': 'warning',
                        'detailSummary': 'Slow queries',
                      },
                    ],
                    'recentEvents': [
                      {
                        'id': '701',
                        'severity': 'critical',
                        'component': 'worker',
                        'status': 'open',
                        'title': 'Worker backlog',
                        'summary': 'Jobs delayed',
                        'tenantImpactLevel': 'none',
                      },
                    ],
                    'infra': {
                      'redis': {'connected': true, 'enabled': true, 'status': 'ok'},
                      'worker': {
                        'messageEscalation': {'lastRunAt': '2026-06-18T08:00:00.000Z'},
                      },
                      'notificationFailures': 3,
                    },
                    'privacyNoteKey': 'systemHealthPrivacyNotice',
                  },
                ),
              );
              return;
            }

            if (options.path == '/platform-admin/system-health/events') {
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'items': [
                      {
                        'id': '701',
                        'severity': 'critical',
                        'component': 'worker',
                        'status': 'open',
                        'title': 'Worker backlog',
                        'summary': 'Jobs delayed',
                        'tenantImpactLevel': 'none',
                        'metadataOnly': true,
                      },
                    ],
                  },
                ),
              );
              return;
            }

            if (options.path == '/platform-admin/system-health/events/701') {
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'event': {
                      'id': '701',
                      'severity': 'critical',
                      'component': 'worker',
                      'status': 'acknowledged',
                      'title': 'Worker backlog',
                      'summary': 'Jobs delayed',
                      'tenantImpactLevel': 'none',
                    },
                  },
                ),
              );
              return;
            }

            if (options.path.endsWith('/acknowledge')) {
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: {'success': true},
                ),
              );
              return;
            }

            if (options.path.endsWith('/escalate')) {
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'event': {
                      'id': '701',
                      'severity': 'critical',
                      'component': 'worker',
                      'status': 'escalated',
                      'title': 'Worker backlog',
                      'summary': 'Jobs delayed',
                    },
                  },
                ),
              );
              return;
            }

            handler.reject(
              DioException(
                requestOptions: options,
                type: DioExceptionType.badResponse,
                response: Response(
                  requestOptions: options,
                  statusCode: 404,
                ),
              ),
            );
          },
        ),
      );
    });

    test('fetchSnapshot returns parsed overview and events', () async {
      final snapshot = await repository.fetchSnapshot();

      expect(repository.usesMockData, isFalse);
      expect(snapshot.services, hasLength(10));
      expect(snapshot.events, hasLength(1));
      expect(snapshot.events.first.id, '701');
      expect(snapshot.overview.failedJobsCount, 3);
      expect(snapshot.overview.openCriticalEventsCount, 1);
    });

    test('fetchEvent returns detail from API', () async {
      await repository.fetchSnapshot();
      final event = await repository.fetchEvent('701');

      expect(event.id, '701');
      expect(event.status, SystemHealthEventStatus.acknowledged);
    });

    test('submitAction acknowledge updates status', () async {
      await repository.fetchSnapshot();
      final updated = await repository.submitAction(
        eventId: '701',
        request: const SystemHealthActionRequest(
          type: SystemHealthActionType.acknowledge,
        ),
      );

      expect(updated.status, SystemHealthEventStatus.acknowledged);
    });

    test('submitAction escalate updates status when endpoint exists', () async {
      await repository.fetchSnapshot();
      final updated = await repository.submitAction(
        eventId: '701',
        request: const SystemHealthActionRequest(
          type: SystemHealthActionType.escalate,
          note: 'Need on-call',
        ),
      );

      expect(updated.status, SystemHealthEventStatus.investigating);
    });

    test('events endpoint availability is tracked', () async {
      await repository.fetchSnapshot();
      expect(api.eventsEndpointAvailable, isTrue);
    });
  });

  group('MockSystemHealthRepository', () {
    test('uses mock data and returns snapshot', () async {
      final repository = MockSystemHealthRepository();

      expect(repository.usesMockData, isTrue);

      final snapshot = await repository.fetchSnapshot();
      expect(snapshot.services, hasLength(10));
      expect(snapshot.events, isNotEmpty);
      expect(snapshot.overview.overallStatus, SystemHealthOverallStatus.critical);
    });

    test('submitAction acknowledge updates cached event', () async {
      final repository = MockSystemHealthRepository();
      final snapshot = await repository.fetchSnapshot();
      final eventId = snapshot.events.first.id;

      final updated = await repository.submitAction(
        eventId: eventId,
        request: const SystemHealthActionRequest(
          type: SystemHealthActionType.acknowledge,
        ),
      );

      expect(updated.status, SystemHealthEventStatus.acknowledged);

      final refreshed = await repository.fetchEvent(eventId);
      expect(refreshed.status, SystemHealthEventStatus.acknowledged);
    });
  });
}
