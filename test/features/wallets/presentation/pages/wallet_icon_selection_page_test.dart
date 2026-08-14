import 'package:expenses_tracker/app/app_theme.dart';
import 'package:expenses_tracker/features/wallets/presentation/pages/wallet_icon_selection_page.dart';
import 'package:expenses_tracker/features/wallets/presentation/wallet_icon_catalog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows every Wallet icon and the initial selection', (
    tester,
  ) async {
    await _pumpPage(tester, initialIconKey: 'card');

    for (final option in WalletIconOption.values) {
      expect(find.byKey(ValueKey('wallet-icon-${option.key}')), findsOneWidget);
    }
    expect(find.byIcon(Icons.check_circle), findsOneWidget);

    final cardSemantics = tester.getSemantics(
      find.byKey(const ValueKey('wallet-icon-card')),
    );
    expect(cardSemantics.label, 'Card');
    expect(cardSemantics.hasFlag(SemanticsFlag.isSelected), isTrue);
  });

  testWidgets('updates the live preview when an icon is selected', (
    tester,
  ) async {
    await _pumpPage(tester);

    await tester.tap(find.byKey(const ValueKey('wallet-icon-person')));
    await tester.pumpAndSettle();

    final previewIcon = tester.widget<Icon>(
      find.byKey(const ValueKey('wallet-icon-preview-icon')),
    );
    expect(previewIcon.icon, Icons.person_outline);

    final personSemantics = tester.getSemantics(
      find.byKey(const ValueKey('wallet-icon-person')),
    );
    expect(personSemantics.hasFlag(SemanticsFlag.isSelected), isTrue);
  });

  testWidgets('falls back to Wallet when the initial key is unknown', (
    tester,
  ) async {
    await _pumpPage(tester, initialIconKey: 'unknown');

    final walletSemantics = tester.getSemantics(
      find.byKey(const ValueKey('wallet-icon-wallet')),
    );
    expect(walletSemantics.hasFlag(SemanticsFlag.isSelected), isTrue);
  });

  testWidgets('returns the selected stable icon key', (tester) async {
    String? selectedIconKey;
    await _pumpLauncher(tester, onResult: (result) => selectedIconKey = result);

    await tester.tap(find.text('Choose icon'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('wallet-icon-travel')));
    await tester.tap(find.byKey(const ValueKey('use-wallet-icon-button')));
    await tester.pumpAndSettle();

    expect(selectedIconKey, 'travel');
  });

  testWidgets('meets tap-target and labeling accessibility guidelines', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    try {
      await _pumpPage(tester);

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    } finally {
      semantics.dispose();
    }
  });
}

Future<void> _pumpPage(
  WidgetTester tester, {
  String initialIconKey = 'wallet',
}) {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: WalletIconSelectionPage(
        initialIconKey: initialIconKey,
        colorKey: 'blue',
        walletName: 'Main card',
      ),
    ),
  );
}

Future<void> _pumpLauncher(
  WidgetTester tester, {
  required ValueChanged<String?> onResult,
}) {
  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: Builder(
        builder: (context) => Scaffold(
          body: Center(
            child: FilledButton(
              onPressed: () async {
                final result = await Navigator.push<String>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const WalletIconSelectionPage(),
                  ),
                );
                onResult(result);
              },
              child: const Text('Choose icon'),
            ),
          ),
        ),
      ),
    ),
  );
}
