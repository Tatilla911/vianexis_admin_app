import 'dart:io';

import 'admin_app_smoke_check.dart';

const stagingAllowLocalhostEnv = 'STAGING_ALLOW_LOCALHOST';

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
    issues.addAll(validateStagingApiBaseUrl(apiBaseUrl));
  }

  _validateStagingMockFallbackPolicy(root, issues);
  _validateAppVersion(root, issues);
  _validateStagingBuildDocs(root, issues);
  _validateNoHardcodedRenderStagingUrl(root, issues);
  _validateDartDefineBasedApiConfig(root, issues);

  return issues;
}

/// Validates staging [apiBaseUrl] — HTTPS host required; Render onrender.com allowed.
List<String> validateStagingApiBaseUrl(String apiBaseUrl) {
  final issues = <String>[];
  final trimmed = apiBaseUrl.trim();

  final uri = Uri.tryParse(trimmed);
  if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
    issues.add('API_BASE_URL must be a valid absolute URL');
    return issues;
  }

  if (uri.scheme != 'https') {
    issues.add('Staging API_BASE_URL should use HTTPS');
  }

  final allowLocalhost =
      Platform.environment[stagingAllowLocalhostEnv]?.trim().toLowerCase() ==
      'true';

  if (!allowLocalhost &&
      (trimmed.contains('localhost') || trimmed.contains('127.0.0.1'))) {
    issues.add(
      'Staging API_BASE_URL should not use localhost — set $stagingAllowLocalhostEnv=true only for local override',
    );
  }

  return issues;
}

bool isAllowedStagingApiHost(String host) {
  final normalized = host.trim().toLowerCase();
  if (normalized.endsWith('.onrender.com')) {
    return true;
  }
  if (normalized.contains('staging') || normalized.contains('example.com')) {
    return true;
  }
  return false;
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

void _validateNoHardcodedRenderStagingUrl(Directory root, List<String> issues) {
  final libDir = Directory('${root.path}${Platform.pathSeparator}lib');
  if (!libDir.existsSync()) {
    return;
  }

  final onRenderUrl = RegExp(
    r'https://[a-zA-Z0-9.-]+\.onrender\.com',
    caseSensitive: false,
  );

  for (final entity in libDir.listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) {
      continue;
    }
    final text = entity.readAsStringSync();
    if (onRenderUrl.hasMatch(text)) {
      issues.add(
        'Hardcoded Render staging URL in source — use dart-define API_BASE_URL instead: ${entity.path}',
      );
    }
  }
}

void _validateDartDefineBasedApiConfig(Directory root, List<String> issues) {
  final configFile = File(
    '${root.path}${Platform.pathSeparator}lib${Platform.pathSeparator}app${Platform.pathSeparator}app_config.dart',
  );
  if (!configFile.existsSync()) {
    return;
  }
  final text = configFile.readAsStringSync();
  if (!text.contains('String.fromEnvironment')) {
    issues.add('app_config.dart should read API_BASE_URL from dart-define');
  }
  if (text.contains('.onrender.com')) {
    issues.add('app_config.dart must not hardcode onrender.com staging URL');
  }
}
