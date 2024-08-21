import 'dart:ui';

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

  @override
  toString() => 'BoringAvatarPalette($colors)';
}
