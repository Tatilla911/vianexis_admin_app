import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/driver_access/domain/driver_registration_email_status.dart';
import 'package:vianexis_admin_app/features/driver_access/domain/driver_registration_request.dart';
import 'package:vianexis_admin_app/l10n/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('parses notification email status from registration JSON', () {
    final item = DriverRegistrationRequestItem.fromJson({
      'id': 12,
      'fullName': 'Test Driver',
      'email': 'driver@example.test',
      'status': 'rejected',
      'notificationEmailStatus': 'failed',
      'notificationEmailAt': '2026-09-02T10:00:00.000Z',
    });
    expect(item.notificationEmailStatus, 'failed');
    expect(item.notificationEmailAt, isNotNull);
  });

  test('decision result prefers notificationEmailStatus over deliveryStatus', () {
    final result = DriverRegistrationDecisionResult.fromJson({
      'deliveryStatus': 'queued',
      'notificationEmailStatus': 'sent',
      'request': {'notificationEmailStatus': 'failed'},
    });
    expect(result.notificationEmailStatus, 'sent');
  });

  testWidgets('localizes email delivery statuses', (tester) async {
    late BuildContext captured;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: Builder(
          builder: (context) {
            captured = context;
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      resolveDriverRegistrationEmailStatus(captured, 'queued'),
      'Email queued',
    );
    expect(
      resolveDriverRegistrationEmailStatus(captured, 'sent'),
      'Email sent',
    );
    expect(
      resolveDriverRegistrationEmailStatus(captured, 'failed'),
      'Email delivery failed',
    );
  });
}
