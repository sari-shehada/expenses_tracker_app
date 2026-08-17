import 'package:expenses_tracker/app/app_theme.dart';
import 'package:expenses_tracker/features/sheets/presentation/pages/sheets_page.dart';
import 'package:expenses_tracker/features/sheets/presentation/widgets/sheets_empty_state_cta.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('matches the Figma Sheets empty state', (tester) async {
    await _pumpPage(tester, onAddSheet: () {});

    final illustration = find.byKey(
      const ValueKey('sheets-empty-state-illustration'),
    );
    final button = find.byKey(const ValueKey('add-sheet-button'));

    expect(tester.getSize(illustration), const Size.square(220));
    expect(tester.widget(illustration), isA<SvgPicture>());
    expect(find.text('No sheets yet'), findsOneWidget);
    expect(
      find.text(
        'Create your first sheet to start tracking expenses by trip, project, '
        'or category.',
      ),
      findsOneWidget,
    );
    expect(tester.getSize(button), const Size(200, 48));
    expect(find.text('Add Sheet'), findsOneWidget);
  });

  testWidgets('uses the Figma empty-state typography', (tester) async {
    await _pumpPage(tester, onAddSheet: () {});

    final title = tester.widget<Text>(find.text('No sheets yet'));
    final description = tester.widget<Text>(
      find.text(
        'Create your first sheet to start tracking expenses by trip, project, '
        'or category.',
      ),
    );

    expect(title.style?.color, AppTheme.lightColorScheme.onSurface);
    expect(title.style?.fontSize, 20);
    expect(title.style?.fontWeight, FontWeight.w700);
    expect(
      description.style?.color,
      AppTheme.lightColorScheme.onSurfaceVariant,
    );
    expect(description.style?.fontSize, 14);
    expect(description.style?.height, 20 / 14);
  });

  testWidgets('invokes the placeholder Add Sheet action', (tester) async {
    var addSheetCalls = 0;
    await _pumpPage(tester, onAddSheet: () => addSheetCalls++);

    await tester.tap(find.text('Add Sheet'));

    expect(addSheetCalls, 1);
  });

  testWidgets('keeps the empty state usable on a short screen', (tester) async {
    tester.view.physicalSize = const Size(402, 540);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _pumpPage(tester, onAddSheet: () {});

    expect(tester.takeException(), isNull);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(find.byType(SheetsEmptyStateCta), findsOneWidget);
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
