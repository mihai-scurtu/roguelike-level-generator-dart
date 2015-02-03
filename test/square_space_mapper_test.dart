import 'dart:math' as Math;

import 'package:unittest/unittest.dart';
import 'package:level_generator/square_space_mapper.dart';
import 'package:matrix/matrix.dart';

void main() {
  Matrix<int> level;
  List<List<int>> expected;
  SquareSpaceMapper mapper;
  Function isSpace = (int tile) => tile == 0;

  test('Sanity test', () {
    level = new Matrix<int>.fromArray([[1]]);
    expected = [[0]];
    mapper = new SquareSpaceMapper(level, isSpace);
    expect(mapper.generateMap().toArray, equals(expected));

    level = new Matrix<int>.fromArray([[0]]);
    expected = [[1]];
    mapper = new SquareSpaceMapper(level, isSpace);
    expect(mapper.generateMap().toArray, equals(expected));
  });

  test('Empty space', () {
    level = new Matrix<int>.fromArray([[0, 0], [0, 0]]);

    expected = [[2, 1], [1, 1]];

    mapper = new SquareSpaceMapper(level, isSpace);

    expect(mapper.generateMap().toArray, equals(expected));
  });

  test('Vertical wall', () {
    level = new Matrix<int>.fromArray([[0, 0, 1, 0], [0, 0, 1, 0], [0, 0, 1, 0],]);

    expected = [[2, 1, 0, 1], [2, 1, 0, 1], [1, 1, 0, 1],];

    mapper = new SquareSpaceMapper(level, isSpace);

    expect(mapper.generateMap().toArray, equals(expected));
  });

  test('Multiple walls', () {
    level = new Matrix<int>.fromArray([[1, 0, 1, 0], [0, 0, 1, 0], [0, 0, 0, 0], [1, 0, 0, 0], [1, 0, 1, 1],]);

    expected = [[0, 1, 0, 1], [2, 1, 0, 1], [1, 2, 2, 1], [0, 1, 1, 1], [0, 1, 0, 0],];

    mapper = new SquareSpaceMapper(level, isSpace);

    expect(mapper.generateMap().toArray, equals(expected));
  });

  test('Huge random space', () {
    int size = 500;
    double wallChance = 0.1;
    Math.Random rng = new Math.Random();

    level = new Matrix<int>(size, size);

    level.forEach((value, i, j) {
      if (rng.nextDouble() < wallChance) {
        level.set(i, j, 1);
      } else {
        level.set(i, j, 0);
      }
    });

    mapper = new SquareSpaceMapper(level, isSpace);

    Stopwatch stopwatch = new Stopwatch()..start();
    print('Map was generated in ${stopwatch.elapsed}');
  });

  test('Reference should be preserved', () {
    level = new Matrix<int>.fromArray([[0, 0], [0, 0]]);

    expected = [[1, 1], [1, 0]];

    mapper = new SquareSpaceMapper(level, isSpace);

    level.set(1, 1, 1);

    expect(mapper.generateMap().toArray, equals(expected));
  });
}
