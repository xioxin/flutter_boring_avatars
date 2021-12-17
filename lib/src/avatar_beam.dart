// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import './utilities.dart';
import 'dart:ui';
import 'avatar_base.dart';

class AvatarBeamData {
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

  AvatarBeamData({
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

  AvatarBeamData.generate(String name, [List<Color>? colors]) {
    colors ??= defaultBoringAvatarsColors;
    const double boxSize = 36;
    final numFromName = getNumber(name);
    final range = colors.length;
    wrapperColor = getRandomColor<Color>(numFromName, colors, range);
    final preTranslateX = getUnit(numFromName, 10, 1);
    final wrapperTranslateX =
        preTranslateX < 5 ? preTranslateX + boxSize / 9 : preTranslateX;
    final preTranslateY = getUnit(numFromName, 10, 2);
    final wrapperTranslateY =
        preTranslateY < 5 ? preTranslateY + boxSize / 9 : preTranslateY;
    isCircle = getBoolean(numFromName, 1);
    faceColor = getContrast(wrapperColor);
    backgroundColor = getRandomColor(numFromName + 13, colors, range);
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
}

class AvatarBeamPainter extends AvatarCustomPainter {
  final AvatarBeamData propertie;

  @override
  double get boxSize => 36;

  AvatarBeamPainter(String name, [List<Color>? colors])
      : propertie = AvatarBeamData.generate(name, colors);

  AvatarBeamPainter.data(this.propertie);

  @override
  void paint(Canvas canvas, Size size) {
    this.size = size;

    final p = propertie;
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
    if (p.isMouthOpen) {
      final mouthPath = svgPath('M15 ${19 + p.mouthSpread}c2 1 4 1 6 0');
      canvas.drawPath(mouthPath, roundStrokePaint(p.faceColor, 1.0));
    } else {
      final mouthPath = svgPath('M13,${19 + p.mouthSpread} a1,0.75 0 0,0 10,0');
      canvas.drawPath(mouthPath, fillPaint(p.faceColor));
    }
    final lEyeRect = getRectFromLTWH(14 - p.eyeSpread, 14, 1.5, 2);
    canvas.drawRRect(
        RRect.fromRectXY(lEyeRect, cX(1), cX(1)), fillPaint(p.faceColor));
    final rEyeRect = getRectFromLTWH(20 + p.eyeSpread, 14, 1.5, 2);
    canvas.drawRRect(
        RRect.fromRectXY(rEyeRect, cX(1), cX(1)), fillPaint(p.faceColor));
    canvas.transform(Matrix4.identity().storage);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
