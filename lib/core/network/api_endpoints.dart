/// Chemins des endpoints REST, centralisés pour que les RemoteDataSource
/// n'utilisent jamais de chaînes littérales. Split en deux car auth_api et
/// banque1_api sont deux services distincts (voir [AppConfig.authApiBaseUrl]
/// et [AppConfig.banqueApiBaseUrl]).
abstract class AuthEndpoints {
  static const String sendOtp = '/auth/send-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String login = '/auth/login';
}

abstract class BanqueEndpoints {
  static const String comptes = '/comptes';
  static const String compteMe = '/comptes/me';
  static const String verifyPin = '/comptes/verify-pin';
  static const String changePin = '/comptes/change-pin';

  static const String transactions = '/transactions/me';
  static const String depot = '/transactions/depot';
  static const String retrait = '/transactions/retrait';
  static const String paiement = '/transactions/paiement';
}
