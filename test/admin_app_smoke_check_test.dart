import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/app/admin_app_smoke_check.dart';

void main() {
  test('admin app smoke checker passes for current project', () {
    final issues = runAdminAppSmokeChecks(Directory.current);
    expect(issues, isEmpty, reason: issues.join('\n'));
  });
}
