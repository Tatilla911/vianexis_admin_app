import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/core/auth/admin_auth_state.dart';
import 'package:vianexis_admin_app/core/auth/admin_user.dart';
import 'package:vianexis_admin_app/core/widgets/vianexis_admin_scaffold.dart';
import 'package:vianexis_admin_app/features/global_search/data/platform_admin_search_api.dart';
import 'package:vianexis_admin_app/features/global_search/domain/platform_admin_search_models.dart';
import 'package:vianexis_admin_app/features/global_search/presentation/global_search_sheet.dart';
import 'package:vianexis_admin_app/l10n/app_localizations.dart';

class _AuthenticatedAdminAuthNotifier extends AdminAuthNotifier {
  @override
  AdminAuthState build() {
    ref.watch(adminAuthRepositoryProvider);
    return const AdminAuthState(
      user: AdminUser(
        id: '1',
        email: 'admin@vianexis.hu',
        role: AdminRole.superAdmin,
      ),
    );
  }
}

class _RaceSearchRepository implements PlatformAdminSearchRepository {
  _RaceSearchRepository({
    required this.slow,
    required this.fast,
  });

  final Completer<PlatformAdminSearchResponse> slow;
  final Completer<PlatformAdminSearchResponse> fast;
  int calls = 0;

  @override
  bool get usesMockData => true;

  @override
  Future<PlatformAdminSearchResponse> search(String q) {
    calls += 1;
    if (calls == 1) return slow.future;
    return fast.future;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('open sheet, type query, see extended grouped mock results', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          adminAuthProvider.overrideWith(_AuthenticatedAdminAuthNotifier.new),
          platformAdminSearchRepositoryProvider.overrideWith(
            (ref) => MockPlatformAdminSearchRepository(),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: const VianexisAdminScaffold(child: Text('shell')),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();

    expect(find.byType(GlobalSearchSheet), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Nord');
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pumpAndSettle();

    expect(find.text('NordTrans Kft.'), findsWidgets);
    expect(find.text('Kovács Péter'), findsOneWidget);
    expect(find.text('CMR-Nord-001.pdf'), findsOneWidget);
    expect(find.text('ABC-123'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(GlobalSearchSheet),
        matching: find.text('Companies'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byType(GlobalSearchSheet),
        matching: find.text('Documents'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byType(GlobalSearchSheet),
        matching: find.text('Vehicles'),
      ),
      findsOneWidget,
    );

    // ListView builds lazily — scroll to later groups.
    final listFinder = find.descendant(
      of: find.byType(GlobalSearchSheet),
      matching: find.byType(ListView),
    );
    await tester.drag(listFinder, const Offset(0, -800));
    await tester.pumpAndSettle();

    expect(find.text('Budapest Depot'), findsOneWidget);
    expect(find.text('TRL-88'), findsOneWidget);
    expect(find.text('support_grant.created'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(GlobalSearchSheet),
        matching: find.text('Sites'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byType(GlobalSearchSheet),
        matching: find.text('Events'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('ignores stale race response', (tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final slow = Completer<PlatformAdminSearchResponse>();
    final fast = Completer<PlatformAdminSearchResponse>();
    final raceRepo = _RaceSearchRepository(slow: slow, fast: fast);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          adminAuthProvider.overrideWith(_AuthenticatedAdminAuthNotifier.new),
          platformAdminSearchRepositoryProvider.overrideWith((ref) => raceRepo),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: const VianexisAdminScaffold(child: Text('shell')),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'aa');
    await tester.pump(const Duration(milliseconds: 350));

    await tester.enterText(find.byType(TextField), 'bb');
    await tester.pump(const Duration(milliseconds: 350));

    fast.complete(
      PlatformAdminSearchResponse.fromGroupedHits(
        query: 'bb',
        hits: const [
          PlatformAdminSearchHit(
            id: '2',
            type: PlatformAdminSearchResultType.company,
            title: 'BB Company',
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('BB Company'), findsOneWidget);

    slow.complete(
      PlatformAdminSearchResponse.fromGroupedHits(
        query: 'aa',
        hits: const [
          PlatformAdminSearchHit(
            id: '1',
            type: PlatformAdminSearchResultType.company,
            title: 'AA Company',
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('AA Company'), findsNothing);
    expect(find.text('BB Company'), findsOneWidget);
  });
}
