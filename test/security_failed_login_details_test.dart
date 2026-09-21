import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/security_center/domain/security_event.dart';
import 'package:vianexis_admin_app/features/security_center/domain/security_event_severity.dart';
import 'package:vianexis_admin_app/features/security_center/domain/security_event_type.dart';
import 'package:vianexis_admin_app/features/security_center/presentation/security_center_providers.dart';
import 'package:vianexis_admin_app/features/security_center/presentation/security_event_detail_screen.dart';
import 'package:vianexis_admin_app/features/security_center/presentation/widgets/security_event_card.dart';
import 'package:vianexis_admin_app/l10n/app_localizations.dart';

final _failedLoginFixture = SecurityEvent(
  id: 'audit:901',
  type: SecurityEventType.failedLogin,
  severity: SecurityEventSeverity.warning,
  title: 'Failed login attempt',
  summary: 'Login failed (invalid_credentials) — s***@vianexis.test',
  result: 'failed',
  reason: 'invalid_credentials',
  accountEmailRedacted: 's***@vianexis.test',
  ipFingerprint: 'a1b2c3d4e5f67890',
  deviceSummary: 'Admin Android',
  platform: 'android',
  sourceType: 'system_audit_log',
  sourceId: '901',
  createdAt: DateTime.utc(2026, 6, 19, 7, 15),
);

class _FixedEventsNotifier extends SecurityEventsNotifier {
  @override
  Future<List<SecurityEvent>> build() async => [_failedLoginFixture];
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('parses failed-login detail fields from JSON', () {
    final event = SecurityEvent.fromJson({
      'id': 'audit:1',
      'type': 'failed_login',
      'severity': 'warning',
      'title': 'Failed login attempt',
      'summary': 'Login failed (locked)',
      'sourceType': 'system_audit_log',
      'result': 'failed',
      'reason': 'locked',
      'accountEmailRedacted': 'a***@example.com',
      'ipFingerprint': 'deadbeefcafebabe',
      'deviceSummary': 'iOS',
      'platform': 'ios',
      'createdAt': '2026-09-20T12:00:00.000Z',
    });
    expect(event.reason, 'locked');
    expect(event.result, 'failed');
    expect(event.accountEmailRedacted, 'a***@example.com');
    expect(event.ipFingerprint, 'deadbeefcafebabe');
    expect(event.platform, 'ios');
  });

  testWidgets('card shows full failed-login summary without ellipsis clip', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: SecurityEventCard(event: _failedLoginFixture)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('invalid_credentials'), findsWidgets);
    expect(find.textContaining('s***@vianexis.test'), findsWidgets);
  });

  testWidgets('detail screen shows actionable failed-login fields', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          securityEventsProvider.overrideWith(_FixedEventsNotifier.new),
        ],
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const SecurityEventDetailScreen(eventId: 'audit:901'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('failed'), findsOneWidget);
    expect(find.text('invalid_credentials'), findsOneWidget);
    expect(find.text('s***@vianexis.test'), findsOneWidget);
    expect(find.text('a1b2c3d4e5f67890'), findsOneWidget);
    expect(find.text('android'), findsOneWidget);
    expect(find.text('Admin Android'), findsOneWidget);
  });
}
