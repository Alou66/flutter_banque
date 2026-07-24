import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/network/api_client.dart';
import 'session_controller.dart';

/// Client HTTP partagé par tous les RemoteDataSource, jamais instancié tant
/// que [AppConfig.dataSourceMode] vaut `mock`.
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(readToken: () => ref.read(sessionTokenControllerProvider));
});
