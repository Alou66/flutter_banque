# Endpoints REST réels

Deux backends distincts, deux base URLs (`AppConfig.authApiBaseUrl` / `AppConfig.banqueApiBaseUrl`, `lib/config/app_config.dart`), chemins centralisés dans `lib/core/network/api_endpoints.dart` (`AuthEndpoints` / `BanqueEndpoints`). Toute requête authentifiée porte `Authorization: Bearer <jwt>` (ajouté par `AuthInterceptor`) ; le backend identifie l'utilisateur via `Authentication.getName()` (le téléphone, sujet du JWT) — jamais via un identifiant dans le corps de la requête.

Toute réponse 2xx est enveloppée en `{ success, message, data, ... }` ; `ApiClient.guardData` extrait automatiquement `data`, les DTO ne voient donc que son contenu. Toute réponse d'erreur (4xx/5xx) porte un champ `message` au niveau racine, lu par `ErrorInterceptor`.

## auth_api (port 8081) — OTP, login

| Méthode | Endpoint | Auth requise | Corps | `data` de la réponse |
|---|---|---|---|---|
| POST | `/api/auth/send-otp` | Non | `{ telephone }` | `{ message, expiresAt }` |
| POST | `/api/auth/verify-otp` | Non | `{ telephone, otp }` | `{ message, expiresAt }` |
| POST | `/api/auth/login` | Non | `{ telephone, pin }` | `{ token, telephone, nom, prenom, tokenExpiresAt }` |

`telephone` : 9 chiffres. `pin` : 4 à 6 chiffres côté auth_api (4 exactement côté compte, voir plus bas).

## banque1_api (port 8080) — comptes, transactions

| Méthode | Endpoint | Auth requise | Corps | `data` de la réponse |
|---|---|---|---|---|
| POST | `/api/comptes` | Non (OTP déjà vérifié requis) | `{ prenom, nom, telephone, pin, numPiece, adresse? }` | `CompteResponse` |
| GET | `/api/comptes/me` | Oui | — | `CompteResponse` |
| PUT | `/api/comptes` | Oui | `{ prenom, nom, telephone }` | `CompteResponse` à jour |
| POST | `/api/comptes/verify-pin` | Oui | `{ pin }` | — (401 si incorrect) |
| POST | `/api/comptes/change-pin` | Oui | `{ currentPin, newPin }` | — |
| GET | `/api/transactions/me` | Oui | — | `TransactionResponse[]` (liste complète, pas de filtre/tri/pagination serveur) |
| POST | `/api/transactions/depot` | Oui | `{ montant }` | `TransactionResponse` |
| POST | `/api/transactions/retrait` | Oui | `{ montant }` | `TransactionResponse` |
| POST | `/api/transactions/paiement` | Oui | `{ montant }` | `TransactionResponse` |

`telephone` : 9 chiffres, préfixe `70`, `77` ou `78`. `pin` : exactement 4 chiffres. `numPiece` : 10 chiffres, obligatoire à la création de compte. `montant` : entier (FCFA, pas de décimales).

`CompteResponse` :

```json
{ "id": 8, "solde": 50000, "dateCreation": "2026-08-21", "numPiece": "9988776655",
  "prenom": "Test", "nom": "User", "adresse": null, "telephone": "781318048", "actif": true }
```

`TransactionResponse` (`typeTransaction` ∈ `DEPOT|RETRAIT|PAIEMENT`, `dateTransaction` en `LocalDate`, pas de libellé stocké) :

```json
{ "id": 5, "montant": 50000, "typeTransaction": "DEPOT", "dateTransaction": "2026-08-21" }
```

## Écarts absorbés côté Flutter (documentés, pas des bugs)

- **Devise** : absente du backend, codée en dur `'FCFA'` côté client (`WalletDto`).
- **Numéro de compte** : pas de champ dédié, `WalletDto.accountNumber` = `telephone`.
- **Libellé de transaction** : absent du backend, dérivé du type (`"Dépôt"`, `"Retrait"`, `"Paiement"`) par `TransactionDto.fromJson` quand `label` n'est pas dans le JSON. Pour un paiement, le libellé saisi par l'utilisateur n'est affiché que pour la transaction fraîchement créée (retour immédiat de `WalletRemoteDataSource.pay`) — il n'est pas persisté, donc absent au prochain rechargement de l'historique.
- **Recherche/tri/pagination de l'historique** : aucun support serveur (`GET /transactions/me` renvoie tout). `WalletRemoteDataSource` applique `TransactionQuery` côté client sur la liste complète, pour que `TransactionQueryController` et les écrans n'aient rien à savoir de cette limitation.
- **JWT à l'inscription** : `POST /api/comptes` ne renvoie pas de jeton. `AuthRemoteDataSource.createPin` enchaîne un `POST /auth/login` juste après la création du compte pour obtenir un vrai JWT.
