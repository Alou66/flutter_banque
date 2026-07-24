import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'app_colors_extension.dart';

/// Styles de texte centralisés, basés sur Google Fonts (Inter). Les styles
/// sans couleur explicite héritent de la couleur du thème ambiant (clair ou
/// sombre) via [DefaultTextStyle] — comportement standard de [Text].
abstract class AppTextStyles {
  static TextStyle get _base => GoogleFonts.inter();

  static TextStyle get displayLarge => _base.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get headline => _base.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get title => _base.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get body => _base.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w400,
      );

  /// Couleur atténuée, différente entre thèmes : nécessite [context].
  static TextStyle bodySecondary(BuildContext context) => _base.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: context.appColors.textSecondary,
      );

  /// Couleur atténuée, différente entre thèmes : nécessite [context].
  static TextStyle caption(BuildContext context) => _base.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: context.appColors.textSecondary,
      );

  static TextStyle get button => _base.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textOnPrimary,
      );
}
