import '../../core/errors/app_exception.dart';
import '../../models/auth_user.dart';
import '../../models/registration_data.dart';
import '../auth_data_source.dart';

class _MockAccount {
  _MockAccount({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.pin,
  });

  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String pin;

  AuthUser toUser() => AuthUser(
        id: phoneNumber,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
      );
}

/// Simule les appels réseau du backend Banque (absent) avec des délais
/// réalistes et un état en mémoire, le temps que la vraie API existe.
class AuthMockDataSource implements AuthDataSource {
  final List<_MockAccount> _accounts = [
    _MockAccount(
      firstName: 'Alassane',
      lastName: 'Diallo',
      phoneNumber: '700000000',
      pin: '1234',
    ),
  ];

  static const _demoOtp = '123456';
  String? _pendingOtpPhone;

  @override
  Future<AuthUser> login({
    required String phoneNumber,
    required String pin,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    final account = _findAccount(phoneNumber);
    if (account == null) {
      throw const AppException('Aucun compte associé à ce numéro.');
    }
    if (account.pin != pin) {
      throw const AppException('Code PIN incorrect.');
    }
    return account.toUser();
  }

  @override
  Future<void> register({
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    if (_findAccount(phoneNumber) != null) {
      throw const AppException('Ce numéro de téléphone est déjà utilisé.');
    }
    _pendingOtpPhone = phoneNumber;
  }

  @override
  Future<void> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (_pendingOtpPhone != phoneNumber || otp != _demoOtp) {
      throw const AppException('Code de vérification invalide.');
    }
  }

  @override
  Future<AuthUser> createPin({
    required RegistrationData data,
    required String pin,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    final account = _MockAccount(
      firstName: data.firstName,
      lastName: data.lastName,
      phoneNumber: data.phoneNumber,
      pin: pin,
    );
    _accounts.add(account);
    _pendingOtpPhone = null;
    return account.toUser();
  }

  @override
  Future<void> verifyPin({
    required String phoneNumber,
    required String pin,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final account = _findAccount(phoneNumber);
    if (account == null || account.pin != pin) {
      throw const AppException('Code PIN incorrect.');
    }
  }

  @override
  Future<AuthUser> getProfile({required String phoneNumber}) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final account = _findAccount(phoneNumber);
    if (account == null) {
      throw const AppException('Utilisateur introuvable.');
    }
    return account.toUser();
  }

  @override
  Future<AuthUser> updateProfile({
    required String currentPhoneNumber,
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    final index =
        _accounts.indexWhere((a) => a.phoneNumber == currentPhoneNumber);
    if (index == -1) {
      throw const AppException('Utilisateur introuvable.');
    }
    if (phoneNumber != currentPhoneNumber && _findAccount(phoneNumber) != null) {
      throw const AppException('Ce numéro de téléphone est déjà utilisé.');
    }
    final updated = _MockAccount(
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
      pin: _accounts[index].pin,
    );
    _accounts[index] = updated;
    return updated.toUser();
  }

  @override
  Future<void> changePin({
    required String phoneNumber,
    required String currentPin,
    required String newPin,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final index = _accounts.indexWhere((a) => a.phoneNumber == phoneNumber);
    if (index == -1) {
      throw const AppException('Utilisateur introuvable.');
    }
    if (_accounts[index].pin != currentPin) {
      throw const AppException('Ancien code PIN incorrect.');
    }
    _accounts[index] = _MockAccount(
      firstName: _accounts[index].firstName,
      lastName: _accounts[index].lastName,
      phoneNumber: _accounts[index].phoneNumber,
      pin: newPin,
    );
  }

  _MockAccount? _findAccount(String phoneNumber) {
    for (final account in _accounts) {
      if (account.phoneNumber == phoneNumber) return account;
    }
    return null;
  }
}
