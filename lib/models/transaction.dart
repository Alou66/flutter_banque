import 'package:equatable/equatable.dart';

enum TransactionType { deposit, withdrawal, payment }

/// Représente une opération effectuée sur le wallet.
class Transaction extends Equatable {
  const Transaction({
    required this.id,
    required this.type,
    required this.label,
    required this.amount,
    required this.date,
  });

  final String id;
  final TransactionType type;
  final String label;
  final double amount;
  final DateTime date;

  bool get isCredit => type == TransactionType.deposit;

  @override
  List<Object?> get props => [id, type, label, amount, date];
}
