import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/app/app_config.dart';
import 'package:vianexis_admin_app/app/app_environment.dart';
import 'package:vianexis_admin_app/app/canonical_api_hosts.dart';

void main() {
  group('AppConfig.resolveApiBaseUrl', () {
    test('staging without saved URL → staging API', () {
      final url = AppConfig.resolveApiBaseUrl(
        environment: AppEnvironment.staging,
        explicitApiBaseUrl: '',
      );
      expect(url, CanonicalApiHosts.staging);
      expect(url, isNotEmpty);
    });

    test('local/dev without define stay empty so mock fallback remains', () {
      expect(
        AppConfig.resolveApiBaseUrl(
          environment: AppEnvironment.local,
          explicitApiBaseUrl: '',
        ),
        isEmpty,
      );
      expect(
        AppConfig.resolveApiBaseUrl(
          environment: AppEnvironment.dev,
          explicitApiBaseUrl: '',
        ),
        isEmpty,
      );
    });

    test('explicit API_BASE_URL wins', () {
      const override = 'https://custom-api.example.com';
      expect(
        AppConfig.resolveApiBaseUrl(
          environment: AppEnvironment.staging,
          explicitApiBaseUrl: override,
        ),
        override,
      );
      expect(
        AppConfig.resolveApiBaseUrl(
          environment: AppEnvironment.production,
          explicitApiBaseUrl: '$override/',
        ),
        override,
      );
      expect(
        AppConfig.resolveApiBaseUrl(
          environment: AppEnvironment.local,
          explicitApiBaseUrl: override,
        ),
        override,
      );
    });

    test('production environment → production API', () {
      expect(
        AppConfig.resolveApiBaseUrl(
          environment: AppEnvironment.production,
          explicitApiBaseUrl: '',
        ),
        CanonicalApiHosts.production,
      );
    });

    test('staging fresh prefs path is configured', () {
      final config = AppConfig.forTest(
        environment: AppEnvironment.staging,
        apiBaseUrl: AppConfig.resolveApiBaseUrl(
          environment: AppEnvironment.staging,
          explicitApiBaseUrl: '',
        ),
      );
      expect(config.isApiConfigured, isTrue);
      expect(config.isMockFallbackActive, isFalse);
      expect(config.safeApiHostDisplay, 'vianexis-staging-api.onrender.com');
    });

    test('local without URL remains mock-fallback eligible', () {
      final config = AppConfig.forTest(
        environment: AppEnvironment.local,
        apiBaseUrl: AppConfig.resolveApiBaseUrl(
          environment: AppEnvironment.local,
          explicitApiBaseUrl: '',
        ),
      );
      expect(config.isApiConfigured, isFalse);
      expect(config.isMockFallbackActive, isTrue);
    });
  });
}
