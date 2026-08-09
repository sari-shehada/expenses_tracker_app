import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:expenses_tracker/features/auth/domain/auth_exceptions.dart';
import 'package:expenses_tracker/features/auth/domain/auth_repository.dart';
import 'package:expenses_tracker/features/auth/domain/auth_user.dart';
import 'package:expenses_tracker/features/auth/presentation/bloc/authentication_bloc.dart';
import 'package:expenses_tracker/features/auth/presentation/bloc/authentication_event.dart';
import 'package:expenses_tracker/features/auth/presentation/bloc/authentication_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const user = AuthUser(
    id: 'user-id',
    email: 'user@example.com',
    displayName: 'User',
    photoUrl: null,
  );

  late _FakeAuthRepository repository;

  blocTest<AuthenticationBloc, AuthenticationState>(
    'emits auth states from the repository subscription',
    build: () {
      repository = _FakeAuthRepository();
      addTearDown(repository.dispose);
      return AuthenticationBloc(repository: repository);
    },
    act: (bloc) async {
      bloc.add(const AuthenticationSubscriptionRequested());
      await Future<void>.delayed(Duration.zero);
      repository.emit(null);
      repository.emit(user);
    },
    expect: () => [
      isA<Unauthenticated>(),
      isA<Authenticated>().having((state) => state.user, 'user', user),
    ],
  );

  blocTest<AuthenticationBloc, AuthenticationState>(
    'returns to unauthenticated when Google sign-in is cancelled',
    build: () {
      repository = _FakeAuthRepository(
        signInError: const AuthSignInCancelled(),
      );
      addTearDown(repository.dispose);
      return AuthenticationBloc(repository: repository);
    },
    act: (bloc) => bloc.add(const GoogleSignInRequested()),
    expect: () => [isA<AuthenticationInProgress>(), isA<Unauthenticated>()],
  );

  blocTest<AuthenticationBloc, AuthenticationState>(
    'reports a Google sign-in failure',
    build: () {
      repository = _FakeAuthRepository(signInError: Exception('failed'));
      addTearDown(repository.dispose);
      return AuthenticationBloc(repository: repository);
    },
    act: (bloc) => bloc.add(const GoogleSignInRequested()),
    expect: () => [
      isA<AuthenticationInProgress>(),
      isA<AuthenticationFailure>().having(
        (state) => state.reason,
        'reason',
        AuthenticationFailureReason.unknown,
      ),
    ],
  );

  blocTest<AuthenticationBloc, AuthenticationState>(
    'reports that the network is unavailable during Google sign-in',
    build: () {
      repository = _FakeAuthRepository(
        signInError: const AuthNetworkUnavailable(),
      );
      addTearDown(repository.dispose);
      return AuthenticationBloc(repository: repository);
    },
    act: (bloc) => bloc.add(const GoogleSignInRequested()),
    expect: () => [
      isA<AuthenticationInProgress>(),
      isA<AuthenticationFailure>().having(
        (state) => state.reason,
        'reason',
        AuthenticationFailureReason.networkUnavailable,
      ),
    ],
  );

  blocTest<AuthenticationBloc, AuthenticationState>(
    'delegates sign out',
    build: () {
      repository = _FakeAuthRepository();
      addTearDown(repository.dispose);
      return AuthenticationBloc(repository: repository);
    },
    act: (bloc) => bloc.add(const SignOutRequested()),
    expect: () => [isA<AuthenticationInProgress>()],
    verify: (_) => expect(repository.signOutCalls, 1),
  );
}

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({this.signInError});

  final _controller = StreamController<AuthUser?>.broadcast();
  final Object? signInError;
  int signOutCalls = 0;

  @override
  Stream<AuthUser?> get authStateChanges => _controller.stream;

  void emit(AuthUser? user) => _controller.add(user);

  Future<void> dispose() => _controller.close();

  @override
  Future<void> signInWithGoogle() async {
    if (signInError case final error?) {
      throw error;
    }
  }

  @override
  Future<void> signOut() async {
    signOutCalls++;
  }
}
