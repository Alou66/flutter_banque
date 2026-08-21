# Flux d'authentification

Tous les flux suivent le même chemin : `Screen → *Controller (AsyncNotifier) → AuthRepository → AuthDataSource (Mock ou Remote)`. `login` et `createPin` retournent un `AuthSession` (utilisateur + jeton) — banque1_api n'émettant de JWT qu'au login, jamais à la création de compte, `AuthRemoteDataSource.createPin` enchaîne un login juste après avoir créé le compte. Le Controller met ensuite à jour `SessionController` (utilisateur courant) et `SessionTokenController.issue(session.token)` (jeton JWT réel en mode remote, simulé par `AuthMockDataSource` en mode mock), persisté via `SessionStorageService`.

## 1. Inscription (Register → OTP → PIN)

Trois écrans, un seul `RegistrationData` (dont `numPiece`, obligatoire) transmis de proche en proche via les paramètres `extra` de GoRouter.

```mermaid
sequenceDiagram
    participant U as Utilisateur
    participant RS as RegisterScreen
    participant RC as RegisterController
    participant OS as OtpScreen
    participant OC as OtpController
    participant PS as PinSetupScreen
    participant PC as PinSetupController
    participant Repo as AuthRepository
    participant DS as AuthDataSource
    participant Sess as SessionController /\nSessionTokenController

    U->>RS: Prénom, Nom, Téléphone, N° pièce
    RS->>RC: submit(firstName, lastName, phoneNumber)
    RC->>Repo: register(...)
    Repo->>DS: register(...)
    Note right of DS: auth_api POST /auth/send-otp {telephone}
    DS-->>Repo: OK (ou AppException si numéro déjà utilisé)
    Repo-->>RC: OK
    RC-->>RS: succès
    RS->>OS: push('/otp', extra: RegistrationData)

    U->>OS: Code reçu (6 chiffres)
    OS->>OC: verify(phoneNumber, otp)
    OC->>Repo: verifyOtp(...)
    Repo->>DS: verifyOtp(...)
    Note right of DS: auth_api POST /auth/verify-otp
    DS-->>Repo: OK (ou AppException si code invalide)
    Repo-->>OC: OK
    OC-->>OS: succès
    OS->>PS: push('/pin-setup', extra: RegistrationData)

    U->>PS: Crée un PIN (4 chiffres), le confirme
    PS->>PC: createPin(data, pin)
    PC->>Repo: createPin(data, pin)
    Repo->>DS: createPin(data, pin)
    Note right of DS: banque1_api POST /comptes,\npuis auth_api POST /auth/login (JWT)
    DS-->>Repo: AuthSession
    Repo-->>PC: AuthSession
    PC->>Sess: setUser(session.user) + issue(session.token)
    PC-->>PS: succès
    PS->>PS: go('/home')
```

Un `redirect` GoRouter renvoie vers `/register` si `/otp` ou `/pin-setup` sont atteints sans `RegistrationData` (deep link direct, refresh navigateur web, etc.).

## 2. Connexion

```mermaid
sequenceDiagram
    participant U as Utilisateur
    participant LS as LoginScreen
    participant LC as LoginController
    participant Repo as AuthRepository
    participant DS as AuthDataSource
    participant Sess as SessionController /\nSessionTokenController

    U->>LS: Téléphone + PIN
    LS->>LC: login(phoneNumber, pin)
    LC->>Repo: login(phoneNumber, pin)
    Repo->>DS: login(phoneNumber, pin)
    Note right of DS: auth_api POST /auth/login
    DS-->>Repo: AuthSession (ou AppException : compte introuvable / PIN incorrect)
    Repo-->>LC: AuthSession
    LC->>Sess: setUser(session.user) + issue(session.token)
    LC-->>LS: succès
    LS->>LS: go('/home')
```

## 3. Gestion du profil (affichage, modification, changement de PIN, déconnexion)

```mermaid
sequenceDiagram
    participant PS as ProfileScreen
    participant PCt as ProfileController
    participant EPS as EditProfileScreen
    participant EPC as EditProfileController
    participant CPS as ChangePinScreen
    participant CPC as ChangePinController
    participant Repo as AuthRepository
    participant DS as AuthDataSource
    participant Sess as SessionController /\nSessionTokenController

    PS->>PCt: build() → getProfile(phoneNumber: session.phoneNumber)
    PCt->>Repo: getProfile(...)
    Repo->>DS: getProfile(...)
    Note right of DS: banque1_api GET /comptes/me
    DS-->>PCt: AuthUser
    PCt-->>PS: Loading → Success(AuthUser) / Error

    PS->>EPS: push('/profile/edit')
    EPS->>EPC: submit(firstName, lastName, phoneNumber)
    EPC->>Repo: updateProfile(currentPhoneNumber, ...)
    Repo->>DS: updateProfile(...)
    Note right of DS: banque1_api PUT /comptes
    DS-->>EPC: AuthUser mis à jour
    EPC->>Sess: setUser(updated)
    EPC->>PCt: refresh()
    EPC-->>EPS: succès → retour Profil

    PS->>CPS: push('/profile/change-pin')
    CPS->>CPC: submit(currentPin, newPin)
    CPC->>Repo: changePin(phoneNumber, currentPin, newPin)
    Repo->>DS: changePin(...)
    Note right of DS: banque1_api POST /comptes/change-pin
    DS-->>CPC: OK (ou AppException si ancien PIN incorrect)
    CPC-->>CPS: succès → retour Profil

    PS->>Sess: clear() [session + jeton]
    PS->>PS: go('/login')
```

`ChangePinScreen` vérifie l'ancien PIN **côté DataSource**, jamais côté UI — le formulaire ne fait qu'enchaîner 3 saisies de 4 chiffres (ancien, nouveau, confirmation) avant d'appeler `submit`.

## 4. Re-vérification du PIN avant une opération sensible

`WithdrawController` et `PaymentController` appellent `AuthRepository.verifyPin(phoneNumber, pin)` avant respectivement le retrait et le paiement, comme confirmation supplémentaire. Côté remote, ceci appelle `banque1_api POST /comptes/verify-pin` (JWT + PIN), qui réutilise `CompteHelper.verifierPin` — la même logique que `POST /transactions/paiement-externe` (paiement initié par gestion_service_api) et l'authentification au login.
