import '../models/auth_session.dart';
import '../models/auth_user.dart';
import '../models/registration_data.dart';

/// Contrat d'authentification. L'implémentation mock sera remplacée par un
/// appel REST (Dio) une fois le backend disponible, sans impacter Riverpod/UI.
abstract class AuthRepository {
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
