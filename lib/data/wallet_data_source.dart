import '../models/transaction.dart';
import '../models/transaction_page.dart';
import '../models/transaction_query.dart';
import '../models/wallet.dart';

/// Contrat implémenté par [WalletMockDataSource] et [WalletRemoteDataSource] :
/// permet à [WalletRepositoryImpl] d'ignorer totalement l'origine des données.
abstract class WalletDataSource {
  Future<Wallet> fetchWallet(String userId);

  Future<List<Transaction>> fetchRecentTransactions(
    String userId, {
    int limit = 5,
  });

  Future<TransactionPage> fetchTransactions(
    String userId,
    TransactionQuery query,
  );

  Future<Transaction> deposit({required String userId, required double amount});

  Future<Transaction> withdraw({required String userId, required double amount});

  Future<Transaction> pay({
    required String userId,
    required double amount,
    required String label,
  });
}
