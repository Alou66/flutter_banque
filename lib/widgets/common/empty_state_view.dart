import 'package:flutter/material.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/theme/app_colors_extension.dart';
import '../../core/theme/app_text_styles.dart';

/// État vide générique (aucune donnée à afficher), réutilisable sur les
/// écrans listant des données issues du Mock Repository.
class EmptyStateView extends StatelessWidget {
  const EmptyStateView({super.key, required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.spaceLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: context.appColors.textSecondary),
            const SizedBox(height: AppDimens.spaceMd),
            Text(
              message,
              style: AppTextStyles.bodySecondary(context),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
