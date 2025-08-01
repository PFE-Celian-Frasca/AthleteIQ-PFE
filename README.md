[![Mobile CI](https://github.com/PFE-Celian-Frasca/AthleteIQ-PFE/actions/workflows/ci-mobile.yml/badge.svg?branch=develop)](https://github.com/PFE-Celian-Frasca/AthleteIQ-PFE/actions/workflows/ci-mobile.yml)
[![codecov](https://codecov.io/github/PFE-Celian-Frasca/AthleteIQ-PFE/graph/badge.svg?token=HT88ENZM6O)](https://codecov.io/github/PFE-Celian-Frasca/AthleteIQ-PFE)

# Manuels – AthleteIQ (Bloc 2.4.1)
---

## 📘 Manuel de déploiement (MVP)

### 1) Pré‑requis
- **OS** : macOS / Windows / Linux
- **Flutter / Dart** : Flutter **3.32.0**, Dart **3.8.0**
- **Android** : Android Studio Narwhal 2025.1.1, SDK 34+
- **iOS** : Xcode (build local iOS post‑MVP)
- **Firebase** : accès aux projets `dev`, `staging`, `prod`
- **Secrets** : fichier `.env` (fourni séparément) et **GitHub Secrets** pour la CI

### 2) Clonage & configuration locale
```bash
git clone https://github.com/PFE-Celian-Frasca/AthleteIQ-PFE.git
cd AthleteIQ-PFE
echo "<contenu .env>" > .env          # clés Maps, IDs Firebase, etc.
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### 3) Lancer l’app en développement
```bash
flutter run    # sélectionner un émulateur/device Android ou iOS
```
> Au premier démarrage, autoriser la **localisation** « Pendant l’utilisation ».

### 4) Build release Android (local)
```bash
flutter build apk --release --obfuscate --split-debug-info=build/obf/
```
- APK : `build/app/outputs/flutter-apk/app-release.apk`
- Symboles d’obfuscation : `build/obf/` (pour déobfusquer les crashs : `flutter symbolize`).

### 5) Déploiement via CI/CD (production interne)
- **CI – GitHub Actions** : _analyse → tests → couverture (Codecov)_ à chaque PR.
- **CD Android** : sur **tag**/release, build **obfusqué** + **distribution** via **Firebase App Distribution** (groupe *testers*).

### 6) Installation testeurs (Firebase App Distribution)
1. Scanner le **QR‑code** partagé ou ouvrir l’URL de distribution.
2. Renseigner son **e‑mail** pour rejoindre le groupe test.
3. Télécharger et installer l’APK, puis lancer l’app.

---

## 👤 Manuel d’utilisation (MVP)

### Démarrer
1. **Créer un compte** (e‑mail / mot de passe) ou **se connecter**.
2. Arriver sur la page home. Navigation par onglets.

### Enregistrer une activité
1. Page **home** → bouton **Go**.
2. Accorder la **permission de localisation** si demandée.
3. L’activité s’enregistre (distance, durée, trace).
4. Appuyer sur **Stop** → affichage du **Résumé** (distance, durée, allure).
5. Remplissage des informations du parcours pour enregistrement
6. Validation via le bouton en bas à droite de la page

### Consulter l’historique
- Onglet **Profil** : la dernière session apparaît en premier.
- Appuyer sur une session → **détail** (métriques + tracé).

### Group de discussion
- Onglet **Chat** : les groupes de discussions déjà rejoint apparaissent ici.
- Appuyer sur la loupe en haut à droite : rechercher des amis et des groupes à rejoindre ou quitter
- Appuyer sur le "+" en bas pour créer un nouveau groupe

### Confidentialité & accessibilité
- **Paramètres → Confidentialité** : résumé des données traitées et préférences (consentements **opt‑in**, désactivés par défaut).
- UI : **contrastes suffisants**, libellés **lecteur d’écran** sur les écrans clés.


---

## 🔄 Manuel de mise à jour

### Branches & versionnage
- Flux Git : `feature/*` → PR vers `develop` → PR vers `staging` → PR vers `main`.
- **SemVer** : `MAJOR.MINOR.PATCH` (ex. `v0.3.1`). Les releases sont **taguées** sur `main`.

### Check‑list avant release
1. **CI verte** (analyse statique sans warning + tests OK, couverture publiée).
2. **Recette manuelle** du cahier sur la build bêta (parcours MVP).
3. **Notes de version** rédigées (features/fix visibles).

### Publier une bêta (Android)
1. Créer un **tag** (ex. `v0.3.0-beta`) sur `main`.
2. La CD génère l’APK **obfusqué** et le **distribue** aux testeurs (App Distribution).

### Promouvoir / rollback
- Promotion : tag sans suffixe (ex. `v0.3.0`).
- **Rollback** : re‑tag vers la version précédente puis relancer la CD.
- Les symboles d’obfuscation de chaque build sont conservés pour l’analyse de crashs.

---

## 🧰 Choix techniques (contexte RNCP)
- **Langage & framework** : **Flutter / Dart** pour Android & iOS (rendement natif, time‑to‑market court).
- **Backend managé** : **Firebase** (Auth, Firestore, Storage) – HTTPS par défaut, chiffrement au repos.
- **Gestion d’état** : **Riverpod** ; modèles **Freezed** (immutabilité, sérialisation).
- **Cartographie** : **Google Maps SDK**.
- **Qualité** : `flutter analyze` bloquant, **tests** (unit/widget) avec couverture publiée (Codecov).
- **CI/CD** : **GitHub Actions** + **Firebase App Distribution** ; build Android **obfusqué** (`--obfuscate --split-debug-info`).




## 👥 Auteurs
- **Célian Frasca** - Développeur
- Projet réalisé dans le cadre du PFE pour le titre **RNCP 39583**
