import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/app/app_config.dart';
import 'package:vianexis_admin_app/app/vianexis_admin_app.dart';

void main() {
  test('staging/release config does not treat DEBUG banner as always-on', () {
    expect(AppConfig.instance.isDebugBannerVisible, kDebugMode);
  });

  testWidgets('MaterialApp disables checked-mode DEBUG banner', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: VianexisAdminApp()));
    await tester.pump();

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.debugShowCheckedModeBanner, isFalse);
  });
}
