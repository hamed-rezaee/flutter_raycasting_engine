import 'dart:math';
import 'dart:ui';

import 'data.dart';

double degreesToRadians(double degrees) => degrees * pi / 180;

double cosDegrees(double degrees) => cos(degreesToRadians(degrees));

double sinDegrees(double degrees) => sin(degreesToRadians(degrees));

double getDistance(Offset a, Offset b) =>
    sqrt(pow(a.dx - b.dx, 2) + pow(a.dy - b.dy, 2));

double getAngle(Offset a, Offset b) => atan2(b.dy - a.dy, b.dx - a.dx);

Color getShadowedColor(Color color, double distance, double maxDistance) {
  final double normalizedDistance = distance / maxDistance;
  final double shadowIntensity = lerpDouble(1.0, 0.0, normalizedDistance)!;

  final Color shadowedWallColor = Color.fromARGB(
    color.alpha,
    (color.red * shadowIntensity).toInt(),
    (color.green * shadowIntensity).toInt(),
    (color.blue * shadowIntensity).toInt(),
  );

  return shadowedWallColor;
}

List<Offset> calculateRaycasts() {
  final List<Offset> rays = <Offset>[];

  double rayAngle = Player.angle - Player.halfFov;

  for (int rayCount = 0; rayCount < Projection.width; rayCount++) {
    Offset ray = Player.position;

    final double rayCos = cosDegrees(rayAngle) / RayCasting.precision;
    final double raySin = sinDegrees(rayAngle) / RayCasting.precision;

    while (true) {
      ray = Offset(ray.dx + rayCos, ray.dy + raySin);

      if (MapInfo.data[ray.dy.toInt()][ray.dx.toInt()] > 0) {
        break;
      }
    }

    rays.add(ray);

    rayAngle += RayCasting.increment;
  }

  return rays;
}
