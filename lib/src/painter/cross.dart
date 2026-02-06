import 'package:flutter/material.dart';
import '../painter.dart';

class BoringAvatarCrossData extends BoringAvatarData {
  late BoringAvatarData begin;
  BoringAvatarData end;
  double t;

  BoringAvatarCrossData(
      {required this.begin, required this.end, required this.t, super.shape});

  static BoringAvatarData mixed({
    required BoringAvatarData begin,
    required BoringAvatarData end,
    ShapeBorder? shape,
    required double t,
  }) {
    if (begin is BoringAvatarCrossData) {
      begin = begin.t > 0.5 ? begin.end : begin.begin;
    }
    if (begin.runtimeType == end.runtimeType) {
      return begin.lerp(end, t);
    }
    return BoringAvatarCrossData(
      begin: begin,
      end: end,
      t: t,
      shape: ShapeBorder.lerp(begin.shape, end.shape, t),
    );
  }

  BoringAvatarCrossData copyWith({
    BoringAvatarData? begin,
    BoringAvatarData? end,
    ShapeBorder? shape,
    double? t,
  }) {
    return BoringAvatarCrossData(
      begin: begin ?? this.begin,
      end: end ?? this.end,
      t: t ?? this.t,
      shape: ShapeBorder.lerp(
        begin?.shape,
        end?.shape,
        t ?? this.t,
      ),
    );
  }

  @override
  BoringAvatarData lerp(BoringAvatarData end, double t) {
    if (t == 1) return end;
    return copyWith(end: end, t: t);
  }

  @override
  void paint(Canvas canvas, Rect rect) {
    final painter = BoringAvatarCrossPainter(this, rect);
    painter.paint(canvas);
  }

  @override
  operator ==(Object other) {
    if (other is BoringAvatarCrossData) {
      return other.begin == begin &&
          other.end == end &&
          other.t == t &&
          other.shape == shape;
    }
    return false;
  }

  @override
  int get hashCode => Object.hashAll([begin, end, t, shape]);
}

class BoringAvatarCrossPainter extends BoringAvatarPainter {
  @override
  final BoringAvatarCrossData properties;

  BoringAvatarCrossPainter(this.properties, Rect rect)
      : super(boxSize: 64, rect: rect);

  @override
  void avatarPaint(Canvas canvas) {
    final p = properties;
    canvas.save();
    p.begin.paint(canvas, Offset.zero & rect.size);
    canvas.restore();
    canvas.saveLayer(Offset.zero & rect.size,
        Paint()..color = Colors.white.withValues(alpha: p.t));
    p.end.paint(canvas, Offset.zero & rect.size);
    canvas.restore();
  }
}
