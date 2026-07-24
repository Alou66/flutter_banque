import 'package:dio/dio.dart';
import '../../errors/api_exception.dart';

/// Normalise toute erreur Dio en [ApiException], pour que le reste de l'app
/// n'ait qu'un seul type d'erreur réseau à traiter.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err.copyWith(error: _toApiException(err)));
  }

  ApiException _toApiException(DioException err) {
    final statusCode = err.response?.statusCode;
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiException(
          message: 'Le serveur met trop de temps à répondre.',
        );
      case DioExceptionType.connectionError:
        return const ApiException(
          message: 'Impossible de contacter le serveur.',
        );
      case DioExceptionType.badResponse:
        return ApiException(
          message: _extractMessage(err.response?.data) ??
              'Erreur serveur ($statusCode).',
          statusCode: statusCode,
        );
      default:
        return const ApiException(message: 'Une erreur réseau est survenue.');
    }
  }

  String? _extractMessage(dynamic data) {
    if (data is Map && data['message'] is String) {
      return data['message'] as String;
    }
    return null;
  }
}
