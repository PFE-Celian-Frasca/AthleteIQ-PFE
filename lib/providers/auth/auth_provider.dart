import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../services/auth_service.dart';
import 'auth_state.dart';

final authProvider = StateNotifierProvider<AuthProvider, AuthState>((ref) {
  return AuthProvider(ref);
});

class AuthProvider extends StateNotifier<AuthState> {
  final Ref _ref;

  AuthProvider(this._ref) : super(const AuthState.initial()) {
    _subscribeToAuthChanges();
  }

  void _subscribeToAuthChanges() {
    _ref.read(authService).authStateChanges.listen((user) {
      state = user != null
          ? AuthState.authenticated(user)
          : const AuthState.unauthenticated();
    });
  }

  Future<void> signIn({required String email, required String password}) async {
    state = const AuthState.loading();
    try {
      await _ref.read(authService).signIn(email: email, password: password);
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<bool> signUp({required String email, required String password}) async {
    state = const AuthState.loading();
    try {
      await _ref.read(authService).signUp(email: email, password: password);
      return true;
    } catch (e) {
      state = AuthState.error(e.toString());
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _ref.read(authService).signOut();
      state = const AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _ref.read(authService).resetPassword(email);
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      await _ref.read(authService).sendEmailVerification();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> updateEmail(String newEmail) async {
    try {
      await _ref.read(authService).updateEmail(newEmail);
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      await _ref.read(authService).updatePassword(newPassword);
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> reauthenticate(String email, String password) async {
    try {
      await _ref.read(authService).reauthenticate(email, password);
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> deleteAccount() async {
    try {
      await _ref.read(authService).deleteAccount();
      state = const AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.error(e.toString());
      rethrow;
    }
  }
}
