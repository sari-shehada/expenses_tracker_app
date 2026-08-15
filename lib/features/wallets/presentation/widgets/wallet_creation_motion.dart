import 'package:flutter/animation.dart';

abstract final class WalletCreationMotion {
  static const stepTransitionDuration = Duration(milliseconds: 500);
  static const stepTransitionCurve = Cubic(0.65, 0, 0.35, 1);
}
