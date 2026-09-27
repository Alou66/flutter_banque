/// Messages d'erreur et de succès standardisés pour l'interface utilisateur.
/// Centralise la traduction des erreurs techniques en messages utilisateurs clairs.
abstract class AppErrorMessages {
  // --- Messages de succès ---
  static const String paymentSuccess = 'Paiement effectué avec succès.';
  static const String depositSuccess = 'Dépôt effectué avec succès.';
  static const String withdrawSuccess = 'Retrait effectué avec succès.';
  static const String loginSuccess = 'Connexion réussie.';
  static const String pinVerified = 'PIN vérifié avec succès.';
  static const String pinChanged = 'PIN modifié avec succès.';
  static const String profileUpdated = 'Profil mis à jour avec succès.';
  static const String accountCreated = 'Compte créé avec succès.';

  // --- Messages d'erreur ---
  static const String insufficientBalance =
      'Solde insuffisant pour effectuer cette opération.';
  static const String invalidPin =
      'Code PIN incorrect. Veuillez réessayer.';
  static const String accountNotFound =
      'Aucun compte bancaire associé à ce numéro de téléphone.';
  static const String userNotConnected =
      'Utilisateur non connecté. Veuillez vous reconnecter.';
  static const String invalidAmount =
      'Le montant doit être supérieur à zéro.';
  static const String networkError =
      'Impossible de contacter le serveur. Vérifiez votre connexion.';
  static const String timeoutError =
      'Le serveur met trop de temps à répondre. Réessayez plus tard.';
  static const String unexpectedError =
      'Une erreur inattendue est survenue. Réessayez plus tard.';
  static const String validationError =
      'Veuillez corriger les erreurs dans le formulaire.';

  // --- Messages d'erreur par contexte ---
  static String paymentError(String? reason) {
    if (reason == null || reason.isEmpty) {
      return 'Le paiement a échoué. Réessayez.';
    }
    return 'Le paiement a échoué : $reason';
  }

  static String withdrawError(String? reason) {
    if (reason == null || reason.isEmpty) {
      return 'Le retrait a échoué. Réessayez.';
    }
    return 'Le retrait a échoué : $reason';
  }

  static String depositError(String? reason) {
    if (reason == null || reason.isEmpty) {
      return 'Le dépôt a échoué. Réessayez.';
    }
    return 'Le dépôt a échoué : $reason';
  }

  static String loginError(String? reason) {
    if (reason == null || reason.isEmpty) {
      return 'La connexion a échoué. Vérifiez vos identifiants.';
    }
    if (reason.toLowerCase().contains('pin') ||
        reason.toLowerCase().contains('telephone') ||
        reason.toLowerCase().contains('téléphone') ||
        reason.toLowerCase().contains('incorrect')) {
      return 'Numéro de téléphone ou PIN incorrect.';
    }
    return 'La connexion a échoué : $reason';
  }

  /// Traduit un message d'erreur du serveur en message utilisateur.
  static String translateError(String? errorMessage) {
    if (errorMessage == null || errorMessage.isEmpty) {
      return unexpectedError;
    }

    final lower = errorMessage.toLowerCase();

    if (lower.contains('solde') && lower.contains('insuffisant')) {
      return insufficientBalance;
    }
    if (lower.contains('pin') && lower.contains('incorrect')) {
      return invalidPin;
    }
    if (lower.contains('téléphone') || lower.contains('telephone')) {
      if (lower.contains('introuvable') || lower.contains('existe pas') ||
          lower.contains('n\'existe pas') || lower.contains('no account') ||
          lower.contains('compte introuvable')) {
        return accountNotFound;
      }
    }
    if (lower.contains('compte') && (lower.contains('introuvable') ||
        lower.contains('existe pas') || lower.contains('n\'existe pas'))) {
      return accountNotFound;
    }
    if (lower.contains('connexion') || lower.contains('connex')) {
      return networkError;
    }
    if (lower.contains('timeout') || lower.contains('délai') ||
        lower.contains('trop de temps')) {
      return timeoutError;
    }
    if (lower.contains('réseau') || lower.contains('réseau') ||
        lower.contains('network') || lower.contains('impossible de contacter')) {
      return networkError;
    }

    return errorMessage;
  }
}