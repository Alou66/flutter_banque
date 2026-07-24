import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/errors/app_exception.dart';
import 'auth_providers.dart';
import 'profile_controller.dart';
import 'session_controller.dart';

/// Gère la soumission du formulaire de modification du profil.
class EditProfileController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<bool> submit({
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final session = ref.read(sessionControllerProvider);
      if (session == null) {
        throw const AppException('Utilisateur non connecté.');
      }

      final updated = await ref.read(authRepositoryProvider).updateProfile(
            currentPhoneNumber: session.phoneNumber,
            firstName: firstName,
            lastName: lastName,
            phoneNumber: phoneNumber,
          );
      ref.read(sessionControllerProvider.notifier).setUser(updated);
      await ref.read(profileControllerProvider.notifier).refresh();
    });

    return !state.hasError;
  }
}

final editProfileControllerProvider =
    AsyncNotifierProvider<EditProfileController, void>(
  EditProfileController.new,
);
