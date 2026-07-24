import '../transaction.dart';

/// Représentation JSON d'une [Transaction], telle qu'échangée avec l'API REST.
class TransactionDto {
  const TransactionDto({
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

  factory TransactionDto.fromJson(Map<String, dynamic> json) => TransactionDto(
        id: json['id'] as String,
        type: TransactionType.values.byName(json['type'] as String),
        label: json['label'] as String,
        amount: (json['amount'] as num).toDouble(),
        date: DateTime.parse(json['date'] as String),
      );

  factory TransactionDto.fromDomain(Transaction transaction) => TransactionDto(
        id: transaction.id,
        type: transaction.type,
        label: transaction.label,
        amount: transaction.amount,
        date: transaction.date,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'label': label,
        'amount': amount,
        'date': date.toIso8601String(),
      };

  Transaction toDomain() => Transaction(
        id: id,
        type: type,
        label: label,
        amount: amount,
        date: date,
      );
}
