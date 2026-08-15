import 'package:expenses_tracker/features/wallets/presentation/widgets/wallet_creation_step_transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('slides forward and backward in the navigation direction', (
    tester,
  ) async {
    final harnessKey = GlobalKey<_TransitionHarnessState>();
    await _pumpHarness(tester, harnessKey: harnessKey);

    final transition = tester.widget<WalletCreationStepTransition>(
      find.byType(WalletCreationStepTransition),
    );
    expect(transition.duration, const Duration(milliseconds: 500));
    expect(tester.getTopLeft(find.byKey(const ValueKey('step-1'))).dx, 0);

    harnessKey.currentState!.showStep(2);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    final forwardOutgoingX = tester
        .getTopLeft(find.byKey(const ValueKey('step-1')))
        .dx;
    final forwardIncomingX = tester
        .getTopLeft(find.byKey(const ValueKey('step-2')))
        .dx;
    final outgoingOpacity = tester.widget<Opacity>(
      find.ancestor(
        of: find.byKey(const ValueKey('step-1')),
        matching: find.byType(Opacity),
      ),
    );
    final incomingOpacity = tester.widget<Opacity>(
      find.ancestor(
        of: find.byKey(const ValueKey('step-2')),
        matching: find.byType(Opacity),
      ),
    );
    expect(forwardOutgoingX, lessThan(0));
    expect(forwardIncomingX, greaterThan(0));
    expect(outgoingOpacity.opacity, inExclusiveRange(0.85, 1));
    expect(incomingOpacity.opacity, inExclusiveRange(0.85, 1));

    await tester.pump(const Duration(milliseconds: 200));
    expect(find.byKey(const ValueKey('step-1')), findsOneWidget);
    expect(find.byKey(const ValueKey('step-2')), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('step-1')), findsNothing);
    expect(tester.getTopLeft(find.byKey(const ValueKey('step-2'))).dx, 0);

    harnessKey.currentState!.showStep(1);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    final backOutgoingX = tester
        .getTopLeft(find.byKey(const ValueKey('step-2')))
        .dx;
    final backIncomingX = tester
        .getTopLeft(find.byKey(const ValueKey('step-1')))
        .dx;
    expect(backOutgoingX, greaterThan(0));
    expect(backIncomingX, lessThan(0));

    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('step-2')), findsNothing);
    expect(tester.getTopLeft(find.byKey(const ValueKey('step-1'))).dx, 0);
  });

  testWidgets('switches immediately when animations are disabled', (
    tester,
  ) async {
    final harnessKey = GlobalKey<_TransitionHarnessState>();
    await _pumpHarness(tester, harnessKey: harnessKey, animate: false);

    harnessKey.currentState!.showStep(2);
    await tester.pump();

    expect(find.byKey(const ValueKey('step-1')), findsNothing);
    expect(tester.getTopLeft(find.byKey(const ValueKey('step-2'))).dx, 0);
    expect(tester.binding.hasScheduledFrame, isFalse);
  });
}

Future<void> _pumpHarness(
  WidgetTester tester, {
  required GlobalKey<_TransitionHarnessState> harnessKey,
  bool animate = true,
}) {
  tester.view.physicalSize = const Size(400, 800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  return tester.pumpWidget(
    MaterialApp(
      home: _TransitionHarness(key: harnessKey, animate: animate),
    ),
  );
}

class _TransitionHarness extends StatefulWidget {
  const _TransitionHarness({required this.animate, super.key});

  final bool animate;

  @override
  State<_TransitionHarness> createState() => _TransitionHarnessState();
}

class _TransitionHarnessState extends State<_TransitionHarness> {
  int _step = 1;

  void showStep(int step) => setState(() => _step = step);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WalletCreationStepTransition(
        step: _step,
        animate: widget.animate,
        child: ColoredBox(
          key: ValueKey('step-$_step'),
          color: _step == 1 ? Colors.blue : Colors.green,
        ),
      ),
    );
  }
}
