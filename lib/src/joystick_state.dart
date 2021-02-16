import 'dart:ui';

class JoystickState {
  final Offset offset;

  bool get isLeft => x < 0;
  bool get isRight => x > 0;
  bool get isTop => y < 0;
  bool get isBottom => y > 0;
  double get x => offset?.dx ?? 0;
  double get y => offset?.dy ?? 0;

  const JoystickState({this.offset});
  const JoystickState.empty() : this.offset = const Offset(0, 0);

  JoystickState copyWith({double x, double y}) {
    return JoystickState(
      offset: Offset(
        x ?? x,
        y ?? y,
      ),
    );
  }

  @override
  String toString() => "$offset";
}
