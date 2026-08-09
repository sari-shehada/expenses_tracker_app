import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/auth_exceptions.dart';
import '../../domain/auth_repository.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({required this.repository})
    : super(const AuthenticationUnknown()) {
    on<AuthenticationSubscriptionRequested>(_onSubscriptionRequested);
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
    on<SignOutRequested>(_onSignOutRequested);
  }

  final AuthRepository repository;

  Future<void> _onSubscriptionRequested(
    AuthenticationSubscriptionRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    await emit.forEach(
      repository.authStateChanges,
      onData: (user) =>
          user == null ? const Unauthenticated() : Authenticated(user),
      onError: (error, stackTrace) => const AuthenticationFailure(),
    );
  }

  Future<void> _onGoogleSignInRequested(
    GoogleSignInRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(const AuthenticationInProgress());
    try {
      await repository.signInWithGoogle();
    } on AuthSignInCancelled {
      emit(const Unauthenticated());
    } catch (_) {
      emit(const AuthenticationFailure());
    }
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(const AuthenticationInProgress());
    try {
      await repository.signOut();
    } catch (_) {
      emit(const AuthenticationFailure());
    }
  }
}
