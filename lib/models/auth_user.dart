import 'package:equatable/equatable.dart';

/// Représente un utilisateur authentifié.
class AuthUser extends Equatable {
  const AuthUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String phoneNumber;

  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [id, firstName, lastName, phoneNumber];
}
