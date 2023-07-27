import 'dart:math';

double degreesToRadians(double degrees) => degrees * pi / 180;

double cosDegrees(double degrees) => cos(degreesToRadians(degrees));

double sinDegrees(double degrees) => sin(degreesToRadians(degrees));
