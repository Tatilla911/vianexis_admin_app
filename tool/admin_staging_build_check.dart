// ignore_for_file: avoid_print
import 'dart:io';

import 'package:vianexis_admin_app/app/admin_staging_build_check.dart';

/// Run: dart run tool/admin_staging_build_check.dart
///
/// Optional env overrides (for CI):
///   STAGING_BUILD_APP_ENV=staging
///   STAGING_BUILD_API_BASE_URL=https://api-staging.example.com
void main() {
  final root = _findProjectRoot();
  final appEnv = Platform.environment['STAGING_BUILD_APP_ENV'] ?? 'staging';
  final apiBaseUrl =
      Platform.environment['STAGING_BUILD_API_BASE_URL'] ??
      'https://api-staging.example.com';

  final issues = runAdminStagingBuildChecks(
    root,
    appEnv: appEnv,
    apiBaseUrl: apiBaseUrl,
  );

  if (issues.isEmpty) {
    print('Admin staging build check: OK');
    exit(0);
  }

  print('Admin staging build check: ${issues.length} issue(s)');
  for (final issue in issues) {
    print('  - $issue');
  }
  exit(1);
}

Directory _findProjectRoot() {
  var dir = Directory.current;
  while (true) {
    if (File('${dir.path}${Platform.pathSeparator}pubspec.yaml').existsSync()) {
      return dir;
    }
    final parent = dir.parent;
    if (parent.path == dir.path) {
      return Directory.current;
    }
    dir = parent;
  }
}
