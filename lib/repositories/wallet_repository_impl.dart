import '../data/wallet_data_source.dart';
import '../models/transaction.dart';
import '../models/transaction_page.dart';
import '../models/transaction_query.dart';
import '../models/wallet.dart';
import 'wallet_repository.dart';

/// Implémentation de [WalletRepository] indépendante de l'origine des
/// données : [_dataSource] est [WalletDataSource], mock ou remote selon
/// [AppConfig.dataSourceMode] (voir `wallet_providers.dart`).
class WalletRepositoryImpl implements WalletRepository {
  WalletRepositoryImpl(this._dataSource);

  final WalletDataSource _dataSource;

  @override
  Future<Wallet> fetchWallet(String userId) {
    return _dataSource.fetchWallet(userId);
  }

  @override
  Future<List<Transaction>> fetchRecentTransactions(
    String userId, {
    int limit = 5,
  }) {
    return _dataSource.fetchRecentTransactions(userId, limit: limit);
  }

  @override
  Future<TransactionPage> fetchTransactions(String userId, TransactionQuery query) {
    return _dataSource.fetchTransactions(userId, query);
  }

  @override
  Future<Transaction> deposit({required String userId, required double amount}) {
    return _dataSource.deposit(userId: userId, amount: amount);
  }

  @override
  Future<Transaction> withdraw({required String userId, required double amount}) {
    return _dataSource.withdraw(userId: userId, amount: amount);
  }

  @override
  Future<Transaction> pay({
    required String userId,
    required double amount,
    required String label,
  }) {
    return _dataSource.pay(userId: userId, amount: amount, label: label);
  }
}
