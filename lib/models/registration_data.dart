import 'package:equatable/equatable.dart';

/// Données collectées pendant le tunnel d'inscription (formulaire → OTP → PIN),
/// transmises entre écrans via GoRouter.
class RegistrationData extends Equatable {
  const RegistrationData({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
  });

  final String firstName;
  final String lastName;
  final String phoneNumber;

  @override
  List<Object?> get props => [firstName, lastName, phoneNumber];
}
