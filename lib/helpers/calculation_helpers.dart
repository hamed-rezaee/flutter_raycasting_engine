import 'dart:math';
import 'dart:ui';

double degreesToRadians(double degrees) => degrees * pi / 180;

double cosDegrees(double degrees) => cos(degreesToRadians(degrees));

double sinDegrees(double degrees) => sin(degreesToRadians(degrees));

double getDistance(Offset a, Offset b) =>
    sqrt(pow(a.dx - b.dx, 2) + pow(a.dy - b.dy, 2));

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

List<Offset> calculateRaycasts({
  required Offset playerPosition,
  required double playerAngle,
  required double fov,
  required int precision,
  required double width,
  required List<List<int>> map,
}) {
  final List<Offset> rays = <Offset>[];

  double rayAngle = playerAngle - fov / 2;

  for (int rayCount = 0; rayCount < width; rayCount++) {
    Offset ray = playerPosition;

    final double rayCos = cosDegrees(rayAngle) / precision;
    final double raySin = sinDegrees(rayAngle) / precision;

    while (true) {
      ray = Offset(ray.dx + rayCos, ray.dy + raySin);

      if (map[ray.dy.floor()][ray.dx.floor()] > 0) {
        break;
      }
    }

    rays.add(ray);

    rayAngle += fov / width;
  }

  return rays;
}
