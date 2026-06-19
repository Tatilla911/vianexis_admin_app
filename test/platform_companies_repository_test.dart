import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vianexis_admin_app/core/api/api_client.dart';
import 'package:vianexis_admin_app/core/api/auth_token_storage.dart';
import 'package:vianexis_admin_app/features/companies/data/platform_companies_api.dart';
import 'package:vianexis_admin_app/features/companies/data/platform_companies_repository.dart';
import 'package:vianexis_admin_app/features/companies/domain/platform_company_status.dart';
import 'package:vianexis_admin_app/features/companies/domain/platform_company_status_request.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
  });

  group('LivePlatformCompaniesRepository', () {
    late LivePlatformCompaniesRepository repo;

    setUp(() {
      final dio = Dio(BaseOptions(baseUrl: 'https://api.test.local'));
      final apiClient = ApiClient(
        tokenStorage: AuthTokenStorage(),
        dio: dio,
        enableDebugLogging: false,
      );
      repo = LivePlatformCompaniesRepository(PlatformCompaniesApi(apiClient));

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path == '/platform-admin/companies') {
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'total': 1,
                    'metadataOnly': true,
                    'items': [
                      {
                        'id': 9,
                        'name': 'Live Co',
                        'status': 'active',
                        'country': 'HU',
                        'activeUsersCount': 2,
                        'driversCount': 1,
                        'vehiclesCount': 1,
                        'trailersCount': 0,
                        'openSupportTicketsCount': 0,
                        'activeSupportAccessGrantsCount': 0,
                        'pendingRegistrationApplicationsCount': 0,
                        'pendingBulkOnboardingJobsCount': 0,
                        'metadataOnly': true,
                      },
                    ],
                  },
                ),
              );
              return;
            }
            if (options.path == '/platform-admin/companies/9/status') {
              expect(options.method, 'PATCH');
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'id': 9,
                    'name': 'Live Co',
                    'status': 'suspended',
                    'activeUsersCount': 2,
                    'driversCount': 1,
                    'vehiclesCount': 1,
                    'trailersCount': 0,
                    'openSupportTicketsCount': 0,
                    'activeSupportAccessGrantsCount': 0,
                    'pendingRegistrationApplicationsCount': 0,
                    'pendingBulkOnboardingJobsCount': 0,
                    'metadataOnly': true,
                  },
                ),
              );
              return;
            }
            if (options.path == '/platform-admin/companies/9/users-summary') {
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'companyId': 9,
                    'activeUsersCount': 2,
                    'invitedUsersCount': 0,
                    'suspendedUsersCount': 0,
                    'totalUsersCount': 2,
                    'driversCount': 1,
                    'usersByRole': {'company_admin': 1},
                    'usersByStatus': {'active': 2},
                    'metadataOnly': true,
                  },
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
    });

    test('fetches companies metadata list', () async {
      final companies = await repo.fetchCompanies();
      expect(companies, hasLength(1));
      expect(companies.first.metadataOnly, isTrue);
      expect(repo.usesMockData, isFalse);
    });

    test('updates company status via patch endpoint', () async {
      final updated = await repo.updateStatus(
        id: '9',
        request: const PlatformCompanyStatusRequest(
          status: PlatformCompanyStatus.suspended,
          reason: 'Compliance hold',
        ),
      );
      expect(updated.status, PlatformCompanyStatus.suspended);
    });

    test('loads users summary metadata', () async {
      final summary = await repo.fetchUsersSummary('9');
      expect(summary.metadataOnly, isTrue);
      expect(summary.totalUsersCount, 2);
    });
  });

  group('MockPlatformCompaniesRepository', () {
    test('returns mock companies and supports status update', () async {
      final repo = MockPlatformCompaniesRepository();
      final companies = await repo.fetchCompanies();
      expect(repo.usesMockData, isTrue);
      expect(companies.length, greaterThanOrEqualTo(2));

      final updated = await repo.updateStatus(
        id: '1',
        request: const PlatformCompanyStatusRequest(
          status: PlatformCompanyStatus.suspended,
          reason: 'Mock hold',
        ),
      );
      expect(updated.status, PlatformCompanyStatus.suspended);
    });

    test('mock search filters companies', () async {
      final repo = MockPlatformCompaniesRepository();
      final filtered = await repo.fetchCompanies(search: 'Alpine');
      expect(filtered, hasLength(1));
      expect(filtered.first.name, contains('Alpine'));
    });
  });
}
