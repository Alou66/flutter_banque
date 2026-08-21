# Documentation technique — Banque (flutter_banque)

Documentation de l'application Flutter du microservice Banque (wallet), branchée sur les backends réels `auth_api` et `banque1_api`. Mock et Remote restent deux implémentations strictement interchangeables du même contrat (`AuthDataSource`/`WalletDataSource`), sans impact sur les écrans, providers ou contrôleurs.

## Sommaire

- [architecture.md](architecture.md) — schéma des couches (Clean Architecture) et rôle de chaque dossier
- [auth-flow.md](auth-flow.md) — flux d'authentification (inscription, connexion, profil, PIN, déconnexion)
- [transactions-flow.md](transactions-flow.md) — flux Wallet (dashboard, dépôt/retrait/paiement, historique)
- [api-endpoints.md](api-endpoints.md) — contrat REST réel exposé par auth_api/banque1_api
- [mock-to-remote-migration.md](mock-to-remote-migration.md) — comment lancer les backends et basculer en mode remote

## État actuel

- `AppConfig.dataSourceMode` (`lib/config/app_config.dart`) reste `mock` dans le code committé : toutes les données viennent de `AuthMockDataSource`/`WalletMockDataSource` (en mémoire, réinitialisées à chaque lancement), et les tests d'intégration (`test/*_test.dart`) en dépendent.
- Compte de démonstration (mode mock) : téléphone `700000000`, PIN `1234`.
- L'infrastructure REST (`ApiClient`, interceptors, `RemoteDataSource`, DTO) est fonctionnelle contre les vrais backends (validé de bout en bout : inscription OTP, login, dépôt/retrait/paiement, profil, changement de PIN). Basculer `dataSourceMode` sur `remote` localement, backends lancés, pour l'utiliser (voir [mock-to-remote-migration.md](mock-to-remote-migration.md)).
