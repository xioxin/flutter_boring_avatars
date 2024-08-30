import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'painter/cross.dart';
import 'palette.dart';
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

abstract class BoringAvatarPainter {
  BoringAvatarData get properties;

  final double boxSize;
  final Rect rect;

  Size get size => rect.size;

  late final Size scale = Size(size.width / boxSize, size.height / boxSize);

  BoringAvatarPainter({required this.boxSize, required this.rect});

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

  double cX(double x) => x * scale.width;

  double cY(double y) => y * scale.height;

  paint(Canvas canvas) {
    canvas.save();
    if (properties.shape != null) {
      final shape = properties.shape!;
      shape.paint(canvas, rect);
      canvas.clipPath(
        shape.getInnerPath(
          rect,
          textDirection: TextDirection.ltr,
        ),
      );
    }
    canvas.translate(rect.left, rect.top);
    avatarPaint(canvas);
    canvas.restore();
  }

  @protected
  void avatarPaint(Canvas canvas);
}

abstract class BoringAvatarData {
  final ShapeBorder? shape;

  BoringAvatarData({this.shape});

  @override
  operator ==(Object other) {
    if (other is BoringAvatarData) {
      return shape == other.shape;
    }
    return false;
  }

  @override
  int get hashCode => shape.hashCode;

  BoringAvatarData lerp(BoringAvatarData end, double t);

  factory BoringAvatarData.generate({
    required String name,
    ShapeBorder? shape,
    BoringAvatarType type = BoringAvatarType.marble,
    BoringAvatarPalette palette = BoringAvatarPalette.defaultPalette,
  }) {
    switch (type) {
      case BoringAvatarType.bauhaus:
        return BoringAvatarBauhausData.generate(
          name: name,
          palette: palette,
          shape: shape,
        );
      case BoringAvatarType.marble:
        return BoringAvatarMarbleData.generate(
          name: name,
          palette: palette,
          shape: shape,
        );
      case BoringAvatarType.beam:
        return BoringAvatarBeamData.generate(
          name: name,
          palette: palette,
          shape: shape,
        );
      case BoringAvatarType.pixel:
        return BoringAvatarPixelData.generate(
          name: name,
          palette: palette,
          shape: shape,
        );
      case BoringAvatarType.ring:
        return BoringAvatarRingData.generate(
          name: name,
          palette: palette,
          shape: shape,
        );
      case BoringAvatarType.sunset:
        return BoringAvatarSunsetData.generate(
          name: name,
          palette: palette,
          shape: shape,
        );
    }
  }

  Future<ui.Image> toImage({Size size = const Size.square(128)}) {
    ui.PictureRecorder recorder = ui.PictureRecorder();
    Canvas canvas = Canvas(recorder);
    paint(canvas, ui.Offset.zero & size);
    return recorder
        .endRecording()
        .toImage(size.width.toInt(), size.height.toInt());
  }

  void paint(Canvas canvas, Rect rect);
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
      return BoringAvatarCrossData.mixed(begin: begin!, end: end!, t: t);
    }
  }
}
