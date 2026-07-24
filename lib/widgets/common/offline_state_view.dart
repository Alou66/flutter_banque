import 'package:flutter/material.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/theme/app_colors_extension.dart';
import '../../core/theme/app_text_styles.dart';

/// État "pas de connexion", visuellement distinct d'une erreur serveur
/// générique ([ErrorStateView]). Prêt à être déclenché dès que
/// l'intégration REST distinguera les erreurs réseau des erreurs métier.
class OfflineStateView extends StatelessWidget {
  const OfflineStateView({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.spaceLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded,
                size: 48, color: context.appColors.textSecondary),
            const SizedBox(height: AppDimens.spaceMd),
            Text(
              'Pas de connexion internet.',
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
