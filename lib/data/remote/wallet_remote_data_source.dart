import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../../models/dto/transaction_dto.dart';
import '../../models/dto/wallet_dto.dart';
import '../../models/transaction.dart';
import '../../models/transaction_page.dart';
import '../../models/transaction_query.dart';
import '../../models/wallet.dart';
import '../wallet_data_source.dart';

/// Implémentation REST de [WalletDataSource] contre banque1_api.
///
/// banque1_api ne fournit aucun filtre/tri/pagination côté serveur pour
/// `GET /transactions/me` : il renvoie la liste complète. Cette couche
/// applique donc [TransactionQuery] côté client (même logique que
/// [WalletMockDataSource]), pour que [TransactionQueryController] et les
/// écrans d'historique n'aient rien à savoir de cette limitation.
class WalletRemoteDataSource implements WalletDataSource {
  WalletRemoteDataSource(this._client);

  final ApiClient _client;

  @override
  Future<Wallet> fetchWallet(String userId) async {
    final data = await _client
        .guardData(() => _client.dio.get(BanqueEndpoints.compteMe));
    return WalletDto.fromJson(data as Map<String, dynamic>).toDomain();
  }

  @override
  Future<List<Transaction>> fetchRecentTransactions(
    String userId, {
    int limit = 5,
  }) async {
    final all = await _fetchAllTransactions();
    final sorted = [...all]..sort((a, b) => b.date.compareTo(a.date));
    return sorted.take(limit).toList();
  }

  @override
  Future<TransactionPage> fetchTransactions(
    String userId,
    TransactionQuery query,
  ) async {
    final all = await _fetchAllTransactions();

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
    final data = await _client.guardData(() => _client.dio.post(
          BanqueEndpoints.depot,
          data: {'montant': amount.round()},
        ));
    return TransactionDto.fromJson(data as Map<String, dynamic>).toDomain();
  }

  @override
  Future<Transaction> withdraw({
    required String userId,
    required double amount,
  }) async {
    final data = await _client.guardData(() => _client.dio.post(
          BanqueEndpoints.retrait,
          data: {'montant': amount.round()},
        ));
    return TransactionDto.fromJson(data as Map<String, dynamic>).toDomain();
  }

  @override
  Future<Transaction> pay({
    required String userId,
    required double amount,
    required String label,
  }) async {
    final data = await _client.guardData(() => _client.dio.post(
          BanqueEndpoints.paiement,
          data: {'montant': amount.round()},
        ));
    final transaction =
        TransactionDto.fromJson(data as Map<String, dynamic>).toDomain();
    // banque1_api ne stocke aucun libellé : on réaffiche celui saisi par
    // l'utilisateur pour cette transaction fraîchement créée (perdu au
    // prochain rechargement de l'historique, faute de persistance serveur).
    return Transaction(
      id: transaction.id,
      type: transaction.type,
      label: label,
      amount: transaction.amount,
      date: transaction.date,
    );
  }

  Future<List<Transaction>> _fetchAllTransactions() async {
    final data = await _client
        .guardData(() => _client.dio.get(BanqueEndpoints.transactions));
    return (data as List)
        .map((e) => TransactionDto.fromJson(e as Map<String, dynamic>).toDomain())
        .toList();
  }
}
