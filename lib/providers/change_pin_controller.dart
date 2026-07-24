import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/errors/app_exception.dart';
import 'auth_providers.dart';
import 'session_controller.dart';

/// Gère le changement de PIN ; l'ancien code est vérifié par le data source,
/// sans logique de validation dupliquée côté UI.
class ChangePinController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<bool> submit({
    required String currentPin,
    required String newPin,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final session = ref.read(sessionControllerProvider);
      if (session == null) {
        throw const AppException('Utilisateur non connecté.');
      }

      await ref.read(authRepositoryProvider).changePin(
            phoneNumber: session.phoneNumber,
            currentPin: currentPin,
            newPin: newPin,
          );
    });

    return !state.hasError;
  }
}

final changePinControllerProvider =
    AsyncNotifierProvider<ChangePinController, void>(ChangePinController.new);
