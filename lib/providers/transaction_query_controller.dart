import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/transaction.dart';
import '../models/transaction_query.dart';

/// Détient les critères courants de recherche/filtre/tri de l'historique.
/// Toute modification réinitialise la pagination à la première page.
class TransactionQueryController extends Notifier<TransactionQuery> {
  @override
  TransactionQuery build() => const TransactionQuery();

  void setType(TransactionType? type) {
    state = TransactionQuery(
      type: type,
      searchText: state.searchText,
      sortBy: state.sortBy,
      sortOrder: state.sortOrder,
    );
  }

  void setSearchText(String searchText) {
    state = TransactionQuery(
      type: state.type,
      searchText: searchText,
      sortBy: state.sortBy,
      sortOrder: state.sortOrder,
    );
  }

  void setSort(TransactionSortBy sortBy, SortOrder sortOrder) {
    state = TransactionQuery(
      type: state.type,
      searchText: state.searchText,
      sortBy: sortBy,
      sortOrder: sortOrder,
    );
  }
}

final transactionQueryControllerProvider =
    NotifierProvider<TransactionQueryController, TransactionQuery>(
  TransactionQueryController.new,
);
