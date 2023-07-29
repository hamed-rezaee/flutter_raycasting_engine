import 'package:flutter/material.dart';

class Screen {
  static const double width = 640;
  static const double height = 480;
  static const double halfWidth = width / 2;
  static const double halfHeight = height / 2;
  static const double scale = 2;
}

class MiniMap {
  static const double scale = 16 / Screen.scale;
}

class Projection {
  static const double width = Screen.width / Screen.scale;
  static const double height = Screen.height / Screen.scale;
  static const double halfWidth = width / 2;
  static const double halfHeight = height / 2;
}

class RayCasting {
  static const double increment = Player.fov / Projection.width;
  static const int precision = 32;
}

class Player {
  static Offset position = const Offset(5, 7);
  static double angle = 0;

  static const double fov = 60;
  static const double halfFov = fov / 2;
  static const double radius = 10;
  static const double speed = 0.2;
  static const double rotationSpeed = 3;
}

class MapInfo {
  static const List<List<int>> data = <List<int>>[
    <int>[1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    <int>[1, 0, 0, 0, 0, 0, 0, 0, 0, 1],
    <int>[1, 0, 1, 1, 1, 0, 1, 0, 0, 1],
    <int>[1, 0, 0, 0, 0, 0, 1, 1, 0, 1],
    <int>[1, 0, 1, 1, 0, 0, 1, 0, 0, 1],
    <int>[1, 0, 1, 0, 0, 1, 1, 0, 0, 1],
    <int>[1, 0, 1, 0, 0, 0, 0, 0, 0, 1],
    <int>[1, 0, 1, 0, 0, 0, 0, 0, 0, 1],
    <int>[1, 0, 1, 0, 0, 1, 0, 1, 1, 1],
    <int>[1, 0, 0, 0, 0, 0, 0, 1, 0, 1],
    <int>[1, 1, 1, 1, 1, 1, 0, 1, 0, 1],
    <int>[1, 0, 0, 0, 1, 0, 0, 1, 0, 1],
    <int>[1, 0, 0, 0, 0, 0, 0, 0, 0, 1],
    <int>[1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
  ];
}

class BitmapTexture {
  static const double width = 8;
  static const double height = 8;
  static const List<Color> colors = <Color>[
    Color.fromARGB(255, 255, 241, 232),
    Color.fromARGB(255, 194, 195, 199),
  ];
  static const List<List<int>> bitmap = <List<int>>[
    <int>[1, 1, 1, 1, 1, 1, 1, 1],
    <int>[0, 0, 0, 1, 0, 0, 0, 1],
    <int>[1, 1, 1, 1, 1, 1, 1, 1],
    <int>[0, 1, 0, 0, 0, 1, 0, 0],
    <int>[1, 1, 1, 1, 1, 1, 1, 1],
    <int>[0, 0, 0, 1, 0, 0, 0, 1],
    <int>[1, 1, 1, 1, 1, 1, 1, 1],
    <int>[0, 1, 0, 0, 0, 1, 0, 0]
  ];
}
