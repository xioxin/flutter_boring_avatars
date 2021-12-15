// Copyright (c) 2016, SlickTech. All rights reserved. Use of this source code
// is governed by a MIT license that can be found in the LICENSE file.

class BoundingBox {
  num _x;
  num _y;
  num _width;
  num _height;

  BoundingBox(this._x, this._y, this._width, this._height);

  @override
  bool operator ==(rhs) {
    return rhs is BoundingBox &&
        _x == rhs._x &&
        _y == rhs._y &&
        _width == rhs._width &&
        _height == rhs._height;
  }

  @override
  int get hashCode {
    var hash = 17;
    hash = 31 * hash + _x.hashCode;
    hash = 31 * hash + _y.hashCode;
    hash = 31 * hash + _width.hashCode;
    hash = 31 * hash + _height.hashCode;
    return hash;
  }

  @override
  String toString() {
    return 'x: $_x, y: $_y, width: $_width, height: $_height';
  }

  BoundingBox round([int numberOfDecimal = 0]) {
    if (numberOfDecimal == 0) {
      _x = _x.toInt();
      _y = _y.toInt();
      _width = _width.toInt();
      _height = _height.toInt();
    } else {
      _x = double.parse(_x.toStringAsFixed(numberOfDecimal));
      _y = double.parse(_y.toStringAsFixed(numberOfDecimal));
      _width = double.parse(_width.toStringAsFixed(numberOfDecimal));
      _height = double.parse(_height.toStringAsFixed(numberOfDecimal));
    }
    return this;
  }

  num get x => _x;
  num get y => _y;
  num get width => _width;
  num get height => _height;
}
