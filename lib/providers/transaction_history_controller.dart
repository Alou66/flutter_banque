import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/errors/app_exception.dart';
import '../models/transaction.dart';
import 'session_controller.dart';
import 'transaction_query_controller.dart';
import 'wallet_providers.dart';

/// État affiché par l'écran Historique : transactions chargées, indicateur de
/// page suivante disponible, et indicateur de chargement de cette page.
class TransactionHistoryState extends Equatable {
  const TransactionHistoryState({
    required this.transactions,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  final List<Transaction> transactions;
  final bool hasMore;
  final bool isLoadingMore;

  TransactionHistoryState copyWith({
    List<Transaction>? transactions,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return TransactionHistoryState(
      transactions: transactions ?? this.transactions,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [transactions, hasMore, isLoadingMore];
}

/// Charge l'historique paginé de l'utilisateur connecté, réagit aux
/// changements de filtre/recherche/tri et permet de charger la page suivante.
class TransactionHistoryController extends AsyncNotifier<TransactionHistoryState> {
  int _currentPage = 1;

  @override
  Future<TransactionHistoryState> build() async {
    final user = ref.watch(sessionControllerProvider);
    if (user == null) {
      throw const AppException('Utilisateur non connecté.');
    }
    // Toute évolution des critères doit relancer la recherche depuis la
    // première page.
    final query = ref.watch(transactionQueryControllerProvider);
    _currentPage = 1;

    final page = await ref
        .read(walletRepositoryProvider)
        .fetchTransactions(user.id, query.copyWithPage(1));

    return TransactionHistoryState(
      transactions: page.items,
      hasMore: page.hasMore,
    );
  }

  Future<void> loadMore() async {
    final current = state.value;
    final user = ref.read(sessionControllerProvider);
    if (current == null || !current.hasMore || current.isLoadingMore) return;
    if (user == null) return;

    state = AsyncData(current.copyWith(isLoadingMore: true));
    _currentPage += 1;

    final query = ref.read(transactionQueryControllerProvider).copyWithPage(_currentPage);
    final page =
        await ref.read(walletRepositoryProvider).fetchTransactions(user.id, query);

    state = AsyncData(
      current.copyWith(
        transactions: [...current.transactions, ...page.items],
        hasMore: page.hasMore,
        isLoadingMore: false,
      ),
    );
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

final transactionHistoryControllerProvider = AsyncNotifierProvider<
    TransactionHistoryController, TransactionHistoryState>(
  TransactionHistoryController.new,
);
