import '../auth_user.dart';

/// Représentation JSON d'un [AuthUser], telle qu'échangée avec l'API REST.
class AuthUserDto {
  const AuthUserDto({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String phoneNumber;

  factory AuthUserDto.fromJson(Map<String, dynamic> json) => AuthUserDto(
        id: json['id'] as String,
        firstName: json['firstName'] as String,
        lastName: json['lastName'] as String,
        phoneNumber: json['phoneNumber'] as String,
      );

  factory AuthUserDto.fromDomain(AuthUser user) => AuthUserDto(
        id: user.id,
        firstName: user.firstName,
        lastName: user.lastName,
        phoneNumber: user.phoneNumber,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
      };

  AuthUser toDomain() => AuthUser(
        id: id,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
      );
}
