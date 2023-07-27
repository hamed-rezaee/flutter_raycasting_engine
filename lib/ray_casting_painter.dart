import 'dart:math';

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

    double rayAngle = Player.angle - Player.halfFov;

    for (int rayCount = 0; rayCount < Projection.width; rayCount++) {
      Offset ray = Player.position;

      final rayCos = cosDegrees(rayAngle) / RayCasting.precision;
      final raySin = sinDegrees(rayAngle) / RayCasting.precision;

      while (true) {
        ray = Offset(ray.dx + rayCos, ray.dy + raySin);

        if (MapInfo.data[ray.dy.toInt()][ray.dx.toInt()] > 0) {
          break;
        }
      }

      double distance = sqrt(pow(Player.position.dx - ray.dx, 2) +
          pow(Player.position.dy - ray.dy, 2));
      distance = distance * cosDegrees(rayAngle - Player.angle);

      final double wallHeight =
          (Projection.halfHeight / distance).floorToDouble();

      canvas.drawLine(
        Offset(rayCount.toDouble(), 0),
        Offset(rayCount.toDouble(), Projection.halfHeight - wallHeight),
        Paint()
          ..color = Colors.black
          ..strokeWidth = Screen.scale,
      );

      // canvas.drawLine(
      //   Offset(rayCount.toDouble(), Projection.halfHeight - wallHeight),
      //   Offset(rayCount.toDouble(), Projection.halfHeight + wallHeight),
      //   Paint()
      //     ..color = Colors.red
      //     ..strokeWidth = Screen.scale,
      // );

      int texturePositionX =
          (BitmapTexture.width * (ray.dx + ray.dy) % BitmapTexture.width)
              .floor();

      _drwaTexture(
        canvas,
        rayCount,
        wallHeight,
        texturePositionX,
      );

      canvas.drawLine(
        Offset(rayCount.toDouble(), Projection.halfHeight + wallHeight),
        Offset(rayCount.toDouble(), Projection.height),
        Paint()
          ..color = Colors.green
          ..strokeWidth = Screen.scale,
      );

      rayAngle += RayCasting.increment;
    }
  }

  void _drwaTexture(
    Canvas canvas,
    int rayCount,
    double wallHeight,
    int texturePositionX,
  ) {
    double yIncrement = wallHeight * 2 / BitmapTexture.height;
    double y = Projection.halfHeight - wallHeight;

    for (int i = 0; i < BitmapTexture.height; i++) {
      canvas.drawLine(
        Offset(rayCount.toDouble(), y),
        Offset(rayCount.toDouble(), y + yIncrement + 0.5),
        Paint()
          ..color =
              BitmapTexture.colors[BitmapTexture.bitmap[i][texturePositionX]]
          ..strokeWidth = Screen.scale,
      );

      y += yIncrement;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
