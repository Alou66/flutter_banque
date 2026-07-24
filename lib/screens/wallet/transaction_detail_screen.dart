import 'package:flutter/material.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_colors_extension.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/transaction.dart';
import '../../utils/formatters.dart';
import '../../widgets/common/responsive_body.dart';
import '../../widgets/wallet/transaction_style.dart';

/// Détail d'une transaction : montant, type, libellé, date et référence.
class TransactionDetailScreen extends StatelessWidget {
  const TransactionDetailScreen({super.key, required this.transaction});

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    final sign = transaction.isCredit ? '+' : '-';
    final amountColor =
        transaction.isCredit ? AppColors.success : context.appColors.textPrimary;
    final iconColor = TransactionStyle.color(transaction.type);

    return Scaffold(
      appBar: AppBar(title: const Text('Détail de la transaction')),
      body: SafeArea(
        child: ResponsiveBody(
          child: ListView(
          padding: const EdgeInsets.all(AppDimens.spaceLg),
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      TransactionStyle.icon(transaction.type),
                      color: iconColor,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: AppDimens.spaceMd),
                  Text(
                    '$sign${Formatters.amount(transaction.amount)}',
                    style: AppTextStyles.displayLarge.copyWith(color: amountColor),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimens.spaceXl),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.spaceMd,
                  vertical: AppDimens.spaceSm,
                ),
                child: Column(
                  children: [
                    _DetailRow(label: 'Type', value: TransactionStyle.label(transaction.type)),
                    const Divider(),
                    _DetailRow(label: 'Libellé', value: transaction.label),
                    const Divider(),
                    _DetailRow(label: 'Date', value: Formatters.date(transaction.date)),
                    const Divider(),
                    _DetailRow(label: 'Référence', value: transaction.id),
                  ],
                ),
              ),
            ),
          ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceSm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodySecondary(context)),
          Text(value, style: AppTextStyles.body),
        ],
      ),
    );
  }
}
