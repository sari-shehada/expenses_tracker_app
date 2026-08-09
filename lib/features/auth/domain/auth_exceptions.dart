sealed class AuthException implements Exception {
  const AuthException();
}

final class AuthSignInCancelled extends AuthException {
  const AuthSignInCancelled();
}

final class AuthUserMissingEmail extends AuthException {
  const AuthUserMissingEmail();
}
