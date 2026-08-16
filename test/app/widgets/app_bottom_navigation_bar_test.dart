import 'package:expenses_tracker/app/app_theme.dart';
import 'package:expenses_tracker/app/widgets/app_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('matches the Figma component dimensions and destinations', (
    tester,
  ) async {
    await _pumpNavigationBar(tester);

    expect(
      tester.getSize(find.byType(AppBottomNavigationBar)),
      const Size(354, 72),
    );
    expect(find.text('Sheets'), findsOneWidget);
    expect(find.text('Wallets'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('Sheets-navigation-icon')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('Wallets-navigation-icon')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('Settings-navigation-icon')),
      findsOneWidget,
    );
  });

  testWidgets('uses the selected and unselected Figma label styles', (
    tester,
  ) async {
    await _pumpNavigationBar(tester, selectedIndex: 1);

    final sheetsLabel = tester.widget<Text>(find.text('Sheets'));
    final walletsLabel = tester.widget<Text>(find.text('Wallets'));

    expect(sheetsLabel.style?.color, const Color(0xFF475569));
    expect(sheetsLabel.style?.fontSize, 11);
    expect(sheetsLabel.style?.fontWeight, FontWeight.w500);
    expect(walletsLabel.style?.color, AppTheme.lightColorScheme.primary);
    expect(walletsLabel.style?.fontSize, 11);
    expect(walletsLabel.style?.fontWeight, FontWeight.w700);
  });

  testWidgets('reports the selected destination', (tester) async {
    int? selectedIndex;
    await _pumpNavigationBar(
      tester,
      onDestinationSelected: (index) => selectedIndex = index,
    );

    await tester.tap(find.text('Settings'));

    expect(selectedIndex, 2);
  });
}

Future<void> _pumpNavigationBar(
  WidgetTester tester, {
  int selectedIndex = 0,
  ValueChanged<int>? onDestinationSelected,
}) {
  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(
        body: Center(
          child: AppBottomNavigationBar(
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected ?? (_) {},
          ),
        ),
      ),
    ),
  );
}
