library random;

import 'dart:math' as Math;

class Random {
  final int seed;

  Math.Random _rng;

  Random([this.seed]) {
    this._rng = new Math.Random();
  }

  bool nextBool() {
    return this._rng.nextBool();
  }

  double nextDouble() {
    return this._rng.nextDouble();
  }

  int nextInt(int max) {
    return ((max + 1) * this.nextDouble()).floor();
  }

  int intBetween(int min, int max) {
    return this.nextInt(max - min) + min;
  }

  dynamic pick(List list) {
    if(list.length == 0) return null;
    return list[this.nextInt(list.length - 1)];
  }
}