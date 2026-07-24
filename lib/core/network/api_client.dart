import 'package:dio/dio.dart';
import '../../config/app_config.dart';
import '../errors/api_exception.dart';
import '../errors/app_exception.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

/// Client HTTP central, partagé par tous les RemoteDataSource.
class ApiClient {
  ApiClient({required String? Function() readToken})
      : dio = Dio(
          BaseOptions(
            baseUrl: AppConfig.baseUrl,
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
}
