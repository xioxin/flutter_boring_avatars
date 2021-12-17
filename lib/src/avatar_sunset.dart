import 'package:flutter/material.dart';
import './utilities.dart';
import 'dart:ui';

import 'avatar_base.dart';

class AvatarSunsetData {
  Color color;
  AvatarSunsetData({
    required this.color,
  });
}

class AvatarSunsetPainter extends AvatarCustomPainter {
  final String name;
  final List<Color> colors;
  final List<AvatarSunsetData> properties;

  static const int elements = 3;
  @override
  double get boxSize => 80;

  AvatarSunsetPainter(this.name, this.colors)
      : properties = generate(name, colors);

  static List<AvatarSunsetData> generate(String name, List<Color> colors) {
    final numFromName = getNumber(name);
    final range = colors.length;
    final elementsProperties = List.generate(
        4,
        (i) => AvatarSunsetData(
              color: getRandomColor(numFromName + i, colors, range),
            ));
    return elementsProperties;
  }

  @override
  void paint(Canvas canvas, Size size) {
    this.size = size;
    final p0 = properties[0];
    final p1 = properties[1];
    final p2 = properties[2];
    final p3 = properties[3];
    canvas.clipRect(Rect.fromLTRB(0, 0, size.width, size.height));

    final rect1 = Rect.fromLTWH(0, 0, size.width, size.height / 2);
    final paint1 = Paint()
      ..shader = LinearGradient(
              colors: [ p0.color, p1.color],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter)
          .createShader(rect1);
    canvas.drawRect(rect1, paint1);

    final rect2 = Rect.fromLTWH(0, size.height / 2, size.width, size.height / 2);
    final paint2 = Paint()
      ..shader = LinearGradient(
              colors: [p2.color, p3.color],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter)
          .createShader(rect2);
    canvas.drawRect(rect2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
