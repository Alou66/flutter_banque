import 'package:flutter/material.dart';
import '../../models/transaction_query.dart';

typedef _SortOption = ({TransactionSortBy sortBy, SortOrder order});

/// Menu de tri de l'historique (date, montant, type).
class TransactionSortMenu extends StatelessWidget {
  const TransactionSortMenu({
    super.key,
    required this.sortBy,
    required this.sortOrder,
    required this.onChanged,
  });

  final TransactionSortBy sortBy;
  final SortOrder sortOrder;
  final void Function(TransactionSortBy sortBy, SortOrder order) onChanged;

  static const _options = <(_SortOption, String)>[
    ((sortBy: TransactionSortBy.date, order: SortOrder.desc), 'Plus récent'),
    ((sortBy: TransactionSortBy.date, order: SortOrder.asc), 'Plus ancien'),
    ((sortBy: TransactionSortBy.amount, order: SortOrder.desc), 'Montant ↓'),
    ((sortBy: TransactionSortBy.amount, order: SortOrder.asc), 'Montant ↑'),
    ((sortBy: TransactionSortBy.type, order: SortOrder.asc), 'Type'),
  ];

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_SortOption>(
      icon: const Icon(Icons.sort_rounded),
      tooltip: 'Trier',
      onSelected: (option) => onChanged(option.sortBy, option.order),
      itemBuilder: (context) => [
        for (final (option, label) in _options)
          PopupMenuItem(
            value: option,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  option.sortBy == sortBy && option.order == sortOrder
                      ? Icons.check_rounded
                      : null,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(label, overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
