import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/qr_codes/presentation/widgets/vianexis_qr_identity_card.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('renders identity card fields and QR', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: VianexisQrIdentityCard(
                brandTitle: 'ViaNexis Driver ID',
                displayName: 'Teszt Sofőr',
                entityIdLabel: '42',
                roleLabel: 'Driver',
                purposeLabel: 'Public driver ID',
                qrPayload: 'https://vianexis.eu/q/test-code',
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is RichText &&
            widget.text.toPlainText().contains('Teszt Sofőr'),
      ),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is RichText && widget.text.toPlainText().contains('42'),
      ),
      findsWidgets,
    );
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is RichText &&
            widget.text.toPlainText().contains('Public driver ID'),
      ),
      findsOneWidget,
    );
  });
}
