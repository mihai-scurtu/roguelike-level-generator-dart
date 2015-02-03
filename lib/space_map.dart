library space_map;

import 'package:matrix/matrix.dart';
import 'package:level_generator/point.dart';

class SpaceMap extends Matrix {
  SpaceMap(int rows, int columns) : super(rows, columns);
  SpaceMap.fromArray(List<List> data) : super.fromArray(data);

  List getListBySize({int min, int max}) {
    List list = new List();
    int i, j;

    for (i = 0; i < this.rows; i++) {
      for (j = 0; j < this.columns; j++) {
        int size = this.get(i, j);

        // if the square is larger, jump ahead to desired point
        if (size > max) {
          j += size - min - 1;
        } else if (size < min) {
          j += size;
        } else {
          list.add(new Point(i, j));
        }
      }
    }

    return list;
  }
}
