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

  BoringAvatarMarbleData.generate(
      {required String name,
      BoringAvatarPalette palette = BoringAvatarPalette.defaultPalette,
      BoringAvatarHashCodeFunc getHashCode = boringAvatarHashCode}) {
    const double boxSize = 80;
    final numFromName = getHashCode(name);
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
          element2Scale == other.element2Scale;
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
    );
  }

  @override
  CustomPainter get painter => AvatarMarblePainter(this);
}

class AvatarMarblePainter extends AvatarCustomPainter {
  final BoringAvatarMarbleData properties;

  static const int elements = 3;

  @override
  double get boxSize => 80;

  AvatarMarblePainter(this.properties);

  @override
  void paint(Canvas canvas, Size size) {
    this.size = size;
    final p = properties;
    canvas.clipRect(Rect.fromLTRB(0, 0, size.width, size.height));
    final blur = MaskFilter.blur(
      BlurStyle.normal,
      cX(14),
    );

    Paint paintFill = Paint()
      ..style = PaintingStyle.fill
      ..color = properties.bgColor;

    canvas.drawRect(Rect.fromLTRB(0, 0, size.width, size.height), paintFill);

    final path1 = svgPath(
        "M32.414 59.35L50.376 70.5H72.5v-71H33.728L26.5 13.381l19.057 27.08L32.414 59.35z",
        rotate: p.element1Rotate,
        scale: p.element1Scale,
        translateX: p.element1TranslateX,
        translateY: p.element1TranslateY);

    Paint paintFill1 = Paint()
      ..style = PaintingStyle.fill
      ..color = p.element1Color
      ..maskFilter = blur;
    canvas.drawPath(path1, paintFill1);

    final path2 = svgPath(
        "M22.216 24L0 46.75l14.108 38.129L78 86l-3.081-59.276-22.378 4.005 12.972 20.186-23.35 27.395L22.215 24z",
        rotate: p.element1Rotate, // Not bug
        scale: p.element2Scale,
        translateX: p.element2TranslateX,
        translateY: p.element2TranslateY);
    final paintFill2 = Paint()
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.overlay
      ..color = p.element2Color
      ..maskFilter = blur;

    canvas.drawPath(path2, paintFill2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is AvatarMarblePainter &&
        oldDelegate.properties != properties;
  }
}
