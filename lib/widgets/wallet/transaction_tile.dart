import 'package:flutter/material.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_colors_extension.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/transaction.dart';
import '../../utils/formatters.dart';
import 'transaction_style.dart';

/// Ligne représentant une transaction, réutilisable dans l'aperçu du
/// Dashboard comme dans l'historique complet.
class TransactionTile extends StatelessWidget {
  const TransactionTile({super.key, required this.transaction});

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    final sign = transaction.isCredit ? '+' : '-';
    final amountColor =
        transaction.isCredit ? AppColors.success : context.appColors.textPrimary;
    final iconColor = TransactionStyle.color(transaction.type);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceSm),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(TransactionStyle.icon(transaction.type), color: iconColor, size: 20),
          ),
          const SizedBox(width: AppDimens.spaceMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.label,
                  style: AppTextStyles.body,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  Formatters.date(transaction.date),
                  style: AppTextStyles.caption(context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppDimens.spaceSm),
          Text(
            '$sign${Formatters.amount(transaction.amount)}',
            style: AppTextStyles.body.copyWith(
              color: amountColor,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
