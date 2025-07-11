![CI](https://github.com/PFE-Celian-Frasca/AthleteIQ-PFE/actions/workflows/ci_mobile.yml/badge.svg)

# AthleteIQ

**AthleteIQ** est une application mobile développée avec Flutter qui permet aux utilisateurs de suivre leurs performances sportives, de consulter leurs parcours d'entraînement, d’interagir via des groupes, et de partager leurs activités. L’application met l’accent sur l’ergonomie, la géolocalisation et la dimension communautaire. Tout cela, gratuitement.

---

## 🚀 Fonctionnalités principales

- Création de compte, connexion sécurisée (Firebase Auth)
- Parcours GPS personnalisés avec clustering sur Google Maps
- Messagerie de groupe et gestion des groupes d’utilisateurs
- Visualisation, modification et suivi de parcours enregistrés
- Design adaptatif, mode sombre, navigation fluide via GoRouter

---

## 🛠️ Technologies et outils

- **Flutter & Dart**
- **Firebase (Auth, Firestore, Storage, Messaging)**
- **Riverpod** (gestion d’état)
- **Google Maps SDK**
- **Freezed / JsonSerializable / Build Runner**

---

## 🧪 Tests et qualité logicielle

- **Tests unitaires** en cours d’intégration (répertoire `test/`)
- Gestion des erreurs via blocs try/catch
- Architecture modulaire pour garantir la maintenabilité
- Code commenté et structuré pour faciliter les évolutions

---

## 🧾 Documentation technique (Bloc 2.4.1)

### Structure du projet

- `lib/models/` : modèles de données (user, parcours, groupes)
- `lib/repository/` : interaction avec Firebase
- `lib/providers/` : logique métier (états utilisateur, parcours, préférences…)
- `lib/view/` : interfaces utilisateurs (screens modulaires)
- `lib/utils/` : fonctions diverses (conversion, maps, thèmes…)
- `lib/resources/` : composants UI personnalisés

### Sécurité et confidentialité

- Authentification Firebase
- Filtrage des données Firestore par UID
- Permissions Firebase Storage sécurisées
- Navigation restreinte selon l'état utilisateur (middleware GoRouter)

### Accessibilité

- UI responsive (MediaQuery)
- Thème sombre activable
- Tailles de texte adaptatives

### Déploiement

- Android & iOS (`flutter build apk` / `flutter build ios`)
- Configuration Firebase incluse (`firebase_options.dart`)
- Fichiers d’icônes et splash personnalisés (`flutter_native_splash`, `flutter_launcher_icons`)

### Mise à jour / maintenance

- Architecture orientée composant
- Utilisation de `build_runner` pour générer automatiquement les modèles
- Versionnage via Git + nommage de branches clair (ex : `feature/chat`, `fix/login-bug`)

---

## 📦 Installation rapide

```bash
git clone https://github.com/ton-repo/athleteiq.git
cd athleteiq
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```
---

## 👥 Auteurs
- **Célian Frasca** - Développeur
- Projet réalisé dans le cadre du PFE pour le titre **RNCP 39583**
