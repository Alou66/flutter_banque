import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../../models/auth_user.dart';
import '../../models/dto/auth_user_dto.dart';
import '../../models/registration_data.dart';
import '../auth_data_source.dart';

/// Implémentation REST d'[AuthDataSource], prête à remplacer
/// [AuthMockDataSource] dès que le backend Auth existera : aucun repository,
/// provider ni écran n'a besoin de changer.
class AuthRemoteDataSource implements AuthDataSource {
  AuthRemoteDataSource(this._client);

  final ApiClient _client;

  @override
  Future<AuthUser> login({
    required String phoneNumber,
    required String pin,
  }) async {
    final response = await _client.guard(() => _client.dio.post(
          ApiEndpoints.login,
          data: {'phoneNumber': phoneNumber, 'pin': pin},
        ));
    return AuthUserDto.fromJson(response.data as Map<String, dynamic>)
        .toDomain();
  }

  @override
  Future<void> register({
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) async {
    await _client.guard(() => _client.dio.post(
          ApiEndpoints.register,
          data: {
            'firstName': firstName,
            'lastName': lastName,
            'phoneNumber': phoneNumber,
          },
        ));
  }

  @override
  Future<void> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    await _client.guard(() => _client.dio.post(
          ApiEndpoints.verifyOtp,
          data: {'phoneNumber': phoneNumber, 'otp': otp},
        ));
  }

  @override
  Future<AuthUser> createPin({
    required RegistrationData data,
    required String pin,
  }) async {
    final response = await _client.guard(() => _client.dio.post(
          ApiEndpoints.createPin,
          data: {
            'firstName': data.firstName,
            'lastName': data.lastName,
            'phoneNumber': data.phoneNumber,
            'pin': pin,
          },
        ));
    return AuthUserDto.fromJson(response.data as Map<String, dynamic>)
        .toDomain();
  }

  @override
  Future<void> verifyPin({
    required String phoneNumber,
    required String pin,
  }) async {
    await _client.guard(() => _client.dio.post(
          ApiEndpoints.verifyPin,
          data: {'phoneNumber': phoneNumber, 'pin': pin},
        ));
  }

  @override
  Future<AuthUser> getProfile({required String phoneNumber}) async {
    final response = await _client.guard(() => _client.dio.get(
          ApiEndpoints.profile,
        ));
    return AuthUserDto.fromJson(response.data as Map<String, dynamic>)
        .toDomain();
  }

  @override
  Future<AuthUser> updateProfile({
    required String currentPhoneNumber,
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) async {
    final response = await _client.guard(() => _client.dio.put(
          ApiEndpoints.profile,
          data: {
            'firstName': firstName,
            'lastName': lastName,
            'phoneNumber': phoneNumber,
          },
        ));
    return AuthUserDto.fromJson(response.data as Map<String, dynamic>)
        .toDomain();
  }

  @override
  Future<void> changePin({
    required String phoneNumber,
    required String currentPin,
    required String newPin,
  }) async {
    await _client.guard(() => _client.dio.post(
          ApiEndpoints.changePin,
          data: {'currentPin': currentPin, 'newPin': newPin},
        ));
  }
}
