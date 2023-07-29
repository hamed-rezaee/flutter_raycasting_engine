import 'package:flutter/material.dart';
import 'package:flutter_raycasting/data.dart';

import 'calculation_helpers.dart';
import 'textures.dart';

void drawMiniMap({
  required Canvas canvas,
  required List<List<int>> map,
  required double scale,
}) {
  for (int i = 0; i < map.length; i++) {
    for (int j = 0; j < map.first.length; j++) {
      if (map[i][j] > 0) {
        canvas.drawRect(
          Rect.fromLTRB(
            j * scale,
            i * scale,
            j * scale + scale,
            i * scale + scale,
          ),
          Paint()..color = Colors.orange,
        );
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
      Paint()..color = Colors.white.withOpacity(0.3),
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
  required List<List<int>> map,
}) =>
    canvas.drawLine(
      Offset(rayCount.toDouble(), height / 2 - wallHeight),
      Offset(rayCount.toDouble(), height / 2 + wallHeight),
      Paint()
        ..color = getShadowedColor(Colors.red, distance, map.length.toDouble())
        ..strokeWidth = 1,
    );

void drawTexture({
  required Canvas canvas,
  required Offset ray,
  required int rayCount,
  required double wallHeight,
  required double distance,
  required double height,
  required BitmapTexture texture,
}) {
  final int texturePositionX =
      (texture.width * (ray.dx + ray.dy) % texture.width).floor();
  final double yIncrement = wallHeight * 2 / texture.height;

  double y = height / 2 - wallHeight;

  for (int i = 0; i < texture.height; i++) {
    final int textureColorIndex = texture.bitmap[i][texturePositionX];
    final Color wallColor = texture.colors[textureColorIndex];

    final Paint wallPainter = Paint()
      ..color = getShadowedColor(
        wallColor,
        distance,
        MapInfo.data.length.toDouble(),
      )
      ..strokeWidth = 1;

    canvas.drawLine(
      Offset(rayCount.toDouble(), y),
      Offset(rayCount.toDouble(), y + yIncrement + 0.5),
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
