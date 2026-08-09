import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/authentication_bloc.dart';
import '../bloc/authentication_event.dart';
import '../bloc/authentication_state.dart';
import 'network_unavailable_sheet.dart';
import 'sign_in_page.dart';
import 'signed_in_page.dart';

class AuthenticationGate extends StatelessWidget {
  const AuthenticationGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listenWhen: (previous, current) =>
          current is AuthenticationFailure &&
          current.reason == AuthenticationFailureReason.networkUnavailable,
      listener: (context, state) {
        showModalBottomSheet<void>(
          context: context,
          showDragHandle: true,
          useSafeArea: true,
          builder: (_) => const NetworkUnavailableSheet(),
        );
      },
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
        AuthenticationFailure(:final reason) => SignInPage(
          errorMessage: reason == AuthenticationFailureReason.unknown
              ? 'Sign-in failed. Please try again.'
              : null,
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
