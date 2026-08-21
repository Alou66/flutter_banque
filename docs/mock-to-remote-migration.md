# Basculer du Mock vers le backend réel

L'app est branchée sur auth_api et banque1_api (voir [api-endpoints.md](api-endpoints.md) pour le contrat exact). Ce basculement ne touche **ni les écrans, ni les providers de contrôleurs métier (`*_controller.dart`), ni les repositories** — tout est déjà câblé dans `lib/data/remote/*` et `lib/models/dto/*`.

## 1. Lancer les deux backends

```bash
cd auth_api && ./mvnw spring-boot:run      # port 8081
cd banque1_api && ./mvnw spring-boot:run   # port 8080
```

Chaque service a besoin de son `application-secrets.yaml` (voir `application-secrets.yaml.example`) avec `DB_URL`/`DB_USERNAME`/`DB_PASSWORD` (Neon), et surtout `JWT_SECRET`/`INTERNAL_API_KEY` **strictement identiques entre les deux services**.

## 2. Renseigner les URLs du backend

Dans `lib/config/app_config.dart` (déjà pointées sur `localhost` par défaut) :

```dart
abstract class AppConfig {
  static const DataSourceMode dataSourceMode = DataSourceMode.mock; // → à changer en étape 3
  static const String authApiBaseUrl = 'http://localhost:8081/api';
  static const String banqueApiBaseUrl = 'http://localhost:8080/api';
  ...
}
```

- Émulateur Android : remplacer `localhost` par `10.0.2.2`.
- Appareil physique : remplacer par l'IP LAN de la machine qui exécute les backends.

## 3. Activer le mode Remote

Un seul changement :

```dart
static const DataSourceMode dataSourceMode = DataSourceMode.remote;
```

`lib/providers/auth_providers.dart` et `wallet_providers.dart` injectent alors `AuthRemoteDataSource`/`WalletRemoteDataSource` (au lieu de `AuthMockDataSource`/`WalletMockDataSource`) dans `AuthRepositoryImpl`/`WalletRepositoryImpl`, sans aucune autre modification.

## 4. Points d'attention spécifiques au vrai backend

- **JWT réel** : `SessionTokenController.issue(token)` reçoit le JWT renvoyé par `POST /auth/login` (transmis via `AuthSession`, voir `lib/models/auth_session.dart`). `AuthMockDataSource` continue de fabriquer un faux jeton en mode `mock`, pour que les deux implémentations restent interchangeables.
- **Écarts de contrat absorbés côté DTO** : devise, numéro de compte, libellé de transaction, recherche/tri/pagination de l'historique — voir la section « Écarts absorbés côté Flutter » de [api-endpoints.md](api-endpoints.md).
- **Timeouts réseau** : `AppConfig.connectTimeout`/`receiveTimeout` (10 s par défaut) sont à ajuster selon la latence réelle du backend.
- **Logs** : `LoggingInterceptor` écrit chaque requête/réponse via `dart:developer` — à désactiver ou filtrer en production si les payloads contiennent des données sensibles.
- **Erreurs réseau (hors ligne, timeout)** : déjà gérées par `ErrorInterceptor` → `ApiException` → `AppException`, remontées telles quelles jusqu'à l'UI (`ErrorStateView`, `SnackBar`). `OfflineStateView` (`lib/widgets/common/offline_state_view.dart`) existe comme état visuel dédié mais n'est pas encore déclenché automatiquement — à brancher si une détection de connectivité réelle est ajoutée.
- **Tests** : les tests d'intégration actuels (`test/*_test.dart`) pilotent l'app via le Mock (compte démo `700000000` / PIN `1234`, transactions seed). En mode `remote`, ils nécessitent soit un backend de test dédié, soit un mock du canal Dio (à l'image de `test/flutter_test_config.dart`, qui mocke déjà le canal natif `flutter_secure_storage`) — c'est pourquoi `dataSourceMode` reste `mock` dans le code committé.

## 5. Revenir au Mock si besoin

Remettre `dataSourceMode = DataSourceMode.mock` : aucune trace du backend réel ne reste dans l'état de l'app, puisque Mock et Remote sont deux implémentations strictement interchangeables du même contrat (`AuthDataSource`/`WalletDataSource`).
