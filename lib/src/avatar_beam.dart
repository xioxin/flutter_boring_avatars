import 'package:flutter/material.dart';
import './utilities.dart';
import 'dart:ui';
import 'avatar_base.dart';
import 'package:flutter/foundation.dart';

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

  

  static AvatarBeamData? lerp(AvatarBeamData? a, AvatarBeamData? b, double t) {
    assert(a != null);
    assert(b != null);
    a ??= AvatarBeamData.empty();
    b ??= AvatarBeamData.empty();
    return AvatarBeamData(
      wrapperColor: Color.lerp(a.wrapperColor, b.wrapperColor, t)!,
      faceColor: Color.lerp(a.faceColor, b.faceColor, t)!,
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t)!,
      wrapperTranslateX: lerpDouble(a.wrapperTranslateX, b.wrapperTranslateX, t),
      wrapperTranslateY: lerpDouble(a.wrapperTranslateY, b.wrapperTranslateY, t),
      wrapperRotate: lerpDouble(a.wrapperRotate, b.wrapperRotate, t),
      wrapperRadius: lerpDouble(a.wrapperRadius, b.wrapperRadius, t),
      wrapperScale: lerpDouble(a.wrapperScale, b.wrapperScale, t),
      isMouthOpen: t >= 0.5 ? b.isMouthOpen : a.isMouthOpen,
      isCircle:  t >= 0.5 ? b.isCircle : a.isCircle,
      eyeSpread: lerpDouble(a.eyeSpread, b.eyeSpread, t),
      mouthSpread: lerpDouble(a.mouthSpread, b.mouthSpread, t),
      faceRotate: lerpDouble(a.faceRotate, b.faceRotate, t),
      faceTranslateX: lerpDouble(a.faceTranslateX, b.faceTranslateX, t),
      faceTranslateY: lerpDouble(a.faceTranslateY, b.faceTranslateY, t),
    );
  }


  AvatarBeamData.empty(){
    wrapperColor = Color.fromRGBO(255, 255, 255, 0);
    faceColor = Color.fromRGBO(255, 255, 255, 0);
    backgroundColor = Color.fromRGBO(255, 255, 255, 0);
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

  AvatarBeamData.generate(String name, [List<Color>? colors]) {
    colors ??= defaultBoringAvatarsColors;
    const double boxSize = 36;
    final numFromName = getNumber(name);
    final range = colors.length;
    wrapperColor = getRandomColor<Color>(numFromName, colors, range);
    final preTranslateX = getUnit(numFromName, 10, 1).toDouble();
    wrapperTranslateX =
        preTranslateX < 5 ? preTranslateX + boxSize / 9 : preTranslateX;
    final preTranslateY = getUnit(numFromName, 10, 2).toDouble();
    wrapperTranslateY =
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
    return true;
  }
}

class AvatarBeamDataTween extends Tween<AvatarBeamData?> {
  AvatarBeamDataTween({ AvatarBeamData? begin, AvatarBeamData? end }) : super(begin: begin, end: end);
  @override
  AvatarBeamData? lerp(double t) => AvatarBeamData.lerp(begin, end, t);
}

class AnimatedAvatarBeam extends ImplicitlyAnimatedWidget {
  AnimatedAvatarBeam({
    Key? key,
    required this.name,
    Curve curve = Curves.linear,
    required Duration duration,
    VoidCallback? onEnd,
  }): data = AvatarBeamData.generate(name), super(key: key, curve: curve, duration: duration, onEnd: onEnd);

  final String name;
  final AvatarBeamData data;

  @override
  AnimatedWidgetBaseState<AnimatedAvatarBeam> createState() => _AnimatedAvatarBeamState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<String>('name', name));
    properties.add(DiagnosticsProperty<AvatarBeamData>('data', data));
  }
}

class _AnimatedAvatarBeamState extends AnimatedWidgetBaseState<AnimatedAvatarBeam> {
  AvatarBeamDataTween? _data;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _data = visitor(_data, widget.data, (dynamic value) => AvatarBeamDataTween(begin: value)) as AvatarBeamDataTween?;
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
                    size: const Size(100, 100),
                    painter: AvatarBeamPainter.data(_data!.evaluate(animation)!),
                  );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder description) {
    super.debugFillProperties(description);
    description.add(DiagnosticsProperty<AvatarBeamDataTween>('data', _data, defaultValue: null));
  }
}
