sealed class AuthenticationEvent {
  const AuthenticationEvent();
}

final class AuthenticationSubscriptionRequested extends AuthenticationEvent {
  const AuthenticationSubscriptionRequested();
}

final class GoogleSignInRequested extends AuthenticationEvent {
  const GoogleSignInRequested();
}

final class SignOutRequested extends AuthenticationEvent {
  const SignOutRequested();
}
