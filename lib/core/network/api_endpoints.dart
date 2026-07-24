/// Chemins des endpoints REST, centralisés pour que les RemoteDataSource
/// n'utilisent jamais de chaînes littérales.
abstract class ApiEndpoints {
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String verifyOtp = '/auth/verify-otp';
  static const String createPin = '/auth/create-pin';
  static const String verifyPin = '/auth/verify-pin';
  static const String profile = '/profile';
  static const String changePin = '/profile/change-pin';

  static const String wallet = '/wallet';
  static const String transactions = '/wallet/transactions';
  static const String deposit = '/wallet/deposit';
  static const String withdraw = '/wallet/withdraw';
  static const String payment = '/wallet/payment';
}
