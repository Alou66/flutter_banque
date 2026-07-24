import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../../models/dto/transaction_dto.dart';
import '../../models/dto/transaction_page_dto.dart';
import '../../models/dto/wallet_dto.dart';
import '../../models/transaction.dart';
import '../../models/transaction_page.dart';
import '../../models/transaction_query.dart';
import '../../models/wallet.dart';
import '../wallet_data_source.dart';

/// Implémentation REST de [WalletDataSource], prête à remplacer
/// [WalletMockDataSource] dès que le backend Wallet existera : aucun
/// repository, provider ni écran n'a besoin de changer.
class WalletRemoteDataSource implements WalletDataSource {
  WalletRemoteDataSource(this._client);

  final ApiClient _client;

  @override
  Future<Wallet> fetchWallet(String userId) async {
    final response =
        await _client.guard(() => _client.dio.get(ApiEndpoints.wallet));
    return WalletDto.fromJson(response.data as Map<String, dynamic>)
        .toDomain();
  }

  @override
  Future<List<Transaction>> fetchRecentTransactions(
    String userId, {
    int limit = 5,
  }) async {
    final response = await _client.guard(() => _client.dio.get(
          ApiEndpoints.transactions,
          queryParameters: {'limit': limit},
        ));
    return _parseTransactions(response.data as List);
  }

  @override
  Future<TransactionPage> fetchTransactions(
    String userId,
    TransactionQuery query,
  ) async {
    final response = await _client.guard(() => _client.dio.get(
          ApiEndpoints.transactions,
          queryParameters: {
            if (query.type != null) 'type': query.type!.name,
            if (query.searchText.isNotEmpty) 'q': query.searchText,
            'sortBy': query.sortBy.name,
            'sortOrder': query.sortOrder.name,
            'page': query.page,
            'pageSize': query.pageSize,
          },
        ));
    return TransactionPageDto.fromJson(response.data as Map<String, dynamic>)
        .toDomain();
  }

  @override
  Future<Transaction> deposit({
    required String userId,
    required double amount,
  }) async {
    final response = await _client.guard(() => _client.dio.post(
          ApiEndpoints.deposit,
          data: {'amount': amount},
        ));
    return TransactionDto.fromJson(response.data as Map<String, dynamic>)
        .toDomain();
  }

  @override
  Future<Transaction> withdraw({
    required String userId,
    required double amount,
  }) async {
    final response = await _client.guard(() => _client.dio.post(
          ApiEndpoints.withdraw,
          data: {'amount': amount},
        ));
    return TransactionDto.fromJson(response.data as Map<String, dynamic>)
        .toDomain();
  }

  @override
  Future<Transaction> pay({
    required String userId,
    required double amount,
    required String label,
  }) async {
    final response = await _client.guard(() => _client.dio.post(
          ApiEndpoints.payment,
          data: {'amount': amount, 'label': label},
        ));
    return TransactionDto.fromJson(response.data as Map<String, dynamic>)
        .toDomain();
  }

  List<Transaction> _parseTransactions(List<dynamic> items) {
    return items
        .map((e) => TransactionDto.fromJson(e as Map<String, dynamic>).toDomain())
        .toList();
  }
}
