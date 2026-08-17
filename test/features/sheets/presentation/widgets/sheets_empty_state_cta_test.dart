import 'package:expenses_tracker/app/app_theme.dart';
import 'package:expenses_tracker/features/sheets/presentation/widgets/sheets_empty_state_cta.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('matches the Figma Sheets empty-state CTA', (tester) async {
    await _pumpButton(tester);

    final widgetFinder = find.byType(SheetsEmptyStateCta);
    final buttonFinder = find.byKey(const ValueKey('add-sheet-button'));
    final button = tester.widget<FilledButton>(buttonFinder);
    final states = <WidgetState>{};

    expect(tester.getSize(widgetFinder), const Size(200, 48));
    expect(find.byKey(const ValueKey('add-sheet-icon')), findsOneWidget);
    final icon = tester.widget<Icon>(
      find.byKey(const ValueKey('add-sheet-icon')),
    );
    expect(icon.icon, Icons.add);
    expect(icon.size, 16);
    expect(find.text('Add Sheet'), findsOneWidget);
    expect(
      button.style?.backgroundColor?.resolve(states),
      AppTheme.lightColorScheme.primary,
    );
    expect(
      button.style?.foregroundColor?.resolve(states),
      AppTheme.lightColorScheme.onPrimary,
    );
    expect(
      button.style?.padding?.resolve(states),
      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    );

    final shape =
        button.style?.shape?.resolve(states)! as RoundedRectangleBorder;
    expect(shape.borderRadius, BorderRadius.circular(16));
    expect(button.style?.textStyle?.resolve(states)?.fontSize, 15);
    expect(
      button.style?.textStyle?.resolve(states)?.fontWeight,
      FontWeight.w600,
    );
  });

  testWidgets('invokes its callback', (tester) async {
    var presses = 0;
    await _pumpButton(tester, onPressed: () => presses++);

    await tester.tap(find.byKey(const ValueKey('add-sheet-button')));

    expect(presses, 1);
  });
}

Future<void> _pumpButton(WidgetTester tester, {VoidCallback? onPressed}) {
  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(
        body: Center(child: SheetsEmptyStateCta(onPressed: onPressed ?? () {})),
      ),
    ),
  );
}
