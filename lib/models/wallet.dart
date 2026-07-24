import 'package:equatable/equatable.dart';

/// Représente le portefeuille (wallet) d'un utilisateur.
class Wallet extends Equatable {
  const Wallet({
    required this.balance,
    required this.currency,
    required this.accountNumber,
  });

  final double balance;
  final String currency;
  final String accountNumber;

  @override
  List<Object?> get props => [balance, currency, accountNumber];
}
