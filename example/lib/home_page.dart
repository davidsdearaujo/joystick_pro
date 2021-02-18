import 'package:flutter/material.dart';
import 'package:joystick_pro/joystick_pro.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var state = JoystickState.empty();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Center(
            child: JoystickWidget(
              size: 100,
              onUpdate: (state) {
                setState(() => this.state = state);
              },
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("x: ${state.x}"),
                Text("y: ${state.y}"),
                Text("dx: ${state.dx}"),
                Text("dy: ${state.dy}"),
                Text("size: ${state.size}"),
                Text("isTop: ${state.isTop}"),
                Text("isLeft: ${state.isLeft}"),
                Text("isRight: ${state.isRight}"),
                Text("isBottom: ${state.isBottom}"),
              ],
            ),
          )
        ],
      ),
    );
  }
}
