library point;

import 'dart:math' as Math;

import 'package:quiver/core.dart';

class Point {
  num x;
  num y;

  Point(this.x, this.y);

  static int diagonalDistance(Point p1, Point p2)
    => Math.max((p1.x - p2.x).abs(), (p1.y - p2.y).abs());

  bool operator ==(o) => o is Point && x == o.x && y == o.y;
  int get hashCode => hash2(x.hashCode, y.hashCode);
}