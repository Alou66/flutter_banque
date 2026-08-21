/// Validateurs de formulaires, centralisés pour éviter toute logique de
/// validation dans les widgets.
abstract class Validators {
  // Doit rester aligné avec le pattern serveur (CompteRequest/UpdateCompteRequest
  // dans banque1_api) : téléphone sénégalais à 9 chiffres, préfixe 70/77/78.
  static final _phoneRegExp = RegExp(r'^(70|77|78)\d{7}$');
  static final _pinRegExp = RegExp(r'^\d{4}$');
  static final _otpRegExp = RegExp(r'^\d{6}$');
  // Doit rester aligné avec CompteRequest.numPiece dans banque1_api.
  static final _numPieceRegExp = RegExp(r'^\d{10}$');

  static String? name(String? value) {
    if (value == null || value.trim().length < 2) {
      return 'Doit contenir au moins 2 caractères.';
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Le numéro de téléphone est requis.';
    }
    if (!_phoneRegExp.hasMatch(value.trim())) {
      return 'Numéro invalide (9 chiffres, commence par 70, 77 ou 78).';
    }
    return null;
  }

  static String? pin(String? value) {
    if (value == null || !_pinRegExp.hasMatch(value)) {
      return 'Le code PIN doit contenir 4 chiffres.';
    }
    return null;
  }

  static String? otp(String? value) {
    if (value == null || !_otpRegExp.hasMatch(value)) {
      return 'Le code doit contenir 6 chiffres.';
    }
    return null;
  }

  static String? numPiece(String? value) {
    if (value == null || !_numPieceRegExp.hasMatch(value.trim())) {
      return 'Le numéro de pièce doit contenir 10 chiffres.';
    }
    return null;
  }

  /// Valide un montant saisi. [maxAmount], quand fourni, borne la validation
  /// au solde disponible pour un retour immédiat sans appel réseau.
  static String? amount(String? value, {double? maxAmount}) {
    if (value == null || value.trim().isEmpty) {
      return 'Le montant est requis.';
    }
    final parsed = double.tryParse(value.trim().replaceAll(',', '.'));
    if (parsed == null || parsed <= 0) {
      return 'Montant invalide.';
    }
    if (maxAmount != null && parsed > maxAmount) {
      return 'Solde insuffisant.';
    }
    return null;
  }
}
