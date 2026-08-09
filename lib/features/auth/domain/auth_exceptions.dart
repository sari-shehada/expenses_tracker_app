sealed class AuthException implements Exception {
  const AuthException();
}

final class AuthSignInCancelled extends AuthException {
  const AuthSignInCancelled();
}

final class AuthNetworkUnavailable extends AuthException {
  const AuthNetworkUnavailable();
}

final class AuthUserMissingEmail extends AuthException {
  const AuthUserMissingEmail();
}
