import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/app/admin_staging_build_check.dart';

void main() {
  test('staging build checker passes with example staging API URL', () {
    final issues = runAdminStagingBuildChecks(
      Directory.current,
      appEnv: 'staging',
      apiBaseUrl: 'https://api-staging.example.com',
    );
    expect(issues, isEmpty, reason: issues.join('\n'));
  });

  test('staging build checker fails without API URL', () {
    final issues = runAdminStagingBuildChecks(
      Directory.current,
      appEnv: 'staging',
      apiBaseUrl: '',
    );
    expect(
      issues.any((i) => i.contains('API_BASE_URL is required')),
      isTrue,
    );
  });

  test('staging build checker rejects localhost API URL', () {
    final issues = runAdminStagingBuildChecks(
      Directory.current,
      appEnv: 'staging',
      apiBaseUrl: 'http://localhost:3000',
    );
    expect(
      issues.any((i) => i.contains('localhost')),
      isTrue,
    );
  });
}
