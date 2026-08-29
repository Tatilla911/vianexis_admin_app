import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vianexis_admin_app/core/api/api_client.dart';
import 'package:vianexis_admin_app/core/api/auth_token_storage.dart';
import 'package:vianexis_admin_app/core/auth/admin_auth_state.dart';
import 'package:vianexis_admin_app/core/auth/admin_user.dart';
import 'package:vianexis_admin_app/features/modules/admin_modules_hub_screen.dart';
import 'package:vianexis_admin_app/features/pricing_quotes/data/pricing_quotes_api.dart';
import 'package:vianexis_admin_app/features/pricing_quotes/domain/pricing_quote.dart';
import 'package:vianexis_admin_app/features/pricing_quotes/presentation/pricing_quote_detail_screen.dart';
import 'package:vianexis_admin_app/features/pricing_quotes/presentation/pricing_quotes_list_screen.dart';
import 'package:vianexis_admin_app/l10n/app_localizations.dart';

class _AuthNotifier extends AdminAuthNotifier {
  _AuthNotifier(this.role);

  final AdminRole role;

  @override
  AdminAuthState build() {
    ref.watch(adminAuthRepositoryProvider);
    return AdminAuthState(
      user: AdminUser(
        id: '1',
        email: 'admin@vianexis.hu',
        role: role,
      ),
    );
  }
}

class _FakePricingQuotesApi extends PricingQuotesApi {
  _FakePricingQuotesApi()
    : super(
        ApiClient(tokenStorage: AuthTokenStorage(), enableDebugLogging: false),
      );

  int recalculateCalls = 0;
  int adjustmentCalls = 0;
  PricingQuoteAdjustmentRequest? lastAdjustment;

  List<String> flags = const ['PROVIDER_VALIDATION_PENDING'];

  Map<String, dynamic> _listItem() => {
    'id': 11,
    'publicReference': 'PQ-2401-001',
    'companyId': 7,
    'publicIntakeId': 42,
    'status': 'REVIEW_REQUIRED',
    'questionnaireVersion': 'q-v3',
    'pricingConfigVersion': 'pricing-config-v1-freeze-candidate',
    'recurringTotalNet': '890.00',
    'oneTimeTotalNet': '1200.00',
    'confidence': 'MEDIUM',
    'reviewFlags': flags,
    'currentRevisionNumber': 2,
    'createdAt': '2026-08-20T10:00:00.000Z',
  };

  Map<String, dynamic> _detail() => {
    ..._listItem(),
    'internalNotes': 'Internal review',
    'revisions': [
      {
        'id': 1,
        'revisionNumber': 1,
        'pricingConfigVersion': 'pricing-config-v1-freeze-candidate',
        'questionnaireVersion': 'q-v3',
        'calculatedAt': '2026-08-20T10:00:00.000Z',
        'reason': 'Initial calculation from public intake',
        'calculationResultJson': {
          'operationalLicences': 12,
          'licenseBasis': 'vehicle_licences',
          'paidModules': ['cmr', 'tms'],
          'recurringBreakdown': {'base': 700, 'modules': 190},
          'oneTimeBreakdown': {'setup': 1200},
          'directCostNet': 410,
          'directContributionNet': 480,
          'directContributionPercent': 53.9,
        },
        'reviewFlags': ['PROVIDER_VALIDATION_PENDING'],
      },
      {
        'id': 2,
        'revisionNumber': 2,
        'pricingConfigVersion': 'pricing-config-v1-freeze-candidate',
        'questionnaireVersion': 'q-v3',
        'calculatedAt': '2026-08-21T10:00:00.000Z',
        'reason': 'Recalculate after intake update',
        'calculationResultJson': {
          'operationalLicences': 14,
          'licenseBasis': 'vehicle_licences',
          'paidModules': ['cmr', 'tms'],
          'usageLineItems': ['ocr_band_b'],
          'recurringBreakdown': {'base': 700, 'modules': 190},
          'oneTimeBreakdown': {'setup': 1200},
          'directCostNet': 410,
          'directContributionNet': 480,
          'directContributionPercent': 53.9,
        },
        'reviewFlags': flags,
      },
    ],
    'adjustments': [
      {
        'id': 3,
        'type': 'DISCOUNT',
        'percent': 5,
        'reason': 'Pilot',
        'approvalRequired': false,
        'createdAt': '2026-08-21T11:00:00.000Z',
      },
    ],
  };

  @override
  Future<List<PricingQuoteListItem>> listQuotes() async {
    return [PricingQuoteListItem.fromJson(_listItem())];
  }

  @override
  Future<PricingQuoteDetail> getQuote(int id) async {
    return PricingQuoteDetail.fromJson(_detail());
  }

  @override
  Future<PricingQuoteListItem> recalculate({
    required int id,
    required String reason,
  }) async {
    recalculateCalls += 1;
    return PricingQuoteListItem.fromJson(_listItem());
  }

  @override
  Future<PricingQuoteListItem> applyAdjustment({
    required int id,
    required PricingQuoteAdjustmentRequest request,
  }) async {
    adjustmentCalls += 1;
    lastAdjustment = request;
    if ((request.percent ?? 0) > 15) {
      flags = [
        'PROVIDER_VALIDATION_PENDING',
        'MANUAL_DISCOUNT_APPROVAL_REQUIRED',
      ];
    }
    return PricingQuoteListItem.fromJson(_listItem());
  }
}

class _FailingPricingQuotesApi extends PricingQuotesApi {
  _FailingPricingQuotesApi()
    : super(
        ApiClient(tokenStorage: AuthTokenStorage(), enableDebugLogging: false),
      );

  @override
  Future<List<PricingQuoteListItem>> listQuotes() async {
    throw Exception('DioException: status=503 raw dump');
  }
}

Widget _app({
  required Widget home,
  required PricingQuotesApi api,
  AdminRole role = AdminRole.billingAdmin,
  Locale locale = const Locale('en'),
}) {
  return ProviderScope(
    overrides: [
      adminAuthProvider.overrideWith(() => _AuthNotifier(role)),
      pricingQuotesApiProvider.overrideWithValue(api),
    ],
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      home: home,
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('A: Pricing Quotes nav visible with BILLING_READ', (tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      _app(home: const AdminModulesHubScreen(), api: _FakePricingQuotesApi()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Pricing Quotes'), findsWidgets);
  });

  testWidgets('A: Pricing Quotes nav hidden without billing read', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      _app(
        home: const AdminModulesHubScreen(),
        api: _FakePricingQuotesApi(),
        role: AdminRole.onboardingReviewer,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Pricing Quotes'), findsNothing);
  });

  testWidgets('B: list loads backend quotes', (tester) async {
    await tester.pumpWidget(
      _app(home: const PricingQuotesListScreen(), api: _FakePricingQuotesApi()),
    );
    await tester.pumpAndSettle();

    expect(find.text('PQ-2401-001'), findsOneWidget);
    expect(find.textContaining('€890.00'), findsOneWidget);
  });

  testWidgets('C/D/E/F: detail renders breakdown, blocker, revisions, blocked approve', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      _app(
        home: const PricingQuoteDetailScreen(quoteId: '11'),
        api: _FakePricingQuotesApi(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('PQ-2401-001'), findsOneWidget);
    expect(find.text('Provider cost validation required'), findsWidgets);

    final scrollable = find.byType(Scrollable).first;
    await tester.scrollUntilVisible(
      find.text('Recurring target'),
      400,
      scrollable: scrollable,
    );
    expect(find.textContaining('890'), findsWidgets);
    await tester.scrollUntilVisible(
      find.text('Direct contribution'),
      400,
      scrollable: scrollable,
    );
    expect(find.textContaining('53.9'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Revision 1'), 400, scrollable: scrollable);
    expect(find.text('Revision 1'), findsOneWidget);
    expect(find.text('Revision 2'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Approve quote'),
      400,
      scrollable: scrollable,
    );
    final approve = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Approve quote'),
    );
    expect(approve.onPressed, isNull);
  });

  testWidgets('G: recalculate calls backend', (tester) async {
    final api = _FakePricingQuotesApi();
    await tester.pumpWidget(
      _app(home: const PricingQuoteDetailScreen(quoteId: '11'), api: api),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Recalculate'),
      400,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Recalculate'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, 'Refresh calc');
    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();

    expect(api.recalculateCalls, 1);
  });

  testWidgets('H/I: adjustment calls backend and shows >15% approval flag', (
    tester,
  ) async {
    final api = _FakePricingQuotesApi();
    await tester.pumpWidget(
      _app(home: const PricingQuoteDetailScreen(quoteId: '11'), api: api),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Add adjustment'),
      400,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Add adjustment'));
    await tester.pumpAndSettle();
    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), '20');
    await tester.enterText(fields.at(2), 'Pilot discount');
    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();

    expect(api.adjustmentCalls, 1);
    expect(api.lastAdjustment?.percent, 20);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.textContaining('Manual discount approval required'),
      400,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.textContaining('Manual discount approval required'), findsWidgets);
  });

  testWidgets('J: read-only permission hides decision actions', (tester) async {
    await tester.pumpWidget(
      _app(
        home: const PricingQuoteDetailScreen(quoteId: '11'),
        api: _FakePricingQuotesApi(),
        role: AdminRole.supportAdmin,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('PQ-2401-001'), findsOneWidget);
    expect(find.text('Approve quote'), findsNothing);
    expect(find.text('Recalculate'), findsNothing);
    expect(find.text('Add adjustment'), findsNothing);
  });

  testWidgets('K: HU labels', (tester) async {
    await tester.pumpWidget(
      _app(
        home: const PricingQuotesListScreen(),
        api: _FakePricingQuotesApi(),
        locale: const Locale('hu'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Árajánlatok'), findsOneWidget);
    expect(find.text('Ellenőrzés szükséges'), findsOneWidget);
    expect(find.text('Szolgáltatói költségek ellenőrzése szükséges'), findsOneWidget);
  });

  testWidgets('L: EN labels', (tester) async {
    await tester.pumpWidget(
      _app(home: const PricingQuotesListScreen(), api: _FakePricingQuotesApi()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Pricing Quotes'), findsOneWidget);
    expect(find.text('Review required'), findsOneWidget);
    expect(find.text('Provider cost validation required'), findsOneWidget);
  });

  testWidgets('M: API error does not show false empty success', (tester) async {
    await tester.pumpWidget(
      _app(
        home: const PricingQuotesListScreen(),
        api: _FailingPricingQuotesApi(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No pricing quotes yet.'), findsNothing);
    expect(find.textContaining('DioException'), findsNothing);
    expect(find.text('Could not load pricing quotes.'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });
}
