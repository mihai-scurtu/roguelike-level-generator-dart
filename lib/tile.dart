library tile;

import 'package:level_generator/point.dart';
import 'package:level_generator/tile_type.dart';

class Tile extends Point {
  TileType type;

  Tile(int x, int y, this.type): super(x, y);
}