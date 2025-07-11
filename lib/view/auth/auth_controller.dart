import 'package:athlete_iq/repository/auth/auth_repository.dart';
import 'package:athlete_iq/repository/user/user_repository.dart';
import 'package:athlete_iq/utils/internal_notification/internal_notification_service.dart';
import 'package:athlete_iq/models/user/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  bool build() => false; // Initial loading state

  Future<void> signIn({required String email, required String password}) async {
    state = true;
    try {
      await ref.read(authRepositoryProvider).signIn(email: email, password: password);
    } catch (e) {
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'invalid-credential':
            ref
                .read(internalNotificationProvider)
                .showErrorToast('Email ou mot de passe invalide.');
            break;
          case 'user-not-found':
            ref
                .read(internalNotificationProvider)
                .showErrorToast('Aucun utilisateur trouvé pour cet email.');
            break;
          case 'wrong-password':
            ref.read(internalNotificationProvider).showErrorToast('Mot de passe incorrect.');
            break;
          case 'user-disabled':
            ref
                .read(internalNotificationProvider)
                .showErrorToast('Cet utilisateur a été désactivé.');
            break;
          default:
            ref
                .read(internalNotificationProvider)
                .showErrorToast('Une erreur est survenue lors de la connexion.');
        }
      } else {
        ref.read(internalNotificationProvider).showErrorToast(e.toString());
      }
      rethrow;
    } finally {
      state = false;
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String pseudo,
    required String sex,
  }) async {
    state = true;
    try {
      // Vérifier si le pseudo existe déjà
      final pseudoExists = await ref.read(userRepositoryProvider).checkIfPseudoExist(pseudo);
      if (pseudoExists) {
        throw Exception('Ce pseudo est déjà pris.');
      }
      await ref.read(authRepositoryProvider).signUp(email: email, password: password);
      final user = ref.read(authRepositoryProvider).currentUser;
      if (user != null) {
        final newUser = UserModel(
          id: user.uid,
          pseudo: pseudo,
          email: email,
          sex: sex,
          createdAt: DateTime.now(),
        );
        await ref.read(userRepositoryProvider).createUser(newUser);
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'email-already-in-use':
            ref.read(internalNotificationProvider).showErrorToast('Cet email est déjà utilisé.');
            break;
          case 'invalid-email':
            ref.read(internalNotificationProvider).showErrorToast('Cet email est invalide.');
            break;
          case 'operation-not-allowed':
            ref.read(internalNotificationProvider).showErrorToast('L\'inscription est désactivée.');
            break;
          case 'weak-password':
            ref
                .read(internalNotificationProvider)
                .showErrorToast('Le mot de passe est trop faible.');
            break;
          default:
            ref
                .read(internalNotificationProvider)
                .showErrorToast(e.message ?? 'Une erreur est survenue lors de l\'inscription.');
        }
      } else {
        ref.read(internalNotificationProvider).showErrorToast(e.toString());
      }
      rethrow;
    } finally {
      state = false;
    }
  }

  Future<void> sendEmailVerification() async {
    state = true;
    try {
      await ref.read(authRepositoryProvider).sendEmailVerification();
    } catch (e) {
      ref.read(internalNotificationProvider).showErrorToast(e.toString());
      rethrow;
    } finally {
      state = false;
    }
  }
}
