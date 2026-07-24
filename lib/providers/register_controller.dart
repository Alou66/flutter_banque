import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_providers.dart';

/// Gère l'envoi du formulaire d'inscription (déclenche l'envoi de l'OTP).
class RegisterController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<bool> submit({
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).register(
            firstName: firstName,
            lastName: lastName,
            phoneNumber: phoneNumber,
          ),
    );
    return !state.hasError;
  }
}

final registerControllerProvider =
    AsyncNotifierProvider<RegisterController, void>(RegisterController.new);
