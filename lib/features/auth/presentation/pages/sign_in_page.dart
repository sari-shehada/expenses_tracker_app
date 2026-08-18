import 'package:flutter/material.dart';

import '../../../../app/widgets/app_spacing.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({
    required this.onGoogleSignIn,
    this.errorMessage,
    super.key,
  });

  final VoidCallback onGoogleSignIn;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Expenses Tracker',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const AddVerticalSpacing(24),
                if (errorMessage case final message?) ...[
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  const AddVerticalSpacing(16),
                ],
                FilledButton(
                  onPressed: onGoogleSignIn,
                  child: const Text('Continue with Google'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
