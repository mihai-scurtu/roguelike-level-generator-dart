library rectangle;

import 'package:level_generator/point.dart';

class Rectangle implements Comparable {
  num x;
  num y;
  num width;
  num height;

  Point opposingCorner;

  Rectangle(this.x, this.y, this.width, this.height) {
    this.opposingCorner = new Point(this.x + this.height - 2, this.y + this.width - 2);
  }

  bool containsPoint(Point p) => this.contains(p.x, p.y);

  bool contains(int x, int y)
    => x >= this.x && y >= this.y
      && x <= this.opposingCorner.x && y <= this.opposingCorner.y;

  num get area => this.width.abs() * this.height.abs();

  bool get isNull => this.width == 0 || this.height == 0;

  bool operator==(Rectangle o)
    => o is Rectangle && x == o.x && y == o.y && width == o.width && height == o.height;

  @override
  int compareTo(other) {
    return (this.x + this.y).compareTo(other.x + other.y);
  }
}