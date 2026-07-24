import 'package:flutter/material.dart';

/// Couleurs de marque, volontairement identiques en thème clair et sombre.
/// Les couleurs qui doivent varier selon le thème (fonds, texte, bordures)
/// vivent dans [AppColorsExtension], accessible via `context.appColors`.
abstract class AppColors {
  static const Color primary = Color(0xFF0A2E6B);
  static const Color primaryLight = Color(0xFF1E4FA3);
  static const Color secondary = Color(0xFF00C48C);
  static const Color secondaryDark = Color(0xFF00A876);

  static const Color textOnPrimary = Color(0xFFFFFFFF);

  static const Color success = Color(0xFF00C48C);
  static const Color error = Color(0xFFE5484D);
  static const Color warning = Color(0xFFF5A623);

  static const Color shadow = Color(0x40000000);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
