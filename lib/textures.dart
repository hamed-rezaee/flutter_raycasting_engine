import 'package:flutter/material.dart';

class BitmapTexture {
  BitmapTexture({
    required this.colors,
    required this.bitmap,
    this.width = 8,
    this.height = 8,
  });

  final double width;
  final double height;
  final List<Color> colors;
  final List<List<int>> bitmap;
}

BitmapTexture brickTexture = BitmapTexture(colors: <Color>[
  const Color.fromARGB(255, 255, 241, 232),
  const Color.fromARGB(255, 194, 195, 199),
], bitmap: <List<int>>[
  <int>[1, 1, 1, 1, 1, 1, 1, 1],
  <int>[0, 0, 0, 1, 0, 0, 0, 1],
  <int>[1, 1, 1, 1, 1, 1, 1, 1],
  <int>[0, 1, 0, 0, 0, 1, 0, 0],
  <int>[1, 1, 1, 1, 1, 1, 1, 1],
  <int>[0, 0, 0, 1, 0, 0, 0, 1],
  <int>[1, 1, 1, 1, 1, 1, 1, 1],
  <int>[0, 1, 0, 0, 0, 1, 0, 0]
]);
