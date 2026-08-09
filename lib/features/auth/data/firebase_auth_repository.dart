import '../domain/auth_exceptions.dart';
import '../domain/auth_repository.dart';
import '../domain/auth_user.dart';
import 'auth_client.dart';

class FirebaseAuthRepository implements AuthRepository {
  const FirebaseAuthRepository({required this.client});

  final AuthClient client;

  @override
  Stream<AuthUser?> get authStateChanges =>
      client.authStateChanges.map(_toAuthUser);

  @override
  Future<void> signInWithGoogle() async {
    try {
      await client.signInWithGoogle();
    } on AuthClientSignInCancelled {
      throw const AuthSignInCancelled();
    } on AuthClientNetworkUnavailable {
      throw const AuthNetworkUnavailable();
    }
  }

  @override
  Future<void> signOut() => client.signOut();

  AuthUser? _toAuthUser(AuthClientUser? user) {
    if (user == null) {
      return null;
    }

    final email = user.email;
    if (email == null || email.isEmpty) {
      throw const AuthUserMissingEmail();
    }

    return AuthUser(
      id: user.id,
      email: email,
      displayName: user.displayName,
      photoUrl: user.photoUrl,
    );
  }
}
