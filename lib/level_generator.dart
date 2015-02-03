library level_generator;

import 'dart:math' as Math;

import 'package:level_generator/level.dart';
import 'package:level_generator/space_map.dart';
import 'package:level_generator/square_space_mapper.dart';
import 'package:level_generator/tile_library.dart';
import 'package:level_generator/random.dart';
import 'package:level_generator/room.dart';
import 'package:level_generator/point.dart';
import 'package:level_generator/tile.dart';
import 'package:matrix/matrix.dart';

class LevelGenerator {
  // the generated level
  Level _level;

  // the space mapper
  SquareSpaceMapper _spaceMapper;

  // the level's space map
  SpaceMap spaceMap;

  // the tile library
  TileLibrary tileLibrary;

  // whether the level is generated, and can be retrieved
  bool _levelGenerated = false;

  // the RNG
  Random rng;

  // the room list
  List<Room> rooms;

  // the room path graph
  Matrix<bool> roomGraph;

  // the space function
  Function canDig = (Tile tile) {
    return !tile.type.isPassable;
  };

  int MIN_ROOMS = 10;
  int MAX_ROOMS = 20;

  int ROOM_WIDTH = 25;
  int ROOM_WIDTH_DEVIATION = 8;
  int ROOM_HEIGHT = 8;
  int ROOM_HEIGHT_DEVIATION = 4;

  int MAX_RETRIES = 10;

  double MAX_TUNNEL_TURN_CHANCE = 0.15;
  double TUNNEL_TURN_CHANCE_INCREMENT = 0.02;

  LevelGenerator(int width, int height, [int seed]) {
    this.rng = new Random(seed);
    this.tileLibrary = new TileLibrary();
    this._level = new Level(width, height, this.tileLibrary.WALL);
    this.rooms = new List<Room>();

    ROOM_WIDTH = (width / 5).floor();
    ROOM_WIDTH_DEVIATION = (ROOM_WIDTH / 4).floor();

    ROOM_HEIGHT = (height / 5).floor();
    ROOM_HEIGHT_DEVIATION = (ROOM_HEIGHT / 2).floor();
  }

  Level generateLevel() {
    this._level.fill(this.tileLibrary.WALL);
    this._spaceMapper = new SquareSpaceMapper(this._level.tiles, this.canDig);

    this.generateRooms();
    this.connectRooms();

    this._levelGenerated = true;

    return this.level;
  }

  void generateRooms() {
    int roomsLeft = this.rng.intBetween(MIN_ROOMS, MAX_ROOMS);
    int retries = 0;
    while (roomsLeft > 0) {
      this.spaceMap = this._spaceMapper.generateMap();

      int width = this.randomRoomWidth;
      int height = this.randomRoomHeight;

      List availablePoints = spaceMap.getListBySize(
        min: Math.max(width, height),
        max: Math.min(this._level.width, this._level.height));

      if(availablePoints.length == 0) {
        if(retries == MAX_RETRIES) {
          retries = 0;
          break;
        } else {
          retries++;
          continue;
        }
      }

      Room room = this.generateRoomfromPoint(this.rng.pick(availablePoints), width, height);

      this.digRoom(room);
      this.rooms.add(room);

      roomsLeft--;
    }

    this.rooms.sort();
  }

  void connectRooms() {
    this.roomGraph = new Matrix<bool>(this.rooms.length, this.rooms.length);
    int i, j;
    Point from, to;

    // initialize graph
    this.roomGraph.forEach((value, i, j) {
      this.roomGraph.set(i, j, false);
    });

    for(i = 0; i < this.rooms.length; i++) {
      for(j = i + 1; j < this.rooms.length; j++) {
        if(!this._checkRoomPathByIndex(i, j)) {
          from = this.randomTileInRoom(this.rooms[i]);
          to = this.randomTileInRoom(this.rooms[j]);

          this.digTunnel(from, to);
        }

        this.roomGraph.set(i, j, true);
        this.roomGraph.set(j, i, true);
      }
    }
  }

  bool _checkRoomPathByIndex(int fromIndex, int toIndex) {
//    int fromIndex = this.rooms.indexOf(from);
//    int toIndex = this.rooms.indexOf(to);
    int current;

    Set<int> queue = new Set<int>();
    Set<int> visited = new Set<int>();

    queue.add(fromIndex);

    while(queue.length > 0) {
      current = queue.first;

      if(current == toIndex) {
        return true;
      }

      for(int i = 0; i < this.rooms.length; i++) {
        if(!visited.contains(i) && this.roomGraph.get(current, i)) {
          queue.add(i);
        }
      }

      visited.add(current);
      queue.remove(current);
    }

    return false;
  }

  Room generateRoomfromPoint(Point p, int width, int height) => new Room(p.x, p.y, width, height);

  void digRoom(Room room) {
    int i, j;

    for (i = room.x; i < room.x + room.height; i++) {
      for (j = room.y; j < room.y + room.width; j++) {
        this.dig(i, j);
      }
    }
  }

  Tile randomTileInRoom(Room room) {
    int x = this.rng.intBetween(room.x, room.opposingCorner.x);
    int y = this.rng.intBetween(room.y, room.opposingCorner.y);

    return this._level.tiles.get(x, y);
  }

  void digTunnel(Point from, Point to) {
    // handle simple cases
    if(from.x == to.x) {
      for(int i = Math.min(from.x, to.x); i < Math.max(from.x, to.x); i++) {
        this.dig(i, from.y);
      }

      return;
    }

    if(from.y == to.y) {
      for(int i = Math.min(from.y, to.y); i < Math.max(from.y, to.y); i++) {
        this.dig(from.x, i);
      }

      return;
    }

    bool digX = this.rng.nextBool();
    double turnChance = 0.0;

    while(from != to) {
      int stepX = from.x > to.x ? -1 : 1;
      int stepY = from.y > to.y ? -1 : 1;

      turnChance = Math.min(MAX_TUNNEL_TURN_CHANCE, turnChance + TUNNEL_TURN_CHANCE_INCREMENT);

      if(this.rng.nextDouble() < turnChance) {
        digX = !digX;
        turnChance = 0.0;
      }

      if(digX) {
        from.x += stepX;
      } else {
        from.y += stepY;
      }

      this.digTile(from);
    }
  }

  void digTile(Point p) => this.dig(p.x, p.y);

  void dig(int x, int y) {
    this._level.tiles.get(x, y)..type = this.tileLibrary.FLOOR;
  }

  bool get levelGenerated => this._levelGenerated;

  Level get level {
    if (!this._levelGenerated) {
      throw new Exception('Level was not generated');
    }

    return this._level;
  }

  int get randomRoomWidth => this.rng.intBetween(ROOM_WIDTH - ROOM_WIDTH_DEVIATION, ROOM_WIDTH + ROOM_WIDTH_DEVIATION);
  int get randomRoomHeight => this.rng.intBetween(ROOM_HEIGHT - ROOM_HEIGHT_DEVIATION, ROOM_HEIGHT + ROOM_HEIGHT_DEVIATION);
}