import 'package:flutter/material.dart';

import '../../../../app/app_shell_layout.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({required this.onSignOut, super.key});

  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  'Settings',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  margin: EdgeInsets.zero,
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    key: const ValueKey('sign-out-button'),
                    leading: const Icon(Icons.logout),
                    title: const Text('Sign out'),
                    onTap: onSignOut,
                  ),
                ),
              ]),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              key: ValueKey(AppShellLayout.navigationClearanceKey),
              height: AppShellLayout.destinationBottomClearance,
            ),
          ),
        ],
      ),
    );
  }
}
