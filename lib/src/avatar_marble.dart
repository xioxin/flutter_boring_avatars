import 'package:flutter/material.dart';
import './utilities.dart';
import 'dart:ui';

import 'avatar_base.dart';

class AvatarMarbleData {
  Color color;
  double translateX;
  double translateY;
  double rotate;
  double scale;
  AvatarMarbleData({
    required this.color,
    required this.translateX,
    required this.translateY,
    required this.rotate,
    required this.scale,
  });
}

class AvatarMarblePainter extends AvatarCustomPainter {
  final String name;
  final List<Color> colors;
  final List<AvatarMarbleData> properties;

  static const int elements = 3;
  @override
  double get boxSize => 80;

  AvatarMarblePainter(this.name, this.colors)
      : properties = generate(name, colors);
  
  static List<AvatarMarbleData> generate(String name, List<Color> colors) {
    const double boxSize = 80;
    final numFromName = getNumber(name);
    final range = colors.length;
    final elementsProperties = List.generate(
        3,
        (i) => AvatarMarbleData(
              color: getRandomColor(numFromName + i, colors, range),
              translateX:
                  getUnit(numFromName * (i + 1), boxSize ~/ 10, 1).toDouble(),
              translateY:
                  getUnit(numFromName * (i + 1), boxSize ~/ 10, 2).toDouble(),
              scale: 1.2 + getUnit(numFromName * (i + 1), boxSize ~/ 20) / 10,
              rotate: getUnit(numFromName * (i + 1), 360, 1).toDouble(),
            ));
    return elementsProperties;
  }

  @override
  void paint(Canvas canvas, Size size) {
    this.size = size;
    final p0 = properties[0];
    final p1 = properties[1];
    final p2 = properties[2];
    canvas.clipRect(Rect.fromLTRB(0, 0, size.width, size.height));
    final blur = MaskFilter.blur(
      BlurStyle.normal,
      7 * (size.width / boxSize),
    );

    Paint paintFill = Paint()
      ..style = PaintingStyle.fill
      ..color = p0.color;

    canvas.drawRect(Rect.fromLTRB(0, 0, size.width, size.height), paintFill);

    final path1 = svgPath("M32.414 59.35L50.376 70.5H72.5v-71H33.728L26.5 13.381l19.057 27.08L32.414 59.35z",
        rotate: p1.rotate,
        scale: p1.scale,
        transformX: p1.translateX,
        transformY: p1.translateY);

    Paint paintFill1 = Paint()
      ..style = PaintingStyle.fill
      ..color = p1.color
      ..maskFilter = blur;
    canvas.drawPath(path1, paintFill1);

    final path2 = svgPath("M22.216 24L0 46.75l14.108 38.129L78 86l-3.081-59.276-22.378 4.005 12.972 20.186-23.35 27.395L22.215 24z",
        rotate: p1.rotate,
        scale: p2.scale,
        transformX: p2.translateX,
        transformY: p2.translateY);
    final paintFill2 = Paint()
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.overlay
      ..color = p2.color
      ..maskFilter = blur;

    canvas.drawPath(path2, paintFill2);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
