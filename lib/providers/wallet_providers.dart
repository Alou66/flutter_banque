import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/app_config.dart';
import '../data/mock/wallet_mock_data_source.dart';
import '../data/remote/wallet_remote_data_source.dart';
import '../data/wallet_data_source.dart';
import '../repositories/wallet_repository.dart';
import '../repositories/wallet_repository_impl.dart';
import 'network_providers.dart';

/// Bascule Mock/Remote pilotée par [AppConfig.dataSourceMode] : seul point à
/// changer le jour où le backend Wallet existe.
final walletDataSourceProvider = Provider<WalletDataSource>((ref) {
  return switch (AppConfig.dataSourceMode) {
    DataSourceMode.mock => WalletMockDataSource(),
    DataSourceMode.remote =>
      WalletRemoteDataSource(ref.watch(banqueApiClientProvider)),
  };
});

final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  return WalletRepositoryImpl(ref.watch(walletDataSourceProvider));
});
