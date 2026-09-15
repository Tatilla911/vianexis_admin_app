import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/core/api/api_client.dart';
import 'package:vianexis_admin_app/core/api/auth_token_storage.dart';
import 'package:vianexis_admin_app/features/driver_access/data/driver_access_repository.dart';
import 'package:vianexis_admin_app/features/driver_access/domain/driver_access_profile.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
  });

  group('LiveDriverAccessRepository.fetchOperationalHealth', () {
    late Dio dio;
    late LiveDriverAccessRepository repository;
    String? requestedPath;

    setUp(() {
      requestedPath = null;
      dio = Dio(BaseOptions(baseUrl: 'https://api.test.local'));
      repository = LiveDriverAccessRepository(
        ApiClient(
          tokenStorage: AuthTokenStorage(),
          dio: dio,
          enableDebugLogging: false,
        ),
      );
    });

    test('GETs operational-health and parses issues', () async {
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            requestedPath = options.path;
            handler.resolve(
              Response<Map<String, dynamic>>(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'overallLevel': 'yellow',
                  'activeIssueCount': 1,
                  'remoteRetryPossible': false,
                  'issues': [
                    {
                      'id': '9',
                      'category': 'profile_sync',
                      'code': 'sync.profile.failed',
                      'severity': 'yellow',
                      'status': 'active',
                      'attemptCount': 2,
                      'safeErrorCode': 'network',
                    },
                  ],
                },
              ),
            );
          },
        ),
      );

      final detail = await repository.fetchOperationalHealth('d-101');
      expect(requestedPath, '/platform-admin/drivers/d-101/operational-health');
      expect(detail, isNotNull);
      expect(detail!.overallLevel, DriverOperationalHealthLevel.yellow);
      expect(detail.issues, hasLength(1));
      expect(detail.issues.first.attemptCount, 2);
    });

    test('returns null when operational-health is not deployed', () async {
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            handler.reject(
              DioException(
                requestOptions: options,
                response: Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 404,
                  data: const <String, dynamic>{},
                ),
                type: DioExceptionType.badResponse,
              ),
            );
          },
        ),
      );

      expect(await repository.fetchOperationalHealth('d-101'), isNull);
    });
  });
}
