class AuthClientUser {
  const AuthClientUser({
    required this.id,
    required this.email,
    required this.displayName,
    required this.photoUrl,
  });

  final String id;
  final String? email;
  final String? displayName;
  final String? photoUrl;
}

final class AuthClientSignInCancelled implements Exception {
  const AuthClientSignInCancelled();
}

abstract interface class AuthClient {
  Stream<AuthClientUser?> get authStateChanges;

  Future<void> signInWithGoogle();

  Future<void> signOut();
}
