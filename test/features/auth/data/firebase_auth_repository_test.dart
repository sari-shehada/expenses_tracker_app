import 'package:expenses_tracker/features/auth/data/auth_client.dart';
import 'package:expenses_tracker/features/auth/data/firebase_auth_repository.dart';
import 'package:expenses_tracker/features/auth/domain/auth_exceptions.dart';
import 'package:expenses_tracker/features/auth/domain/auth_user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const clientUser = AuthClientUser(
    id: 'user-id',
    email: 'user@example.com',
    displayName: 'User',
    photoUrl: 'https://example.com/photo.png',
  );
  const authUser = AuthUser(
    id: 'user-id',
    email: 'user@example.com',
    displayName: 'User',
    photoUrl: 'https://example.com/photo.png',
  );

  test('maps Firebase client users into domain users', () {
    final client = _FakeAuthClient(authStates: Stream.value(clientUser));
    final repository = FirebaseAuthRepository(client: client);

    expect(repository.authStateChanges, emits(authUser));
  });

  test('preserves the signed-out auth state', () {
    final client = _FakeAuthClient(authStates: Stream.value(null));
    final repository = FirebaseAuthRepository(client: client);

    expect(repository.authStateChanges, emits(isNull));
  });

  test('rejects client users without an email', () {
    final client = _FakeAuthClient(
      authStates: Stream.value(
        const AuthClientUser(
          id: 'user-id',
          email: null,
          displayName: 'User',
          photoUrl: null,
        ),
      ),
    );
    final repository = FirebaseAuthRepository(client: client);

    expect(
      repository.authStateChanges,
      emitsError(isA<AuthUserMissingEmail>()),
    );
  });

  test('delegates Google sign-in and sign-out', () async {
    final client = _FakeAuthClient();
    final repository = FirebaseAuthRepository(client: client);

    await repository.signInWithGoogle();
    await repository.signOut();

    expect(client.googleSignInCalls, 1);
    expect(client.signOutCalls, 1);
  });

  test('maps client cancellation into a domain cancellation', () {
    final client = _FakeAuthClient(
      signInError: const AuthClientSignInCancelled(),
    );
    final repository = FirebaseAuthRepository(client: client);

    expect(repository.signInWithGoogle(), throwsA(isA<AuthSignInCancelled>()));
  });
}

class _FakeAuthClient implements AuthClient {
  _FakeAuthClient({Stream<AuthClientUser?>? authStates, this.signInError})
    : _authStates = authStates ?? const Stream.empty();

  final Stream<AuthClientUser?> _authStates;
  final Object? signInError;
  int googleSignInCalls = 0;
  int signOutCalls = 0;

  @override
  Stream<AuthClientUser?> get authStateChanges => _authStates;

  @override
  Future<void> signInWithGoogle() async {
    googleSignInCalls++;
    if (signInError case final error?) {
      throw error;
    }
  }

  @override
  Future<void> signOut() async {
    signOutCalls++;
  }
}
