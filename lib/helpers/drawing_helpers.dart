import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_raycasting/data.dart';

import 'calculation_helpers.dart';

void drawMiniMap({
  required Canvas canvas,
  required List<List<int>> map,
  required double scale,
  required Map<String, BitmapTexture> textures,
  required Map<int, String> textureMapping,
}) {
  for (int i = 0; i < map.length; i++) {
    for (int j = 0; j < map.first.length; j++) {
      final BitmapTexture texture =
          textures[textureMapping[map[i][j]]] ?? textures['unknown']!;
      final int textureWidth = texture.bitmap.first.length;
      final int textureHeight = texture.bitmap.length;

      for (int y = 0; y < textureHeight; y++) {
        for (int x = 0; x < textureWidth; x++) {
          canvas.drawRect(
            Rect.fromLTRB(
              j * scale + x * scale / textureWidth,
              i * scale + y * scale / textureHeight,
              j * scale + x * scale / textureWidth + scale / textureWidth,
              i * scale + y * scale / textureHeight + scale / textureHeight,
            ),
            Paint()
              ..color = texture.bitmap[y][x]
              ..style = PaintingStyle.fill,
          );
        }
      }

      canvas.drawRect(
        Rect.fromLTRB(
          j * scale,
          i * scale,
          j * scale + scale,
          i * scale + scale,
        ),
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke,
      );
    }
  }
}

void drawMiniMapRays({
  required Canvas canvas,
  required Offset playerPosition,
  required List<Offset> rays,
  required double scale,
}) {
  for (int rayCount = 0; rayCount < rays.length; rayCount++) {
    canvas.drawLine(
      playerPosition * scale,
      rays[rayCount] * scale,
      Paint()..color = Colors.white.withOpacity(0.2),
    );
  }
}

void drawMiniMapPlayer({
  required Canvas canvas,
  required Offset playerPosition,
  required double playerAngle,
  required double scale,
}) {
  canvas.drawLine(
    playerPosition * scale,
    (playerPosition +
            Offset(cosDegrees(playerAngle), sinDegrees(playerAngle))) *
        scale,
    Paint()
      ..color = Colors.black
      ..strokeWidth = scale * 0.3,
  );

  canvas.drawCircle(
    playerPosition * scale,
    scale * 0.3,
    Paint()..color = Colors.orange,
  );

  canvas.drawCircle(
    playerPosition * scale,
    scale * 0.3,
    Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = scale * 0.2,
  );
}

void drawSky({
  required Canvas canvas,
  required int rayCount,
  required double wallHeight,
  required double height,
}) =>
    canvas.drawLine(
      Offset(rayCount.toDouble(), 0),
      Offset(rayCount.toDouble(), height / 2 - wallHeight),
      Paint()
        ..color = Colors.indigo
        ..strokeWidth = 1,
    );

void drawWalls({
  required Canvas canvas,
  required int rayCount,
  required double wallHeight,
  required double distance,
  required double height,
}) =>
    canvas.drawLine(
      Offset(rayCount.toDouble(), height / 2 - wallHeight - 1),
      Offset(rayCount.toDouble(), height / 2 + wallHeight + 1),
      Paint()
        ..color = getShadowedColor(Colors.red, distance)
        ..strokeWidth = 1,
    );

void drawTexture({
  required Canvas canvas,
  required Offset ray,
  required int rayCount,
  required double wallHeight,
  required double distance,
  required double height,
  required Map<String, BitmapTexture> textures,
  required Map<int, String> textureMapping,
}) {
  final int mapValue = getMapValue(ray, MapInfo.data);
  final BitmapTexture texture =
      textures[MapInfo.textureMapping[mapValue]] ?? textures['unknown']!;

  final int textureWidth = texture.bitmap.first.length;
  final int textureHeight = texture.bitmap.length;

  final int texturePositionX =
      (textureWidth * (ray.dx + ray.dy) % textureWidth).floor();
  final double yIncrement = wallHeight * 2 / textureHeight;

  double y = height / 2 - wallHeight;

  for (int i = 0; i < textureHeight; i++) {
    final Color textureColor = texture.bitmap[i][texturePositionX];

    final Paint wallPainter = Paint()
      ..color = getShadowedColor(
        textureColor,
        distance,
      )
      ..strokeWidth = 1;

    canvas.drawLine(
      Offset(rayCount.toDouble(), y - 1),
      Offset(rayCount.toDouble(), y + yIncrement + 1),
      wallPainter,
    );

    y += yIncrement;
  }
}

void drawGround({
  required Canvas canvas,
  required int rayCount,
  required double wallHeight,
  required double height,
}) =>
    canvas.drawLine(
      Offset(rayCount.toDouble(), height / 2 + wallHeight),
      Offset(rayCount.toDouble(), Projection.height),
      Paint()
        ..color = Colors.green
        ..strokeWidth = 1,
    );

void drawBackground({
  required Canvas canvas,
  required int x,
  required double y1,
  required double y2,
  required BitmapTexture texture,
}) {
  final double offset = Player.angle + x;

  for (int y = y1.toInt(); y < y2; y++) {
    final int texturePositionX =
        (texture.bitmap.first.length * (offset % 360) / 360).floor();
    final int texturePositionY =
        (texture.bitmap.length * (y % Projection.height) / Projection.height)
            .floor();

    canvas.drawPoints(
      PointMode.points,
      <Offset>[Offset(x.toDouble(), y.toDouble())],
      Paint()
        ..color = texture.bitmap[texturePositionY][texturePositionX]
        ..strokeWidth = 1,
    );
  }
}
