import 'dart:math';
import 'package:flutter/material.dart';
import 'package:svg_path_parser/svg_path_parser.dart';
import 'painter/cross.dart';
import 'utilities.dart';
import 'color_palette.dart';
import 'painter/bauhaus.dart';
import 'painter/beam.dart';
import 'painter/marble.dart';
import 'painter/pixel.dart';
import 'painter/ring.dart';
import 'painter/sunset.dart';

enum BoringAvatarType {
  marble,
  beam,
  pixel,
  sunset,
  bauhaus,
  ring,
}

typedef BoringAvatarHashCodeFunc = int Function(String name);

abstract class AvatarCustomPainter extends CustomPainter {
  double get boxSize => 0;
  Size size = Size.zero;

  Path svgPath(
    String p, {
    double rotate = 0,
    double scale = 1,
    double translateX = 0,
    double translateY = 0,
  }) {
    final scaleX = size.width / boxSize;
    final scaleY = size.height / boxSize;
    final resizeTransform = Matrix4.identity()..scale(scaleX, scaleY);
    final transform = Matrix4.identity()
      ..translate(translateX, translateY)
      ..translate(boxSize / 2, boxSize / 2)
      ..rotateZ(rotate * (pi / 180))
      ..translate(-boxSize / 2, -boxSize / 2)
      ..scale(scale, scale);
    Path path = parseSvgPath(p);
    path = path.transform(transform.storage);
    path = path.transform(resizeTransform.storage);
    return path;
  }

  Paint fillPaint(Color color) => Paint()
    ..style = PaintingStyle.fill
    ..color = color;

  Paint roundStrokePaint(Color color, double width) => Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = cX(width)
    ..strokeJoin = StrokeJoin.round
    ..color = color;

  Paint strokePaint(Color color, double width) => Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = cX(width)
    ..color = color;

  Rect getRectFromLTWH(double l, double t, double w, double h) =>
      Rect.fromLTWH(cX(l), cY(t), cX(w), cY(h));

  Offset getOffset(double x, double y) => Offset(cX(x), cY(y));

  Matrix4 getTransform(
      {double rotate = 0,
      double scale = 1,
      double translateX = 0,
      double translateY = 0}) {
    final transform = Matrix4.identity()
      ..translate(cX(translateX), cY(translateY))
      ..translate(size.width / 2, size.height / 2)
      ..rotateZ(rotate * (pi / 180))
      ..translate(-size.width / 2, -size.height / 2)
      ..scale(scale, scale);
    return transform;
  }

  double cX(double x) => x * (size.width / boxSize);
  double cY(double y) => y * (size.height / boxSize);
}

abstract class BoringAvatarData {
  BoringAvatarData lerp(BoringAvatarData end, double t);

  CustomPainter get painter;

  BoringAvatarData();

  factory BoringAvatarData.generate(
      {required String name,
      BoringAvatarType type = BoringAvatarType.marble,
      BoringAvatarPalette palette = BoringAvatarPalette.defaultPalette,
      BoringAvatarHashCodeFunc getHashCode = boringAvatarHashCode}) {
    switch (type) {
      case BoringAvatarType.bauhaus:
        return BoringAvatarBauhausData.generate(
          name: name,
          palette: palette,
        );
      case BoringAvatarType.marble:
        return BoringAvatarMarbleData.generate(
          name: name,
          palette: palette,
        );
      case BoringAvatarType.beam:
        return BoringAvatarBeamData.generate(
          name: name,
          palette: palette,
        );
      case BoringAvatarType.pixel:
        return BoringAvatarPixelData.generate(
          name: name,
          palette: palette,
        );
      case BoringAvatarType.ring:
        return BoringAvatarRingData.generate(
          name: name,
          palette: palette,
        );
      case BoringAvatarType.sunset:
        return BoringAvatarSunsetData.generate(
          name: name,
          palette: palette,
        );
    }
  }
}

class BoringAvatarDataTween extends Tween<BoringAvatarData> {
  BoringAvatarDataTween({super.begin, super.end});

  @override
  BoringAvatarData lerp(double t) {
    assert(begin != null);
    assert(end != null);
    if (t == 1) return end!;
    if (t == 0) return begin!;
    if (begin.runtimeType == end.runtimeType) {
      return begin!.lerp(end!, t);
    } else {
      return BoringAvatarCrossData(begin: begin!, end: end!, t: t);
    }
  }
}
