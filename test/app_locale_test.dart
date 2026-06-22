import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vianexis_admin_app/core/locale/app_locale_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('default admin locale is Hungarian', () {
    expect(kDefaultAdminLocale.languageCode, 'hu');
  });

  test('resolveAppLocale falls back to Hungarian for unsupported device locale', () {
    expect(
      resolveAppLocale(const Locale('de'), const [Locale('en'), Locale('hu')])
          .languageCode,
      'hu',
    );
  });

  test('resolveAppLocale respects supported English device locale', () {
    expect(
      resolveAppLocale(const Locale('en', 'US'), const [Locale('en'), Locale('hu')])
          .languageCode,
      'en',
    );
  });
}
