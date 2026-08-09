import 'auth_user.dart';

abstract interface class AuthRepository {
  Stream<AuthUser?> get authStateChanges;

  Future<void> signInWithGoogle();

  Future<void> signOut();
}
