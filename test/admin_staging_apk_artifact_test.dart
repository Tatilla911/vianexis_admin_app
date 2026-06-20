import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/app/admin_staging_apk_artifact.dart';

void main() {
  test('artifact naming includes staging and version', () {
    final plan = buildStagingApkArtifactPlan(
      Directory.current,
      appEnv: 'staging',
      apiBaseUrl: 'https://api-staging.example.com',
    );
    expect(plan.artifactFileName, startsWith('ViaNexisAdmin-staging-v'));
    expect(plan.artifactFileName, endsWith('.apk'));
    expect(plan.buildCommand, contains('--dart-define=APP_ENV=staging'));
  });

  test('missing API URL fails checks', () {
    final issues = runStagingApkArtifactChecks(
      Directory.current,
      appEnv: 'staging',
      apiBaseUrl: '',
    );
    expect(
      issues.any((i) => i.contains('API_BASE_URL is required')),
      isTrue,
    );
  });

  test('staging env accepted', () {
    final issues = runStagingApkArtifactChecks(
      Directory.current,
      appEnv: 'staging',
      apiBaseUrl: 'https://api-staging.example.com',
    );
    expect(issues, isEmpty);
  });

  test('production env rejected by default', () {
    final issues = runStagingApkArtifactChecks(
      Directory.current,
      appEnv: 'production',
      apiBaseUrl: 'https://api-staging.example.com',
    );
    expect(
      issues.any((i) => i.contains('Production APP_ENV rejected')),
      isTrue,
    );
  });

  test('dry-run plan does not require built apk copy', () async {
    final plan = buildStagingApkArtifactPlan(
      Directory.current,
      appEnv: 'staging',
      apiBaseUrl: 'https://api-staging.example.com',
      dryRun: true,
      copyToArtifacts: true,
    );
    expect(await copyBuiltApkIfRequested(Directory.current, plan), isNull);
  });
}
