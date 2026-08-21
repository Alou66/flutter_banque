import 'package:equatable/equatable.dart';

/// Données collectées pendant le tunnel d'inscription (formulaire → OTP → PIN),
/// transmises entre écrans via GoRouter.
class RegistrationData extends Equatable {
  const RegistrationData({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.numPiece,
  });

  final String firstName;
  final String lastName;
  final String phoneNumber;

  /// Numéro de pièce d'identité (10 chiffres), obligatoire pour la création
  /// de compte côté banque1_api (`CompteRequest.numPiece`).
  final String numPiece;

  @override
  List<Object?> get props => [firstName, lastName, phoneNumber, numPiece];
}
