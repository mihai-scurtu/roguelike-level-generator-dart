library tile_type;

class TileType {
  String glyph;
  String color;
  bool isPassable;

  TileType(this.glyph, this.color, this.isPassable) {
    if(this.glyph.length > 1) {
      throw new ArgumentError.value(this.glyph, 'glyph', 'Glyph must be one character long');
    }
  }
}