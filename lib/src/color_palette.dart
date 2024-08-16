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
    if (!(other is BoringAvatarPalette)) return false;
    if (listEquals(this.colors, other.colors)) return true;
    return false;
  }

  static const BoringAvatarPalette defaultPalette = BoringAvatarPalette([
    const Color(0xffA3A948),
    const Color(0xffEDB92E),
    const Color(0xffF85931),
    const Color(0xffCE1836),
    const Color(0xff009989)
  ]);
}
