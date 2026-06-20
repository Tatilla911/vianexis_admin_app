import 'dart:io';

import 'release_readiness.dart';

/// Local project smoke checks — no live API login required.
List<String> runAdminAppSmokeChecks(Directory root) {
  final issues = <String>[
    ...runReleaseReadinessChecks(root),
  ];

  for (final relative in _requiredL10nFiles) {
    if (!File('${root.path}${Platform.pathSeparator}$relative').existsSync()) {
      issues.add('Missing localization file: $relative');
    }
  }

  for (final relative in _smokeDocs) {
    if (!File('${root.path}${Platform.pathSeparator}$relative').existsSync()) {
      issues.add('Missing smoke doc: $relative');
    }
  }

  _validateAppConfigSources(root, issues);

  return issues;
}

void _validateAppConfigSources(Directory root, List<String> issues) {
  final envFile = File(
    '${root.path}${Platform.pathSeparator}lib${Platform.pathSeparator}app${Platform.pathSeparator}app_environment.dart',
  );
  if (!envFile.existsSync()) {
    issues.add('Missing app_environment.dart');
    return;
  }
  final envText = envFile.readAsStringSync();
  for (final profile in ['local', 'dev', 'staging', 'production']) {
    if (!envText.contains("'$profile'")) {
      issues.add('app_environment.dart should define profile: $profile');
    }
  }
  if (!envText.contains('fromDefine')) {
    issues.add('app_environment.dart should parse dart-define APP_ENV');
  }

  final configFile = File(
    '${root.path}${Platform.pathSeparator}lib${Platform.pathSeparator}app${Platform.pathSeparator}app_config.dart',
  );
  if (!configFile.existsSync()) {
    issues.add('Missing app_config.dart');
    return;
  }
  final configText = configFile.readAsStringSync();
  for (final token in [
    'fromEnvironment',
    'AppEnvironment.fromDefine',
    'isProductionMisconfigured',
    'isApiConfigured',
  ]) {
    if (!configText.contains(token)) {
      issues.add('app_config.dart should expose: $token');
    }
  }
}

const _requiredL10nFiles = [
  'lib/l10n/app_en.arb',
  'lib/l10n/app_hu.arb',
  'lib/l10n/app_localizations.dart',
];

const _smokeDocs = [
  'docs/ADMIN_APP_SMOKE_TESTS.md',
];
