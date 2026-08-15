import 'dart:ui' as ui;

import 'package:expenses_tracker/app/app_motion.dart';
import 'package:expenses_tracker/app/app_theme.dart';
import 'package:expenses_tracker/features/wallets/domain/wallet_appearance.dart';
import 'package:expenses_tracker/features/wallets/presentation/wallet_color_palette.dart';
import 'package:expenses_tracker/features/wallets/presentation/wallet_icon_catalog.dart';
import 'package:expenses_tracker/features/wallets/presentation/widgets/wallet_appearance_step.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('matches the Figma appearance step and defaults', (tester) async {
    await _pumpStep(tester);

    expect(find.text('Create Wallet'), findsNWidgets(2));
    expect(find.text('Step 3 of 3'), findsOneWidget);
    expect(find.text('100% Complete'), findsOneWidget);
    expect(find.text('Personalize your wallet'), findsOneWidget);
    expect(
      find.text('Choose a color and icon to identify this wallet at a glance'),
      findsOneWidget,
    );
    expect(find.text('Wallet Color'), findsOneWidget);
    expect(find.text('Wallet Icon'), findsOneWidget);

    for (final palette in WalletColorPalette.values) {
      expect(
        find.byKey(ValueKey('wallet-creation-color-${palette.key}')),
        findsOneWidget,
      );
    }
    for (final option in WalletIconOption.values) {
      expect(
        find.byKey(ValueKey('wallet-creation-icon-${option.key}')),
        findsOneWidget,
      );
    }

    expect(find.byIcon(Icons.check_rounded), findsOneWidget);
    _expectSelected(tester, 'wallet-creation-color-blue', true);
    _expectSelected(tester, 'wallet-creation-icon-wallet', true);
  });

  testWidgets('keeps color and icon selection controlled by the parent', (
    tester,
  ) async {
    await _pumpStep(tester);

    await tester.tap(find.byKey(const ValueKey('wallet-creation-color-green')));
    await tester.tap(find.byKey(const ValueKey('wallet-creation-icon-travel')));
    await tester.pump();

    expect(find.byIcon(Icons.check_rounded), findsOneWidget);
    _expectSelected(tester, 'wallet-creation-color-blue', false);
    _expectSelected(tester, 'wallet-creation-color-green', true);
    _expectSelected(tester, 'wallet-creation-icon-wallet', false);
    _expectSelected(tester, 'wallet-creation-icon-travel', true);
  });

  testWidgets('animates the selected palette across icon and flow chrome', (
    tester,
  ) async {
    await _pumpStep(tester);
    final blue = WalletColorPalette.blue;
    final green = WalletColorPalette.resolve('green');

    expect(_progressFillColor(tester), blue.accentColor);
    expect(_ctaColor(tester), blue.accentColor);
    expect(
      _renderedColor(tester, 'wallet-creation-icon-card-wallet'),
      blue.cardColor,
    );
    expect(
      _renderedColor(tester, 'wallet-creation-icon-accent-wallet'),
      blue.accentColor,
    );

    await tester.tap(find.byKey(const ValueKey('wallet-creation-color-green')));
    await tester.pump();
    await tester.pump(AppMotion.colorTransitionDuration * 0.5);

    for (final animatedColor in [
      _progressFillColor(tester),
      _ctaColor(tester),
      _renderedColor(tester, 'wallet-creation-icon-accent-wallet'),
    ]) {
      expect(animatedColor, isNot(blue.accentColor));
      expect(animatedColor, isNot(green.accentColor));
    }
    expect(
      _renderedColor(tester, 'wallet-creation-icon-card-wallet'),
      isNot(blue.cardColor),
    );
    expect(
      _renderedColor(tester, 'wallet-creation-icon-card-wallet'),
      isNot(green.cardColor),
    );

    await tester.pumpAndSettle();

    expect(_progressFillColor(tester), green.accentColor);
    expect(_ctaColor(tester), green.accentColor);
    expect(
      _renderedColor(tester, 'wallet-creation-icon-card-wallet'),
      green.cardColor,
    );
    expect(
      _renderedBorderColor(tester, 'wallet-creation-icon-card-wallet'),
      green.borderColor,
    );
    expect(
      _renderedColor(tester, 'wallet-creation-icon-accent-wallet'),
      green.accentColor,
    );
  });

  testWidgets('creates with the retained appearance', (tester) async {
    var createCalls = 0;
    await _pumpStep(tester, onCreate: () => createCalls++);

    await tester.tap(find.byKey(const ValueKey('wallet-appearance-create')));

    expect(createCalls, 1);
  });

  testWidgets('keeps Create Wallet visible on a compact screen', (
    tester,
  ) async {
    await _pumpStep(tester, size: const Size(320, 568));

    expect(
      find.byKey(const ValueKey('wallet-appearance-create')).hitTestable(),
      findsOneWidget,
    );
    expect(find.byType(SingleChildScrollView), findsOneWidget);
  });

  testWidgets('meets iOS tap-target and labeling accessibility guidelines', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    try {
      await _pumpStep(tester);

      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    } finally {
      semantics.dispose();
    }
  });
}

Color? _ctaColor(WidgetTester tester) {
  return tester
      .widget<FilledButton>(find.byType(FilledButton))
      .style
      ?.backgroundColor
      ?.resolve(<WidgetState>{});
}

Color? _progressFillColor(WidgetTester tester) {
  return _renderedColor(tester, 'wallet-step-progress-fill');
}

Color? _renderedColor(WidgetTester tester, String key) {
  return _renderedDecoration(tester, key).color;
}

Color? _renderedBorderColor(WidgetTester tester, String key) {
  return _renderedDecoration(tester, key).border?.top.color;
}

BoxDecoration _renderedDecoration(WidgetTester tester, String key) {
  return tester
          .widget<DecoratedBox>(
            find
                .descendant(
                  of: find.byKey(ValueKey(key)),
                  matching: find.byType(DecoratedBox),
                )
                .first,
          )
          .decoration
      as BoxDecoration;
}

void _expectSelected(WidgetTester tester, String key, bool expected) {
  expect(
    tester.getSemantics(find.byKey(ValueKey(key))).flagsCollection.isSelected,
    expected ? ui.Tristate.isTrue : ui.Tristate.isFalse,
  );
}

Future<void> _pumpStep(
  WidgetTester tester, {
  VoidCallback? onCreate,
  Size size = const Size(402, 874),
}) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: _WalletAppearanceStepHarness(onCreate: onCreate ?? () {}),
    ),
  );
}

class _WalletAppearanceStepHarness extends StatefulWidget {
  const _WalletAppearanceStepHarness({required this.onCreate});

  final VoidCallback onCreate;

  @override
  State<_WalletAppearanceStepHarness> createState() =>
      _WalletAppearanceStepHarnessState();
}

class _WalletAppearanceStepHarnessState
    extends State<_WalletAppearanceStepHarness> {
  String _colorKey = WalletAppearance.defaultColorKey;
  String _iconKey = WalletAppearance.defaultIconKey;

  @override
  Widget build(BuildContext context) {
    return WalletAppearanceStep(
      selectedColorKey: _colorKey,
      selectedIconKey: _iconKey,
      onColorSelected: (key) => setState(() => _colorKey = key),
      onIconSelected: (key) => setState(() => _iconKey = key),
      onBack: () {},
      onCreate: widget.onCreate,
      ctaButtonKey: const ValueKey('wallet-appearance-create'),
    );
  }
}
