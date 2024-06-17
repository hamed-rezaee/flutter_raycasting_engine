import 'package:flutter/material.dart';

class Screen {
  static double width = 640;
  static double height = 480;
  static double halfWidth = width / 2;
  static double halfHeight = height / 2;
  static const double scale = 2;
}

class MiniMap {
  static const double scale = 18 / Screen.scale;
}

class Projection {
  static double width = Screen.width / Screen.scale;
  static double height = Screen.height / Screen.scale;
  static double halfWidth = width / 2;
  static double halfHeight = height / 2;
}

class RayCasting {
  static const int precision = 64;
}

class Player {
  static Offset position = const Offset(2, 2);
  static double _angle = 45;

  static const double fov = 60;
  static const double radius = 10;
  static const double speed = 0.2;
  static const double rotationSpeed = 8;

  static double get angle => _angle;

  static set angle(double value) {
    _angle = value;

    if (_angle > 360) {
      _angle -= 360;
    } else if (_angle < 0) {
      _angle += 360;
    }
  }
}

class MapInfo {
  static const List<List<int>> data = <List<int>>[
    <int>[4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4],
    <int>[4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4],
    <int>[4, 0, 0, 2, 2, 2, 2, 2, 0, 0, 3, 3, 3, 0, 0, 4],
    <int>[4, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 0, 3, 0, 0, 4],
    <int>[4, 0, 0, 0, 0, 9, 0, 0, 0, 0, 0, 0, 3, 0, 0, 4],
    <int>[4, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 1],
    <int>[4, 0, 0, 2, 2, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 4],
    <int>[4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4],
    <int>[4, 0, 0, 4, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 4],
    <int>[4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4],
  ];

  static const Map<int, String> textureMapping = <int, String>{
    0: 'grass',
    1: 'portal',
    2: 'wall_stone',
    3: 'wall_green',
    4: 'wall_brick',
  };
}

class BitmapTexture {
  BitmapTexture(this.bitmap);

  final List<List<Color>> bitmap;
}
