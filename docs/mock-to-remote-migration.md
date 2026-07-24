# Basculer du Mock vers le backend réel

L'app a été conçue pour que ce basculement ne touche **ni les écrans, ni les providers de contrôleurs métier (`*_controller.dart`), ni les repositories**. Voici ce qu'il faut réellement faire, dans l'ordre.

## 1. Renseigner l'URL du backend

Dans `lib/config/app_config.dart` :

```dart
abstract class AppConfig {
  static const DataSourceMode dataSourceMode = DataSourceMode.mock; // → à changer en étape 3
  static const String baseUrl = 'https://api.banque.example.com';  // → remplacer par l'URL réelle
  ...
}
```

## 2. Vérifier que le backend respecte le contrat attendu

Le backend doit exposer exactement les endpoints listés dans [api-endpoints.md](api-endpoints.md), avec :
- les mêmes formes de requête/réponse JSON (`AuthUserDto`, `WalletDto`, `TransactionDto`, `TransactionPageDto`) ;
- l'utilisateur identifié via le JWT (`Authorization: Bearer <token>`), jamais via un identifiant dans le corps de la requête ;
- les erreurs au format `{ "message": "..." }`.

Si le backend renvoie un JSON différent, adapter uniquement `lib/models/dto/*.dart` (méthodes `fromJson`/`toJson`) — ce sont les seuls fichiers qui connaissent la forme exacte du JSON. Les modèles de domaine (`lib/models/*.dart`, sans les DTO) et tout ce qui est au-dessus ne changent pas.

## 3. Activer le mode Remote

Un seul changement :

```dart
static const DataSourceMode dataSourceMode = DataSourceMode.remote;
```

À partir de là, `lib/providers/auth_providers.dart` et `wallet_providers.dart` injectent automatiquement `AuthRemoteDataSource`/`WalletRemoteDataSource` (au lieu de `AuthMockDataSource`/`WalletMockDataSource`) dans `AuthRepositoryImpl`/`WalletRepositoryImpl`, sans aucune autre modification :

```dart
final authDataSourceProvider = Provider<AuthDataSource>((ref) {
  return switch (AppConfig.dataSourceMode) {
    DataSourceMode.mock => AuthMockDataSource(),
    DataSourceMode.remote => AuthRemoteDataSource(ref.watch(apiClientProvider)),
  };
});
```

## 4. Points d'attention spécifiques au vrai backend

- **JWT réel** : `SessionTokenController.issue()` (`lib/providers/session_controller.dart`) génère aujourd'hui un jeton simulé (`mock.<userId>.<timestamp>`) à la connexion. Une fois le backend réel branché, le jeton doit venir de la réponse de `POST /auth/login` / `POST /auth/create-pin` (ajouter un champ `token` à `AuthUserDto` ou créer un DTO de réponse dédié, puis appeler `issue(realToken)` avec la valeur reçue au lieu d'en fabriquer une).
- **Timeouts réseau** : `AppConfig.connectTimeout`/`receiveTimeout` (10 s par défaut) sont à ajuster selon la latence réelle du backend.
- **Logs** : `LoggingInterceptor` écrit chaque requête/réponse via `dart:developer` — à désactiver ou filtrer en production si les payloads contiennent des données sensibles.
- **Erreurs réseau (hors ligne, timeout)** : déjà gérées par `ErrorInterceptor` → `ApiException` → `AppException`, remontées telles quelles jusqu'à l'UI (`ErrorStateView`, `SnackBar`). `OfflineStateView` (`lib/widgets/common/offline_state_view.dart`) existe comme état visuel dédié mais n'est pas encore déclenché automatiquement — à brancher si une détection de connectivité réelle est ajoutée.
- **Tests** : les tests d'intégration actuels (`test/*_test.dart`) pilotent l'app via le Mock (compte démo `700000000` / PIN `1234`, transactions seed). Une fois en mode `remote`, ils nécessitent soit un backend de test dédié, soit un mock du canal Dio (à l'image de `test/flutter_test_config.dart`, qui mocke déjà le canal natif `flutter_secure_storage`).

## 5. Revenir au Mock si besoin

Remettre `dataSourceMode = DataSourceMode.mock` : aucune trace du backend réel ne reste dans l'état de l'app, puisque Mock et Remote sont deux implémentations strictement interchangeables du même contrat (`AuthDataSource`/`WalletDataSource`).
