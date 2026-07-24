import 'package:flutter/material.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// État d'erreur générique avec action de réessai, réutilisable sur les
/// écrans alimentés par le Mock Repository.
class ErrorStateView extends StatelessWidget {
  const ErrorStateView({super.key, required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.spaceLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 48),
            const SizedBox(height: AppDimens.spaceMd),
            Text(
              message,
              style: AppTextStyles.bodySecondary(context),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimens.spaceMd),
            ElevatedButton(onPressed: onRetry, child: const Text('Réessayer')),
          ],
        ),
      ),
    );
  }
}
