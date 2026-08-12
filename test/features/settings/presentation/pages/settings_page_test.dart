import 'package:expenses_tracker/features/settings/presentation/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows Settings with Sign out as its only action', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: SettingsPage(onSignOut: () {})),
      ),
    );

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Sign out'), findsOneWidget);
    expect(find.byType(ListTile), findsOneWidget);
  });

  testWidgets('invokes the Sign out callback', (tester) async {
    var signOutCalls = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: SettingsPage(onSignOut: () => signOutCalls++)),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('sign-out-button')));

    expect(signOutCalls, 1);
  });
}
