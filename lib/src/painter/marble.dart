import 'dart:math';
import 'package:flutter/material.dart';
import '../utilities.dart';
import '../painter.dart';

import '../palette.dart';

class BoringAvatarMarbleData extends BoringAvatarData {
  late Color bgColor;
  late Color element1Color;
  late double element1TranslateX;
  late double element1TranslateY;
  late double element1Scale;
  late double element1Rotate;
  late Color element2Color;
  late double element2TranslateX;
  late double element2TranslateY;
  late double element2Scale;
  late double element2Rotate;

  BoringAvatarMarbleData({
    required this.bgColor,
    required this.element1Color,
    required this.element1TranslateX,
    required this.element1TranslateY,
    required this.element1Scale,
    required this.element1Rotate,
    required this.element2Color,
    required this.element2TranslateX,
    required this.element2TranslateY,
    required this.element2Scale,
    required this.element2Rotate,
    super.shape,
  });

  // static AvatarMarbleData? lerp(
  //     AvatarMarbleData? a, AvatarMarbleData? b, double t) {
  //   if (a == null || b == null) return a ?? b;
  //   return AvatarMarbleData(
  //     bgColor: Color.lerp(a.bgColor, b.bgColor, t)!,
  //     element1Color: Color.lerp(a.element1Color, b.element1Color, t)!,
  //     element1TranslateX:
  //         lerpDouble(a.element1TranslateX, b.element1TranslateX, t),
  //     element1TranslateY:
  //         lerpDouble(a.element1TranslateY, b.element1TranslateY, t),
  //     element1Scale: lerpDouble(a.element1Scale, b.element1Scale, t),
  //     element1Rotate: lerpRotate(a.element1Rotate, b.element1Rotate, t),
  //     element2Color: Color.lerp(a.element2Color, b.element2Color, t)!,
  //     element2TranslateX:
  //         lerpDouble(a.element2TranslateX, b.element2TranslateX, t),
  //     element2TranslateY:
  //         lerpDouble(a.element2TranslateY, b.element2TranslateY, t),
  //     element2Scale: lerpDouble(a.element2Scale, b.element2Scale, t),
  //   );
  // }

  BoringAvatarMarbleData.generate({
    required String name,
    super.shape,
    BoringAvatarPalette palette = BoringAvatarPalette.defaultPalette,
  }) {
    const double boxSize = 80;
    final numFromName = boringAvatarHashCode(name);
    int i = 0;
    bgColor = palette.getColor(numFromName + i);

    i = 1;
    element1Color = palette.getColor(numFromName + i);
    element1TranslateX = getUnit(numFromName * (i + 1), boxSize ~/ 10, 1);
    element1TranslateY = getUnit(numFromName * (i + 1), boxSize ~/ 10, 2);
    element1Scale = 1.2 + getUnit(numFromName * (i + 1), boxSize ~/ 20) / 10;
    element1Rotate = getUnit(numFromName * (i + 1), 360, 1);

    i = 2;
    element2Color = palette.getColor(numFromName + i);
    element2TranslateX = getUnit(numFromName * (i + 1), boxSize ~/ 10, 1);
    element2TranslateY = getUnit(numFromName * (i + 1), boxSize ~/ 10, 2);
    element2Scale = 1.2 + getUnit(numFromName * (i + 1), boxSize ~/ 20) / 10;
    element2Rotate = getUnit(numFromName * (i + 1), 360, 1);
  }

  @override
  operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    if (other is BoringAvatarMarbleData) {
      return bgColor == other.bgColor &&
          element1Color == other.element1Color &&
          element1TranslateX == other.element1TranslateX &&
          element1TranslateY == other.element1TranslateY &&
          element1Scale == other.element1Scale &&
          element1Rotate == other.element1Rotate &&
          element2Color == other.element2Color &&
          element2TranslateX == other.element2TranslateX &&
          element2TranslateY == other.element2TranslateY &&
          element2Scale == other.element2Scale &&
          element2Rotate == other.element2Rotate &&
          shape == other.shape;
    }
    return false;
  }

  @override
  int get hashCode => Object.hashAll([
        bgColor,
        element1Color,
        element1TranslateX,
        element1TranslateY,
        element1Scale,
        element1Rotate,
        element2Color,
        element2TranslateX,
        element2TranslateY,
        element2Scale,
        element2Rotate,
        shape
      ]);

  @override
  BoringAvatarData lerp(BoringAvatarData end, double t) {
    assert(end is BoringAvatarMarbleData);
    final a = this;
    final b = end as BoringAvatarMarbleData;
    return BoringAvatarMarbleData(
      bgColor: Color.lerp(a.bgColor, b.bgColor, t)!,
      element1Color: Color.lerp(a.element1Color, b.element1Color, t)!,
      element1TranslateX:
          lerpDouble(a.element1TranslateX, b.element1TranslateX, t),
      element1TranslateY:
          lerpDouble(a.element1TranslateY, b.element1TranslateY, t),
      element1Scale: lerpDouble(a.element1Scale, b.element1Scale, t),
      element1Rotate: lerpRotate(a.element1Rotate, b.element1Rotate, t),
      element2Color: Color.lerp(a.element2Color, b.element2Color, t)!,
      element2TranslateX:
          lerpDouble(a.element2TranslateX, b.element2TranslateX, t),
      element2TranslateY:
          lerpDouble(a.element2TranslateY, b.element2TranslateY, t),
      element2Scale: lerpDouble(a.element2Scale, b.element2Scale, t),
      element2Rotate: lerpRotate(a.element2Rotate, b.element2Rotate, t),
      shape: ShapeBorder.lerp(a.shape, b.shape, t),
    );
  }

  @override
  void paint(Canvas canvas, Rect rect) {
    final painter = AvatarMarblePainter(this, rect);
    painter.paint(canvas);
  }
}

final Path _marblePath1 = Path()
  ..moveTo(32.414, 59.35)
  ..lineTo(50.376, 70.5)
  ..lineTo(72.5, 70.5)
  ..lineTo(72.5, -0.5)
  ..lineTo(33.728, -0.5)
  ..lineTo(26.5, 13.381)
  ..relativeLineTo(19.057, 27.08)
  ..close();

final Path _marblePath2 = Path()
  ..moveTo(22.216, 24)
  ..lineTo(0, 46.75)
  ..relativeLineTo(14.108, 38.129)
  ..lineTo(78, 86)
  ..relativeLineTo(-3.081, -59.276)
  ..relativeLineTo(-22.378, 4.005)
  ..relativeLineTo(12.972, 20.186)
  ..relativeLineTo(-23.35, 27.395)
  ..close();

class AvatarMarblePainter extends BoringAvatarPainter {
  @override
  final BoringAvatarMarbleData properties;

  static const int elements = 3;

  AvatarMarblePainter(this.properties, Rect rect)
      : super(boxSize: 80, rect: rect);

  @override
  void avatarPaint(Canvas canvas) {
    final p = properties;
    canvas.clipRect(Rect.fromLTRB(0, 0, size.width, size.height));
    final blur = MaskFilter.blur(
      BlurStyle.normal,
      cX(7),
    );
    Paint paintFill = Paint()
      ..style = PaintingStyle.fill
      ..color = properties.bgColor;
    canvas.drawRect(Rect.fromLTRB(0, 0, size.width, size.height), paintFill);
    final scaleX = size.width / boxSize;
    final scaleY = size.height / boxSize;
    final path1Transform = Matrix4.identity()
      ..scaleByDouble(scaleX, scaleY, scaleX, 1.0)
      ..translateByDouble(p.element1TranslateX, p.element1TranslateY, 0.0, 1.0)
      ..translateByDouble(boxSize / 2, boxSize / 2, 0.0, 1.0)
      ..rotateZ(p.element1Rotate * (pi / 180))
      ..translateByDouble(-boxSize / 2, -boxSize / 2, 0.0, 1.0)
      ..scaleByDouble(p.element1Scale, p.element1Scale, p.element1Scale, 1.0);

    final path1 = _marblePath1.transform(path1Transform.storage);
    Paint paintFill1 = Paint()
      ..style = PaintingStyle.fill
      ..color = p.element1Color
      ..maskFilter = blur;

    canvas.drawPath(path1, paintFill1);

    final paintFill2 = Paint()
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.overlay
      ..color = p.element2Color
      ..maskFilter = blur;

    final path2Transform = Matrix4.identity()
      ..scaleByDouble(scaleX, scaleY, scaleX, 1.0)
      ..translateByDouble(p.element2TranslateX, p.element2TranslateY, 0.0, 1.0)
      ..translateByDouble(boxSize / 2, boxSize / 2, 0.0, 1.0)
      ..rotateZ(p.element2Rotate * (pi / 180))
      ..translateByDouble(-boxSize / 2, -boxSize / 2, 0.0, 1.0)
      ..scaleByDouble(p.element2Scale, p.element2Scale, p.element2Scale, 1.0);

    final path2 = _marblePath2.transform(path2Transform.storage);
    canvas.drawPath(path2, paintFill2);
  }
}
