import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/core/api/api_client.dart';
import 'package:vianexis_admin_app/core/api/auth_token_storage.dart';
import 'package:vianexis_admin_app/features/applications/data/public_applications_api.dart';
import 'package:vianexis_admin_app/features/registrations/data/registration_applications_api.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
  });

  test('registration sendPasswordSetup posts live endpoint', () async {
    final dio = Dio(
      BaseOptions(baseUrl: 'https://vianexis-staging-api.onrender.com'),
    );
    final client = ApiClient(
      tokenStorage: AuthTokenStorage(),
      dio: dio,
      enableDebugLogging: false,
    );
    RequestOptions? seen;
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          seen = options;
          handler.resolve(
            Response<Map<String, dynamic>>(
              requestOptions: options,
              statusCode: 200,
              data: {
                'emailSent': false,
                'emailDeliveryStatus': 'provider_disabled',
                'companyId': 7,
              },
            ),
          );
        },
      ),
    );

    final api = RegistrationApplicationsApi(client);
    final result = await api.sendPasswordSetup('42');

    expect(seen, isNotNull);
    expect(seen!.method, 'POST');
    expect(
      seen!.path,
      '/platform-admin/registration-applications/42/send-password-setup',
    );
    expect(result['emailDeliveryStatus'], 'provider_disabled');
  });

  test(
    'public applications resendActivationInvite posts live endpoint',
    () async {
      final dio = Dio(
        BaseOptions(baseUrl: 'https://vianexis-staging-api.onrender.com'),
      );
      final client = ApiClient(
        tokenStorage: AuthTokenStorage(),
        dio: dio,
        enableDebugLogging: false,
      );
      RequestOptions? seen;
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            seen = options;
            handler.resolve(
              Response<Map<String, dynamic>>(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'inviteId': 12,
                  'deliveryStatus': 'sent',
                  'emailInviteSent': true,
                },
              ),
            );
          },
        ),
      );

      final api = PublicApplicationsApi(client);
      final result = await api.resendActivationInvite(99);

      expect(seen, isNotNull);
      expect(seen!.method, 'POST');
      expect(
        seen!.path,
        '/platform-admin/applications/99/resend-activation-invite',
      );
      expect(result['deliveryStatus'], 'sent');
    },
  );
}
