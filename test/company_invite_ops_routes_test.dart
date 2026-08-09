import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/core/api/api_client.dart';
import 'package:vianexis_admin_app/core/api/auth_token_storage.dart';
import 'package:vianexis_admin_app/features/companies/data/platform_companies_api.dart';

/// Locks the previously working Admin App → backend contract.
void main() {
  test('resendInvite posts canonical companies/:id/resend-invite', () async {
    String? hitPath;
    String? hitMethod;
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          hitPath = options.path;
          hitMethod = options.method;
          return handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: {
                'companyId': 7,
                'mode': 'invite',
                'emailSent': true,
                'deliveryStatus': 'sent',
              },
            ),
          );
        },
      ),
    );

    final api = PlatformCompaniesApi(
      ApiClient(tokenStorage: AuthTokenStorage(), dio: dio),
    );
    final result = await api.resendInvite('7');

    expect(hitMethod, 'POST');
    expect(hitPath, '/platform-admin/companies/7/resend-invite');
    expect(result['mode'], 'invite');
  });

  test('sendPasswordSetup posts canonical companies/:id/send-password-setup',
      () async {
    String? hitPath;
    String? hitMethod;
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          hitPath = options.path;
          hitMethod = options.method;
          return handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: {
                'companyId': 7,
                'mode': 'password_reset',
                'emailSent': true,
                'deliveryStatus': 'sent',
              },
            ),
          );
        },
      ),
    );

    final api = PlatformCompaniesApi(
      ApiClient(tokenStorage: AuthTokenStorage(), dio: dio),
    );
    final result = await api.sendPasswordSetup('7');

    expect(hitMethod, 'POST');
    expect(hitPath, '/platform-admin/companies/7/send-password-setup');
    expect(result['mode'], 'password_reset');
  });
}
