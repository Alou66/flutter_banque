import '../wallet.dart';

/// Représentation JSON d'un [Wallet]. banque1_api ne renvoie ni "wallet"
/// dédié ni devise : le solde vient de `CompteResponse` (`{ solde,
/// telephone, ... }`) et la devise est fixée à FCFA côté client.
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
        balance: (json['solde'] as num).toDouble(),
        currency: json['currency'] as String? ?? 'FCFA',
        accountNumber: json['telephone'] as String,
      );

  factory WalletDto.fromDomain(Wallet wallet) => WalletDto(
        balance: wallet.balance,
        currency: wallet.currency,
        accountNumber: wallet.accountNumber,
      );

  Map<String, dynamic> toJson() => {
        'solde': balance,
        'currency': currency,
        'telephone': accountNumber,
      };

  Wallet toDomain() => Wallet(
        balance: balance,
        currency: currency,
        accountNumber: accountNumber,
      );
}
