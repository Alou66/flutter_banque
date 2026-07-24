import 'package:equatable/equatable.dart';
import 'transaction.dart';

/// Page de résultats, au format d'une réponse paginée REST classique.
class TransactionPage extends Equatable {
  const TransactionPage({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalCount,
  });

  final List<Transaction> items;
  final int page;
  final int pageSize;
  final int totalCount;

  bool get hasMore => page * pageSize < totalCount;

  @override
  List<Object?> get props => [items, page, pageSize, totalCount];
}
