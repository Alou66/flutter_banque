/// Validateurs de formulaires, centralisés pour éviter toute logique de
/// validation dans les widgets.
abstract class Validators {
  static final _phoneRegExp = RegExp(r'^\d{8,15}$');
  static final _pinRegExp = RegExp(r'^\d{4}$');
  static final _otpRegExp = RegExp(r'^\d{6}$');

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
      return 'Numéro de téléphone invalide (8 à 15 chiffres).';
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
