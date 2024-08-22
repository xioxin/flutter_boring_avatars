import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class BoringAvatarPalette {
  final List<Color> colors;

  const BoringAvatarPalette(this.colors);

  Color getColor<T>(int number) {
    assert(colors.isNotEmpty);
    return colors[(number) % colors.length];
  }

  @override
  int get hashCode => Object.hashAll(colors);

  @override
  bool operator ==(Object other) {
    if (other is! BoringAvatarPalette) return false;
    if (listEquals(colors, other.colors)) return true;
    return false;
  }

  static const BoringAvatarPalette defaultPalette = BoringAvatarPalette([
    Color(0xffA3A948),
    Color(0xffEDB92E),
    Color(0xffF85931),
    Color(0xffCE1836),
    Color(0xff009989)
  ]);

  BoringAvatarPalette copyWith({
    Color? c1,
    Color? c2,
    Color? c3,
    Color? c4,
    Color? c5,
  }) {
    return BoringAvatarPalette([
      c1 ?? colors[0],
      c2 ?? colors[1],
      c3 ?? colors[2],
      c4 ?? colors[3],
      c5 ?? colors[4],
    ]);
  }

  BoringAvatarPalette copyWithOne(int index, Color color) {
    return BoringAvatarPalette([
      if (index == 0) color else colors[0],
      if (index == 1) color else colors[1],
      if (index == 2) color else colors[2],
      if (index == 3) color else colors[3],
      if (index == 4) color else colors[4],
    ]);
  }

  @override
  toString() => 'BoringAvatarPalette($colors)';
}
