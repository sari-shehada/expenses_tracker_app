import 'package:expenses_tracker/app/expenses_tracker_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('builds the application root', (tester) async {
    await tester.pumpWidget(const ExpensesTrackerApp());

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
