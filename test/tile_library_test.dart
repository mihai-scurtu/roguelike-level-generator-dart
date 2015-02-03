import 'package:level_generator/tile_library.dart';
import 'package:level_generator/tile_type.dart';
import 'package:unittest/unittest.dart';

void main() {
  test('Sanity test', () {
    TileLibrary library = new TileLibrary();

    expect(library.WALL is TileType, isTrue);
    expect(library.FLOOR is TileType, isTrue);
  });
}
