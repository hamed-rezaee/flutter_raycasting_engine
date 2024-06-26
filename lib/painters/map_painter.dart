import 'package:flutter/material.dart';
import 'package:flutter_raycasting/data.dart';
import 'package:flutter_raycasting/helpers/calculation_helpers.dart';
import 'package:flutter_raycasting/helpers/drawing_helpers.dart';
import 'package:flutter_raycasting/main.dart';

class MapPainter extends CustomPainter {
  MapPainter({
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

    drawMiniMap(
      canvas: canvas,
      map: MapInfo.data,
      scale: MiniMap.scale,
      textures: textures,
      textureMapping: MapInfo.textureMapping,
    );

    drawMiniMapRays(
      canvas: canvas,
      playerPosition: Player.position,
      rays: rays,
      scale: MiniMap.scale,
    );

    drawMiniMapPlayer(
      canvas: canvas,
      playerPosition: Player.position,
      playerAngle: Player.angle,
      scale: MiniMap.scale,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
