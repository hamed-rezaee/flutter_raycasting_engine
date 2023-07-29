import 'package:flutter/material.dart';

class Screen {
  static const double width = 640;
  static const double height = 480;
  static const double halfWidth = width / 2;
  static const double halfHeight = height / 2;
  static const double scale = 2;
}

class MiniMap {
  static const double scale = 18 / Screen.scale;
}

class Projection {
  static const double width = Screen.width / Screen.scale;
  static const double height = Screen.height / Screen.scale;
  static const double halfWidth = width / 2;
  static const double halfHeight = height / 2;
}

class RayCasting {
  static const int precision = 64;
}

class Player {
  static Offset position = const Offset(2, 2);
  static double angle = 45;

  static const double fov = 60;
  static const double radius = 10;
  static const double speed = 0.2;
  static const double rotationSpeed = 3;
}

class MapInfo {
  static const List<List<int>> data = <List<int>>[
    <int>[1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    <int>[1, 0, 0, 0, 0, 2, 0, 0, 0, 1],
    <int>[1, 0, 0, 0, 0, 2, 0, 9, 0, 1],
    <int>[1, 0, 0, 0, 0, 2, 0, 0, 0, 1],
    <int>[1, 0, 0, 0, 0, 2, 2, 0, 2, 1],
    <int>[1, 0, 0, 0, 0, 0, 0, 0, 0, 1],
    <int>[1, 5, 5, 5, 0, 0, 0, 0, 0, 1],
    <int>[1, 0, 0, 4, 0, 0, 0, 0, 0, 1],
    <int>[1, 0, 0, 5, 0, 0, 0, 0, 0, 1],
    <int>[1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
  ];

  static const Map<int, String> textureMapping = <int, String>{
    0: 'grass',
    1: 'brick',
    2: 'stone',
    3: 'door',
    4: 'portal',
    5: 'wall_with_leaves',
  };
}

class BitmapTexture {
  BitmapTexture(this.bitmap);

  final List<List<Color>> bitmap;
}
