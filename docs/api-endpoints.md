# Endpoints REST attendus

Chemins centralisés dans `lib/core/network/api_endpoints.dart`. Base URL configurée dans `AppConfig.baseUrl` (`lib/config/app_config.dart` — actuellement un placeholder, à remplacer par l'URL réelle du backend). Toutes les requêtes portent un header `Authorization: Bearer <jwt>` dès qu'une session existe (ajouté automatiquement par `AuthInterceptor`) ; les endpoints marqués **Auth requise** en dépendent pour identifier l'utilisateur côté serveur — **aucun ne reçoit d'identifiant utilisateur dans le corps de la requête**, le backend doit le déduire du JWT.

## Authentification

| Méthode | Endpoint | Auth requise | Corps de la requête | Réponse 2xx |
|---|---|---|---|---|
| POST | `/auth/login` | Non | `{ "phoneNumber": string, "pin": string }` | `AuthUserDto` |
| POST | `/auth/register` | Non | `{ "firstName": string, "lastName": string, "phoneNumber": string }` | 2xx vide (déclenche l'envoi d'un OTP côté backend) |
| POST | `/auth/verify-otp` | Non | `{ "phoneNumber": string, "otp": string }` | 2xx vide |
| POST | `/auth/create-pin` | Non | `{ "firstName": string, "lastName": string, "phoneNumber": string, "pin": string }` | `AuthUserDto` |
| POST | `/auth/verify-pin` | Oui | `{ "phoneNumber": string, "pin": string }` | 2xx vide |
| GET | `/profile` | Oui | — | `AuthUserDto` |
| PUT | `/profile` | Oui | `{ "firstName": string, "lastName": string, "phoneNumber": string }` | `AuthUserDto` mis à jour |
| POST | `/profile/change-pin` | Oui | `{ "currentPin": string, "newPin": string }` | 2xx vide |

`AuthUserDto` :

```json
{
  "id": "700000000",
  "firstName": "Alassane",
  "lastName": "Diallo",
  "phoneNumber": "700000000"
}
```

## Wallet

| Méthode | Endpoint | Auth requise | Corps / Query | Réponse 2xx |
|---|---|---|---|---|
| GET | `/wallet` | Oui | — | `WalletDto` |
| GET | `/wallet/transactions` | Oui | Query : `limit` **ou** `type`, `q`, `sortBy`, `sortOrder`, `page`, `pageSize` (voir ci-dessous) | `List<TransactionDto>` (avec `limit`) ou `TransactionPageDto` (avec pagination) |
| POST | `/wallet/deposit` | Oui | `{ "amount": number }` | `TransactionDto` |
| POST | `/wallet/withdraw` | Oui | `{ "amount": number }` | `TransactionDto` |
| POST | `/wallet/payment` | Oui | `{ "amount": number, "label": string }` | `TransactionDto` |

`GET /wallet/transactions` sert deux usages avec les mêmes chemins mais des paramètres différents :
- **Aperçu Dashboard** (5 dernières) : `?limit=5` → tableau simple de `TransactionDto`.
- **Historique complet** (recherche/filtre/tri/pagination) : `?type=deposit&q=canal&sortBy=date&sortOrder=desc&page=1&pageSize=10` → `TransactionPageDto`. `type` omis = tous types ; `q` omis/vide = pas de recherche texte. `sortBy` ∈ `date|amount|type`, `sortOrder` ∈ `asc|desc`.

`WalletDto` :

```json
{ "balance": 250000.0, "currency": "FCFA", "accountNumber": "700000000" }
```

`TransactionDto` (`type` ∈ `deposit|withdrawal|payment`, `date` en ISO 8601) :

```json
{
  "id": "t1",
  "type": "deposit",
  "label": "Dépôt Orange Money",
  "amount": 50000.0,
  "date": "2026-07-20T11:00:00.000Z"
}
```

`TransactionPageDto` :

```json
{
  "items": [ /* TransactionDto[] */ ],
  "page": 1,
  "pageSize": 10,
  "totalCount": 6
}
```

## Format d'erreur attendu

`ErrorInterceptor` (`lib/core/network/interceptors/error_interceptor.dart`) lit `response.data["message"]` pour toute réponse HTTP en erreur (4xx/5xx) et l'affiche telle quelle à l'utilisateur. Le backend doit donc répondre :

```json
{ "message": "Code PIN incorrect." }
```

Sans ce champ, un message générique (« Erreur serveur (`<code>`). ») est utilisé à la place — fonctionnel, mais moins parlant pour l'utilisateur.
