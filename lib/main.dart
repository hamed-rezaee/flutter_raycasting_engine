import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'data.dart';
import 'calculation_helpers.dart';
import 'ray_casting_painter.dart';

void main() => runApp(const MainApp());

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          body: RawKeyboardListener(
            focusNode: FocusNode(),
            onKey: _handleKeyPress,
            child: ClipRect(
              child: SizedBox(
                width: Screen.width,
                height: Screen.height,
                child: Stack(
                  children: <Widget>[
                    CustomPaint(
                      size: const Size(Screen.width, Screen.height),
                      painter: RayCastingPainter(
                        playerPosition: Player.position,
                        playerRotation: Player.angle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextButton(
                onPressed: moveUp,
                child: const Icon(Icons.arrow_upward, color: Colors.black),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: moveDown,
                child: const Icon(Icons.arrow_downward, color: Colors.black),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: rotateLeft,
                child: const Icon(Icons.rotate_left, color: Colors.black),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: rotateRight,
                child: const Icon(Icons.rotate_right, color: Colors.black),
              ),
            ],
          ),
        ),
      );

  void _handleKeyPress(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        rotateLeft();
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        rotateRight();
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        moveUp();
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        moveDown();
      }
    }
  }

  void moveUp() {
    Player.position += Offset(
      cosDegrees(Player.angle) * Player.speed,
      sinDegrees(Player.angle) * Player.speed,
    );

    if (_isInsideWall()) {
      Player.position -= Offset(
        cosDegrees(Player.angle) * Player.speed,
        sinDegrees(Player.angle) * Player.speed,
      );
    }

    setState(() {});
  }

  void moveDown() {
    Player.position -= Offset(
      cosDegrees(Player.angle) * Player.speed,
      sinDegrees(Player.angle) * Player.speed,
    );

    if (_isInsideWall()) {
      Player.position += Offset(
        cosDegrees(Player.angle) * Player.speed,
        sinDegrees(Player.angle) * Player.speed,
      );
    }

    setState(() {});
  }

  void rotateLeft() {
    Player.angle -= Player.rotationSpeed;

    setState(() {});
  }

  void rotateRight() {
    Player.angle += Player.rotationSpeed;

    setState(() {});
  }

  bool _isInsideWall() =>
      MapInfo.data[Player.position.dy.floor()][Player.position.dx.floor()] > 0;
}
