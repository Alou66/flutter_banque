import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_banque/models/auth_user.dart';
import 'package:flutter_banque/models/dto/auth_user_dto.dart';
import 'package:flutter_banque/models/dto/registration_data_dto.dart';
import 'package:flutter_banque/models/dto/transaction_dto.dart';
import 'package:flutter_banque/models/dto/transaction_page_dto.dart';
import 'package:flutter_banque/models/dto/wallet_dto.dart';
import 'package:flutter_banque/models/registration_data.dart';
import 'package:flutter_banque/models/transaction.dart';
import 'package:flutter_banque/models/transaction_page.dart';
import 'package:flutter_banque/models/wallet.dart';

void main() {
  test('AuthUserDto : round-trip fromJson/toJson et toDomain', () {
    const user = AuthUser(
      id: '700000000',
      firstName: 'Alassane',
      lastName: 'Diallo',
      phoneNumber: '700000000',
    );
    final json = AuthUserDto.fromDomain(user).toJson();
    final decoded = AuthUserDto.fromJson(json).toDomain();

    expect(decoded, user);
  });

  test('WalletDto : round-trip fromJson/toJson et toDomain', () {
    const wallet = Wallet(
      balance: 250000,
      currency: 'FCFA',
      accountNumber: '700000000',
    );
    final json = WalletDto.fromDomain(wallet).toJson();
    final decoded = WalletDto.fromJson(json).toDomain();

    expect(decoded, wallet);
  });

  test('TransactionDto : round-trip fromJson/toJson et toDomain', () {
    final transaction = Transaction(
      id: 't1',
      type: TransactionType.deposit,
      label: 'Dépôt Orange Money',
      amount: 50000,
      date: DateTime.utc(2026, 1, 15, 10, 30),
    );
    final json = TransactionDto.fromDomain(transaction).toJson();
    final decoded = TransactionDto.fromJson(json).toDomain();

    expect(decoded, transaction);
  });

  test('TransactionPageDto : round-trip fromJson/toJson et toDomain', () {
    final page = TransactionPage(
      items: [
        Transaction(
          id: 't1',
          type: TransactionType.withdrawal,
          label: 'Retrait agence',
          amount: 20000,
          date: DateTime.utc(2026, 1, 10),
        ),
      ],
      page: 1,
      pageSize: 10,
      totalCount: 1,
    );
    final json = TransactionPageDto.fromDomain(page).toJson();
    final decoded = TransactionPageDto.fromJson(json).toDomain();

    expect(decoded, page);
  });

  test('RegistrationDataDto : round-trip fromJson/toJson et toDomain', () {
    const data = RegistrationData(
      firstName: 'Awa',
      lastName: 'Diallo',
      phoneNumber: '701234567',
      numPiece: '1234567890',
    );
    final json = RegistrationDataDto.fromDomain(data).toJson();
    final decoded = RegistrationDataDto.fromJson(json).toDomain();

    expect(decoded, data);
  });
}
