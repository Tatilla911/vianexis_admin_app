import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/core/api/api_client.dart';
import 'package:vianexis_admin_app/core/api/api_exception.dart';
import 'package:vianexis_admin_app/core/api/auth_token_storage.dart';
import 'package:vianexis_admin_app/features/companies/data/platform_companies_api.dart';

void main() {
  test('softDelete falls back to status PATCH when archive route is missing',
      () async {
    var archiveHits = 0;
    var statusHits = 0;
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final path = options.path;
          if (options.method == 'POST' && path.contains('/archive')) {
            archiveHits++;
            return handler.reject(
              DioException(
                requestOptions: options,
                response: Response(
                  requestOptions: options,
                  statusCode: 404,
                  data: {
                    'message':
                        'Cannot POST /platform-admin/companies/7/archive',
                    'errorCode': 'resource_not_found',
                    'requestId': 'req-archive-404',
                  },
                ),
                type: DioExceptionType.badResponse,
              ),
            );
          }
          if (options.method == 'PATCH' && path.contains('/status')) {
            statusHits++;
            return handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'id': 7,
                  'companyName': 'Demo',
                  'status': 'archived',
                },
              ),
            );
          }
          return handler.next(options);
        },
      ),
    );

    final api = PlatformCompaniesApi(
      ApiClient(tokenStorage: AuthTokenStorage(), dio: dio),
    );

    final result = await api.softDelete(id: '7', reason: 'audit reason');
    expect(archiveHits, 1);
    expect(statusHits, 1);
    expect(result['fallback'], 'status_patch');
    expect(result['status'], 'archived');
  });

  test('softDelete does not fall back when company is missing', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          return handler.reject(
            DioException(
              requestOptions: options,
              response: Response(
                requestOptions: options,
                statusCode: 404,
                data: {
                  'message': 'Company not found',
                  'errorCode': 'COMPANY_NOT_FOUND',
                  'requestId': 'req-company-404',
                },
              ),
              type: DioExceptionType.badResponse,
            ),
          );
        },
      ),
    );

    final api = PlatformCompaniesApi(
      ApiClient(tokenStorage: AuthTokenStorage(), dio: dio),
    );

    expect(
      () => api.softDelete(id: '7', reason: 'audit reason'),
      throwsA(isA<ApiException>()),
    );
  });
}
