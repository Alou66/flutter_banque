import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_banque/main.dart';
import 'package:flutter_banque/widgets/auth/code_input_field.dart';
import 'package:flutter_banque/widgets/auth/phone_input_field.dart';
import 'package:flutter_banque/widgets/wallet/amount_input_field.dart';

Future<void> _login(WidgetTester tester) async {
  await tester.pumpWidget(const ProviderScope(child: BanqueApp()));
  await tester.pump(const Duration(seconds: 2)); // Splash → Login
  await tester.pumpAndSettle();

  await tester.enterText(
    find.descendant(
      of: find.byType(PhoneInputField),
      matching: find.byType(TextFormField),
    ),
    '700000000',
  );
  await tester.enterText(
    find.descendant(
      of: find.byType(CodeInputField),
      matching: find.byType(TextField),
    ),
    '1234',
  );
  await tester.tap(find.widgetWithText(ElevatedButton, 'Se connecter'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
      'Un retrait avec le bon PIN met à jour le solde et rejette un PIN invalide',
      (tester) async {
    await _login(tester);
    expect(find.text('250,000 FCFA'), findsOneWidget);

    await tester.tap(find.text('Retrait'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.descendant(
        of: find.byType(AmountInputField),
        matching: find.byType(TextFormField),
      ),
      '20000',
    );
    await tester.enterText(
      find.descendant(
        of: find.byType(CodeInputField),
        matching: find.byType(TextField),
      ),
      '0000',
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Retirer'));
    await tester.pumpAndSettle();

    // Mauvais PIN : le retrait échoue, toujours sur l'écran Retrait.
    expect(find.text('Retirer des fonds'), findsOneWidget);

    await tester.enterText(
      find.descendant(
        of: find.byType(CodeInputField),
        matching: find.byType(TextField),
      ),
      '1234',
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Retirer'));
    await tester.pumpAndSettle();

    expect(find.text('230,000 FCFA'), findsOneWidget);
  });
}
