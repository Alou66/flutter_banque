import 'package:flutter/material.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/theme/app_text_styles.dart';

/// En-tête standard (titre + sous-titre) utilisé sur les écrans d'auth.
class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key, required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.headline),
        const SizedBox(height: AppDimens.spaceXs),
        Text(subtitle, style: AppTextStyles.bodySecondary(context)),
      ],
    );
  }
}
