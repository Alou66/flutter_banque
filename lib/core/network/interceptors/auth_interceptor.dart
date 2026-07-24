import 'package:dio/dio.dart';

/// Ajoute le jeton de session courant (JWT) à chaque requête, si présent.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._readToken);

  final String? Function() _readToken;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _readToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
