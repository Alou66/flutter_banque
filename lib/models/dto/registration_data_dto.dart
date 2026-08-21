import '../registration_data.dart';

/// Représentation JSON d'un [RegistrationData], envoyée lors de l'inscription.
class RegistrationDataDto {
  const RegistrationDataDto({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.numPiece,
  });

  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String numPiece;

  factory RegistrationDataDto.fromJson(Map<String, dynamic> json) =>
      RegistrationDataDto(
        firstName: json['firstName'] as String,
        lastName: json['lastName'] as String,
        phoneNumber: json['phoneNumber'] as String,
        numPiece: json['numPiece'] as String,
      );

  factory RegistrationDataDto.fromDomain(RegistrationData data) =>
      RegistrationDataDto(
        firstName: data.firstName,
        lastName: data.lastName,
        phoneNumber: data.phoneNumber,
        numPiece: data.numPiece,
      );

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'numPiece': numPiece,
      };

  RegistrationData toDomain() => RegistrationData(
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        numPiece: numPiece,
      );
}
