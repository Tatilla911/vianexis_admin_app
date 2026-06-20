import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/app/release_readiness.dart';

void main() {
  test('release readiness checker passes for current project', () {
    final issues = runReleaseReadinessChecks(Directory.current);
    expect(issues, isEmpty, reason: issues.join('\n'));
  });
}
