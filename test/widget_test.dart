import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_banque/main.dart';

void main() {
  testWidgets('App démarre et affiche le Splash Screen', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: BanqueApp()));
    await tester.pump();

    expect(find.text('Banque'), findsOneWidget);
    expect(find.byIcon(Icons.account_balance_rounded), findsOneWidget);

    // Laisse le timer de redirection du Splash Screen s'écouler avant la fin
    // du test, pour éviter un timer en attente à la finalisation.
    await tester.pump(const Duration(seconds: 2));
  });
}
