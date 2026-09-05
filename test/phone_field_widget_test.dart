import 'package:flutter/material.dart';
import 'package:flutter_project_core/axii_core.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets('trigger shows the flag and dial code of the selection', (
    tester,
  ) async {
    final controller = PhoneFieldController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      _host(
        PhoneField(
          label: 'Phone Number',
          countryIsoCodes: const ['TR', 'DE', 'GB'],
          phoneFieldController: controller,
        ),
      ),
    );

    expect(find.text('+90'), findsOneWidget);
    expect(find.text('\u{1F1F9}\u{1F1F7}'), findsOneWidget);
  });

  testWidgets('typing is masked and read back as E.164', (tester) async {
    final controller = PhoneFieldController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      _host(
        PhoneField(
          countryIsoCodes: const ['TR'],
          phoneFieldController: controller,
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField), '5527802864');
    await tester.pump();

    expect(controller.formattedNumber, '552 780 2864');
    expect(controller.getPhoneNumber(), '+905527802864');
  });

  testWidgets('picking from the sheet re-masks the number already typed', (
    tester,
  ) async {
    final controller = PhoneFieldController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      _host(
        PhoneField(
          countryIsoCodes: const ['TR', 'DE', 'GB'],
          favoriteCountryIsoCodes: const ['TR'],
          phoneFieldController: controller,
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField), '5527802864');
    await tester.tap(find.text('+90'));
    await tester.pumpAndSettle();

    expect(find.text('Select Country'), findsOneWidget);
    expect(find.text('POPULAR'), findsOneWidget);

    await tester.tap(find.text('Germany'));
    await tester.pumpAndSettle();

    expect(controller.isoCode, 'DE');
    expect(controller.getPhoneNumber(), '+495527802864');
    expect(find.text('+49'), findsOneWidget);
  });

  testWidgets('search narrows the sheet to matching countries', (tester) async {
    final controller = PhoneFieldController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      _host(
        PhoneField(
          countryIsoCodes: const [],
          phoneFieldController: controller,
        ),
      ),
    );

    await tester.tap(find.text('+90'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, 'germ');
    await tester.pumpAndSettle();

    expect(find.text('Germany'), findsOneWidget);
    expect(find.text('France'), findsNothing);
  });

  testWidgets('a country outside the allowed list snaps to the first one', (
    tester,
  ) async {
    final controller = PhoneFieldController(initialCountryCode: 'TR');
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      _host(
        PhoneField(
          countryIsoCodes: const ['DE', 'GB'],
          phoneFieldController: controller,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(controller.isoCode, 'DE');
  });
}
