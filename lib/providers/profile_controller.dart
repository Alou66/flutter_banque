import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/errors/app_exception.dart';
import '../models/auth_user.dart';
import 'auth_providers.dart';
import 'session_controller.dart';

/// Charge les informations à jour du profil de l'utilisateur connecté.
class ProfileController extends AsyncNotifier<AuthUser> {
  @override
  Future<AuthUser> build() async {
    final session = ref.watch(sessionControllerProvider);
    if (session == null) {
      throw const AppException('Utilisateur non connecté.');
    }
    return ref
        .read(authRepositoryProvider)
        .getProfile(phoneNumber: session.phoneNumber);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

final profileControllerProvider =
    AsyncNotifierProvider<ProfileController, AuthUser>(ProfileController.new);
