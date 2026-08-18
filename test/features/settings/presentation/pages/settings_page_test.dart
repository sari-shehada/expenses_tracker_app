import 'package:expenses_tracker/app/app_shell_layout.dart';
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
    expect(find.byType(CustomScrollView), findsOneWidget);
    expect(find.byType(ListView), findsNothing);
    _expectNavigationClearance(tester);
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

void _expectNavigationClearance(WidgetTester tester) {
  final scrollView = tester.widget<CustomScrollView>(
    find.byType(CustomScrollView),
  );
  final adapter = scrollView.slivers.last as SliverToBoxAdapter;
  final clearance = adapter.child as SizedBox;

  expect(clearance.key, const ValueKey(AppShellLayout.navigationClearanceKey));
  expect(clearance.height, AppShellLayout.destinationBottomClearance);
}
