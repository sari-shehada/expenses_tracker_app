import 'package:expenses_tracker/app/widgets/app_spacing.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AddVerticalSpacing applies only the requested height', (
    tester,
  ) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: Row(children: [AddVerticalSpacing(24)]),
      ),
    );

    expect(tester.getSize(find.byType(AddVerticalSpacing)), const Size(0, 24));
  });

  testWidgets('AddHorizontalSpacing applies only the requested width', (
    tester,
  ) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: Column(children: [AddHorizontalSpacing(16)]),
      ),
    );

    expect(
      tester.getSize(find.byType(AddHorizontalSpacing)),
      const Size(16, 0),
    );
  });
}
