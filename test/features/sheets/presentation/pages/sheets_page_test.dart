import 'package:expenses_tracker/app/app_theme.dart';
import 'package:expenses_tracker/features/sheets/presentation/pages/sheets_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the Sheets empty state', (tester) async {
    await _pumpPage(tester, onAddSheet: () {});

    expect(
      find.byKey(const ValueKey('sheets-empty-state-illustration')),
      findsOneWidget,
    );
    expect(find.text('No Sheets yet'), findsOneWidget);
    expect(
      find.text(
        'Create a Sheet to organize expenses for a month, trip, or project.',
      ),
      findsOneWidget,
    );
    expect(find.text('Add Sheet'), findsOneWidget);
  });

  testWidgets('uses a softened primary color for the heading', (tester) async {
    await _pumpPage(tester, onAddSheet: () {});

    final heading = tester.widget<Text>(find.text('No Sheets yet'));
    final expectedColor = Color.alphaBlend(
      AppTheme.lightColorScheme.primary.withValues(alpha: 0.74),
      AppTheme.lightColorScheme.surface,
    );

    expect(heading.style?.color, expectedColor);
  });

  testWidgets('invokes the placeholder Add Sheet action', (tester) async {
    var addSheetCalls = 0;
    await _pumpPage(tester, onAddSheet: () => addSheetCalls++);

    await tester.tap(find.text('Add Sheet'));

    expect(addSheetCalls, 1);
  });
}

Future<void> _pumpPage(
  WidgetTester tester, {
  required VoidCallback onAddSheet,
}) {
  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(body: SheetsPage(onAddSheet: onAddSheet)),
    ),
  );
}
