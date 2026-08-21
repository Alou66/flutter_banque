# Flux Wallet (transactions)

Même principe que l'authentification : `Screen → *Controller (AsyncNotifier) → WalletRepository → WalletDataSource (Mock ou Remote)`. Les opérations qui débitent/créditent (`Dépôt`, `Retrait`, `Paiement`) revérifient toujours le PIN côté serveur (`AuthRepository.verifyPin`) avant de toucher au solde — jamais de confiance dans une vérification faite uniquement côté UI.

## 1. Chargement du Dashboard

```mermaid
sequenceDiagram
    participant WDS as WalletDashboardScreen
    participant WDC as WalletDashboardController
    participant Sess as SessionController
    participant Repo as WalletRepository
    participant DS as WalletDataSource

    WDS->>WDC: watch (build)
    WDC->>Sess: lit l'utilisateur connecté
    WDC->>Repo: fetchWallet(user.id)
    Repo->>DS: fetchWallet(user.id)
    DS-->>WDC: Wallet (solde, devise, n° compte)
    WDC->>Repo: fetchRecentTransactions(user.id, limit: 5)
    Repo->>DS: fetchRecentTransactions(...)
    DS-->>WDC: List<Transaction>
    WDC-->>WDS: Loading → Success(WalletDashboardData) / Error
    Note over WDS: Pull-to-refresh appelle WDC.refresh()
```

## 2. Dépôt / Retrait / Paiement

Les trois écrans suivent le même schéma ; Retrait et Paiement ajoutent la vérification de PIN. L'exemple ci-dessous est le Retrait (le plus complet) :

```mermaid
sequenceDiagram
    participant WS as WithdrawScreen
    participant WC as WithdrawController
    participant AuthRepo as AuthRepository
    participant WalletRepo as WalletRepository
    participant DS as WalletDataSource
    participant WDC as WalletDashboardController

    WS->>WC: submit(amount, pin)
    Note over WC: state = AsyncLoading (couvre tout le flux, y compris le refresh)
    WC->>AuthRepo: verifyPin(phoneNumber, pin)
    AuthRepo-->>WC: OK (ou AppException : PIN incorrect)
    WC->>WalletRepo: withdraw(userId, amount)
    WalletRepo->>DS: withdraw(userId, amount)
    DS-->>WC: Transaction (ou AppException : solde insuffisant / montant invalide)
    WC->>WDC: refresh()
    WDC-->>WC: Dashboard à jour
    WC-->>WS: succès → SnackBar + retour Dashboard
```

Dépôt : identique sans l'étape `verifyPin`. Paiement : identique au Retrait, avec un champ `label` (motif) en plus dans la requête.

**Détail important :** le rafraîchissement du Dashboard (`WDC.refresh()`) est appelé **à l'intérieur** du même bloc `AsyncValue.guard` que l'opération elle-même, pas après — sinon le bouton arrête de tourner avant que le nouveau solde soit affiché, ouvrant une fenêtre de double-soumission (bug réel corrigé à l'Étape 4, voir l'historique du projet).

## 3. Historique paginé (recherche, filtre, tri)

```mermaid
sequenceDiagram
    participant TS as TransactionsScreen
    participant TQC as TransactionQueryController
    participant THC as TransactionHistoryController
    participant Repo as WalletRepository
    participant DS as WalletDataSource

    TS->>TQC: setSearchText / setType / setSort (UI)
    TQC-->>THC: nouvelle TransactionQuery (watch) → page réinitialisée à 1
    THC->>Repo: fetchTransactions(userId, query)
    Repo->>DS: fetchTransactions(userId, query)
    DS-->>THC: TransactionPage(items, page, pageSize, totalCount)
    THC-->>TS: Loading → Success(TransactionHistoryState) / Error

    Note over TS: Scroll proche du bas
    TS->>THC: loadMore()
    THC->>Repo: fetchTransactions(userId, query.copyWithPage(page+1))
    Repo->>DS: fetchTransactions(...)
    DS-->>THC: page suivante
    THC-->>TS: liste étendue (hasMore recalculé)
```

`TransactionQuery` est modélisé comme les paramètres d'une requête REST (`type`, `q`, `sortBy`, `sortOrder`, `page`, `pageSize`), mais banque1_api ne les supporte pas côté serveur : `WalletRemoteDataSource` récupère la liste complète (`GET /transactions/me`) et applique filtre/tri/pagination côté client — voir « Écarts absorbés côté Flutter » dans [api-endpoints.md](api-endpoints.md). `TQC`/`THC` et les écrans n'en savent rien.
