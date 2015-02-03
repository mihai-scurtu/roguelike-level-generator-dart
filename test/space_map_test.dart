import 'package:level_generator/space_map.dart';
import 'package:unittest/unittest.dart';
import 'package:level_generator/point.dart';

void main() {
  SpaceMap map;
  List<List> data;

  test('Test list query', () {
    data = [
      [0, 1],
      [2, 1],
      [1, 1]];
    map = new SpaceMap.fromArray(data);

    List list = map.getListBySize(min: 1, max: 1);

    expect(list.length, equals(4));
    expect(list[0], equals(new Point(0, 1)));
    expect(list[1], equals(new Point(1, 1)));
    expect(list[2], equals(new Point(2, 0)));
    expect(list[3], equals(new Point(2, 1)));
  });
}
