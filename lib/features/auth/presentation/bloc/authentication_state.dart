import '../../domain/auth_user.dart';

sealed class AuthenticationState {
  const AuthenticationState();
}

final class AuthenticationUnknown extends AuthenticationState {
  const AuthenticationUnknown();
}

final class AuthenticationInProgress extends AuthenticationState {
  const AuthenticationInProgress();
}

final class Unauthenticated extends AuthenticationState {
  const Unauthenticated();
}

final class Authenticated extends AuthenticationState {
  const Authenticated(this.user);

  final AuthUser user;
}

final class AuthenticationFailure extends AuthenticationState {
  const AuthenticationFailure();
}
