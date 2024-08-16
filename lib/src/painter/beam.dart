import 'package:flutter/material.dart';
import '../utilities.dart';
import '../painter.dart';
import '../color_palette.dart';

class BoringAvatarBeamData extends BoringAvatarData {
  late Color wrapperColor;
  late Color faceColor;
  late Color backgroundColor;
  late double wrapperTranslateX;
  late double wrapperTranslateY;
  late double wrapperRotate;
  late double wrapperScale;
  late double wrapperRadius;
  late bool isMouthOpen;
  late bool isCircle;
  late double eyeSpread;
  late double mouthSpread;
  late double faceRotate;
  late double faceTranslateX;
  late double faceTranslateY;

  BoringAvatarBeamData({
    required this.wrapperColor,
    required this.faceColor,
    required this.backgroundColor,
    required this.wrapperTranslateX,
    required this.wrapperTranslateY,
    required this.wrapperRotate,
    required this.wrapperRadius,
    required this.wrapperScale,
    required this.isMouthOpen,
    required this.isCircle,
    required this.eyeSpread,
    required this.mouthSpread,
    required this.faceRotate,
    required this.faceTranslateX,
    required this.faceTranslateY,
  });

  @override
  operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    if (other is BoringAvatarBeamData) {
      return wrapperColor == other.wrapperColor &&
          faceColor == other.faceColor &&
          backgroundColor == other.backgroundColor &&
          wrapperTranslateX == other.wrapperTranslateX &&
          wrapperTranslateY == other.wrapperTranslateY &&
          wrapperRotate == other.wrapperRotate &&
          wrapperRadius == other.wrapperRadius &&
          wrapperScale == other.wrapperScale &&
          isMouthOpen == other.isMouthOpen &&
          isCircle == other.isCircle &&
          eyeSpread == other.eyeSpread &&
          mouthSpread == other.mouthSpread &&
          faceRotate == other.faceRotate &&
          faceTranslateX == other.faceTranslateX &&
          faceTranslateY == other.faceTranslateY;
    }
    return false;
  }

  @override
  int get hashCode => Object.hashAll([
        wrapperColor,
        faceColor,
        backgroundColor,
        wrapperTranslateX,
        wrapperTranslateY,
        wrapperRotate,
        wrapperRadius,
        wrapperScale,
        isMouthOpen,
        isCircle,
        eyeSpread,
        mouthSpread,
        faceRotate,
        faceTranslateX,
        faceTranslateY
      ]);

  // static BoringAvatarBeamData? lerp2(
  //     BoringAvatarBeamData? a, BoringAvatarBeamData? b, double t) {
  //   assert(a != null);
  //   assert(b != null);
  //   a ??= BoringAvatarBeamData.empty();
  //   b ??= BoringAvatarBeamData.empty();
  //   return BoringAvatarBeamData(
  //     wrapperColor: Color.lerp(a.wrapperColor, b.wrapperColor, t)!,
  //     faceColor: Color.lerp(a.faceColor, b.faceColor, t)!,
  //     backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t)!,
  //     wrapperTranslateX:
  //         lerpDouble(a.wrapperTranslateX, b.wrapperTranslateX, t),
  //     wrapperTranslateY:
  //         lerpDouble(a.wrapperTranslateY, b.wrapperTranslateY, t),
  //     wrapperRotate: lerpRotate(a.wrapperRotate, b.wrapperRotate, t),
  //     wrapperRadius: lerpDouble(a.wrapperRadius, b.wrapperRadius, t),
  //     wrapperScale: lerpDouble(a.wrapperScale, b.wrapperScale, t),
  //     isMouthOpen: t >= 0.5 ? b.isMouthOpen : a.isMouthOpen,
  //     isCircle: t >= 0.5 ? b.isCircle : a.isCircle,
  //     // isMouthOpen: b.isMouthOpen,
  //     // isCircle: b.isCircle,
  //     eyeSpread: lerpDouble(a.eyeSpread, b.eyeSpread, t),
  //     mouthSpread: lerpDouble(a.mouthSpread, b.mouthSpread, t),
  //     faceRotate: lerpRotate(a.faceRotate, b.faceRotate, t),
  //     faceTranslateX: lerpDouble(a.faceTranslateX, b.faceTranslateX, t),
  //     faceTranslateY: lerpDouble(a.faceTranslateY, b.faceTranslateY, t),
  //   );
  // }

  @override
  BoringAvatarData lerp(BoringAvatarData end, double t) {
    assert(end is BoringAvatarBeamData);
    final a = this;
    final b = end as BoringAvatarBeamData;
    return BoringAvatarBeamData(
      wrapperColor: Color.lerp(a.wrapperColor, b.wrapperColor, t)!,
      faceColor: Color.lerp(a.faceColor, b.faceColor, t)!,
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t)!,
      wrapperTranslateX:
          lerpDouble(a.wrapperTranslateX, b.wrapperTranslateX, t),
      wrapperTranslateY:
          lerpDouble(a.wrapperTranslateY, b.wrapperTranslateY, t),
      wrapperRotate: lerpRotate(a.wrapperRotate, b.wrapperRotate, t),
      wrapperRadius: lerpDouble(a.wrapperRadius, b.wrapperRadius, t),
      wrapperScale: lerpDouble(a.wrapperScale, b.wrapperScale, t),
      isMouthOpen: t >= 0.5 ? b.isMouthOpen : a.isMouthOpen,
      isCircle: t >= 0.5 ? b.isCircle : a.isCircle,
      eyeSpread: lerpDouble(a.eyeSpread, b.eyeSpread, t),
      mouthSpread: lerpDouble(a.mouthSpread, b.mouthSpread, t),
      faceRotate: lerpRotate(a.faceRotate, b.faceRotate, t),
      faceTranslateX: lerpDouble(a.faceTranslateX, b.faceTranslateX, t),
      faceTranslateY: lerpDouble(a.faceTranslateY, b.faceTranslateY, t),
    );
  }

  BoringAvatarBeamData.empty() {
    wrapperColor = const Color.fromRGBO(255, 255, 255, 0);
    faceColor = const Color.fromRGBO(255, 255, 255, 0);
    backgroundColor = const Color.fromRGBO(255, 255, 255, 0);
    wrapperTranslateX = 0;
    wrapperTranslateY = 0;
    wrapperRotate = 0;
    wrapperRadius = 0;
    wrapperScale = 0;
    isMouthOpen = false;
    isCircle = false;
    eyeSpread = 0;
    mouthSpread = 0;
    faceRotate = 0;
    faceTranslateX = 0;
    faceTranslateY = 0;
  }

  BoringAvatarBeamData.generate(
      {required String name,
      BoringAvatarPalette palette = BoringAvatarPalette.defaultPalette,
      BoringAvatarHashCodeFunc getHashCode = boringAvatarHashCode}) {
    const double boxSize = 36;
    final numFromName = getHashCode(name);
    wrapperColor = palette.getColor(numFromName);
    final preTranslateX = getUnit(numFromName, 10, 1).toDouble();
    wrapperTranslateX =
        preTranslateX < 5 ? preTranslateX + boxSize / 9 : preTranslateX;
    final preTranslateY = getUnit(numFromName, 10, 2).toDouble();
    wrapperTranslateY =
        preTranslateY < 5 ? preTranslateY + boxSize / 9 : preTranslateY;
    isCircle = getBoolean(numFromName, 1);
    faceColor = getContrast(wrapperColor);
    backgroundColor = palette.getColor(numFromName + 13);
    wrapperRotate = getUnit(numFromName, 360).toDouble();
    wrapperScale = 1 + getUnit(numFromName, boxSize ~/ 12) / 10;
    isMouthOpen = getBoolean(numFromName, 2);
    wrapperRadius = isCircle ? boxSize : boxSize / 6;
    eyeSpread = getUnit(numFromName, 5).toDouble();
    mouthSpread = getUnit(numFromName, 3).toDouble();
    faceRotate = getUnit(numFromName, 10, 3).toDouble();
    faceTranslateX = wrapperTranslateX > boxSize / 6
        ? wrapperTranslateX / 2
        : getUnit(numFromName, 8, 1).toDouble();
    faceTranslateY = wrapperTranslateY > boxSize / 6
        ? wrapperTranslateY / 2
        : getUnit(numFromName, 7, 2).toDouble();
  }

  @override
  CustomPainter get painter => AvatarBeamPainter(this);
}

class AvatarBeamPainter extends AvatarCustomPainter {
  final BoringAvatarBeamData properties;

  @override
  double get boxSize => 36;

  AvatarBeamPainter(this.properties);

  @override
  void paint(Canvas canvas, Size size) {
    this.size = size;
    canvas.save();
    final p = properties;
    canvas.clipRect(Rect.fromLTRB(0, 0, size.width, size.height));

    Paint paintFill = Paint()
      ..style = PaintingStyle.fill
      ..color = p.backgroundColor;
    canvas.drawRect(Rect.fromLTRB(0, 0, size.width, size.height), paintFill);

    final wrapperTransform = getTransform(
        translateX: p.wrapperTranslateX,
        translateY: p.wrapperTranslateY,
        rotate: p.wrapperRotate,
        scale: p.wrapperScale);
    canvas.transform(wrapperTransform.storage);
    final wrapperRect = getRectFromLTWH(0, 0, 36, 36);
    canvas.drawRRect(
        RRect.fromRectXY(wrapperRect, cX(p.wrapperRadius), cY(p.wrapperRadius)),
        fillPaint(p.wrapperColor));
    wrapperTransform.invert();
    canvas.transform(wrapperTransform.storage);
    canvas.transform(getTransform(
            translateX: p.faceTranslateX,
            translateY: p.faceTranslateY,
            rotate: p.faceRotate)
        .storage);
    final mouthSpread = 19 + p.mouthSpread;
    if (p.isMouthOpen) {
      final mouthPath1 = svgPath('M15 ${mouthSpread}c2 1 4 1 6 0');
      canvas.drawPath(mouthPath1, roundStrokePaint(p.faceColor, 1.0));
    } else {
      final mouthPath2 = svgPath('M13,$mouthSpread a1,0.75 0 0,0 10,0');
      canvas.drawPath(
          mouthPath2, fillPaint(p.isMouthOpen ? p.wrapperColor : p.faceColor));
    }
    final lEyeRect = getRectFromLTWH(14 - p.eyeSpread, 14, 1.5, 2);
    canvas.drawRRect(
        RRect.fromRectXY(lEyeRect, cX(1), cX(1)), fillPaint(p.faceColor));
    final rEyeRect = getRectFromLTWH(20 + p.eyeSpread, 14, 1.5, 2);
    canvas.drawRRect(
        RRect.fromRectXY(rEyeRect, cX(1), cX(1)), fillPaint(p.faceColor));
    canvas.transform(Matrix4.identity().storage);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is AvatarBeamPainter &&
        oldDelegate.properties != properties;
  }
}
