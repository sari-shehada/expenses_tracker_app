import 'package:flutter/material.dart';

import '../../domain/auth_user.dart';

class SignedInPage extends StatelessWidget {
  const SignedInPage({required this.user, required this.onSignOut, super.key});

  final AuthUser user;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    final identity = user.displayName ?? user.email;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses Tracker'),
        actions: [
          TextButton(onPressed: onSignOut, child: const Text('Sign out')),
        ],
      ),
      body: Center(child: Text('Signed in as $identity')),
    );
  }
}
