/// Origine des données consommées par les repositories.
enum DataSourceMode { mock, remote }

/// Configuration globale de l'app. [dataSourceMode] est le point à changer
/// localement une fois auth_api et banque1_api lancés (voir
/// docs/mock-to-remote-migration.md). Reste à `mock` dans le code committé :
/// les tests d'intégration (`test/*_test.dart`) pilotent l'app via le Mock.
abstract class AppConfig {
  static const DataSourceMode dataSourceMode = DataSourceMode.remote;

  // auth_api (port 8081) : OTP, login, émission du JWT.
  // Émulateur Android : remplacer localhost par 10.0.2.2.
  // Appareil physique : remplacer par l'IP LAN de la machine qui exécute le backend.
  static const String authApiBaseUrl = 'http://localhost:8081/api';

  // banque1_api (port 8080) : comptes, transactions.
  static const String banqueApiBaseUrl = 'http://localhost:8080/api';

  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);
}
