import 'package:level_generator/level_generator.dart';
import 'package:level_generator/level.dart';
import 'package:level_generator/tile.dart';
import 'package:level_generator/room.dart';

import 'dart:io';

class ASCIIScreen {
  List<String> buffer;
  int width;
  int height;

  ASCIIScreen(Level level)
      : this.width = level.width,
        this.height = level.height,
        this.buffer = new List<String>(level.width * level.height) {

    level.tiles.forEach((Tile tile, i, j) {
      this.setTile(i, j, tile.type.glyph);
    });
  }

  void setTile(int x, int y, String glyph) {
    if(x > this.height || y > this.width) throw new ArgumentError('Coordinates out of bounds');

    this.buffer[x * width + y] = glyph;
  }

  void output() {
    int i;
    String output = '';

    for(i = 0; i < this.buffer.length; i++) {
      output += this.buffer[i];

      if((i + 1) % this.width == 0) {
        output += '\n';
      }
    }

    print(output);
  }
}

void main() {
  LevelGenerator generator;
  ASCIIScreen screen;
  const int WIDTH = 120;
  const int HEIGHT = 50;

  while (true) {
    generator = new LevelGenerator(WIDTH, HEIGHT);

    screen = new ASCIIScreen(generator.generateLevel());

    int i = 0;
    generator.rooms.forEach((Room room) {
      screen.setTile(room.x + 2, room.y + 2, i.toString());
      i++;
    });

    screen.output();

    String cmd = stdin.readLineSync();

    if (cmd == 'q') {
      break;
    }
  }
}
