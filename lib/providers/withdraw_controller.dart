import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/errors/app_exception.dart';
import 'auth_providers.dart';
import 'session_controller.dart';
import 'wallet_dashboard_controller.dart';
import 'wallet_providers.dart';

/// Gère la soumission d'un retrait : vérifie le PIN puis débite le wallet,
/// et rafraîchit le Dashboard en cas de succès.
class WithdrawController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<bool> submit({required double amount, required String pin}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final user = ref.read(sessionControllerProvider);
      if (user == null) throw const AppException('Utilisateur non connecté.');

      await ref.read(authRepositoryProvider).verifyPin(
            phoneNumber: user.phoneNumber,
            pin: pin,
          );
      await ref.read(walletRepositoryProvider).withdraw(
            userId: user.id,
            amount: amount,
          );
      // Le Dashboard doit refléter le nouveau solde dès la fin de l'opération :
      // le rafraîchissement fait partie de l'état de chargement, pas une étape
      // silencieuse après coup.
      await ref.read(walletDashboardControllerProvider.notifier).refresh();
    });

    return !state.hasError;
  }
}

final withdrawControllerProvider =
    AsyncNotifierProvider<WithdrawController, void>(WithdrawController.new);
