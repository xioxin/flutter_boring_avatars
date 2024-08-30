import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../utilities.dart';
import '../painter.dart';

import '../palette.dart';

class BoringAvatarSunsetData extends BoringAvatarData {
  late List<Color> colorList;

  BoringAvatarSunsetData({
    required this.colorList,
    super.shape,
  });

  BoringAvatarSunsetData.generate({
    required String name,
    super.shape,
    BoringAvatarPalette palette = BoringAvatarPalette.defaultPalette,
  }) {
    final numFromName = boringAvatarHashCode(name);
    colorList = List.generate(4, (i) => palette.getColor(numFromName + i));
  }

  @override
  operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    if (other is BoringAvatarSunsetData) {
      return listEquals(colorList, other.colorList) && shape == other.shape;
    }
    return super == other;
  }

  @override
  int get hashCode => Object.hashAll([...colorList, shape]);

  @override
  BoringAvatarData lerp(BoringAvatarData end, double t) {
    assert(end is BoringAvatarSunsetData);
    final a = this;
    final b = end as BoringAvatarSunsetData;
    final newColor = List.generate(max(a.colorList.length, b.colorList.length),
        (index) => Color.lerp(a.colorList[index], b.colorList[index], t)!);
    return BoringAvatarSunsetData(
      colorList: newColor,
      shape: ShapeBorder.lerp(a.shape, b.shape, t),
    );
  }

  @override
  void paint(Canvas canvas, Rect rect) {
    final painter = AvatarSunsetPainter(this, rect);
    painter.paint(canvas);
  }
}

class AvatarSunsetPainter extends BoringAvatarPainter {
  @override
  final BoringAvatarSunsetData properties;

  @override
  double get boxSize => 80;

  AvatarSunsetPainter(this.properties, Rect rect)
      : super(boxSize: 80, rect: rect);

  @override
  void avatarPaint(Canvas canvas) {
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
}
