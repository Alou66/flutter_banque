import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/auth_user.dart';
import '../services/session_storage_service.dart';

/// Détient l'utilisateur actuellement authentifié pour toute l'application.
class SessionController extends Notifier<AuthUser?> {
  @override
  AuthUser? build() => null;

  void setUser(AuthUser user) => state = user;

  void clear() => state = null;
}

final sessionControllerProvider =
    NotifierProvider<SessionController, AuthUser?>(SessionController.new);

/// Jeton de session (JWT, simulé tant que le backend n'existe pas). L'état
/// en mémoire piloté par l'app reste la source de vérité immédiate ; la
/// persistance via [SessionStorageService] est best-effort et non bloquante,
/// pour préparer la restauration de session sans changer la signature des
/// méthodes ci-dessous (aucun appelant n'a besoin de changer).
class SessionTokenController extends Notifier<String?> {
  @override
  String? build() => null;

  void issue(String userId) {
    final token = 'mock.$userId.${DateTime.now().millisecondsSinceEpoch}';
    state = token;
    unawaited(ref.read(sessionStorageServiceProvider).saveToken(token));
  }

  void clear() {
    state = null;
    unawaited(ref.read(sessionStorageServiceProvider).deleteToken());
  }
}

final sessionTokenControllerProvider =
    NotifierProvider<SessionTokenController, String?>(
  SessionTokenController.new,
);

final sessionStorageServiceProvider = Provider<SessionStorageService>((ref) {
  return SessionStorageService();
});
