import 'package:vianexis_admin_app/app/app_config.dart';
import 'package:vianexis_admin_app/app/app_environment.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppEnvironment.fromDefine', () {
    test('defaults to local when unset', () {
      expect(AppEnvironment.fromDefine(null), AppEnvironment.local);
      expect(AppEnvironment.fromDefine(''), AppEnvironment.local);
    });

    test('parses known profiles', () {
      expect(AppEnvironment.fromDefine('dev'), AppEnvironment.dev);
      expect(AppEnvironment.fromDefine('staging'), AppEnvironment.staging);
      expect(AppEnvironment.fromDefine('production'), AppEnvironment.production);
      expect(AppEnvironment.fromDefine('local'), AppEnvironment.local);
    });

    test('maps legacy devlocal alias to dev', () {
      expect(AppEnvironment.fromDefine('devlocal'), AppEnvironment.dev);
    });
  });

  group('AppConfig compile-time defaults', () {
    test('mock fallback allowed by default in test harness', () {
      final config = AppConfig.instance;
      expect(config.environment, AppEnvironment.local);
      expect(config.isMockFallbackAllowed, isTrue);
    });

    test('environment mock policy by profile', () {
      expect(AppEnvironment.local.allowsMockFallbackByDefault, isTrue);
      expect(AppEnvironment.dev.allowsMockFallbackByDefault, isTrue);
      expect(AppEnvironment.staging.allowsMockFallbackByDefault, isFalse);
      expect(AppEnvironment.production.allowsMockFallbackByDefault, isFalse);
    });

    test('production without API requires live repositories', () {
      final config = AppConfig.instance;
      if (config.environment.isProduction && !config.isApiConfigured) {
        expect(config.isMockFallbackAllowed, isFalse);
        expect(config.shouldUseLiveRepositories, isTrue);
        expect(config.isMockFallbackActive, isFalse);
      }
    });

    test('safe API host display avoids exposing full URL path', () {
      final config = AppConfig.instance;
      if (config.isApiConfigured) {
        expect(config.safeApiHostDisplay, isNot(contains('/auth')));
      } else {
        expect(config.safeApiHostDisplay, isNull);
      }
    });
  });
}
