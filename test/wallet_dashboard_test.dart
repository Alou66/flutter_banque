import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_banque/main.dart';
import 'package:flutter_banque/widgets/auth/code_input_field.dart';
import 'package:flutter_banque/widgets/auth/phone_input_field.dart';

void main() {
  testWidgets('Connexion avec le compte démo affiche le Dashboard Wallet',
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

    expect(find.text('Solde disponible'), findsOneWidget);
    expect(find.text('Alassane Diallo'), findsOneWidget);
    expect(find.text('Transactions récentes'), findsOneWidget);
  });
}
