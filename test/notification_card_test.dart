import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:vianexis_admin_app/features/notifications/domain/admin_notification.dart';
import 'package:vianexis_admin_app/features/notifications/domain/admin_notification_presentation.dart';
import 'package:vianexis_admin_app/features/notifications/domain/notification_severity.dart';
import 'package:vianexis_admin_app/features/notifications/domain/notification_type.dart';
import 'package:vianexis_admin_app/features/notifications/widgets/notification_card.dart';
import 'package:vianexis_admin_app/l10n/app_localizations.dart';

Widget _app({required Widget home, Locale locale = const Locale('en')}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: home,
  );
}

AdminNotification _item({
  String id = 'n-1',
  String title = 'New driver document received',
  String body = 'Péter Kovács uploaded a new driving licence.',
  DateTime? createdAt,
  DateTime? readAt,
  NotificationType type = NotificationType.general,
  NotificationSeverity severity = NotificationSeverity.info,
  Map<String, String> metadata = const {},
  String? titleKey,
  String? messageKey,
  bool inAppOnly = true,
}) {
  return AdminNotification(
    id: id,
    title: title,
    body: body,
    type: type,
    severity: severity,
    createdAt: createdAt ?? DateTime(2026, 9, 16, 20, 41),
    readAt: readAt,
    metadata: metadata,
    inAppOnly: inAppOnly,
    titleKey: titleKey,
    messageKey: messageKey,
  );
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('en');
    await initializeDateFormatting('hu');
  });

  group('formatNotificationTimestamp', () {
    final now = DateTime(2026, 9, 16, 21, 0);

    test('today uses HH:mm', () {
      expect(
        formatNotificationTimestamp(
          createdAt: DateTime(2026, 9, 16, 20, 41),
          now: now,
          localeName: 'en',
          yesterdayLabel: 'Yesterday',
        ),
        '20:41',
      );
    });

    test('yesterday includes localized label and time', () {
      expect(
        formatNotificationTimestamp(
          createdAt: DateTime(2026, 9, 15, 9, 5),
          now: now,
          localeName: 'en',
          yesterdayLabel: 'Yesterday',
        ),
        'Yesterday 09:05',
      );
    });

    test('older dates use yMMMd', () {
      final formatted = formatNotificationTimestamp(
        createdAt: DateTime(2026, 9, 1, 12),
        now: now,
        localeName: 'en',
        yesterdayLabel: 'Yesterday',
      );
      expect(formatted, isNot(contains('Yesterday')));
      expect(formatted, contains('2026'));
      expect(formatted, contains('Sep'));
    });
  });

  group('isUnusableNotificationText', () {
    test('rejects empty, keys, json and deep links', () {
      expect(isUnusableNotificationText(null), isTrue);
      expect(isUnusableNotificationText(''), isTrue);
      expect(
        isUnusableNotificationText(
          'platformAdmin.notifications.driverApplicationSubmitted.title',
        ),
        isTrue,
      );
      expect(
        isUnusableNotificationText('driver_application_submitted'),
        isTrue,
      );
      expect(isUnusableNotificationText('{"foo":1}'), isTrue);
      expect(isUnusableNotificationText('/applications/900'), isTrue);
      expect(isUnusableNotificationText('New driver registration'), isFalse);
    });
  });

  testWidgets('shows title, body preview, timestamp and metadata', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        home: Scaffold(
          body: NotificationCard(
            item: _item(),
            now: DateTime(2026, 9, 16, 21),
            onTap: () {},
            onMarkRead: () {},
            onDelete: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('New driver document received'), findsOneWidget);
    expect(
      find.text('Péter Kovács uploaded a new driving licence.'),
      findsOneWidget,
    );
    expect(find.text('20:41'), findsOneWidget);
    expect(find.text('Info'), findsOneWidget);
    expect(find.text('In-app only'), findsOneWidget);
    expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    expect(find.byIcon(Icons.mark_email_read_outlined), findsOneWidget);
  });

  testWidgets('long body uses ellipsis overflow', (tester) async {
    final longBody = List.filled(40, 'long body line').join('\n');
    await tester.pumpWidget(
      _app(
        home: Scaffold(
          body: NotificationCard(
            item: _item(body: longBody),
            now: DateTime(2026, 9, 16, 21),
            onTap: () {},
            onMarkRead: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final preview = tester.widget<Text>(
      find.text(longBody.replaceAll(RegExp(r'[ \t]+'), ' ').trim()),
    );
    expect(preview.maxLines, 3);
    expect(preview.overflow, TextOverflow.ellipsis);
  });

  testWidgets('missing body shows English fallback', (tester) async {
    await tester.pumpWidget(
      _app(
        home: Scaffold(
          body: NotificationCard(
            item: _item(body: ''),
            now: DateTime(2026, 9, 16, 21),
            onTap: () {},
            onMarkRead: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('No additional content'), findsOneWidget);
  });

  testWidgets('missing body shows Hungarian fallback', (tester) async {
    await tester.pumpWidget(
      _app(
        locale: const Locale('hu'),
        home: Scaffold(
          body: NotificationCard(
            item: _item(body: ''),
            now: DateTime(2026, 9, 16, 21),
            onTap: () {},
            onMarkRead: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Nincs további tartalom'), findsOneWidget);
    expect(find.text('No additional content'), findsNothing);
    expect(find.text('Csak alkalmazáson belül'), findsOneWidget);
  });

  testWidgets('empty title falls back to localized type, not raw enum', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        locale: const Locale('hu'),
        home: Scaffold(
          body: NotificationCard(
            item: _item(
              title: 'platformAdmin.notifications.missing.title',
              body: 'Ellenőrzésre vár.',
              type: NotificationType.security,
            ),
            now: DateTime(2026, 9, 16, 21),
            onTap: () {},
            onMarkRead: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('security'), findsNothing);
    expect(find.text('Biztonsag'), findsOneWidget);
    expect(find.text('Ellenőrzésre vár.'), findsOneWidget);
  });

  testWidgets('prefers Hungarian metadata title and body', (tester) async {
    await tester.pumpWidget(
      _app(
        locale: const Locale('hu'),
        home: Scaffold(
          body: NotificationCard(
            item: _item(
              title: '',
              body: '',
              titleKey:
                  'platformAdmin.notifications.driverApplicationSubmitted.title',
              metadata: const {
                'titleEn': 'New driver registration',
                'titleHu': 'Új sofőrregisztráció',
                'bodyEn': 'Waiting for review.',
                'bodyHu': 'Elbírálás szükséges.',
              },
            ),
            now: DateTime(2026, 9, 16, 21),
            onTap: () {},
            onMarkRead: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Új sofőrregisztráció'), findsOneWidget);
    expect(find.text('Elbírálás szükséges.'), findsOneWidget);
  });

  testWidgets('unread title is bolder than read title', (tester) async {
    await tester.pumpWidget(
      _app(
        home: Scaffold(
          body: Column(
            children: [
              NotificationCard(
                item: _item(id: 'unread', readAt: null),
                now: DateTime(2026, 9, 16, 21),
                onTap: () {},
                onMarkRead: () {},
              ),
              NotificationCard(
                item: _item(
                  id: 'read',
                  title: 'Already seen',
                  readAt: DateTime(2026, 9, 16, 18),
                ),
                now: DateTime(2026, 9, 16, 21),
                onTap: () {},
                onMarkRead: () {},
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final unread = tester.widget<Text>(
      find.text('New driver document received'),
    );
    final read = tester.widget<Text>(find.text('Already seen'));
    expect(unread.style?.fontWeight, FontWeight.w700);
    expect(read.style?.fontWeight, FontWeight.w500);
    expect(find.byIcon(Icons.drafts_outlined), findsOneWidget);
  });

  testWidgets('tap still invokes open callback for detail', (tester) async {
    var opened = false;
    await tester.pumpWidget(
      _app(
        home: Scaffold(
          body: NotificationCard(
            item: _item(),
            now: DateTime(2026, 9, 16, 21),
            onTap: () => opened = true,
            onMarkRead: () {},
            onDelete: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('New driver document received'));
    expect(opened, isTrue);
  });

  testWidgets('yesterday timestamp uses localized label', (tester) async {
    await tester.pumpWidget(
      _app(
        locale: const Locale('hu'),
        home: Scaffold(
          body: NotificationCard(
            item: _item(createdAt: DateTime(2026, 9, 15, 20, 41)),
            now: DateTime(2026, 9, 16, 21),
            onTap: () {},
            onMarkRead: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Tegnap'), findsOneWidget);
  });

  testWidgets('narrow phone width keeps title, preview and chips visible', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      _app(
        home: Scaffold(
          body: NotificationCard(
            item: _item(
              title:
                  'Very long Hungarian-style title that should wrap without covering actions',
              body:
                  'Első sor.\nMásodik sor.\nHarmadik sor ami már a preview határán van.',
            ),
            now: DateTime(2026, 9, 16, 21),
            onTap: () {},
            onMarkRead: () {},
            onDelete: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('In-app only'), findsOneWidget);
    expect(find.byIcon(Icons.delete_outline), findsOneWidget);
  });
}
