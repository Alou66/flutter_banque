import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_banque/main.dart';
import 'package:flutter_banque/widgets/auth/code_input_field.dart';
import 'package:flutter_banque/widgets/auth/phone_input_field.dart';
import 'package:flutter_banque/widgets/wallet/amount_input_field.dart';

void main() {
  testWidgets('Un dépôt met à jour automatiquement le solde du Dashboard',
      (tester) async {
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

    expect(find.text('250,000 FCFA'), findsOneWidget);

    await tester.tap(find.text('Dépôt'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.descendant(
        of: find.byType(AmountInputField),
        matching: find.byType(TextFormField),
      ),
      '10000',
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Déposer'));
    await tester.pumpAndSettle();

    expect(find.text('260,000 FCFA'), findsOneWidget);
  });
}
