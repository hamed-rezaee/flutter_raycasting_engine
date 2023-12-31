import 'package:flutter/material.dart';
import 'package:flutter_raycasting/main.dart';

import '../data.dart';
import '../helpers/calculation_helpers.dart';
import '../helpers/drawing_helpers.dart';

class RayCastingPainter extends CustomPainter {
  RayCastingPainter({
    required Offset playerPosition,
    required double playerRotation,
  }) {
    Player.position = playerPosition;
    Player.angle = playerRotation;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(Screen.scale, Screen.scale);

    final List<Offset> rays = calculateRaycasts(
      playerPosition: Player.position,
      playerAngle: Player.angle,
      fov: Player.fov,
      precision: RayCasting.precision,
      width: Projection.width,
      map: MapInfo.data,
    );

    for (int rayCount = 0; rayCount < rays.length; rayCount++) {
      const double halfFov = Player.fov / 2;

      final double increment = Player.fov / Projection.width;

      final double distance = getDistance(Player.position, rays[rayCount]);
      final double rayAngle = Player.angle - halfFov + (rayCount * increment);
      final double correctedDistance =
          distance * cosDegrees(rayAngle - Player.angle);
      final double wallHeight =
          (Projection.halfHeight / correctedDistance).floorToDouble();

      drawBackground(
        canvas: canvas,
        x: rayCount,
        y1: 0,
        y2: Projection.halfHeight - wallHeight,
        texture: textures['background']!,
      );

      drawTexture(
        canvas: canvas,
        ray: rays[rayCount],
        rayCount: rayCount,
        wallHeight: wallHeight,
        distance: distance,
        height: Projection.height,
        textures: textures,
        textureMapping: MapInfo.textureMapping,
      );

      // drawWalls(
      //   canvas: canvas,
      //   rayCount: rayCount,
      //   wallHeight: wallHeight,
      //   distance: distance,
      //   height: Projection.height,
      //   map: MapInfo.data,
      // );

      drawGround(
        canvas: canvas,
        rayCount: rayCount,
        wallHeight: wallHeight,
        height: Projection.height,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
