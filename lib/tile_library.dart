library tile_library;

import 'package:level_generator/tile_type.dart';

class TileLibrary {
  static TileLibrary _instance;

  TileType WALL;
  TileType FLOOR;

  factory TileLibrary() {
    if (_instance == null) {
      return new TileLibrary._internal();
    } else {
      return _instance;
    }
  }

  TileLibrary._internal() {
    this.WALL = new TileType('#', '#FFFFFF', false);
    this.FLOOR = new TileType('.', '#FFFFFF', true);
  }


}
