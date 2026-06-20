// ignore_for_file: avoid_print
import 'dart:io';

import 'package:vianexis_admin_app/app/admin_app_smoke_check.dart';

/// Run: dart run tool/admin_app_smoke_check.dart
void main() {
  final root = _findProjectRoot();
  final issues = runAdminAppSmokeChecks(root);
  if (issues.isEmpty) {
    print('Admin app smoke check: OK');
    exit(0);
  }
  print('Admin app smoke check: ${issues.length} issue(s)');
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
