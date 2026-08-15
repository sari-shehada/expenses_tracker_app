import 'package:flutter/material.dart';

import 'wallet_creation_motion.dart';

class WalletCreationStepTransition extends StatefulWidget {
  const WalletCreationStepTransition({
    required this.step,
    required this.child,
    this.animate = true,
    this.duration = WalletCreationMotion.stepTransitionDuration,
    this.curve = WalletCreationMotion.stepTransitionCurve,
    super.key,
  });

  final int step;
  final Widget child;
  final bool animate;
  final Duration duration;
  final Curve curve;

  @override
  State<WalletCreationStepTransition> createState() =>
      _WalletCreationStepTransitionState();
}

class _WalletCreationStepTransitionState
    extends State<WalletCreationStepTransition>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late int _currentStep;
  late Widget _currentChild;
  Widget? _outgoingChild;
  int _direction = 1;

  @override
  void initState() {
    super.initState();
    _currentStep = widget.step;
    _currentChild = widget.child;
    _controller = AnimationController(
      value: 1,
      duration: widget.duration,
      vsync: this,
    )..addStatusListener(_handleAnimationStatus);
  }

  @override
  void didUpdateWidget(WalletCreationStepTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.duration = widget.duration;

    if (widget.step == _currentStep) {
      _currentChild = widget.child;
      return;
    }

    _direction = widget.step > _currentStep ? 1 : -1;
    _outgoingChild = _currentChild;
    _currentChild = widget.child;
    _currentStep = widget.step;

    if (widget.animate) {
      _controller.forward(from: 0);
    } else {
      _controller.value = 1;
      _outgoingChild = null;
    }
  }

  @override
  void dispose() {
    _controller
      ..removeStatusListener(_handleAnimationStatus)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final progress = widget.curve.transform(_controller.value);
          final outgoingOpacity = 1 - (0.15 * progress);
          final incomingOpacity = 0.85 + (0.15 * progress);

          return Stack(
            fit: StackFit.expand,
            children: [
              if (_outgoingChild != null)
                ExcludeSemantics(
                  child: IgnorePointer(
                    child: Opacity(
                      opacity: outgoingOpacity,
                      child: FractionalTranslation(
                        translation: Offset(-_direction * progress, 0),
                        child: RepaintBoundary(child: _outgoingChild),
                      ),
                    ),
                  ),
                ),
              IgnorePointer(
                ignoring: _controller.isAnimating,
                child: Opacity(
                  opacity: incomingOpacity,
                  child: FractionalTranslation(
                    translation: Offset(_direction * (1 - progress), 0),
                    child: RepaintBoundary(child: _currentChild),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed && _outgoingChild != null) {
      setState(() => _outgoingChild = null);
    }
  }
}
