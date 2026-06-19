import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vianexis_admin_app/core/api/api_client.dart';
import 'package:vianexis_admin_app/core/api/api_exception.dart';
import 'package:vianexis_admin_app/core/api/auth_token_storage.dart';
import 'package:vianexis_admin_app/core/localization/localization_keys.dart';
import 'package:vianexis_admin_app/features/registrations/data/registration_applications_api.dart';
import 'package:vianexis_admin_app/features/registrations/data/registration_applications_repository.dart';
import 'package:vianexis_admin_app/features/registrations/domain/registration_application_status.dart';
import 'package:vianexis_admin_app/features/registrations/domain/registration_decision_request.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
  });

  group('LiveRegistrationApplicationsRepository', () {
    late Dio dio;
    late ApiClient apiClient;
    late RegistrationApplicationsApi api;
    late LiveRegistrationApplicationsRepository repository;

    setUp(() {
      dio = Dio(BaseOptions(baseUrl: 'https://api.test.local'));
      apiClient = ApiClient(
        tokenStorage: AuthTokenStorage(),
        dio: dio,
        enableDebugLogging: false,
      );
      api = RegistrationApplicationsApi(apiClient);
      repository = LiveRegistrationApplicationsRepository(api);

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path == '/platform-admin/registration-applications') {
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'total': 1,
                    'items': [
                      {
                        'id': 7,
                        'companyName': 'Live Co',
                        'contactEmail': 'live@example.com',
                        'status': 'pending',
                        'createdAt': '2026-06-12T10:00:00.000Z',
                      },
                    ],
                  },
                ),
              );
              return;
            }

            if (options.path == '/platform-admin/registration-applications/7') {
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'application': {
                      'id': 7,
                      'companyName': 'Live Co',
                      'contactEmail': 'live@example.com',
                      'status': 'pending',
                    },
                    'aiReviews': [],
                  },
                ),
              );
              return;
            }

            if (options.path.endsWith('/reject')) {
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: {'success': true},
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

    test('fetchApplications returns parsed items', () async {
      final items = await repository.fetchApplications();
      expect(items, hasLength(1));
      expect(items.first.companyName, 'Live Co');
      expect(items.first.status, RegistrationApplicationStatus.pending);
    });

    test('fetchApplication returns detail', () async {
      final item = await repository.fetchApplication('7');
      expect(item.id, '7');
      expect(item.companyName, 'Live Co');
    });

    test('submitDecision sends reject request', () async {
      await repository.submitDecision(
        applicationId: '7',
        request: RegistrationDecisionRequest(
          type: RegistrationDecisionType.reject,
          reviewNotes: 'Invalid VAT evidence',
        ),
      );
    });

    test('maps API errors through dio layer', () async {
      expect(
        () => repository.fetchApplication('missing'),
        throwsA(
          isA<ApiException>().having(
            (error) => error.kind,
            'kind',
            ApiExceptionKind.notFound,
          ),
        ),
      );
    });
  });

  group('MockRegistrationApplicationsRepository', () {
    test('returns mock applications and supports decisions', () async {
      final repository = MockRegistrationApplicationsRepository();
      expect(repository.usesMockData, isTrue);

      final items = await repository.fetchApplications();
      expect(items, isNotEmpty);

      await repository.submitDecision(
        applicationId: items.first.id,
        request: RegistrationDecisionRequest(
          type: RegistrationDecisionType.reject,
          reviewNotes: 'Not eligible',
        ),
      );

      final updated = await repository.fetchApplication(items.first.id);
      expect(updated.status, RegistrationApplicationStatus.rejected);
    });

    test('throws not found for unknown id', () async {
      final repository = MockRegistrationApplicationsRepository();
      expect(
        () => repository.fetchApplication('999'),
        throwsA(
          isA<ApiException>().having(
            (error) => error.messageKey,
            'messageKey',
            LocalizationKeys.errorGenericBody,
          ),
        ),
      );
    });
  });
}
