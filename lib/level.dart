library level;

import 'package:matrix/matrix.dart';
import 'package:level_generator/tile.dart';
import 'package:level_generator/point.dart';
import 'package:level_generator/tile_type.dart';
import 'package:level_generator/rectangle.dart';

class Level extends Rectangle {
  Matrix<Tile> tiles;

  Level(int width, int height, [TileType tileType]) : super(0, 0, width, height) {
    this.tiles = new Matrix<Tile>(height, width);
    this.fill(tileType);
  }

  void fill(TileType type) {
    this.tiles.forEach((tile, i, j) {
      if(tile == null) {
        tile = new Tile(i, j, type);
        this.tiles.set(i, j, tile);
      } else {
        tile.x = i;
        tile.y = j;
        tile.type = type;
      }
    });
  }

  List<Tile> getNeighbours(Point p) {
    int i, j;

    List<Point> list;

    for(i = -1; i < 2; i++) {
      for(j = -1; j < 2; j++) {
        Point neighbour = new Point(p.x + i, p.y = j);
        if(this.containsPoint(neighbour)) {
          list.add(neighbour);
        }
      }
    }

    return list;
  }
}
