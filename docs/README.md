# Documentation technique — Banque (flutter_banque)

Documentation de l'application Flutter du microservice Banque (wallet). Le backend n'existe pas encore : toute l'app tourne sur un Mock Repository en mémoire, conçu dès le départ pour être remplacé par de vrais appels REST sans toucher aux écrans, providers ou contrôleurs.

## Sommaire

- [architecture.md](architecture.md) — schéma des couches (Clean Architecture) et rôle de chaque dossier
- [auth-flow.md](auth-flow.md) — flux d'authentification (inscription, connexion, profil, PIN, déconnexion)
- [transactions-flow.md](transactions-flow.md) — flux Wallet (dashboard, dépôt/retrait/paiement, historique)
- [api-endpoints.md](api-endpoints.md) — endpoints REST attendus par le frontend, avec formats de requête/réponse
- [mock-to-remote-migration.md](mock-to-remote-migration.md) — comment brancher le vrai backend

## État actuel

- `AppConfig.dataSourceMode` (`lib/config/app_config.dart`) vaut `mock` : toutes les données viennent de `AuthMockDataSource`/`WalletMockDataSource` (en mémoire, réinitialisées à chaque lancement).
- Compte de démonstration : téléphone `700000000`, PIN `1234`.
- L'infrastructure REST (`ApiClient`, interceptors, `RemoteDataSource`, DTO) existe déjà et compile, mais n'est jamais appelée tant que `dataSourceMode` reste `mock`.
