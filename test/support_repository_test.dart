import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vianexis_admin_app/core/api/api_client.dart';
import 'package:vianexis_admin_app/core/api/api_exception.dart';
import 'package:vianexis_admin_app/core/api/auth_token_storage.dart';
import 'package:vianexis_admin_app/core/localization/localization_keys.dart';
import 'package:vianexis_admin_app/features/support/data/support_api.dart';
import 'package:vianexis_admin_app/features/support/data/support_access_grants_repository.dart';
import 'package:vianexis_admin_app/features/support/data/support_tickets_repository.dart';
import 'package:vianexis_admin_app/features/support/domain/support_access_grant_request.dart';
import 'package:vianexis_admin_app/features/support/domain/support_access_grant_status.dart';
import 'package:vianexis_admin_app/features/support/domain/support_access_scope_type.dart';
import 'package:vianexis_admin_app/features/support/domain/support_ticket_action_request.dart';
import 'package:vianexis_admin_app/features/support/domain/support_ticket_status.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
  });

  group('LiveSupportTicketsRepository', () {
    late Dio dio;
    late ApiClient apiClient;
    late SupportApi api;
    late LiveSupportTicketsRepository repository;

    setUp(() {
      dio = Dio(BaseOptions(baseUrl: 'https://api.test.local'));
      apiClient = ApiClient(
        tokenStorage: AuthTokenStorage(),
        dio: dio,
        enableDebugLogging: false,
      );
      api = SupportApi(apiClient);
      repository = LiveSupportTicketsRepository(api);

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path == '/platform-admin/support-tickets') {
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'items': [
                      {
                        'id': 801,
                        'companyId': 12,
                        'subject': 'Upload queue stalled',
                        'descriptionSummary': 'Metadata only',
                        'status': 'open',
                        'priority': 'urgent',
                      },
                    ],
                  },
                ),
              );
              return;
            }

            if (options.path == '/platform-admin/support-tickets/801') {
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'ticket': {
                      'id': 801,
                      'subject': 'Upload queue stalled',
                      'descriptionSummary': 'Metadata only',
                      'status': 'acknowledged',
                      'priority': 'urgent',
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

            if (options.path.endsWith('/close')) {
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'ticket': {
                      'id': 801,
                      'subject': 'Upload queue stalled',
                      'descriptionSummary': 'Metadata only',
                      'status': 'closed',
                      'priority': 'urgent',
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
                response: Response(requestOptions: options, statusCode: 404),
              ),
            );
          },
        ),
      );
    });

    test('fetchTickets returns parsed items', () async {
      final tickets = await repository.fetchTickets();
      expect(tickets, hasLength(1));
      expect(tickets.first.id, '801');
      expect(repository.usesMockData, isFalse);
    });

    test('submitAction acknowledge updates status', () async {
      await repository.fetchTickets();
      final updated = await repository.submitAction(
        ticketId: '801',
        request: const SupportTicketActionRequest(
          type: SupportTicketActionType.acknowledge,
        ),
      );
      expect(updated.status, SupportTicketStatus.acknowledged);
    });
    test('submitAction close updates status', () async {
      await repository.fetchTickets();
      final updated = await repository.submitAction(
        ticketId: '801',
        request: const SupportTicketActionRequest(
          type: SupportTicketActionType.close,
          note: 'Resolved after review',
        ),
      );
      expect(updated.status, SupportTicketStatus.closed);
    });
  });

  group('LiveSupportAccessGrantsRepository detail and revoke', () {
    late Dio dio;
    late ApiClient apiClient;
    late SupportApi api;
    late LiveSupportAccessGrantsRepository repository;

    setUp(() {
      dio = Dio(BaseOptions(baseUrl: 'https://api.test.local'));
      apiClient = ApiClient(
        tokenStorage: AuthTokenStorage(),
        dio: dio,
        enableDebugLogging: false,
      );
      api = SupportApi(apiClient);
      repository = LiveSupportAccessGrantsRepository(api);

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path == '/platform-admin/support-access-grants' &&
                options.method == 'GET') {
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'items': [
                      {
                        'id': 901,
                        'companyId': 12,
                        'scope': ['audit'],
                        'reason': 'Metadata review',
                        'expiresAt': '2026-06-18T10:00:00.000Z',
                        'createdAt': '2026-06-18T08:00:00.000Z',
                        'isActive': true,
                      },
                    ],
                  },
                ),
              );
              return;
            }

            if (options.path == '/platform-admin/support-access-grants/901' &&
                options.method == 'GET') {
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'grant': {
                      'id': 901,
                      'companyId': 12,
                      'scopeType': 'system_health_issue',
                      'reason': 'Metadata review',
                      'status': 'active',
                      'metadataOnly': true,
                    },
                  },
                ),
              );
              return;
            }

            if (options.path.endsWith('/revoke')) {
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'grant': {
                      'id': 901,
                      'companyId': 12,
                      'status': 'revoked',
                      'metadataOnly': true,
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
                response: Response(requestOptions: options, statusCode: 404),
              ),
            );
          },
        ),
      );
    });

    test('fetchGrant loads live detail', () async {
      final grant = await repository.fetchGrant('901');
      expect(grant.id, '901');
      expect(grant.status, SupportAccessGrantStatus.active);
    });

    test('revokeGrant succeeds on live endpoint', () async {
      final revoked = await repository.revokeGrant(
        grantId: '901',
        request: SupportAccessGrantRequest(
          companyId: '12',
          scopeType: SupportAccessScopeType.systemHealthIssue,
          reason: 'Investigation complete',
          expiresAt: DateTime.now().toUtc().add(const Duration(hours: 1)),
          type: SupportAccessGrantActionType.revoke,
        ),
      );
      expect(revoked.status, SupportAccessGrantStatus.revoked);
    });
  });

  group('LiveSupportAccessGrantsRepository legacy revoke fallback', () {
    late Dio dio;
    late ApiClient apiClient;
    late SupportApi api;
    late LiveSupportAccessGrantsRepository repository;

    setUp(() {
      dio = Dio(BaseOptions(baseUrl: 'https://api.test.local'));
      apiClient = ApiClient(
        tokenStorage: AuthTokenStorage(),
        dio: dio,
        enableDebugLogging: false,
      );
      api = SupportApi(apiClient);
      repository = LiveSupportAccessGrantsRepository(api);

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path == '/platform-admin/support-access-grants' &&
                options.method == 'GET') {
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'items': [
                      {
                        'id': 901,
                        'companyId': 12,
                        'scope': ['portal_dashboard'],
                        'reason': 'Metadata review',
                        'expiresAt': '2026-06-18T10:00:00.000Z',
                        'createdAt': '2026-06-18T08:00:00.000Z',
                        'isActive': true,
                      },
                    ],
                  },
                ),
              );
              return;
            }

            if (options.path == '/platform-admin/support-access-grants' &&
                options.method == 'POST') {
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 201,
                  data: {
                    'items': [
                      {
                        'id': 902,
                        'companyId': 12,
                        'scope': ['portal_dashboard', 'audit'],
                        'reason': 'Investigate health metadata',
                        'expiresAt': '2026-06-18T12:00:00.000Z',
                        'createdAt': '2026-06-18T09:00:00.000Z',
                        'isActive': true,
                        'metadata': {'scopeType': 'system_health_issue'},
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

    test('fetchGrants returns parsed items', () async {
      final grants = await repository.fetchGrants();
      expect(grants, hasLength(1));
      expect(grants.first.id, '901');
    });

    test('createGrant posts scoped request', () async {
      final grant = await repository.createGrant(
        SupportAccessGrantRequest(
          companyId: '12',
          scopeType: SupportAccessScopeType.systemHealthIssue,
          scopeId: '501',
          reason: 'Investigate health metadata',
          expiresAt: DateTime.now().toUtc().add(const Duration(hours: 2)),
        ),
      );
      expect(grant.id, '902');
    });

    test('revokeGrant throws when endpoint missing', () async {
      await repository.fetchGrants();
      await expectLater(
        repository.revokeGrant(
          grantId: '901',
          request: SupportAccessGrantRequest(
            companyId: '12',
            scopeType: SupportAccessScopeType.companyMetadata,
            reason: 'Investigation complete',
            expiresAt: DateTime.now().toUtc().add(const Duration(hours: 1)),
            type: SupportAccessGrantActionType.revoke,
          ),
        ),
        throwsA(
          isA<ApiException>().having(
            (error) => error.messageKey,
            'messageKey',
            LocalizationKeys.supportActionUnavailable,
          ),
        ),
      );
    });
  });

  group('MockSupportRepositories', () {
    test('mock tickets and grants return data', () async {
      final ticketsRepo = MockSupportTicketsRepository();
      final grantsRepo = MockSupportAccessGrantsRepository();

      expect(ticketsRepo.usesMockData, isTrue);
      expect(grantsRepo.usesMockData, isTrue);

      final tickets = await ticketsRepo.fetchTickets();
      final grants = await grantsRepo.fetchGrants();
      expect(tickets, isNotEmpty);
      expect(grants, isNotEmpty);
    });

    test('mock revoke updates grant status', () async {
      final grantsRepo = MockSupportAccessGrantsRepository();
      final grants = await grantsRepo.fetchGrants();
      final active = grants.firstWhere((g) => g.status == SupportAccessGrantStatus.active);

      final revoked = await grantsRepo.revokeGrant(
        grantId: active.id,
        request: SupportAccessGrantRequest(
          companyId: active.companyId,
          scopeType: active.scopeType,
          reason: 'Done investigating',
          expiresAt: DateTime.now().toUtc().add(const Duration(hours: 1)),
          type: SupportAccessGrantActionType.revoke,
        ),
      );

      expect(revoked.status, SupportAccessGrantStatus.revoked);
    });
  });
}
