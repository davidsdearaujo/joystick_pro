import 'package:flutter/material.dart';
import 'package:joystick_pro/src/joystick_state.dart';
import 'package:rx_notifier/rx_notifier.dart';

import 'joystick_store.dart';

class JoystickWidget extends StatefulWidget {
  final double size;
  final double opacity;
  final void Function(JoystickState) onUpdate;
  const JoystickWidget({Key key, this.size = 100, this.onUpdate, this.opacity}) : super(key: key);

  @override
  _JoystickWidgetState createState() => _JoystickWidgetState();
}

class _JoystickWidgetState extends State<JoystickWidget> {
  final store = JoystickStore();
  double get circleSize => widget.size * 0.35;

  @override
  void initState() {
    super.initState();
    if (widget.onUpdate != null) store.observe(onState: widget.onUpdate);
  }

  @override
  void dispose() {
    store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.opacity ?? 1,
      child: GestureDetector(
        onPanStart: (details) {
          final r = widget.size / 2;
          double x = details.localPosition.dx - widget.size / 2;
          double y = details.localPosition.dy - widget.size / 2;
          final isExternalOfCircunference = x * x + y * y > r * r;
          while (isExternalOfCircunference) {
            if (x > 0) x--;
            if (x < 0) x++;
            if (y > 0) y--;
            if (y < 0) y++;
          }
          store.update(store.state.copyWith(x: x, y: y));
        },
        onPanUpdate: (details) {
          final r = widget.size / 2;
          double x = details.localPosition.dx - widget.size / 2;
          double y = details.localPosition.dy - widget.size / 2;
          while (x * x + y * y > r * r) {
            if (x > 0) x--;
            if (x < 0) x++;
            if (y > 0) y--;
            if (y < 0) y++;
          }
          store.update(store.state.copyWith(x: x, y: y));
        },
        onPanEnd: (details) => store.update(JoystickState.empty()),
        child: Container(
          width: widget.size,
          height: widget.size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: RxBuilder(builder: (context) {
            return Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: widget.size / 2 - circleSize / 2 + store.state.x,
                  top: widget.size / 2 - circleSize / 2 + store.state.y,
                  child: Container(
                    width: circleSize,
                    height: circleSize,
                    decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(50)),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
