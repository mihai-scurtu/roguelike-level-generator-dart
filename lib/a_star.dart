library a_star;

//import 'dart:math' as Math;

import 'package:level_generator/level.dart';
import 'package:level_generator/point.dart';

class AStar {
  static List<Point> getPath(Level level, Point from, Point to) {
    Set<Point> closed;
    Set<Point> open;

    Map<Point, int> gScores;
    Map<Point, int> fScores;

    Map<Point, Point> cameFrom;

    open.add(from);

    gScores[from] = 0;
    fScores[from] = 0 + _h(from, to);

    while (open.length > 0) {
      Point current = _getLowestFScore(open, fScores);

      if (current == to) {
        return _getPath(cameFrom, current);
      }

      open.remove(current);
      closed.add(current);

      level.getNeighbours(current).forEach((Point p) {
        if (closed.contains(p)) return;

        int gScore = gScores[current] + 1;

        if (!open.contains(p) || gScore < gScores[p]) {
          cameFrom[p] = current;
          gScores[p] = gScore;
          fScores[p] = gScore + _h(p, to);

          open.add(p);
        }
      });
    }

    return [];
  }

  static List<Point> _getPath(Map<Point, Point> cameFrom, Point current) {
    List<Point> path = new List<Point>();

    do {
      path.add(current);
      current = cameFrom[current];
    } while (cameFrom.containsKey(current));

    return path;
  }

  static Point _getLowestFScore(Set<Point> open, Map<Point, int> scores) {
    Point next = open.first;
    int min = scores[next];

    open.forEach((Point p) {
      int score = scores[p];

      if (score < min) {
        min = score;
        next = p;
      }
    });

    return next;
  }

  static int _h(Point from, Point to) {
    return Point.diagonalDistance(from, to);
  }
}
