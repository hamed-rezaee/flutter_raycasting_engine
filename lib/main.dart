import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:statsfl/statsfl.dart';

import 'data.dart';
import 'helpers/calculation_helpers.dart';
import 'helpers/texture_helpers.dart';
import 'painters/map_painter.dart';
import 'painters/ray_casting_painter.dart';

Map<String, BitmapTexture> textures = <String, BitmapTexture>{};

void main() =>
    runApp(StatsFl(align: Alignment.topRight, child: const MainApp()));

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Completer<void> isTextureLoaded = Completer<void>();

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

    SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    loadTextures().then((Map<String, BitmapTexture> result) {
      textures = result;

      isTextureLoaded.complete();
    });
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          body: FutureBuilder<void>(
            future: isTextureLoaded.future,
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              return RawKeyboardListener(
                focusNode: FocusNode(),
                onKey: _handleKeyPress,
                child: OrientationBuilder(
                  builder: (BuildContext context, Orientation orientation) {
                    Screen.width = MediaQuery.sizeOf(context).width;
                    Screen.height = MediaQuery.sizeOf(context).height;

                    return Stack(
                      children: <Widget>[
                        CustomPaint(
                          size: Size(Screen.width, Screen.height),
                          painter: RayCastingPainter(
                            playerPosition: Player.position,
                            playerRotation: Player.angle,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          left: 8,
                          child: CustomPaint(
                            size: Size(Screen.width, Screen.height),
                            painter: MapPainter(
                              playerPosition: Player.position,
                              playerRotation: Player.angle,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                iconSize: Screen.height / 6,
                                icon: const Icon(
                                  Icons.rotate_left,
                                  color: Colors.white,
                                ),
                                onPressed: rotateLeft,
                              ),
                              const SizedBox(width: 16),
                              IconButton(
                                iconSize: Screen.height / 6,
                                icon: const Icon(
                                  Icons.arrow_upward,
                                  color: Colors.white,
                                ),
                                onPressed: moveUp,
                              ),
                              const SizedBox(width: 16),
                              IconButton(
                                iconSize: Screen.height / 6,
                                icon: const Icon(
                                  Icons.arrow_downward,
                                  color: Colors.white,
                                ),
                                onPressed: moveDown,
                              ),
                              const SizedBox(width: 16),
                              IconButton(
                                iconSize: Screen.height / 6,
                                icon: const Icon(
                                  Icons.rotate_right,
                                  color: Colors.white,
                                ),
                                onPressed: rotateRight,
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  },
                ),
              );
            },
          ),
        ),
      );

  void _handleKeyPress(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        rotateLeft();
      }

      if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        rotateRight();
      }

      if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        moveUp();
      }

      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
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
