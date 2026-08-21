import 'package:equatable/equatable.dart';
import 'auth_user.dart';

/// Résultat d'une connexion ou d'une création de compte réussie : l'utilisateur
/// authentifié et le jeton de session à transmettre à
/// [SessionTokenController.issue] (le seul endroit qui a besoin du jeton brut).
class AuthSession extends Equatable {
  const AuthSession({required this.user, required this.token});

  final AuthUser user;
  final String token;

  @override
  List<Object?> get props => [user, token];
}
