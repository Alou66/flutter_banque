import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/transaction.dart';

/// Icône, couleur et libellé associés à un type de transaction, centralisés
/// pour rester cohérents entre l'aperçu, l'historique et le détail.
abstract class TransactionStyle {
  static IconData icon(TransactionType type) => switch (type) {
        TransactionType.deposit => Icons.arrow_downward_rounded,
        TransactionType.withdrawal => Icons.arrow_upward_rounded,
        TransactionType.payment => Icons.shopping_bag_outlined,
      };

  static Color color(TransactionType type) =>
      type == TransactionType.deposit ? AppColors.success : AppColors.primary;

  static String label(TransactionType type) => switch (type) {
        TransactionType.deposit => 'Dépôt',
        TransactionType.withdrawal => 'Retrait',
        TransactionType.payment => 'Paiement',
      };
}
