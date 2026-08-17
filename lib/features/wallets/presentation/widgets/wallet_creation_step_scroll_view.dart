import 'package:flutter/material.dart';

class WalletCreationFlowMetrics extends InheritedWidget {
  const WalletCreationFlowMetrics({
    required this.ctaClearance,
    required super.child,
    super.key,
  }) : assert(ctaClearance >= 0);

  final double ctaClearance;

  static WalletCreationFlowMetrics of(BuildContext context) {
    final metrics = context
        .dependOnInheritedWidgetOfExactType<WalletCreationFlowMetrics>();
    assert(
      metrics != null,
      'WalletCreationFlowMetrics.of() called without a '
      'WalletCreationFlowMetrics ancestor.',
    );
    return metrics!;
  }

  @override
  bool updateShouldNotify(WalletCreationFlowMetrics oldWidget) {
    return ctaClearance != oldWidget.ctaClearance;
  }
}

class WalletCreationStepScrollView extends StatelessWidget {
  static const ctaClearanceKey = ValueKey<String>(
    'wallet-creation-cta-clearance',
  );

  const WalletCreationStepScrollView({
    required this.slivers,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    super.key,
  });

  final List<Widget> slivers;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  @override
  Widget build(BuildContext context) {
    final metrics = WalletCreationFlowMetrics.of(context);

    return CustomScrollView(
      keyboardDismissBehavior: keyboardDismissBehavior,
      slivers: [
        ...slivers,
        SliverToBoxAdapter(
          child: SizedBox(key: ctaClearanceKey, height: metrics.ctaClearance),
        ),
      ],
    );
  }
}
