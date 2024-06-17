import 'package:flutter/material.dart';
import 'package:flutter_raycasting/data.dart';
import 'package:flutter_raycasting/helpers/calculation_helpers.dart';
import 'package:flutter_raycasting/helpers/drawing_helpers.dart';
import 'package:flutter_raycasting/main.dart';

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

    final rays = calculateRaycasts(
      playerPosition: Player.position,
      playerAngle: Player.angle,
      fov: Player.fov,
      precision: RayCasting.precision,
      width: Projection.width,
      map: MapInfo.data,
    );

    for (var rayCount = 0; rayCount < rays.length; rayCount++) {
      const halfFov = Player.fov / 2;

      final increment = Player.fov / Projection.width;

      final distance = getDistance(Player.position, rays[rayCount]);
      final rayAngle = Player.angle - halfFov + (rayCount * increment);
      final correctedDistance = distance * cosDegrees(rayAngle - Player.angle);
      final wallHeight =
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
