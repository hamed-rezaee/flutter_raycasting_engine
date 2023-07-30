import 'dart:math';
import 'dart:ui';

double degreesToRadians(double degrees) => degrees * pi / 180;

double cosDegrees(double degrees) => cos(degreesToRadians(degrees));

double sinDegrees(double degrees) => sin(degreesToRadians(degrees));

double getDistance(Offset a, Offset b) =>
    sqrt(pow(a.dx - b.dx, 2) + pow(a.dy - b.dy, 2));

Color getShadowedColor(Color color, double distance) {
  final Color shadowedWallColor = Color.fromARGB(
    color.alpha,
    (color.red / (1 + (pow(distance, 4) * 0.0007))).floor(),
    (color.green / (1 + (pow(distance, 4) * 0.0007))).floor(),
    (color.blue / (1 + (pow(distance, 4) * 0.0007))).floor(),
  );

  return shadowedWallColor;
}

int getMapValue(Offset position, List<List<int>> map) =>
    map[position.dy.floor()][position.dx.floor()];

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

    while (getMapValue(ray, map) == 0) {
      ray = Offset(ray.dx + rayCos, ray.dy + raySin);
    }

    rays.add(ray);

    rayAngle += fov / width;
  }

  return rays;
}
