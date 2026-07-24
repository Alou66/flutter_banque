import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Affiche des SnackBars visuellement cohérentes (succès/erreur), en plus du
/// [SnackBarThemeData] déjà appliqué globalement par [AppTheme].
abstract class AppSnackBar {
  static void success(BuildContext context, String message) {
    _show(context, message, icon: Icons.check_circle_outline, color: AppColors.success);
  }

  static void error(BuildContext context, String message) {
    _show(context, message, icon: Icons.error_outline, color: AppColors.error);
  }

  static void _show(
    BuildContext context,
    String message, {
    required IconData icon,
    required Color color,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 12),
              Expanded(child: Text(message)),
            ],
          ),
        ),
      );
  }
}
