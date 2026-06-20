import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/app/release_readiness.dart';

void main() {
  test('declared brand assets exist on disk', () {
    const assets = [
      'assets/branding/vianexis_logo.png',
      'assets/branding/vianexis_mark.png',
      'assets/branding/vianexis_watermark.png',
      'assets/backgrounds/admin_background.png',
      'assets/icons/app_icon.png',
    ];

    for (final relative in assets) {
      expect(
        File(relative).existsSync(),
        isTrue,
        reason: 'Missing $relative — run python tool/generate_admin_branding.py',
      );
    }
  });

  test('release readiness includes brand asset files', () {
    final issues = runReleaseReadinessChecks(Directory.current);
    expect(
      issues.where((issue) => issue.contains('Missing asset')),
      isEmpty,
      reason: issues.join('\n'),
    );
  });
}
