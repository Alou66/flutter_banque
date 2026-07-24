import 'package:flutter/material.dart';
import '../../core/constants/app_dimens.dart';
import '../../models/transaction.dart';
import 'transaction_style.dart';

/// Filtres par type de transaction (Tous / Dépôt / Retrait / Paiement).
class TransactionFilterChips extends StatelessWidget {
  const TransactionFilterChips({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final TransactionType? selected;
  final ValueChanged<TransactionType?> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _chip(null, 'Tous'),
          const SizedBox(width: AppDimens.spaceSm),
          _chip(TransactionType.deposit, TransactionStyle.label(TransactionType.deposit)),
          const SizedBox(width: AppDimens.spaceSm),
          _chip(
            TransactionType.withdrawal,
            TransactionStyle.label(TransactionType.withdrawal),
          ),
          const SizedBox(width: AppDimens.spaceSm),
          _chip(TransactionType.payment, TransactionStyle.label(TransactionType.payment)),
        ],
      ),
    );
  }

  Widget _chip(TransactionType? type, String label) {
    return ChoiceChip(
      label: Text(label),
      selected: selected == type,
      onSelected: (_) => onChanged(type),
    );
  }
}
