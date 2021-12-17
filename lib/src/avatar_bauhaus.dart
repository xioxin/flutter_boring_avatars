import 'package:flutter/material.dart';
import './utilities.dart';
import 'dart:ui';

import 'avatar_base.dart';

class AvatarBauhausData {
  Color color;
  double translateX;
  double translateY;
  double rotate;
  double height;
  bool isSquare;
  AvatarBauhausData({
    required this.color,
    required this.translateX,
    required this.translateY,
    required this.rotate,
    required this.isSquare,
    required this.height,
  });
}

class AvatarBauhausPainter extends AvatarCustomPainter {
  final String name;
  final List<Color> colors;
  final List<AvatarBauhausData> properties;

  @override
  double get boxSize => 80;

  AvatarBauhausPainter(this.name, this.colors)
      : properties = generate(name, colors);
  
  static List<AvatarBauhausData> generate(String name, List<Color> colors) {
    const double boxSize = 80;
      final numFromName = getNumber(name);
  final range = colors.length;
  final isSquare = getBoolean(numFromName, 2);
  final elementsProperties = List.generate(
      4,
      (i) => AvatarBauhausData(
          color: getRandomColor(numFromName + i, colors, range),
          translateX: getUnit(numFromName * (i + 1), boxSize ~/ 2 - (i + 17), 1).toDouble(),
          translateY: getUnit(numFromName * (i + 1), boxSize ~/ 2 - (i + 17), 2).toDouble(),
          rotate: getUnit(numFromName * (i + 1), 360).toDouble(),
          isSquare: isSquare,
          height: isSquare ? boxSize : boxSize / 8,
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
    canvas.drawRect(Rect.fromLTRB(0, 0, size.width, size.height), fillPaint(p0.color));

    final t1 = getTransform(translateX: p1.translateX, translateY: p1.translateY, rotate: p1.rotate);
    canvas.transform(t1.storage);
    canvas.drawRect(getRectFromLTWH(( boxSize - 60 ) / 2, ( boxSize - 20 ) / 2, boxSize, p1.height), fillPaint(p1.color));
    t1.invert();
    canvas.transform(t1.storage);

    final t2 = getTransform(translateX: p2.translateX, translateY: p2.translateY);
    canvas.transform(t2.storage);
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width / 5, fillPaint(p2.color));
    t2.invert();
    canvas.transform(t2.storage);

    final t3 = getTransform(translateX: p3.translateX, translateY: p3.translateY, rotate: p3.rotate);
    canvas.transform(t3.storage);
    canvas.drawLine(Offset(0, size.width / 2), Offset(size.height, size.height / 2), strokePaint(p3.color, 2));
    t3.invert();
    canvas.transform(t3.storage);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
