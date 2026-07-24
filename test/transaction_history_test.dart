import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_banque/main.dart';
import 'package:flutter_banque/widgets/auth/code_input_field.dart';
import 'package:flutter_banque/widgets/auth/phone_input_field.dart';
import 'package:flutter_banque/widgets/wallet/transaction_search_field.dart';

Future<void> _loginAndOpenHistory(WidgetTester tester) async {
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

  await tester.tap(find.text('Voir tout'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
      'Historique : liste complète, filtre, recherche, tri et détail',
      (tester) async {
    await _loginAndOpenHistory(tester);

    // Liste complète (6 transactions seed).
    expect(find.text('Dépôt Orange Money'), findsOneWidget);
    expect(find.text('Retrait distributeur'), findsOneWidget);

    // Filtre par type : seuls les retraits restent visibles.
    await tester.tap(find.text('Retrait'));
    await tester.pumpAndSettle();
    expect(find.text('Retrait agence'), findsOneWidget);
    expect(find.text('Retrait distributeur'), findsOneWidget);
    expect(find.text('Dépôt Orange Money'), findsNothing);

    await tester.tap(find.text('Tous'));
    await tester.pumpAndSettle();

    // Recherche (avec anti-rebond).
    await tester.enterText(
      find.descendant(
        of: find.byType(TransactionSearchField),
        matching: find.byType(TextField),
      ),
      'Canal',
    );
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
    expect(find.text('Paiement Canal+'), findsOneWidget);
    expect(find.text('Retrait agence'), findsNothing);

    await tester.enterText(
      find.descendant(
        of: find.byType(TransactionSearchField),
        matching: find.byType(TextField),
      ),
      '',
    );
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    // Tri par montant croissant : le plus petit montant remonte en tête.
    await tester.tap(find.byIcon(Icons.sort_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Montant ↑'));
    await tester.pumpAndSettle();

    final smallestY = tester.getTopLeft(find.text('Retrait distributeur')).dy;
    final largestY = tester.getTopLeft(find.text('Virement reçu')).dy;
    expect(smallestY, lessThan(largestY));

    // Détail d'une transaction.
    await tester.tap(find.text('Paiement Canal+'));
    await tester.pumpAndSettle();
    expect(find.text('Détail de la transaction'), findsOneWidget);
    expect(find.text('-15,000 FCFA'), findsOneWidget);
    expect(find.text('Référence'), findsOneWidget);
  });
}
