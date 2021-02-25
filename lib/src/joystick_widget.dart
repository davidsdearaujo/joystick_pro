import 'package:flutter/material.dart';
import 'package:rx_notifier/rx_notifier.dart';

import 'package:joystick_pro/src/joystick_state.dart';

import 'joystick_store.dart';

class JoystickWidget extends StatefulWidget {
  final double size;
  final double opacity;
  final Color color;
  final void Function(JoystickState) onUpdate;
  const JoystickWidget({Key key, this.size, this.opacity, this.color, this.onUpdate}) : super(key: key);

  @override
  _JoystickWidgetState createState() => _JoystickWidgetState();
}

class _JoystickWidgetState extends State<JoystickWidget> {
  JoystickStore store;
  double get circleSize => widget.size * 0.35;

  @override
  void initState() {
    super.initState();
    store = JoystickStore(widget.size);
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
          while (x * x + y * y > r * r) //x² + y² = r²
          {
            x = (x > 0) ? x - 1 : x + 1;
            y = (y > 0) ? y - 1 : y + 1;
          }
          store.update(JoystickState(x: x, y: y, size: widget.size));
        },
        onPanUpdate: (details) {
          final r = widget.size / 2;
          double x = details.localPosition.dx - widget.size / 2;
          double y = details.localPosition.dy - widget.size / 2;
          while (x * x + y * y > r * r) //x² + y² = r²
          {
            x = (x > 0) ? x - 1 : x + 1;
            y = (y > 0) ? y - 1 : y + 1;
          }
          store.update(JoystickState(x: x, y: y, size: widget.size));
        },
        onPanEnd: (details) => store.update(JoystickState.empty(widget.size)),
        child: Container(
          width: widget.size,
          height: widget.size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 1, color: widget.color ?? Colors.grey),
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
                    decoration: BoxDecoration(color: widget.color ?? Colors.grey, borderRadius: BorderRadius.circular(50)),
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
