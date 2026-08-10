import 'package:expenses_tracker/features/auth/domain/auth_user.dart';
import 'package:expenses_tracker/features/auth/presentation/pages/authenticated_app_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows Sheets as the default destination', (tester) async {
    await _pumpPage(tester);

    expect(find.text('Sheets will appear here.'), findsOneWidget);
    expect(find.text('Wallets will appear here.'), findsNothing);
  });

  testWidgets('opens Wallets from the bottom navigation', (tester) async {
    await _pumpPage(tester);

    await tester.tap(find.text('Wallets'));
    await tester.pumpAndSettle();

    expect(find.text('Wallets will appear here.'), findsOneWidget);
    expect(find.text('Sheets will appear here.'), findsNothing);
  });
}

Future<void> _pumpPage(WidgetTester tester) {
  return tester.pumpWidget(
    MaterialApp(
      home: AuthenticatedAppShell(
        user: const AuthUser(
          id: 'user-id',
          email: 'user@example.com',
          displayName: 'User',
          photoUrl: null,
        ),
        onSignOut: () {},
      ),
    ),
  );
}
