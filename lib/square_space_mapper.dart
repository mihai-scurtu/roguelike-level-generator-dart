library square_space_mapper;

import 'dart:math' as Math;

import 'package:matrix/matrix.dart';
import 'package:level_generator/space_map.dart';

class SquareSpaceMapper {
  SpaceMap _map;
  Matrix _data;
  Function _isSpace;

  SquareSpaceMapper(this._data, this._isSpace) {
    this._map = new SpaceMap(this._data.rows, this._data.columns);
  }

  SpaceMap generateMap() {
    this._map = new SpaceMap(this._data.rows, this._data.columns);
    this._data.forEach((value, i, j) {
      if(this._map.get(i, j) == null) {
        this._map.set(i, j, this.getSpaceFromPoint(i, j));
      }
    });

    return this._map;
  }

  int getSpaceFromPoint(int x, int y) {
    int space;
    if(this._isOutOfBounds(x, y)) {
      return 0;
    } else if(this._map.get(x, y) != null) {
      return this._map.get(x, y);
    } else if(!this._isSpace(this._data.get(x, y))) {
      space = 0;
    } else {
      int min = this.getSpaceFromPoint(x + 1 , y);
      min = Math.min(min, this.getSpaceFromPoint(x, y + 1));
      min = Math.min(min, this.getSpaceFromPoint(x + 1, y + 1));

      space = min + 1;
    }

    this._map.set(x, y, space);
    return space;
  }

  bool _isOutOfBounds(int x, int y) {
    return x < 0 || y < 0 || x >= this._data.rows || y >= this._data.columns;
  }
}