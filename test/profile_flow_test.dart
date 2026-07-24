import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_banque/main.dart';
import 'package:flutter_banque/widgets/auth/code_input_field.dart';
import 'package:flutter_banque/widgets/auth/phone_input_field.dart';

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

Future<void> _enterCode(WidgetTester tester, String code) async {
  await tester.enterText(
    find.descendant(
      of: find.byType(CodeInputField),
      matching: find.byType(TextField),
    ),
    code,
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
      'Modifier le profil, changer le PIN puis se déconnecter depuis le Profil',
      (tester) async {
    await _login(tester);

    // Dashboard → Profil.
    await tester.tap(find.text('Alassane Diallo'));
    await tester.pumpAndSettle();
    expect(find.text('Prénom'), findsOneWidget);
    expect(find.text('Alassane'), findsOneWidget);

    // Modification du profil.
    await tester.tap(find.widgetWithText(OutlinedButton, 'Modifier le profil'));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, 'Prénom'), 'Awa');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Enregistrer'));
    await tester.pumpAndSettle();

    expect(find.text('Awa'), findsOneWidget);

    // Changement de PIN : ancien, nouveau, confirmation.
    await tester.tap(find.widgetWithText(OutlinedButton, 'Changer le PIN'));
    await tester.pumpAndSettle();

    await _enterCode(tester, '1234');
    await _enterCode(tester, '5678');
    await _enterCode(tester, '5678');

    // Le PIN a été changé : retour automatique sur l'écran Profil.
    expect(find.text('Prénom'), findsOneWidget);

    // Déconnexion depuis le Profil.
    await tester.tap(find.widgetWithText(OutlinedButton, 'Se déconnecter'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Déconnecter'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(ElevatedButton, 'Se connecter'), findsOneWidget);

    // Le nouveau PIN doit désormais être requis pour se reconnecter.
    await tester.enterText(
      find.descendant(
        of: find.byType(PhoneInputField),
        matching: find.byType(TextFormField),
      ),
      '700000000',
    );
    await _enterCode(tester, '5678');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Se connecter'));
    await tester.pumpAndSettle();

    expect(find.text('Awa Diallo'), findsOneWidget);
  });
}
