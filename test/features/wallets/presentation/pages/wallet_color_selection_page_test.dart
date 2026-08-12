import 'package:expenses_tracker/app/app_theme.dart';
import 'package:expenses_tracker/features/wallets/presentation/pages/wallet_color_selection_page.dart';
import 'package:expenses_tracker/features/wallets/presentation/wallet_color_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows every Wallet color and the initial selection', (
    tester,
  ) async {
    await _pumpPage(tester, initialColorKey: 'sky');

    for (final palette in WalletColorPalette.values) {
      expect(
        find.byKey(ValueKey('wallet-color-${palette.key}')),
        findsOneWidget,
      );
    }
    expect(find.byIcon(Icons.check_circle), findsOneWidget);

    final skySemantics = tester.getSemantics(
      find.byKey(const ValueKey('wallet-color-sky')),
    );
    expect(skySemantics.label, 'Sky');
    expect(skySemantics.hasFlag(SemanticsFlag.isSelected), isTrue);
  });

  testWidgets('updates the live preview when a color is selected', (
    tester,
  ) async {
    await _pumpPage(tester);

    await tester.tap(find.byKey(const ValueKey('wallet-color-rose')));
    await tester.pumpAndSettle();

    final preview = tester.widget<AnimatedContainer>(
      find.byKey(const ValueKey('wallet-color-preview')),
    );
    final decoration = preview.decoration! as BoxDecoration;
    expect(decoration.color, WalletColorPalette.resolve('rose').cardColor);

    final roseSemantics = tester.getSemantics(
      find.byKey(const ValueKey('wallet-color-rose')),
    );
    expect(roseSemantics.hasFlag(SemanticsFlag.isSelected), isTrue);
  });

  testWidgets('falls back to Sage when the initial key is unknown', (
    tester,
  ) async {
    await _pumpPage(tester, initialColorKey: 'unknown');

    final sageSemantics = tester.getSemantics(
      find.byKey(const ValueKey('wallet-color-sage')),
    );
    expect(sageSemantics.hasFlag(SemanticsFlag.isSelected), isTrue);
  });

  testWidgets('returns the selected stable color key', (tester) async {
    String? selectedColorKey;
    await _pumpLauncher(
      tester,
      onResult: (result) => selectedColorKey = result,
    );

    await tester.tap(find.text('Choose color'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('wallet-color-teal')));
    await tester.tap(find.byKey(const ValueKey('use-wallet-color-button')));
    await tester.pumpAndSettle();

    expect(selectedColorKey, 'teal');
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

Future<void> _pumpPage(WidgetTester tester, {String initialColorKey = 'sage'}) {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: WalletColorSelectionPage(
        initialColorKey: initialColorKey,
        walletName: 'Travel card',
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
                    builder: (_) => const WalletColorSelectionPage(),
                  ),
                );
                onResult(result);
              },
              child: const Text('Choose color'),
            ),
          ),
        ),
      ),
    ),
  );
}
