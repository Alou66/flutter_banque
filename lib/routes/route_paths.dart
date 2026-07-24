/// Chemins des routes de l'application, centralisés pour éviter les chaînes
/// littérales dispersées dans le code.
abstract class RoutePaths {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String otp = '/otp';
  static const String pinSetup = '/pin-setup';
  static const String home = '/home';
  static const String deposit = '/deposit';
  static const String withdraw = '/withdraw';
  static const String payment = '/payment';
  static const String transactions = '/transactions';
  static const String transactionDetail = '/transactions/detail';
  static const String profile = '/profile';
  static const String profileEdit = '/profile/edit';
  static const String profileChangePin = '/profile/change-pin';
}
