import '../auth_session.dart';
import '../auth_user.dart';

/// Représentation JSON de la réponse de `POST /auth/login` (auth_api),
/// `LoginResponse : { token, telephone, nom, prenom, tokenExpiresAt }`.
/// N'inclut pas d'id de compte : [telephone] sert d'identifiant, comme
/// partout ailleurs côté backend (JWT, clé unique de `Compte`).
class LoginResponseDto {
  const LoginResponseDto({
    required this.token,
    required this.telephone,
    required this.nom,
    required this.prenom,
  });

  final String token;
  final String telephone;
  final String nom;
  final String prenom;

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) =>
      LoginResponseDto(
        token: json['token'] as String,
        telephone: json['telephone'] as String,
        nom: json['nom'] as String,
        prenom: json['prenom'] as String,
      );

  AuthSession toDomain() => AuthSession(
        user: AuthUser(
          id: telephone,
          firstName: prenom,
          lastName: nom,
          phoneNumber: telephone,
        ),
        token: token,
      );
}
