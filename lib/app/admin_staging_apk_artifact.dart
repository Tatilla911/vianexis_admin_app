import 'dart:io';

import 'admin_staging_build_check.dart';

/// Staging APK artifact preparation (naming + build command — no signing secrets).
class StagingApkArtifactPlan {
  const StagingApkArtifactPlan({
    required this.appEnv,
    required this.apiBaseUrl,
    required this.versionLabel,
    required this.artifactFileName,
    required this.buildCommand,
    required this.dryRun,
    this.copyDestination,
  });

  final String appEnv;
  final String apiBaseUrl;
  final String versionLabel;
  final String artifactFileName;
  final List<String> buildCommand;
  final bool dryRun;
  final String? copyDestination;
}

List<String> runStagingApkArtifactChecks(
  Directory root, {
  required String appEnv,
  required String apiBaseUrl,
  bool dryRun = true,
  bool copyToArtifacts = false,
}) {
  final issues = runAdminStagingBuildChecks(
    root,
    appEnv: appEnv,
    apiBaseUrl: apiBaseUrl,
  );

  if (appEnv.trim().toLowerCase() == 'production' &&
      Platform.environment['STAGING_APK_ALLOW_PRODUCTION'] != 'true') {
    issues.add(
      'Production APP_ENV rejected for staging artifact tool — set STAGING_APK_ALLOW_PRODUCTION=true only if intentional',
    );
  }

  return issues;
}

StagingApkArtifactPlan buildStagingApkArtifactPlan(
  Directory root, {
  required String appEnv,
  required String apiBaseUrl,
  bool dryRun = true,
  bool copyToArtifacts = false,
}) {
  final versionLabel = _readPubspecVersion(root);
  final artifactFileName =
      'ViaNexisAdmin-staging-v$versionLabel.apk';

  final buildCommand = [
    'flutter',
    'build',
    'apk',
    '--release',
    '--dart-define=APP_ENV=$appEnv',
    '--dart-define=API_BASE_URL=$apiBaseUrl',
  ];

  String? copyDestination;
  if (copyToArtifacts && !dryRun) {
    copyDestination =
        '${root.path}${Platform.pathSeparator}build${Platform.pathSeparator}artifacts${Platform.pathSeparator}staging${Platform.pathSeparator}$artifactFileName';
  }

  return StagingApkArtifactPlan(
    appEnv: appEnv,
    apiBaseUrl: apiBaseUrl,
    versionLabel: versionLabel,
    artifactFileName: artifactFileName,
    buildCommand: buildCommand,
    dryRun: dryRun,
    copyDestination: copyDestination,
  );
}

String _readPubspecVersion(Directory root) {
  final pubspec = File('${root.path}${Platform.pathSeparator}pubspec.yaml');
  if (!pubspec.existsSync()) {
    return '0.0.0+0';
  }
  final match =
      RegExp(r'^version:\s*(\S+)', multiLine: true).firstMatch(pubspec.readAsStringSync());
  return match?.group(1) ?? '0.0.0+0';
}

Future<String?> copyBuiltApkIfRequested(
  Directory root,
  StagingApkArtifactPlan plan,
) async {
  if (plan.dryRun || plan.copyDestination == null) {
    return null;
  }

  final defaultApk = File(
    '${root.path}${Platform.pathSeparator}build${Platform.pathSeparator}app${Platform.pathSeparator}outputs${Platform.pathSeparator}flutter-apk${Platform.pathSeparator}app-release.apk',
  );
  if (!defaultApk.existsSync()) {
    throw StateError('Built APK not found at ${defaultApk.path}');
  }

  final dest = File(plan.copyDestination!);
  await dest.parent.create(recursive: true);
  await defaultApk.copy(dest.path);
  return dest.path;
}
