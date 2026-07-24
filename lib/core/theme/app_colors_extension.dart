import 'package:flutter/material.dart';

/// Couleurs qui diffèrent entre thème clair et sombre (contrairement aux
/// couleurs de marque dans [AppColors], volontairement identiques partout).
/// Accessible via `context.appColors`.
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  const AppColorsExtension({
    required this.background,
    required this.surface,
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
  });

  final Color background;
  final Color surface;
  final Color textPrimary;
  final Color textSecondary;
  final Color border;

  static const light = AppColorsExtension(
    background: Color(0xFFF5F7FA),
    surface: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF1A1D26),
    textSecondary: Color(0xFF4B5563),
    border: Color(0xFFE5E8EC),
  );

  static const dark = AppColorsExtension(
    background: Color(0xFF0F1218),
    surface: Color(0xFF1A1F28),
    textPrimary: Color(0xFFF1F3F6),
    textSecondary: Color(0xFFA8B0BD),
    border: Color(0xFF2A303C),
  );

  @override
  AppColorsExtension copyWith({
    Color? background,
    Color? surface,
    Color? textPrimary,
    Color? textSecondary,
    Color? border,
  }) {
    return AppColorsExtension(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      border: border ?? this.border,
    );
  }

  @override
  AppColorsExtension lerp(ThemeExtension<AppColorsExtension>? other, double t) {
    if (other is! AppColorsExtension) return this;
    return AppColorsExtension(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      border: Color.lerp(border, other.border, t)!,
    );
  }
}

extension AppColorsContext on BuildContext {
  AppColorsExtension get appColors =>
      Theme.of(this).extension<AppColorsExtension>()!;
}
