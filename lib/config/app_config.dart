/// Origine des données consommées par les repositories.
enum DataSourceMode { mock, remote }

/// Configuration globale de l'app. [dataSourceMode] est le seul point à
/// changer le jour où le backend est disponible.
abstract class AppConfig {
  static const DataSourceMode dataSourceMode = DataSourceMode.mock;

  static const String baseUrl = 'https://api.banque.example.com';

  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);
}
