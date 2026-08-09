import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import 'auth_client.dart';

typedef InternetAccessCheck = Future<bool> Function();

class FlutterFirebaseAuthClient implements AuthClient {
  FlutterFirebaseAuthClient({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    InternetAccessCheck? hasInternetAccess,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       _googleSignIn = googleSignIn ?? GoogleSignIn.instance,
       _hasInternetAccess =
           hasInternetAccess ?? (() => InternetConnection().hasInternetAccess);

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final InternetAccessCheck _hasInternetAccess;
  Future<void>? _googleInitialization;

  @override
  Stream<AuthClientUser?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((user) {
      if (user == null) {
        return null;
      }

      return AuthClientUser(
        id: user.uid,
        email: user.email,
        displayName: user.displayName,
        photoUrl: user.photoURL,
      );
    });
  }

  @override
  Future<void> signInWithGoogle() async {
    try {
      await _initializeGoogleSignIn();
      final googleUser = await _googleSignIn.authenticate();
      final idToken = googleUser.authentication.idToken;
      if (idToken == null) {
        throw StateError('Google Sign-In did not return an ID token.');
      }

      final credential = GoogleAuthProvider.credential(idToken: idToken);
      await _firebaseAuth.signInWithCredential(credential);
    } on GoogleSignInException catch (error) {
      if (error.code == GoogleSignInExceptionCode.canceled) {
        throw const AuthClientSignInCancelled();
      }
      if (!await _hasInternetAccessSafely()) {
        throw const AuthClientNetworkUnavailable();
      }
      rethrow;
    } on FirebaseAuthException catch (error) {
      if (error.code == 'network-request-failed' ||
          !await _hasInternetAccessSafely()) {
        throw const AuthClientNetworkUnavailable();
      }
      rethrow;
    } catch (_) {
      if (!await _hasInternetAccessSafely()) {
        throw const AuthClientNetworkUnavailable();
      }
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    await _initializeGoogleSignIn();
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }

  Future<void> _initializeGoogleSignIn() {
    return _googleInitialization ??= _googleSignIn.initialize();
  }

  Future<bool> _hasInternetAccessSafely() async {
    try {
      return await _hasInternetAccess();
    } catch (_) {
      return false;
    }
  }
}
