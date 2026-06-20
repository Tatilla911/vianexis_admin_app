import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/notifications/widgets/notification_badge.dart';

void main() {
  testWidgets('notification badge hides at zero and shows count', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: NotificationBadge(count: 0)),
      ),
    );
    expect(find.text('0'), findsNothing);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: NotificationBadge(count: 7)),
      ),
    );
    expect(find.text('7'), findsOneWidget);
  });
}
