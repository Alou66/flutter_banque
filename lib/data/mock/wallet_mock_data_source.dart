import '../../core/errors/app_exception.dart';
import '../../models/transaction.dart';
import '../../models/transaction_page.dart';
import '../../models/transaction_query.dart';
import '../../models/wallet.dart';
import '../wallet_data_source.dart';

/// Simule les appels réseau du service Wallet (absent), avec un état en
/// mémoire par utilisateur pour rendre les tests de bout en bout cohérents.
class WalletMockDataSource implements WalletDataSource {
  final Map<String, double> _balances = {};
  final Map<String, List<Transaction>> _transactions = {};
  int _nextTransactionId = 100;

  @override
  Future<Wallet> fetchWallet(String userId) async {
    await Future.delayed(const Duration(milliseconds: 900));
    final balance = _balances.putIfAbsent(userId, () => 250000);
    return Wallet(balance: balance, currency: 'FCFA', accountNumber: userId);
  }

  @override
  Future<List<Transaction>> fetchRecentTransactions(
    String userId, {
    int limit = 5,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));
    final transactions =
        _transactions.putIfAbsent(userId, () => _seedTransactions());
    final sorted = [...transactions]..sort((a, b) => b.date.compareTo(a.date));
    return sorted.take(limit).toList();
  }

  /// Filtre, trie et pagine l'historique complet, à l'image d'un futur
  /// endpoint REST (`GET /transactions?type=...&q=...&sort=...&page=...`).
  @override
  Future<TransactionPage> fetchTransactions(
    String userId,
    TransactionQuery query,
  ) async {
    await Future.delayed(const Duration(milliseconds: 700));
    final all = _transactions.putIfAbsent(userId, () => _seedTransactions());

    var filtered = all.where((t) => query.type == null || t.type == query.type);
    final search = query.searchText.trim().toLowerCase();
    if (search.isNotEmpty) {
      filtered = filtered.where((t) => t.label.toLowerCase().contains(search));
    }

    final results = filtered.toList()
      ..sort((a, b) {
        final comparison = switch (query.sortBy) {
          TransactionSortBy.date => a.date.compareTo(b.date),
          TransactionSortBy.amount => a.amount.compareTo(b.amount),
          TransactionSortBy.type => a.type.name.compareTo(b.type.name),
        };
        return query.sortOrder == SortOrder.asc ? comparison : -comparison;
      });

    final start = (query.page - 1) * query.pageSize;
    final end = (start + query.pageSize).clamp(0, results.length);
    final pageItems =
        start >= results.length ? <Transaction>[] : results.sublist(start, end);

    return TransactionPage(
      items: pageItems,
      page: query.page,
      pageSize: query.pageSize,
      totalCount: results.length,
    );
  }

  @override
  Future<Transaction> deposit({
    required String userId,
    required double amount,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    _validateAmount(amount);

    final balance = _balances.putIfAbsent(userId, () => 250000);
    _balances[userId] = balance + amount;

    return _recordTransaction(
      userId: userId,
      type: TransactionType.deposit,
      label: 'Dépôt',
      amount: amount,
    );
  }

  @override
  Future<Transaction> withdraw({
    required String userId,
    required double amount,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    _validateAmount(amount);

    final balance = _balances.putIfAbsent(userId, () => 250000);
    if (amount > balance) {
      throw const AppException('Solde insuffisant pour ce retrait.');
    }
    _balances[userId] = balance - amount;

    return _recordTransaction(
      userId: userId,
      type: TransactionType.withdrawal,
      label: 'Retrait',
      amount: amount,
    );
  }

  @override
  Future<Transaction> pay({
    required String userId,
    required double amount,
    required String label,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    _validateAmount(amount);

    final balance = _balances.putIfAbsent(userId, () => 250000);
    if (amount > balance) {
      throw const AppException('Solde insuffisant pour ce paiement.');
    }
    _balances[userId] = balance - amount;

    return _recordTransaction(
      userId: userId,
      type: TransactionType.payment,
      label: label,
      amount: amount,
    );
  }

  void _validateAmount(double amount) {
    if (amount <= 0) {
      throw const AppException('Le montant doit être supérieur à 0.');
    }
  }

  Transaction _recordTransaction({
    required String userId,
    required TransactionType type,
    required String label,
    required double amount,
  }) {
    final transaction = Transaction(
      id: 'tx${_nextTransactionId++}',
      type: type,
      label: label,
      amount: amount,
      date: DateTime.now(),
    );
    _transactions
        .putIfAbsent(userId, () => _seedTransactions())
        .insert(0, transaction);
    return transaction;
  }

  List<Transaction> _seedTransactions() {
    final now = DateTime.now();
    return [
      Transaction(
        id: 't1',
        type: TransactionType.deposit,
        label: 'Dépôt Orange Money',
        amount: 50000,
        date: now.subtract(const Duration(hours: 3)),
      ),
      Transaction(
        id: 't2',
        type: TransactionType.payment,
        label: 'Paiement facture SEG',
        amount: 12500,
        date: now.subtract(const Duration(days: 1)),
      ),
      Transaction(
        id: 't3',
        type: TransactionType.withdrawal,
        label: 'Retrait agence',
        amount: 20000,
        date: now.subtract(const Duration(days: 2)),
      ),
      Transaction(
        id: 't4',
        type: TransactionType.payment,
        label: 'Paiement Canal+',
        amount: 15000,
        date: now.subtract(const Duration(days: 3)),
      ),
      Transaction(
        id: 't5',
        type: TransactionType.deposit,
        label: 'Virement reçu',
        amount: 100000,
        date: now.subtract(const Duration(days: 4)),
      ),
      Transaction(
        id: 't6',
        type: TransactionType.withdrawal,
        label: 'Retrait distributeur',
        amount: 10000,
        date: now.subtract(const Duration(days: 6)),
      ),
    ];
  }
}
