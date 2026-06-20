// ignore_for_file: avoid_print
import 'dart:io';

import 'package:vianexis_admin_app/app/admin_staging_apk_artifact.dart';

/// Run: dart run tool/prepare_staging_apk_artifact.dart
///
/// Env / args:
///   STAGING_APK_APP_ENV=staging (default)
///   STAGING_APK_API_BASE_URL=https://api-staging.example.com (required)
///   STAGING_APK_DRY_RUN=true (default — prints command only)
///   STAGING_APK_COPY=true (optional — copy to build/artifacts/staging/ after build)
///   STAGING_APK_EXECUTE=true (runs flutter build when dry-run false)
void main(List<String> args) async {
  final root = _findProjectRoot();
  final appEnv = Platform.environment['STAGING_APK_APP_ENV'] ?? 'staging';
  final apiBaseUrl = Platform.environment['STAGING_APK_API_BASE_URL'] ?? '';
  final dryRun = _parseBool(
    Platform.environment['STAGING_APK_DRY_RUN'],
    defaultValue: true,
  );
  final copyToArtifacts = _parseBool(
    Platform.environment['STAGING_APK_COPY'],
    defaultValue: false,
  );
  final execute = _parseBool(
    Platform.environment['STAGING_APK_EXECUTE'],
    defaultValue: !dryRun,
  );

  final issues = runStagingApkArtifactChecks(
    root,
    appEnv: appEnv,
    apiBaseUrl: apiBaseUrl,
    dryRun: dryRun,
    copyToArtifacts: copyToArtifacts,
  );

  if (issues.isNotEmpty) {
    print('Staging APK artifact: ${issues.length} issue(s)');
    for (final issue in issues) {
      print('  - $issue');
    }
    exit(1);
  }

  final plan = buildStagingApkArtifactPlan(
    root,
    appEnv: appEnv,
    apiBaseUrl: apiBaseUrl,
    dryRun: dryRun,
    copyToArtifacts: copyToArtifacts,
  );

  print('Staging APK artifact plan: OK');
  print('  version: ${plan.versionLabel}');
  print('  artifact: ${plan.artifactFileName}');
  print('  command: ${plan.buildCommand.join(' ')}');

  if (dryRun) {
    print('\nDry-run mode — no build executed. Set STAGING_APK_DRY_RUN=false to build.');
    exit(0);
  }

  if (execute) {
    final result = await Process.run(
      plan.buildCommand.first,
      plan.buildCommand.sublist(1),
      workingDirectory: root.path,
      runInShell: true,
    );
    if (result.exitCode != 0) {
      print('flutter build failed (exit ${result.exitCode})');
      exit(result.exitCode);
    }
  }

  if (copyToArtifacts) {
    try {
      final copied = await copyBuiltApkIfRequested(root, plan);
      if (copied != null) {
        print('Copied to: $copied');
      }
    } on StateError catch (e) {
      print(e.message);
      exit(1);
    }
  }

  print('\nDefault output: build/app/outputs/flutter-apk/app-release.apk');
  print('Rename to: ${plan.artifactFileName} for distribution');
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

bool _parseBool(String? raw, {required bool defaultValue}) {
  if (raw == null || raw.trim().isEmpty) return defaultValue;
  final normalized = raw.trim().toLowerCase();
  return normalized == '1' ||
      normalized == 'true' ||
      normalized == 'yes' ||
      normalized == 'on';
}
