import 'package:flutter/material.dart';

import 'data.dart';
import 'helpers.dart';

class RayCastingPainter extends CustomPainter {
  RayCastingPainter({
    required this.playerPosition,
    required this.playerRotation,
  }) {
    Player.position = playerPosition;
    Player.angle = playerRotation;
  }

  final Offset playerPosition;
  final double playerRotation;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(Screen.scale, Screen.scale);

    final List<Offset> rays = calculateRaycasts();

    for (int rayCount = 0; rayCount < rays.length; rayCount++) {
      final double distance = getDistance(playerPosition, rays[rayCount]);
      final double rayAngle =
          Player.angle - Player.halfFov + (rayCount * RayCasting.increment);
      final double correctedDistance =
          distance * cosDegrees(rayAngle - Player.angle);
      final double wallHeight =
          (Projection.halfHeight / correctedDistance).floorToDouble();

      _drawSky(canvas, rayCount, wallHeight);

      // _drawWalls(canvas, rayCount, wallHeight);

      _drawTexture(
        canvas,
        rays[rayCount],
        rayCount,
        wallHeight,
        correctedDistance,
      );

      _drawGround(canvas, rayCount, wallHeight);
    }
  }

  void _drawSky(Canvas canvas, int rayCount, double wallHeight) =>
      canvas.drawLine(
        Offset(rayCount.toDouble(), 0),
        Offset(rayCount.toDouble(), Projection.halfHeight - wallHeight),
        Paint()
          ..color = Colors.blue.shade900
          ..strokeWidth = 1,
      );

  // void _drawWalls(Canvas canvas, int rayCount, double wallHeight) =>
  //     canvas.drawLine(
  //       Offset(rayCount.toDouble(), Projection.halfHeight - wallHeight),
  //       Offset(rayCount.toDouble(), Projection.halfHeight + wallHeight),
  //       Paint()
  //         ..color = Colors.red
  //         ..strokeWidth = 1,
  //     );

  void _drawTexture(
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

  void _drawGround(Canvas canvas, int rayCount, double wallHeight) =>
      canvas.drawLine(
        Offset(rayCount.toDouble(), Projection.halfHeight + wallHeight),
        Offset(rayCount.toDouble(), Projection.height),
        Paint()
          ..color = Colors.green
          ..strokeWidth = 1,
      );

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
