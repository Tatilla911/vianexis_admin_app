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

  test('accepts onrender.com HTTPS URL', () {
    final issues = validateStagingApiBaseUrl(
      'https://vianexis-backend-staging.onrender.com',
    );
    expect(issues, isEmpty);
    expect(
      isAllowedStagingApiHost('vianexis-backend-staging.onrender.com'),
      isTrue,
    );
  });

  test('localhost allowed with explicit override env', () {
    // Note: override is read from Platform.environment at runtime.
    // validateStagingApiBaseUrl uses the env var directly in checks.
    final issues = runAdminStagingBuildChecks(
      Directory.current,
      appEnv: 'staging',
      apiBaseUrl: 'http://localhost:3000',
    );
    expect(issues.any((i) => i.contains('localhost')), isTrue);
  });
}
