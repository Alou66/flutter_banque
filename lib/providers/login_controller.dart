import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/auth_user.dart';
import 'auth_providers.dart';
import 'session_controller.dart';

/// Gère la soumission du formulaire de connexion (téléphone + PIN).
class LoginController extends AsyncNotifier<AuthUser?> {
  @override
  FutureOr<AuthUser?> build() => null;

  Future<void> login({
    required String phoneNumber,
    required String pin,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final session = await ref.read(authRepositoryProvider).login(
            phoneNumber: phoneNumber,
            pin: pin,
          );
      ref.read(sessionControllerProvider.notifier).setUser(session.user);
      ref.read(sessionTokenControllerProvider.notifier).issue(session.token);
      return session.user;
    });
  }

  void reset() => state = const AsyncData(null);
}

final loginControllerProvider =
    AsyncNotifierProvider<LoginController, AuthUser?>(LoginController.new);
