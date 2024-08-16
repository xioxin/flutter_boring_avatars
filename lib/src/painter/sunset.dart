import 'dart:math';
import 'package:flutter/material.dart';
import '../utilities.dart';
import '../painter.dart';

import '../color_palette.dart';

class BoringAvatarSunsetData extends BoringAvatarData {
  late List<Color> colorList;

  BoringAvatarSunsetData({
    required this.colorList,
  });

  BoringAvatarSunsetData.generate(
      {required String name,
      BoringAvatarPalette palette = BoringAvatarPalette.defaultPalette,
      BoringAvatarHashCodeFunc getHashCode = boringAvatarHashCode}) {
    final numFromName = getHashCode(name);
    colorList = List.generate(4, (i) => palette.getColor(numFromName + i));
  }

  @override
  operator == (Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    if (other is BoringAvatarSunsetData) {
      if (colorList.length != other.colorList.length) return false;
      int i = 0;
      return colorList.every((c) => c == other.colorList[i++]);
    }
    return false;
  }

  @override
  int get hashCode => Object.hashAll(colorList);

  @override
  BoringAvatarData lerp (BoringAvatarData end, double t) {
    assert(end is BoringAvatarSunsetData);
    final a = this;
    final b = end as BoringAvatarSunsetData;
    final newColor = List.generate(max(a.colorList.length, b.colorList.length),
        (index) => Color.lerp(a.colorList[index], b.colorList[index], t)!);
    return BoringAvatarSunsetData(colorList: newColor);
  }

  @override
  CustomPainter get painter => AvatarSunsetPainter(this);
}

class AvatarSunsetPainter extends AvatarCustomPainter {
  final BoringAvatarSunsetData properties;

  @override
  double get boxSize => 80;

  AvatarSunsetPainter(this.properties);

  @override
  void paint(Canvas canvas, Size size) {
    this.size = size;
    final p0 = properties.colorList[0];
    final p1 = properties.colorList[1];
    final p2 = properties.colorList[2];
    final p3 = properties.colorList[3];
    canvas.clipRect(Rect.fromLTRB(0, 0, size.width, size.height));
    final rect1 = Rect.fromLTWH(0, 0, size.width, size.height / 2);
    final paint1 = Paint()
      ..shader = LinearGradient(
              colors: [p0, p1],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter)
          .createShader(rect1);
    canvas.drawRect(rect1, paint1);

    final rect2 =
        Rect.fromLTWH(0, size.height / 2, size.width, size.height / 2);
    final paint2 = Paint()
      ..shader = LinearGradient(
              colors: [p2, p3],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter)
          .createShader(rect2);
    canvas.drawRect(rect2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is AvatarSunsetPainter &&
        oldDelegate.properties != properties;
  }
}
