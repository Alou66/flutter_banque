import 'package:equatable/equatable.dart';

/// Données collectées pendant le tunnel d'inscription (formulaire → OTP → PIN),
/// transmises entre écrans via GoRouter.
class RegistrationData extends Equatable {
  const RegistrationData({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    required this.numPiece,
  });

  final String firstName;
  final String lastName;
  final String phoneNumber;

  /// Adresse email, obligatoire : c'est elle qui reçoit le code OTP (envoyé
  /// via Brevo par auth_api) et elle est aussi stockée sur le compte
  /// (`CompteRequest.email` côté banque1_api).
  final String email;

  /// Numéro de pièce d'identité (10 chiffres), obligatoire pour la création
  /// de compte côté banque1_api (`CompteRequest.numPiece`).
  final String numPiece;

  @override
  List<Object?> get props =>
      [firstName, lastName, phoneNumber, email, numPiece];
}
