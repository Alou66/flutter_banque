import '../auth_user.dart';

/// Représentation JSON d'un [AuthUser], telle que renvoyée par banque1_api
/// (`CompteResponse` : `{ id, prenom, nom, telephone, ... }`).
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
        id: json['id'].toString(),
        firstName: json['prenom'] as String,
        lastName: json['nom'] as String,
        phoneNumber: json['telephone'] as String,
      );

  factory AuthUserDto.fromDomain(AuthUser user) => AuthUserDto(
        id: user.id,
        firstName: user.firstName,
        lastName: user.lastName,
        phoneNumber: user.phoneNumber,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'prenom': firstName,
        'nom': lastName,
        'telephone': phoneNumber,
      };

  AuthUser toDomain() => AuthUser(
        id: id,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
      );
}
