import '../data/auth_data_source.dart';
import '../models/auth_user.dart';
import '../models/registration_data.dart';
import 'auth_repository.dart';

/// Implémentation d'[AuthRepository] indépendante de l'origine des données :
/// [_dataSource] est [AuthDataSource], mock ou remote selon
/// [AppConfig.dataSourceMode] (voir `auth_providers.dart`).
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._dataSource);

  final AuthDataSource _dataSource;

  @override
  Future<AuthUser> login({
    required String phoneNumber,
    required String pin,
  }) {
    return _dataSource.login(phoneNumber: phoneNumber, pin: pin);
  }

  @override
  Future<void> register({
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) {
    return _dataSource.register(
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
    );
  }

  @override
  Future<void> verifyOtp({required String phoneNumber, required String otp}) {
    return _dataSource.verifyOtp(phoneNumber: phoneNumber, otp: otp);
  }

  @override
  Future<AuthUser> createPin({
    required RegistrationData data,
    required String pin,
  }) {
    return _dataSource.createPin(data: data, pin: pin);
  }

  @override
  Future<void> verifyPin({required String phoneNumber, required String pin}) {
    return _dataSource.verifyPin(phoneNumber: phoneNumber, pin: pin);
  }

  @override
  Future<AuthUser> getProfile({required String phoneNumber}) {
    return _dataSource.getProfile(phoneNumber: phoneNumber);
  }

  @override
  Future<AuthUser> updateProfile({
    required String currentPhoneNumber,
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) {
    return _dataSource.updateProfile(
      currentPhoneNumber: currentPhoneNumber,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
    );
  }

  @override
  Future<void> changePin({
    required String phoneNumber,
    required String currentPin,
    required String newPin,
  }) {
    return _dataSource.changePin(
      phoneNumber: phoneNumber,
      currentPin: currentPin,
      newPin: newPin,
    );
  }
}
