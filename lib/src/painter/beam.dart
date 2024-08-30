import 'package:flutter/material.dart';
import '../utilities.dart';
import '../painter.dart';
import '../palette.dart';

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
    super.shape,
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
          faceTranslateY == other.faceTranslateY &&
          shape == other.shape;
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
        faceTranslateY,
        shape,
      ]);

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
      shape: ShapeBorder.lerp(a.shape, b.shape, t),
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

  BoringAvatarBeamData.generate({
    required String name,
    super.shape,
    BoringAvatarPalette palette = BoringAvatarPalette.defaultPalette,
  }) {
    const double boxSize = 36;
    final numFromName = boringAvatarHashCode(name);
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
  void paint(Canvas canvas, Rect rect) {
    final painter = AvatarBeamPainter(this, rect);
    painter.paint(canvas);
  }
}

class AvatarBeamPainter extends BoringAvatarPainter {
  @override
  final BoringAvatarBeamData properties;

  AvatarBeamPainter(this.properties, Rect rect)
      : super(boxSize: 36, rect: rect);

  @override
  void avatarPaint(Canvas canvas) {
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
      final mouthPath1 = Path()
        ..moveTo(cX(15), cY(mouthSpread))
        ..cubicTo(cX(17), cY(mouthSpread + 1), cX(19), cY(mouthSpread + 1),
            cX(21), cY(mouthSpread));
      canvas.drawPath(mouthPath1, roundStrokePaint(p.faceColor, 1.0));
    } else {
      final mouthPath2 = Path()
        ..moveTo(cX(13), cY(mouthSpread))
        ..arcToPoint(Offset(cX(23), cY(mouthSpread)),
            radius: Radius.elliptical(cX(1), cY(0.75)),
            rotation: 0,
            largeArc: false,
            clockwise: false);
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
}
