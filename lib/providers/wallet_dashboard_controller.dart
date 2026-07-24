import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/errors/app_exception.dart';
import '../models/transaction.dart';
import '../models/wallet.dart';
import 'session_controller.dart';
import 'wallet_providers.dart';

/// Agrégat des données affichées par le Dashboard Wallet.
class WalletDashboardData extends Equatable {
  const WalletDashboardData({required this.wallet, required this.transactions});

  final Wallet wallet;
  final List<Transaction> transactions;

  @override
  List<Object?> get props => [wallet, transactions];
}

/// Charge le wallet et les 5 dernières transactions de l'utilisateur connecté.
class WalletDashboardController extends AsyncNotifier<WalletDashboardData> {
  @override
  Future<WalletDashboardData> build() async {
    final user = ref.watch(sessionControllerProvider);
    if (user == null) {
      throw const AppException('Utilisateur non connecté.');
    }

    final repository = ref.read(walletRepositoryProvider);
    final wallet = await repository.fetchWallet(user.id);
    final transactions =
        await repository.fetchRecentTransactions(user.id, limit: 5);

    return WalletDashboardData(wallet: wallet, transactions: transactions);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

final walletDashboardControllerProvider =
    AsyncNotifierProvider<WalletDashboardController, WalletDashboardData>(
  WalletDashboardController.new,
);
