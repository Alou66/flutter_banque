import 'package:dio/dio.dart';
import '../../config/app_config.dart';
import '../errors/api_exception.dart';
import '../errors/app_exception.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

/// Client HTTP central, partagé par tous les RemoteDataSource. Un [ApiClient]
/// par backend (auth_api, banque1_api), chacun avec son propre [baseUrl].
class ApiClient {
  ApiClient({required String baseUrl, required String? Function() readToken})
      : dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: AppConfig.connectTimeout,
            receiveTimeout: AppConfig.receiveTimeout,
          ),
        ) {
    dio.interceptors.addAll([
      AuthInterceptor(readToken),
      LoggingInterceptor(),
      ErrorInterceptor(),
    ]);
  }

  final Dio dio;

  /// Exécute un appel Dio et traduit toute [ApiException] en [AppException],
  /// pour que Repository/Riverpod/UI ignorent totalement le transport.
  Future<T> guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on DioException catch (e) {
      final apiException = e.error is ApiException
          ? e.error as ApiException
          : const ApiException(message: 'Erreur réseau.');
      throw AppException(apiException.message);
    }
  }

  /// Comme [guard], mais dé-enveloppe en plus le corps `{ success, message,
  /// data, ... }` commun aux réponses de auth_api et banque1_api pour ne
  /// retourner que son champ `data`.
  Future<dynamic> guardData(Future<Response> Function() call) async {
    final response = await guard(call);
    final body = response.data;
    if (body is Map && body.containsKey('data')) {
      return body['data'];
    }
    return body;
  }
}
