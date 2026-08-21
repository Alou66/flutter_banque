import '../models/auth_session.dart';
import '../models/auth_user.dart';
import '../models/registration_data.dart';

/// Contrat implémenté par [AuthMockDataSource] et [AuthRemoteDataSource] :
/// permet à [AuthRepositoryImpl] d'ignorer totalement l'origine des données.
abstract class AuthDataSource {
  /// Retourne un [AuthSession] (utilisateur + jeton) car banque1_api n'émet
  /// de JWT qu'au login, jamais à la création de compte.
  Future<AuthSession> login({
    required String phoneNumber,
    required String pin,
  });

  Future<void> register({
    required String firstName,
    required String lastName,
    required String phoneNumber,
  });

  Future<void> verifyOtp({required String phoneNumber, required String otp});

  Future<AuthSession> createPin({
    required RegistrationData data,
    required String pin,
  });

  Future<void> verifyPin({required String phoneNumber, required String pin});

  Future<AuthUser> getProfile({required String phoneNumber});

  Future<AuthUser> updateProfile({
    required String currentPhoneNumber,
    required String firstName,
    required String lastName,
    required String phoneNumber,
  });

  Future<void> changePin({
    required String phoneNumber,
    required String currentPin,
    required String newPin,
  });
}
