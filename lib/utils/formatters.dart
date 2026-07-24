import 'package:intl/intl.dart';

/// Formatte les montants et dates affichés dans l'application. Les patterns
/// utilisés sont purement numériques : aucune initialisation de locale n'est
/// nécessaire.
abstract class Formatters {
  static final _amountFormat =
      NumberFormat.currency(locale: 'en_US', symbol: '', decimalDigits: 0);
  static final _dateFormat = DateFormat('dd/MM/yyyy • HH:mm');

  static String amount(double value) => '${_amountFormat.format(value)} FCFA';

  static String date(DateTime value) => _dateFormat.format(value);
}
