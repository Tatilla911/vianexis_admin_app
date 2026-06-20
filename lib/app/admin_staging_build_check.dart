import 'dart:io';

import 'admin_app_smoke_check.dart';

/// Staging APK build readiness checks (no live API login).
List<String> runAdminStagingBuildChecks(
  Directory root, {
  String appEnv = 'staging',
  String apiBaseUrl = '',
}) {
  final issues = <String>[
    ...runAdminAppSmokeChecks(root),
  ];

  final normalizedEnv = appEnv.trim().toLowerCase();
  if (normalizedEnv != 'staging') {
    issues.add('APP_ENV must be staging for staging build check (got: $appEnv)');
  }

  if (apiBaseUrl.trim().isEmpty) {
    issues.add('API_BASE_URL is required for staging builds');
  } else {
    final uri = Uri.tryParse(apiBaseUrl.trim());
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
      issues.add('API_BASE_URL must be a valid absolute URL');
    }
    if (apiBaseUrl.contains('localhost') || apiBaseUrl.contains('127.0.0.1')) {
      issues.add('Staging API_BASE_URL should not use localhost');
    }
  }

  _validateStagingMockFallbackPolicy(root, issues);
  _validateAppVersion(root, issues);
  _validateStagingBuildDocs(root, issues);

  return issues;
}

void _validateStagingMockFallbackPolicy(Directory root, List<String> issues) {
  final envFile = File(
    '${root.path}${Platform.pathSeparator}lib${Platform.pathSeparator}app${Platform.pathSeparator}app_environment.dart',
  );
  if (!envFile.existsSync()) {
    return;
  }
  final text = envFile.readAsStringSync();
  if (!text.contains('allowsMockFallbackByDefault')) {
    issues.add('app_environment.dart should define mock fallback policy');
    return;
  }
  if (!text.contains('this == AppEnvironment.local || this == AppEnvironment.dev')) {
    issues.add('Mock fallback should be limited to local/dev by default');
  }
}

void _validateAppVersion(Directory root, List<String> issues) {
  final pubspec = File('${root.path}${Platform.pathSeparator}pubspec.yaml');
  if (!pubspec.existsSync()) {
    return;
  }
  final match = RegExp(r'^version:\s*(\S+)', multiLine: true)
      .firstMatch(pubspec.readAsStringSync());
  if (match == null) {
    issues.add('pubspec.yaml should declare version for staging artifact tracking');
    return;
  }
  final version = match.group(1)!;
  if (!version.contains('+')) {
    issues.add('pubspec.yaml version should include build number (e.g. 1.0.0+1)');
  }
}

void _validateStagingBuildDocs(Directory root, List<String> issues) {
  final doc = File(
    '${root.path}${Platform.pathSeparator}docs${Platform.pathSeparator}ADMIN_APP_STAGING_BUILD.md',
  );
  if (!doc.existsSync()) {
    issues.add('Missing docs/ADMIN_APP_STAGING_BUILD.md');
    return;
  }
  final text = doc.readAsStringSync();
  for (final token in [
    'APP_ENV=staging',
    'API_BASE_URL',
    'flutter build apk',
  ]) {
    if (!text.contains(token)) {
      issues.add('ADMIN_APP_STAGING_BUILD.md should document: $token');
    }
  }
  if (RegExp(r'localhost|127\.0\.0\.1').hasMatch(text) &&
      !text.contains('should not')) {
    issues.add(
      'ADMIN_APP_STAGING_BUILD.md should not recommend localhost for staging builds',
    );
  }
}
