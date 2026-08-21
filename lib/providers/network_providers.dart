import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/app_config.dart';
import '../core/network/api_client.dart';
import 'session_controller.dart';

/// Client HTTP vers auth_api (OTP, login), jamais instancié tant que
/// [AppConfig.dataSourceMode] vaut `mock`.
final authApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(
    baseUrl: AppConfig.authApiBaseUrl,
    readToken: () => ref.read(sessionTokenControllerProvider),
  );
});

/// Client HTTP vers banque1_api (comptes, transactions), jamais instancié
/// tant que [AppConfig.dataSourceMode] vaut `mock`.
final banqueApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(
    baseUrl: AppConfig.banqueApiBaseUrl,
    readToken: () => ref.read(sessionTokenControllerProvider),
  );
});
