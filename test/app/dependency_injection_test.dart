import 'package:expenses_tracker/app/dependency_injection.dart';
import 'package:expenses_tracker/features/auth/data/auth_client.dart';
import 'package:expenses_tracker/features/auth/domain/auth_repository.dart';
import 'package:expenses_tracker/features/auth/presentation/bloc/authentication_bloc.dart';
import 'package:expenses_tracker/infrastructure/firebase/firebase_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

void main() {
  test('registers Firebase infrastructure', () {
    final locator = GetIt.asNewInstance();
    final client = _FakeFirebaseClient();
    final authClient = _FakeAuthClient();

    configureDependencies(
      locator: locator,
      firebaseClient: client,
      authClient: authClient,
    );

    expect(locator<FirebaseClient>(), same(client));
    expect(locator<AuthClient>(), same(authClient));
    expect(locator<AuthRepository>(), isA<AuthRepository>());
    expect(locator<AuthenticationBloc>(), isA<AuthenticationBloc>());
  });
}

class _FakeAuthClient implements AuthClient {
  @override
  Stream<AuthClientUser?> get authStateChanges => const Stream.empty();

  @override
  Future<void> signInWithGoogle() async {}

  @override
  Future<void> signOut() async {}
}

class _FakeFirebaseClient implements FirebaseClient {
  @override
  Future<void> initialize() async {}
}
