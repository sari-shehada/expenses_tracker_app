import 'package:expenses_tracker/features/wallets/presentation/widgets/wallet_creation_step_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('appends the shared CTA clearance after the supplied slivers', (
    tester,
  ) async {
    await _pumpScrollView(tester, ctaClearance: 96);

    expect(find.text('Step content'), findsOneWidget);
    expect(
      tester
          .getSize(find.byKey(WalletCreationStepScrollView.ctaClearanceKey))
          .height,
      96,
    );
  });

  testWidgets('updates the clearance when the flow metrics change', (
    tester,
  ) async {
    await _pumpScrollView(tester, ctaClearance: 80);
    await _pumpScrollView(tester, ctaClearance: 144);

    expect(
      tester
          .getSize(find.byKey(WalletCreationStepScrollView.ctaClearanceKey))
          .height,
      144,
    );
  });

  testWidgets('forwards the keyboard-dismiss behavior', (tester) async {
    await _pumpScrollView(
      tester,
      ctaClearance: 80,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
    );

    expect(
      tester
          .widget<CustomScrollView>(find.byType(CustomScrollView))
          .keyboardDismissBehavior,
      ScrollViewKeyboardDismissBehavior.onDrag,
    );
  });
}

Future<void> _pumpScrollView(
  WidgetTester tester, {
  required double ctaClearance,
  ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
      ScrollViewKeyboardDismissBehavior.manual,
}) {
  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: WalletCreationFlowMetrics(
          ctaClearance: ctaClearance,
          child: WalletCreationStepScrollView(
            keyboardDismissBehavior: keyboardDismissBehavior,
            slivers: const [SliverToBoxAdapter(child: Text('Step content'))],
          ),
        ),
      ),
    ),
  );
}
