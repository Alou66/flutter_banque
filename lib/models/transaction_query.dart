import 'package:equatable/equatable.dart';
import 'transaction.dart';

enum TransactionSortBy { date, amount, type }

enum SortOrder { asc, desc }

/// Critères de recherche d'un historique de transactions : conçu comme les
/// paramètres d'une future requête REST (filtre, recherche, tri, pagination).
class TransactionQuery extends Equatable {
  const TransactionQuery({
    this.type,
    this.searchText = '',
    this.sortBy = TransactionSortBy.date,
    this.sortOrder = SortOrder.desc,
    this.page = 1,
    this.pageSize = 10,
  });

  final TransactionType? type;
  final String searchText;
  final TransactionSortBy sortBy;
  final SortOrder sortOrder;
  final int page;
  final int pageSize;

  TransactionQuery copyWithPage(int page) => TransactionQuery(
        type: type,
        searchText: searchText,
        sortBy: sortBy,
        sortOrder: sortOrder,
        page: page,
        pageSize: pageSize,
      );

  @override
  List<Object?> get props =>
      [type, searchText, sortBy, sortOrder, page, pageSize];
}
