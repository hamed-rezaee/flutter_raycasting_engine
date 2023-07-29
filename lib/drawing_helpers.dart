import 'package:flutter/material.dart';

import 'calculation_helpers.dart';
import 'data.dart';

void drawMiniMap(Canvas canvas) {
  for (int i = 0; i < MapInfo.data.length; i++) {
    for (int j = 0; j < MapInfo.data.first.length; j++) {
      if (MapInfo.data[i][j] > 0) {
        canvas.drawRect(
          Rect.fromLTRB(
            j * MiniMap.scale,
            i * MiniMap.scale,
            j * MiniMap.scale + MiniMap.scale,
            i * MiniMap.scale + MiniMap.scale,
          ),
          Paint()..color = Colors.orange,
        );
      }

      canvas.drawRect(
        Rect.fromLTRB(
          j * MiniMap.scale,
          i * MiniMap.scale,
          j * MiniMap.scale + MiniMap.scale,
          i * MiniMap.scale + MiniMap.scale,
        ),
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke,
      );
    }
  }
}

void drawRays(Canvas canvas, List<Offset> rays) {
  for (int rayCount = 0; rayCount < rays.length; rayCount++) {
    canvas.drawLine(
      Player.position * MiniMap.scale,
      rays[rayCount] * MiniMap.scale,
      Paint()..color = Colors.white.withOpacity(0.3),
    );
  }
}

void drawPlayer(Canvas canvas) {
  canvas.drawLine(
    Player.position * MiniMap.scale,
    (Player.position +
            Offset(cosDegrees(Player.angle), sinDegrees(Player.angle))) *
        MiniMap.scale,
    Paint()
      ..color = Colors.black
      ..strokeWidth = MiniMap.scale * 0.3,
  );

  canvas.drawCircle(
    Player.position * MiniMap.scale,
    MiniMap.scale * 0.3,
    Paint()..color = Colors.orange,
  );

  canvas.drawCircle(
    Player.position * MiniMap.scale,
    MiniMap.scale * 0.3,
    Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = MiniMap.scale * 0.2,
  );
}

void drawSky(Canvas canvas, int rayCount, double wallHeight) => canvas.drawLine(
      Offset(rayCount.toDouble(), 0),
      Offset(rayCount.toDouble(), Projection.halfHeight - wallHeight),
      Paint()
        ..color = Colors.indigo
        ..strokeWidth = 1,
    );

void drawWalls(
  Canvas canvas,
  int rayCount,
  double wallHeight,
  double distance,
) =>
    canvas.drawLine(
      Offset(rayCount.toDouble(), Projection.halfHeight - wallHeight),
      Offset(rayCount.toDouble(), Projection.halfHeight + wallHeight),
      Paint()
        ..color = getShadowedColor(
          Colors.red,
          distance,
          MapInfo.data.length.toDouble(),
        )
        ..strokeWidth = 1,
    );

void drawTexture(
  Canvas canvas,
  Offset ray,
  int rayCount,
  double wallHeight,
  double distance,
) {
  final int texturePositionX =
      (BitmapTexture.width * (ray.dx + ray.dy) % BitmapTexture.width).floor();
  final double yIncrement = wallHeight * 2 / BitmapTexture.height;

  double y = Projection.halfHeight - wallHeight;

  for (int i = 0; i < BitmapTexture.height; i++) {
    final int textureColorIndex = BitmapTexture.bitmap[i][texturePositionX];
    final Color wallColor = BitmapTexture.colors[textureColorIndex];

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

void drawGround(Canvas canvas, int rayCount, double wallHeight) =>
    canvas.drawLine(
      Offset(rayCount.toDouble(), Projection.halfHeight + wallHeight),
      Offset(rayCount.toDouble(), Projection.height),
      Paint()
        ..color = Colors.green
        ..strokeWidth = 1,
    );
