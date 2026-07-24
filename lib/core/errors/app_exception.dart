/// Exception métier générique, porteuse d'un message destiné à l'utilisateur.
class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => message;
}
