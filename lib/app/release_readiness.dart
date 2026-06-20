import 'dart:io';

/// Conservative release readiness checks for ViaNexis Admin app.
List<String> runReleaseReadinessChecks(Directory root) {
  final issues = <String>[];

  for (final relative in _requiredDocs) {
    if (!File('${root.path}${Platform.pathSeparator}$relative').existsSync()) {
      issues.add('Missing doc: $relative');
    }
  }

  final pubspec = File('${root.path}${Platform.pathSeparator}pubspec.yaml');
  if (!pubspec.existsSync()) {
    issues.add('Missing pubspec.yaml');
  }
  final pubspecText = pubspec.existsSync() ? pubspec.readAsStringSync() : '';
  for (final relative in _requiredAssetDeclarations) {
    if (!pubspecText.contains(relative)) {
      issues.add('pubspec.yaml should declare asset: $relative');
      continue;
    }
    final assetFile = File('${root.path}${Platform.pathSeparator}$relative');
    if (!assetFile.existsSync()) {
      issues.add('Missing asset file: $relative');
    }
  }

  final readme = File('${root.path}${Platform.pathSeparator}README.md');
  if (readme.existsSync()) {
    final text = readme.readAsStringSync();
    for (final token in ['APP_ENV', 'API_BASE_URL', 'flutter build apk']) {
      if (!text.contains(token)) {
        issues.add('README.md should document: $token');
      }
    }
  } else {
    issues.add('Missing README.md');
  }

  final manifest = File(
    '${root.path}${Platform.pathSeparator}android${Platform.pathSeparator}app${Platform.pathSeparator}src${Platform.pathSeparator}main${Platform.pathSeparator}AndroidManifest.xml',
  );
  if (manifest.existsSync()) {
    final text = manifest.readAsStringSync();
    if (!text.contains('ViaNexis Admin')) {
      issues.add('Android label should be ViaNexis Admin');
    }
  }

  final infoPlist = File(
    '${root.path}${Platform.pathSeparator}ios${Platform.pathSeparator}Runner${Platform.pathSeparator}Info.plist',
  );
  if (infoPlist.existsSync()) {
    final text = infoPlist.readAsStringSync();
    if (!text.contains('ViaNexis Admin')) {
      issues.add('iOS display name should be ViaNexis Admin');
    }
  }

  final appConfig = File(
    '${root.path}${Platform.pathSeparator}lib${Platform.pathSeparator}app${Platform.pathSeparator}app_config.dart',
  );
  if (appConfig.existsSync()) {
    final text = appConfig.readAsStringSync();
    if (text.contains('localhost') || text.contains('127.0.0.1')) {
      issues.add('app_config.dart must not hardcode localhost');
    }
  }

  return issues;
}

const _requiredDocs = [
  'docs/ADMIN_APP_ENVIRONMENTS.md',
  'docs/ADMIN_APP_RUNBOOK.md',
  'docs/ADMIN_APP_RELEASE_CHECKLIST.md',
  'docs/QUALITY-GATES.md',
  'docs/admin-app-current-status.md',
];

const _requiredAssetDeclarations = [
  'assets/branding/vianexis_logo.png',
  'assets/branding/vianexis_mark.png',
  'assets/branding/vianexis_watermark.png',
  'assets/backgrounds/admin_background.png',
  'assets/icons/app_icon.png',
];
