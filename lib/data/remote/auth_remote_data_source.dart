import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../../models/auth_session.dart';
import '../../models/auth_user.dart';
import '../../models/dto/auth_user_dto.dart';
import '../../models/dto/login_response_dto.dart';
import '../../models/registration_data.dart';
import '../auth_data_source.dart';

/// Implémentation REST d'[AuthDataSource] contre auth_api (OTP, login) et
/// banque1_api (comptes) : deux services distincts, donc deux [ApiClient].
class AuthRemoteDataSource implements AuthDataSource {
  AuthRemoteDataSource(this._authClient, this._banqueClient);

  final ApiClient _authClient;
  final ApiClient _banqueClient;

  @override
  Future<AuthSession> login({
    required String phoneNumber,
    required String pin,
  }) async {
    final data = await _authClient.guardData(() => _authClient.dio.post(
          AuthEndpoints.login,
          data: {'telephone': phoneNumber, 'pin': pin},
        ));
    return LoginResponseDto.fromJson(data as Map<String, dynamic>).toDomain();
  }

  @override
  Future<void> register({
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) async {
    // auth_api ne crée pas le compte à cette étape (prénom/nom ne sont
    // utiles qu'à POST /comptes, dans createPin) : elle envoie juste l'OTP.
    await _authClient.guardData(() => _authClient.dio.post(
          AuthEndpoints.sendOtp,
          data: {'telephone': phoneNumber},
        ));
  }

  @override
  Future<void> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    await _authClient.guardData(() => _authClient.dio.post(
          AuthEndpoints.verifyOtp,
          data: {'telephone': phoneNumber, 'otp': otp},
        ));
  }

  @override
  Future<AuthSession> createPin({
    required RegistrationData data,
    required String pin,
  }) async {
    // banque1_api crée le compte (l'OTP vérifié à l'étape précédente est
    // revalidé côté serveur) mais n'émet pas de JWT : on enchaîne un login
    // pour obtenir un vrai jeton de session, comme le ferait l'utilisateur.
    await _banqueClient.guardData(() => _banqueClient.dio.post(
          BanqueEndpoints.comptes,
          data: {
            'prenom': data.firstName,
            'nom': data.lastName,
            'telephone': data.phoneNumber,
            'numPiece': data.numPiece,
            'pin': pin,
          },
        ));
    return login(phoneNumber: data.phoneNumber, pin: pin);
  }

  @override
  Future<void> verifyPin({
    required String phoneNumber,
    required String pin,
  }) async {
    await _banqueClient.guardData(() => _banqueClient.dio.post(
          BanqueEndpoints.verifyPin,
          data: {'pin': pin},
        ));
  }

  @override
  Future<AuthUser> getProfile({required String phoneNumber}) async {
    final data = await _banqueClient
        .guardData(() => _banqueClient.dio.get(BanqueEndpoints.compteMe));
    return AuthUserDto.fromJson(data as Map<String, dynamic>).toDomain();
  }

  @override
  Future<AuthUser> updateProfile({
    required String currentPhoneNumber,
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) async {
    final data = await _banqueClient.guardData(() => _banqueClient.dio.put(
          BanqueEndpoints.comptes,
          data: {
            'prenom': firstName,
            'nom': lastName,
            'telephone': phoneNumber,
          },
        ));
    return AuthUserDto.fromJson(data as Map<String, dynamic>).toDomain();
  }

  @override
  Future<void> changePin({
    required String phoneNumber,
    required String currentPin,
    required String newPin,
  }) async {
    await _banqueClient.guardData(() => _banqueClient.dio.post(
          BanqueEndpoints.changePin,
          data: {'currentPin': currentPin, 'newPin': newPin},
        ));
  }
}
