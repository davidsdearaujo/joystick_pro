import 'dart:ui';

import 'package:animation_helpers/animation_helpers.dart';
import 'package:flutter/foundation.dart';

class JoystickState {
  final Offset offset;
  final double size;
  final InterpolationController xInterpolation;
  final InterpolationController yInterpolation;

  bool get isLeft => x < -1;
  bool get isRight => x > 1;
  bool get isTop => y < -0.5;
  bool get isBottom => y > 0.5;
  double get x => offset?.dx ?? 0;
  double get y => offset?.dy ?? 0;
  double get dx => x == 0 ? 0 : xInterpolation.linear(x, begin: -1, end: 1);
  double get dy => y == 0 ? 0 : yInterpolation.linear(y, begin: -1, end: 1);

  factory JoystickState.empty([double size]) => JoystickState(x: 0, y: 0, size: size ?? 0);
  factory JoystickState.fromOffset(Offset offset, {double size = 0}) => JoystickState(x: offset.dx, y: offset.dy, size: size);
  JoystickState({@required double x, @required double y, @required this.size})
      : this.xInterpolation = InterpolationController(begin: -(size / 2) + 1, end: (size / 2) - 1),
        this.yInterpolation = InterpolationController(begin: -(size / 2) + 0.5, end: (size / 2) - 0.5),
        this.offset = Offset(x, y);

  JoystickState copyWith({double x, double y, double size}) {
    return JoystickState(
      x: x ?? this.x,
      y: y ?? this.y,
      size: size ?? this.size,
    );
  }

  @override
  String toString() => "$offset";
}
