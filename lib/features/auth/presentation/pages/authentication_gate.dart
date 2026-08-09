import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/authentication_bloc.dart';
import '../bloc/authentication_event.dart';
import '../bloc/authentication_state.dart';
import 'sign_in_page.dart';
import 'signed_in_page.dart';

class AuthenticationGate extends StatelessWidget {
  const AuthenticationGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) => switch (state) {
        Authenticated(:final user) => SignedInPage(
          user: user,
          onSignOut: () {
            context.read<AuthenticationBloc>().add(const SignOutRequested());
          },
        ),
        Unauthenticated() => SignInPage(
          onGoogleSignIn: () {
            context.read<AuthenticationBloc>().add(
              const GoogleSignInRequested(),
            );
          },
        ),
        AuthenticationFailure() => SignInPage(
          errorMessage: 'Sign-in failed. Please try again.',
          onGoogleSignIn: () {
            context.read<AuthenticationBloc>().add(
              const GoogleSignInRequested(),
            );
          },
        ),
        AuthenticationUnknown() || AuthenticationInProgress() => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      },
    );
  }
}
