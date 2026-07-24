import 'dart:developer' as developer;
import 'package:dio/dio.dart';

/// Journalise chaque requête/réponse/erreur, utile pour déboguer
/// l'intégration backend sans outil externe.
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    developer.log('→ ${options.method} ${options.uri}', name: 'ApiClient');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    developer.log(
      '← ${response.statusCode} ${response.requestOptions.uri}',
      name: 'ApiClient',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    developer.log(
      '✕ ${err.requestOptions.method} ${err.requestOptions.uri} : ${err.message}',
      name: 'ApiClient',
    );
    handler.next(err);
  }
}
