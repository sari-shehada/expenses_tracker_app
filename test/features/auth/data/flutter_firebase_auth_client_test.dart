import 'package:expenses_tracker/features/auth/data/auth_client.dart';
import 'package:expenses_tracker/features/auth/data/flutter_firebase_auth_client.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(_MockAuthCredential());
  });

  late FirebaseAuth firebaseAuth;
  late GoogleSignIn googleSignIn;
  late FlutterFirebaseAuthClient client;

  setUp(() {
    firebaseAuth = _MockFirebaseAuth();
    googleSignIn = _MockGoogleSignIn();
    client = FlutterFirebaseAuthClient(
      firebaseAuth: firebaseAuth,
      googleSignIn: googleSignIn,
    );

    when(() => googleSignIn.initialize()).thenAnswer((_) async {});
    when(() => firebaseAuth.signOut()).thenAnswer((_) async {});
    when(() => googleSignIn.signOut()).thenAnswer((_) async {});
  });

  test('maps Firebase auth state users', () async {
    final firebaseUser = _MockFirebaseUser();
    when(() => firebaseUser.uid).thenReturn('user-id');
    when(() => firebaseUser.email).thenReturn('user@example.com');
    when(() => firebaseUser.displayName).thenReturn('User');
    when(() => firebaseUser.photoURL).thenReturn('photo-url');
    when(
      () => firebaseAuth.authStateChanges(),
    ).thenAnswer((_) => Stream.value(firebaseUser));

    final user = await client.authStateChanges.first;

    expect(user?.id, 'user-id');
    expect(user?.email, 'user@example.com');
    expect(user?.displayName, 'User');
    expect(user?.photoUrl, 'photo-url');
  });

  test('exchanges a Google ID token for a Firebase credential', () async {
    final account = _MockGoogleSignInAccount();
    final userCredential = _MockUserCredential();
    when(() => googleSignIn.authenticate()).thenAnswer((_) async => account);
    when(
      () => account.authentication,
    ).thenReturn(const GoogleSignInAuthentication(idToken: 'google-id-token'));
    when(
      () => firebaseAuth.signInWithCredential(any()),
    ).thenAnswer((_) async => userCredential);

    await client.signInWithGoogle();

    verify(() => googleSignIn.initialize()).called(1);
    verify(() => firebaseAuth.signInWithCredential(any())).called(1);
  });

  test('maps Google cancellation into a client cancellation', () {
    when(() => googleSignIn.authenticate()).thenThrow(
      const GoogleSignInException(code: GoogleSignInExceptionCode.canceled),
    );

    expect(
      client.signInWithGoogle(),
      throwsA(isA<AuthClientSignInCancelled>()),
    );
  });

  test('initializes Google Sign-In only once', () async {
    final account = _MockGoogleSignInAccount();
    final userCredential = _MockUserCredential();
    when(() => googleSignIn.authenticate()).thenAnswer((_) async => account);
    when(
      () => account.authentication,
    ).thenReturn(const GoogleSignInAuthentication(idToken: 'google-id-token'));
    when(
      () => firebaseAuth.signInWithCredential(any()),
    ).thenAnswer((_) async => userCredential);

    await client.signInWithGoogle();
    await client.signOut();

    verify(() => googleSignIn.initialize()).called(1);
    verify(() => firebaseAuth.signOut()).called(1);
    verify(() => googleSignIn.signOut()).called(1);
  });
}

class _MockFirebaseAuth extends Mock implements FirebaseAuth {}

class _MockGoogleSignIn extends Mock implements GoogleSignIn {}

class _MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}

class _MockFirebaseUser extends Mock implements User {}

class _MockUserCredential extends Mock implements UserCredential {}

class _MockAuthCredential extends Mock implements AuthCredential {}
