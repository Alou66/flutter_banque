import '../wallet.dart';

/// Représentation JSON d'un [Wallet], telle qu'échangée avec l'API REST.
class WalletDto {
  const WalletDto({
    required this.balance,
    required this.currency,
    required this.accountNumber,
  });

  final double balance;
  final String currency;
  final String accountNumber;

  factory WalletDto.fromJson(Map<String, dynamic> json) => WalletDto(
        balance: (json['balance'] as num).toDouble(),
        currency: json['currency'] as String,
        accountNumber: json['accountNumber'] as String,
      );

  factory WalletDto.fromDomain(Wallet wallet) => WalletDto(
        balance: wallet.balance,
        currency: wallet.currency,
        accountNumber: wallet.accountNumber,
      );

  Map<String, dynamic> toJson() => {
        'balance': balance,
        'currency': currency,
        'accountNumber': accountNumber,
      };

  Wallet toDomain() => Wallet(
        balance: balance,
        currency: currency,
        accountNumber: accountNumber,
      );
}
