import '../transaction.dart';

/// Représentation JSON d'une [Transaction]. banque1_api (`TransactionResponse`
/// : `{ id, montant, typeTransaction, dateTransaction }`) ne stocke aucun
/// libellé : [label] est dérivé de [type] quand absent du JSON.
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

  factory TransactionDto.fromJson(Map<String, dynamic> json) {
    final type = _typeFromJson(json['typeTransaction'] as String);
    return TransactionDto(
      id: json['id'].toString(),
      type: type,
      label: json['label'] as String? ?? _defaultLabel(type),
      amount: (json['montant'] as num).toDouble(),
      date: DateTime.parse(json['dateTransaction'] as String),
    );
  }

  factory TransactionDto.fromDomain(Transaction transaction) => TransactionDto(
        id: transaction.id,
        type: transaction.type,
        label: transaction.label,
        amount: transaction.amount,
        date: transaction.date,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'typeTransaction': _typeToJson(type),
        'label': label,
        'montant': amount,
        'dateTransaction': date.toIso8601String(),
      };

  Transaction toDomain() => Transaction(
        id: id,
        type: type,
        label: label,
        amount: amount,
        date: date,
      );
}

TransactionType _typeFromJson(String value) => switch (value) {
      'DEPOT' => TransactionType.deposit,
      'RETRAIT' => TransactionType.withdrawal,
      'PAIEMENT' => TransactionType.payment,
      _ => throw FormatException('Type de transaction inconnu : $value'),
    };

String _typeToJson(TransactionType type) => switch (type) {
      TransactionType.deposit => 'DEPOT',
      TransactionType.withdrawal => 'RETRAIT',
      TransactionType.payment => 'PAIEMENT',
    };

String _defaultLabel(TransactionType type) => switch (type) {
      TransactionType.deposit => 'Dépôt',
      TransactionType.withdrawal => 'Retrait',
      TransactionType.payment => 'Paiement',
    };
