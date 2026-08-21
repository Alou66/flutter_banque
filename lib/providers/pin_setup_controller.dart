import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/auth_user.dart';
import '../models/registration_data.dart';
import 'auth_providers.dart';
import 'session_controller.dart';

/// Gère la création du PIN finalisant l'inscription et connecte l'utilisateur.
class PinSetupController extends AsyncNotifier<AuthUser?> {
  @override
  FutureOr<AuthUser?> build() => null;

  Future<void> createPin({
    required RegistrationData data,
    required String pin,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final session =
          await ref.read(authRepositoryProvider).createPin(data: data, pin: pin);
      ref.read(sessionControllerProvider.notifier).setUser(session.user);
      ref.read(sessionTokenControllerProvider.notifier).issue(session.token);
      return session.user;
    });
  }
}

final pinSetupControllerProvider =
    AsyncNotifierProvider<PinSetupController, AuthUser?>(
  PinSetupController.new,
);
