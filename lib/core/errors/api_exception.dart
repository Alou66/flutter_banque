/// Erreur de la couche réseau (HTTP/Dio), distincte d'[AppException] : les
/// RemoteDataSource la traduisent en [AppException] avant de la relayer, pour
/// que Repository/Riverpod/UI n'aient jamais à connaître le transport.
class ApiException implements Exception {
  const ApiException({required this.message, this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}
