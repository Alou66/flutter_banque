import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/app_config.dart';
import '../data/auth_data_source.dart';
import '../data/mock/auth_mock_data_source.dart';
import '../data/remote/auth_remote_data_source.dart';
import '../repositories/auth_repository.dart';
import '../repositories/auth_repository_impl.dart';
import 'network_providers.dart';

/// Bascule Mock/Remote pilotée par [AppConfig.dataSourceMode] : seul point à
/// changer le jour où le backend Auth existe.
final authDataSourceProvider = Provider<AuthDataSource>((ref) {
  return switch (AppConfig.dataSourceMode) {
    DataSourceMode.mock => AuthMockDataSource(),
    DataSourceMode.remote => AuthRemoteDataSource(
        ref.watch(authApiClientProvider),
        ref.watch(banqueApiClientProvider),
      ),
  };
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(authDataSourceProvider));
});
