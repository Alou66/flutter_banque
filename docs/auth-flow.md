# Flux d'authentification

Tous les flux suivent le même chemin : `Screen → *Controller (AsyncNotifier) → AuthRepository → AuthDataSource (Mock ou Remote)`. En cas de succès qui établit une session, le Controller met à jour `SessionController` (utilisateur courant) et `SessionTokenController` (jeton JWT simulé, persisté via `SessionStorageService`).

## 1. Inscription (Register → OTP → PIN)

Trois écrans, un seul `RegistrationData` transmis de proche en proche via les paramètres `extra` de GoRouter.

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

    U->>RS: Prénom, Nom, Téléphone
    RS->>RC: submit(firstName, lastName, phoneNumber)
    RC->>Repo: register(...)
    Repo->>DS: register(...)
    DS-->>Repo: OK (ou AppException si numéro déjà utilisé)
    Repo-->>RC: OK
    RC-->>RS: succès
    RS->>OS: push('/otp', extra: RegistrationData)

    U->>OS: Code reçu (6 chiffres)
    OS->>OC: verify(phoneNumber, otp)
    OC->>Repo: verifyOtp(...)
    Repo->>DS: verifyOtp(...)
    DS-->>Repo: OK (ou AppException si code invalide)
    Repo-->>OC: OK
    OC-->>OS: succès
    OS->>PS: push('/pin-setup', extra: RegistrationData)

    U->>PS: Crée un PIN (4 chiffres), le confirme
    PS->>PC: createPin(data, pin)
    PC->>Repo: createPin(data, pin)
    Repo->>DS: createPin(data, pin)
    DS-->>Repo: AuthUser
    Repo-->>PC: AuthUser
    PC->>Sess: setUser(user) + issue(user.id)
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
    DS-->>Repo: AuthUser (ou AppException : compte introuvable / PIN incorrect)
    Repo-->>LC: AuthUser
    LC->>Sess: setUser(user) + issue(user.id)
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
    DS-->>PCt: AuthUser
    PCt-->>PS: Loading → Success(AuthUser) / Error

    PS->>EPS: push('/profile/edit')
    EPS->>EPC: submit(firstName, lastName, phoneNumber)
    EPC->>Repo: updateProfile(currentPhoneNumber, ...)
    Repo->>DS: updateProfile(...)
    DS-->>EPC: AuthUser mis à jour
    EPC->>Sess: setUser(updated)
    EPC->>PCt: refresh()
    EPC-->>EPS: succès → retour Profil

    PS->>CPS: push('/profile/change-pin')
    CPS->>CPC: submit(currentPin, newPin)
    CPC->>Repo: changePin(phoneNumber, currentPin, newPin)
    Repo->>DS: changePin(...)
    DS-->>CPC: OK (ou AppException si ancien PIN incorrect)
    CPC-->>CPS: succès → retour Profil

    PS->>Sess: clear() [session + jeton]
    PS->>PS: go('/login')
```

`ChangePinScreen` vérifie l'ancien PIN **côté DataSource**, jamais côté UI — le formulaire ne fait qu'enchaîner 3 saisies de 4 chiffres (ancien, nouveau, confirmation) avant d'appeler `submit`.
